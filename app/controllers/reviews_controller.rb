class ReviewsController < ApplicationController

  # def is function in ruby. Telling that the index page coming from app/views/reviews/index.html.erb
  def index
    # this is our list page for our review
    # variable is @.
    # creating a filter variable for price
    @price = params[:price]
    #creating a filter variable for cuisine
    @cuisine = params[:cuisine]
    # adding location filter using geocoder
    @location = params[:location]

    #filtering properly by get all the reviews "Review" model from the database
    #creating new review variable as ruby list[]
    #@reviews = ["The Smile", "Baby Bo's", "Chipotle", "nandos"]
    @reviews = Review.all

    # filtering by price. this will toggle on/off depend when it has filter
    if @price.present?
      #take all of the review we have and replace the original review with filtered ones
      # find the value of the price in db that matches the param above
      @reviews = @reviews.where(price: @price)
    end

    #filter by cuisine
    if @cuisine.present?
      @reviews = @reviews.where(cuisine: @cuisine)
    end
    #search near the location
    if @location.present?
      # .near is what geo lcation given to us - see docs
      @reviews = @reviews.near(@location)
    end

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
    params.require(:review).permit(:title, :restaurant, :body, :score, :ambiance, :cuisine, :price, :address)
  end

end
