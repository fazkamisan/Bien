Rails.application.routes.draw do
  #resources is a rails convention - generated a controller called reviews
  resources :reviews
  #this is where the homepage goes (app/controllers/reviews_controller.rb)
  root "reviews#index"

end
