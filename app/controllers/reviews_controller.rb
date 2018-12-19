class ReviewsController < ApplicationController

  # def is function in ruby. Telling that the index page coming from app/views/reviews/index.html.erb
  def index
    # this is our list page for our review
    # variable is @.
    # rand([enter number between 0-100]) is a ruby random number function.
    @number =  rand(100)

    #creating new review variable as ruby list[]
    #@reviews = ["The Smile", "Baby Bo's", "Chipotle", "nandos"]

    #calling all Review model from the database
    @reviews = Review.all

  end
  #adding new function to define new review page
  def new
    # this is the form for adding a new review
    # once we generated the model "Review", using the variable we are adding a form to feed into the db
    @review = Review.new
  end

  def create
  # this is a rails convention to compliment "new" function. This going to take info from the form and add it to the model
  #making sure that we add data only relating to "review" - something to do with hackers might able get access.
  # the ":[field]" denotes variable symbols that don't change
  @review = Review.new(form_params)

  # we can to check if the model can be saved, if it is, we're go to home page again, if it isn't show the form
  if @review.save
    redirect_to root_path
  else
    # show the view for new.html.erb
    render "new"
  end

  end

  #adding new function for show page
  def show
    #this is going to be the individual review page using no. in db row using params array of :id. make sure we now create view page
    @review = Review.find(params[:id])
  end

  #adding new function to delete review
  def destroy
    #find the individual review
    @review = Review.find(params[:id])
    #destroy it
    @review.destroy
    #redirect to the homepage
    redirect_to root_path
  end

  #adding new function to edit review
  def edit
    #find the individual review to edit
    @review = Review.find(params[:id])
  end

  # adding new function to update the editted review
  def update
    #find the individual review
    @review = Review.find(params[:id])
    #update the new info from the form - update with new info from the form
    if @review.update(form_params)
      #redirect to individual show page
      redirect_to review_path(@review)
    else
      # using this it will render any validation to the main edit page
      render "edit"
    end

  end

  # creating a new function that will hold templated function
  def form_params
    params.require(:review).permit(:title, :body, :score)
  end

end
