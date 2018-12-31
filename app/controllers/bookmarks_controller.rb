class BookmarksController < ApplicationController
  # this bookmark feature is only for logged in user (in ApplicationController)
  before_action :login_status

  #creating bookmark function
  def create
    #find the review we're bookmarking
    @review = Review.find(params[:review_id])
    #create bookmark based on the id review
    @bookmark = @review.bookmarks.new
    #attach user to the bookmark
    @bookmark.user = @current_user
    #save it
    @bookmark.save
    #redirect to review page
    redirect_to review_path(@review)
  end

  #creating the unbookmark function
  def destroy
    # find the bookmark from user
    @review = Review.find(params[:review_id])
    #unbookmark the item from particular user - see show.html.erb
    @review.bookmarks.where(user: @current_user).delete_all

    #redirect to review page
    redirect_to review_path(@review)
  end

end
