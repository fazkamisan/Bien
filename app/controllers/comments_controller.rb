class CommentsController < ApplicationController
  #take the body that we pass through and find the review
  def create
    # find the review based on resources set in config/routes.rb
    @review = Review.find(params[:review_id])
    #make a brand new comments using form params and only take the body based on @review
    @comment = @review.comments.new(params.require(:comment).permit(:body))

    #before we save the comment
    @comment.user = @current_user

    #save the new comment
    @comment.save
    # redirect back show page
    redirect_to review_path(@review)
  end

end
