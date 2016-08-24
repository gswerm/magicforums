require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  before(:all) do
    @admin_user = User.create(username: "admin_user", email: "admin@gmail.com", password: "password", role: "admin")
    @user = User.create(username: "user", email: "user@gmail.com", password: "userpassword")
    @topic = Topic.create(title: "New Title", description: "New Description need to be longer than 20 chars", slug: "slug-lah", user_id: @admin_user.id)
    @post = Post.create(title: "New Post", body: "New body for post to do TDD testing123", topic_id: @topic.id)
    @topic_2 = Topic.create(title: "New Title 2", description: "New Description need to be longer than 20 chars", slug: "slug-lah", user_id: @admin_user.id)
  end

  describe "index" do
    it "should render index" do
      params = {topic_id: @topic.id}
      get :index, params: params
      expect(subject).to render_template(:index)
      expect(Post.count).to eql(1)
    end
  end

  describe "NEW post" do
    it "should render new form for admin" do
      params = {topic_id: @topic.id}
      get :new, params: params, session: { id: @admin_user.id }
      expect(subject).to render_template(:new)
    end

    it "should deny if not logged in" do
      params = {topic_id: @topic.id}
      get :new, params: params
      expect(flash[:danger]).to eql("You need to login first")
      expect(subject).to redirect_to(root_path)
    end

    it "should deny user" do
      params = {topic_id: @topic.id}
      get :new, params: params, session: { id: @user.id }
      expect(flash[:danger]).to eql("You're not authorized")
    end
  end

  describe "CREATE post" do
    it "should create new post for user" do
      params = { topic_id: @topic_2.id, post: { title: "NewPost2", body: "New TitleDescription TDD testing"} }
      post :create, params: params, session: { id: @user.id }
      post = Post.find_by(title: "NewPost2")
      expect(Post.count).to eql(2)
      expect(post).to be_present
      expect(post.body).to eql("New TitleDescription TDD testing")
      expect(subject).to redirect_to(topic_posts_path)
    end

    it "should redirect if not logged in" do
      params = { topic_id: @topic_2.id, post: { title: "NewTopicTitle", body: "TitleDescription TDD testing" }}
      post :create, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic_2.id, post: { title: "NewTopicTitle", body: "TitleDescription TDD testing" }}
      get :new, params: params, session: { id: @user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end
  end

  describe "EDIT post" do
    it "should render edit form for admin" do
      params = { topic_id: @topic.id, id: @post.id }
      get :edit, params: params, session: { id: @admin_user.id }
      post = Post.find_by(title: "New Post")
      expect(subject).to render_template(:edit)
      expect(post.title).to eql("New Post")
      expect(post.body).to eql("New body for post to do TDD testing123")
   end

    it "should redirect if not logged in" do
      params = { topic_id: @topic.id, id: @post.id }
      get :edit, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = {topic_id: @topic.id}
      get :new, params: params, session: { id: @user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end
  end

  describe "UPDATE post" do
    it "should redirect if not logged in" do
      params = { topic_id: @topic.id, id: @post.id, post: { title: "New title", body: "New body for post to do testing"} }
      patch :update, params: params
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.id, id: @post.id, post: { title: "new title", body: "New body for post to do testing"} }
      patch :update, params: params, session: { id: @user.id }
      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update post" do
      params = { topic_id: @topic.id, id: @post.id, post: { title: "new title test", body: "this is to test the update title function"} }
      patch :update, params: params, session: { id: @admin_user.id }

      @post.reload

      expect(@dummy_post.title).to eql("new title test")
      expect(@post.body).to eql("this is to test the update title function")
    end
  end

  describe "DELETE post" do
  end

end
