class SessionsController < ApplicationController
  #this is where the logged in user will be directed to
  def new
    #login form
  end
  #actually try and log in
  def create

    #take the data entered and see if it matches with existing users
    @form_data = params.require(:session)
    #pull out the username and password form the form data (from object data)
    @username = @form_data[:username]
    @password = @form_data[:password]

    #lets check the user is who they say they are (checking username and match it with the password stored)
    @user = User.find_by(username: @username).try(:authenticate, @password)

    if @user
      # we also want to 'store' the user id as they navigate around the website
      session[:user_id] = @user.id
      #if user is present, redirect to home page
      redirect_to root_path
    else
      #if not, show the form again with error (preloaded via simple_form)
      render "new"
    end

  end

  def destroy
    #log us out by remove the session completely
    #this is built into rails helper, control within rails itself
    reset_session
    #take them to login page
    redirect_to new_session_path
  end

end
