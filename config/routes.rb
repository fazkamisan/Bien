Rails.application.routes.draw do
  #resources is a rails convention - generated a controller called reviews
  resources :reviews do
    # tie comments as part of reviews
    resources :comments
    #bookmark going to be in comments and review. One per user therefore singular
    resource :bookmark

  end

  #sign up path
  resources :users

  #the session url is not reliant on anything, its a completely different flow so we do the following
  resource :session

  #this is where the homepage goes (app/controllers/reviews_controller.rb)
  root "reviews#index"



end
