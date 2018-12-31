class UsersController < ApplicationController
  #creating all of users
  def index
    #notice its plural
    @users = User.all
  end

  #creating the user profile page
  def show
    @user = User.find_by(username: params[:id])
  end

  # form for adding new user
  def new
    # this new user will be defined in our form
    @user = User.new

  end

  #creating a new user on sign up
  def create
    #take the params from the form
    #create a new user,
    @user = User.new(form_params)
    #if valid saves, go to list users page
    if @user.save
      # add in 'session' after user signed up
      session[:user_id] = @user.id
      redirect_to users_path

    else
    # if not, see form with errors
      render "new"
    end
  end


  #creating a seperate function
  def form_params
    #take the following fields - to prevent security problems
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
