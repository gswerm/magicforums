class VotesController < ApplicationController
  before_action :authenticate!, only: [:upvote, :downvote]
  respond_to :js

  def upvote
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])
    @topic = @vote.comment.post.topic
    @post = @vote.comment.post
    if @vote
      @vote.update(value: 1)
      flash[:success] = "You've voted!"
      redirect_to topic_post_comments_path(@topic, @post)
      VoteBroadcastJob.perform_later(@vote.comment)
    end
  end

  def downvote
    @vote = current_user.votes.find_or_create_by(comment_id: params[:comment_id])
    @topic = @vote.comment.post.topic
    @post = @vote.comment.post
    if @vote
      @vote.update(value: -1)
      flash[:success] = "You've voted!"
      redirect_to topic_post_comments_path(@topic, @post)
      VoteBroadcastJob.perform_later(@vote.comment)
    end
  end

  private
    def vote_params
      params.require(:vote).permit(:value, :user_id, :comment_id)
    end

end
