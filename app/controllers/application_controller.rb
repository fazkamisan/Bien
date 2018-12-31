class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #before any page loads find current_user
  #this is built into rails - action is an index, show, view, update and destroy
  before_action :find_current_user
  # add in the method to use in views
  helper_method :is_logged_in?

  #creating function to find current user
  def find_current_user
    # adding if to prevent rails from checking user when logged out
    if is_logged_in?
      #save to a variable
      @current_user = User.find(session[:user_id]);
    else
      @current_user = nil
    end
  end

  #check login status
  def login_status
    #see if user id present
    unless is_logged_in?
      #take them to login page
      redirect_to new_session_path
    end
  end

  #is this person logged in
  def is_logged_in?
    session[:user_id].present?
  end

end
