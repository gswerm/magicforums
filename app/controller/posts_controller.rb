class PostsController < ApplicationController
respond_to :js
before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
      @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
      @posts = @topic.posts.order("created_at DESC").page(params[:page])
      # @posts = @topic.posts.order("created_at DESC")
      # @posts = Post.order(:id).page(params[:page]).per(6)
    end

    def new
      @topic = Topic.friendly.find(params[:topic_id])
      @post = Post.new
      authorize @post
    end

    def create

      @topic = Post.friendly.find(params[:topic_id])
      @post = current_user.posts.build(post_params.merge(topic_id: params[:topic_id]))

      if @post.save
        redirect_to topic_posts_path
      else
        flash.now[:danger] = @post.errors.full_messages
        render :new
      end

    end

    def edit
      @post = Post.friendly.find(params[:id])
      @topic = @post.topic
      authorize @post
    end

    def update
      @topic = Topic.friendly.find(params[:topic_id])
      @post = Post.find_by(id: params[:id])

      if @post.update(post_params)
        redirect_to topic_posts_path(@topic)
      else
        redirect_to edit_topic_post_path(@topic, @post)
      end
    end

    def destroy
      @post = Post.friendly.find(params[:id])
      @topic = @post.topic

      if @post.destroy
        redirect_to topic_posts_path(@topic)
      end
    end

    private

    def post_params
      params.require(:post).permit(:image, :title, :body)
    end
  end
