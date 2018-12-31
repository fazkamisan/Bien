"@" is ruby variables eg:
  ```
    @number = 13
  ```
  you can overwrite the first variable by assign a new one

  ```
    @number = 14
  ```
  can also hold string

  ```
    @username = "Rikloman" + "admin"
  ```

  variable can also hold 'symbol' which cant be changed

  ```
  @method = :delete
  ```

  variable can also hold list

  ```
    @shopping_list = ["eggs", "bacon", "sausages"]
  ```

Hash is like a list but slightly different, it describe one thing instead (singular). Think of it like a js object.

  ```
    @person = { first_name: "Rik", age:33, shopping:["eggs"]}
  ```
  ```
    @link = {method: :delete}
  ```

--------------------------------------------------------------------------------

# Thinking about features as code

  Reviews
    - A user can review a restaurant
    - Anon users can't add a review
    - Anon users can see reviews
    - Anon users can't edit reviews
    - Anon can't delete anything
    - Any users can search and filter
    - A user can edit their own review within an hour
    - A user can't edit other people's reviews
    - A user can delete their own review
    - A user can't delete other people's reviews

  What is a review?
    - Title
    - Body
    - Score (number from 0 to 10)
    - User
    - Restaurant name & location
    - Price rating($, $$, $$$, $$$$)
    - Cuisine

  MVC
    - Model (database model of Reviews)
    - View (HTML of content - page)
    - Controller (URL definition - find the and merge models and views)

  Pages for reviews (rails convention)
    - list (index)
    - Individual review page (show)
    - New review page (new)
    - Edit review page (edit)

  adding a new Controller
  ``` rails generate controller [name with plurals e.g reviews]```

--------------------------------------------------------------------------------

# Setting up our first page

  - Inside routes.rb, update the following text to as follows
    ```
      Rails.application.routes.draw do
        #resources is a rails convention - generated a controller called reviews
        resources :reviews
        #this is where the homepage goes (app/controllers/reviews_controller.rb)
        root "reviews#index"
      end
    ```
  - Inside 'app/controllers/reviews_controller.rb' update the following
    ```
      class ReviewsController < ApplicationController

        # def is function in ruby. Telling that the index page coming from app/views/reviews/index.html.erb
        def index
          # this is our list page for our review
        end

      end
    ```
  - inside 'app/views/reviews/index.html.erb' update the following
    ```
      <h1>Bien Reviews</h1>
      <h2>The best reviews in the world</h2>

    ```
--------------------------------------------------------------------------------
# Adding variables to views

  - Inside 'app/controllers/reviews_controller.rb' we can add dynamic content. add it inside 'def index....'
    ```
      # def is function in ruby. Telling that the index page coming from app/views/reviews/index.html.erb
      def index
        # this is our list page for our review
        # rand([enter number between 0-100]) is a ruby random number function.
        @number =  rand(100)
      end
    ```
  - We can then call the variable in the view: 'app/views/reviews/index.html.erb'
    ```
      <p> the random number is <%= @number %></p>
    ```

--------------------------------------------------------------------------------

# Models is where we can add validation to rails.
https://guides.rubyonrails.org/active_record_validations.html

 - active record validation is where ruby check data.
 - inside 'app/models/review.rb' you can add the following:

 ```
   class Review < ApplicationRecord
     #adding some validations
     validates :title, presence: true
     validates :body, length: {minimum: 10}
     validates :score, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10}
   end
 ```
 - 'validates' takes items is the field (as symbol) its validating.


--------------------------------------------------------------------------------

# Fixing controllers for validations

 - Once validation is added into model, we now need to create user warning.
 - inside 'app/controllers/reviews_controller.rb', we need to change our "def create"
    ```
      # we can to check if the model can be saved, if it is, we're go to home page again, if it isn't show the form
      if @review.save
        redirect_to root_path
      else
        # show the view for new.html.erb
        render "new"
      end
    ```

--------------------------------------------------------------------------------

# Adding errors to our views

  - One of the way to show this in inside 'view' folder, in this example 'app/views/reviews/_form.html.erb'
  - add validation box html like below
  - using ruby if, it will loop through each validation
    ```
    <!-- using rails method of validation -->
    <% if @review.errors.any? %>
      <% @review.errors.full_messages.each do |message| %>
        <p>
          <%= message %>
        </p>
      <% end %>
    <% end %>
    ```
  - the message will display based on the model validate specified in 'app/models/review.rb'

--------------------------------------------------------------------------------

# Using to_param to make SEO-friendly URLs

 - We can override default urls to be SEO friendly inside app/models/review.rb
   ```
      #changing the to_prarams default, take the ID and change it to string (title friendly url)
      def to_param
        id.to_s + "-" + title.parameterize
      end
   ```

--------------------------------------------------------------------------------

Adding page titles with content_for

  - We can easily make content detail page changes dynamically by doing the following
  - Using this special ruby tag, we can grab from certain views (show/new.html.erb).
  - first, we go to 'app/views/layouts/application.html.erb', open '<title>' since this shows everywhere on the site
    ```
      <title> <%= content_for :page_title %> - SuperhiBien </title>
    ```
  - Now create a 'ruby symbol' inside 'app/views/reviews/show.html.erb' (top of the page)
    ```
      <!-- Define it here, so this will print out on the application.html.erb -->
      <% content_for :page_title, @review.title %>
    ```
  - for views that might have a variable to put, we can do the following app/views/reviews/new.html.erb
    ```
      <!-- dont print out coz we going to print elsewhere -->
      <% content_for :page_title, "Add a new review" %>
    ```

--------------------------------------------------------------------------------

Adding new database fields with migrations
https://edgeguides.rubyonrails.org/active_record_migrations.html

 - We can find out what's in our database by 'db/schema.rb'
 - Remember DO NOT EDIT this.
 - What we should do instead is add a migration, located inside 'db/migrate'
 - so go to command and run the following
   ```
     rails generate migration [name of migration] i.e add_new_info_to_review
   ```
 - it will then generate another db file, inside it we add the following code in between 'def change'
   ```
    def change
      add_column :reviews, :phone_number, :string
      add_column :reviews, :ambiance, :string
    end
   ```
  - So it will like as follow:
    add_column :[name of table], :[name of field], :[type of field]

  - Remember to always double check and save. Its easier than having to re-do the whole process
  - Once ok, go back to the terminal and run
    ```
      rails db:migrate
    ```
  - To double check whether the migration is successful, you can go to 'db/schema.rb', it should just update itself

  - You can now add validation model inside 'review.rb' and view 'app/views/reviews/_form.html.erb'

  - also dont forget to update controller 'app/controllers/reviews_controller.rb'
    ```
      # creating a new function that will hold templated function
      def form_params
        params.require(:review).permit(:title, :restaurant, :body, :score, :ambiance)
      end
    ```
  - in order to display the new fields in detail view, dont forget to update here too: 'app/views/reviews/show.html.erb'

--------------------------------------------------------------------------------

How to add filter params

  - Inside 'app/controllers/reviews_controller.rb' you can filter by using query parameter in the url

    ```
      # def is function in ruby. Telling that the index page coming from app/views/reviews/index.html.erb
      def index
        # this is our list page for our review
        # variable is @.
        # creating a filter variable for price
        @price = params[:price]
        #creating a filter variable for cuisine
        @cuisine = params[:cuisine]

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
      end

    ```
    - we can now set some links in rails that acts as a filter, add it inside 'app/views/reviews/index.html.erb'
      ```
        <!-- adding links that matches price based on query params (controller) -->
        <nav class="filters">
          <%= link_to "All prices", root_path %>
          <%= link_to "$", root_path(price: 1) %>
          <%= link_to "$$", root_path(price: 2) %>
          <%= link_to "$$$", root_path(price: 3) %>
        </nav>
      ```
    - Be sure to change the type of input field on the _form.html.erb to radio button for effective use. NOTE did a db migration where we change "price" from an interger to a number - slightly different than this tuts.
      ```
      <!-- adding links that matches price based on query params (controller) -->
      <nav class="filters">
        <%= link_to "All Restaurant", root_path %>
        <%= link_to "Cheap", root_path(price: "Cheap") %>
        <%= link_to "Reasonable", root_path(price: "Reasonable") %>
        <%= link_to "Pricey", root_path(price: "Pricey") %>

        <%= link_to "American", root_path(cuisine: "American") %>
        <%= link_to "Comfort", root_path(cuisine: "Comfort") %>
        <%= link_to "Fusion", root_path(cuisine: "Fusion") %>
      </nav>
      ```
    - radio button ruby helper in _form.html.erb
      ```
        <p>
          <%= f.label :price %>
          <%= f.radio_button :price, "Cheap" %> Cheap<br />
          <%= f.radio_button :price, "Reasonable" %> Reasonable<br />
          <%= f.radio_button :price, "Pricey" %> Pricey<br />
        </p>
      ```
    - To merge the two filter together, we can just add another param like so
      ```
        ...
          <!-- will loop through and filter both queries. @cuisine refers from the controller defined in the code -->
          <%= link_to "Cheap", root_path(price: "Cheap", cuisine: @cuisine) %>
        ...
          <!--will loop through and filter both queries. @price refers from the controller defined in the code -->
          <%= link_to "American", root_path(cuisine: "American", price:@price) %>
      ```

--------------------------------------------------------------------------------

# Adding geolocation using the geocoder gem

  - We can install 3rd party  gems, as we're using rails/bundler we add this to our gemfile
    ```
      #add in our geocoding
      gem 'geocoder'
    ```
  - and run the following command prompt
    ```
      bundle install
    ```
  - Do database migration with the following attributes and then add these to our model
    ```
      rails generate migration add_location_to_reviews
    ```
  - inside of the new migration file, add in the following
    ```
      def change
        add_column :reviews, :address, :text
        add_column :reviews, :latitude, :float
        add_column :reviews, :longitude, :float
      end
    ```
  - So it will like as follow:
    add_column :[name of table], :[name of field], :[type of field]

  - once done, run ```rails db:migrate```
  - Now we need update our model 'app/models/review.rb'
    ```
      #from geocoder gems
      geocoded_by :address
      after_validation :geocode
    ```
  - now part of it to validate if address is entered
    ```
      ...
        #adding validation for our address, part of geocoder
        validates :address, presence: true
      ...
    ```

  - inside our 'app/views/reviews/_form.html.erb' we now need to add our fields
    ```
      <p>
        <%= f.label :address %>
        <%= f.text_field :address %>
      </p>
    ```
  - We now need to add it as part of our controller as well (at the bottom)
    ```
      # creating a new function that will hold templated function
      def form_params
        params.require(:review).permit(:title, :restaurant, :body, :score, :ambiance, :cuisine, :price, :address)
      end
    ```

--------------------------------------------------------------------------------

# Filtering by location

  - using geocoder gem, we will ad the filter in our query params (similar to the cuisine and price filters).

  - inside 'app/controllers/reviews_controller.rb' add the following (at the top of def index..)
    ```
      ...
        # adding location filter using geocoder
        @location = params[:location]
      ...

    ```
    - after cuisine function add the following
      ```
      ...
        #search near the location
        if @location.present?
          # .near is what geo location given to us - see docs
          @reviews = @reviews.near(@location)
        end
        ...
      ```

    - full code below
      ```
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
      ```


--------------------------------------------------------------------------------

# Adding a search location form

  - Submit search query by add in our own form without ruby helper, inside 'app/views/reviews/index.html.erb'
      ```
        <!-- search location -->
        <form action="/">
          <input type="text" name="location" placeholder="search location...." value="<%= @location %>">
          <!-- adding some hidden fields for cuisine and price filtering -->
          <input type="hidden" name="price" value="<%= @price %>">
          <input type="hidden" name="cuisine" value="<%= @cuisine %>">
        </form>
      ```
    - we now need to slightly update our two additional filter to add the location params
        ```
        ...
          <!-- will loop through and filter both queries. @cuisine refers from the controller defined in the code -->
          <%= link_to "Cheap", root_path(price: "Cheap", cuisine:@cuisine, location: @location) %>
        ...
        ```
        ```
        ...
          <!--will loop through and filter both queries. @price refers from the controller defined in the code -->
          <%= link_to "American", root_path(cuisine: "American", price:@price, location: @location) ) %>
        ...
        ```

--------------------------------------------------------------------------------

# Making our forms simple using simple_form

  - simple_form is a ruby gem that is easy to create ruby form: https://github.com/plataformatec/simple_form

  - Inside gemfile add the following
      ```
        gem 'simple_form'
      ```
  - run the command
      ```
        bundle install
      ```
  - run the generator
    ```
      rails generate simple_form:install
    ```
  - We can now use simple form in our app 'app/views/reviews/_form.html.erb'. We can now reduce the code, replace with the following
    ```
      <%= simple_form_for @review do |f| %>
        <%= f.input :title %>
        <%= f.input :restaurant %>
        <%= f.input :address %>
        <%= f.input :body %>
        <%= f.input :cuisine %>
        <%= f.input :ambiance %>
        <%= f.input :score %>
        <%= f.radio_button :price, "Cheap" %> Cheap<br />
        <%= f.radio_button :price, "Reasonable" %> Reasonable<br />
        <%= f.radio_button :price, "Pricey" %> Pricey<br />

        <%= f.button :submit %>
      <% end %>
    ```
    NOTE: old reference using ruby ifs
    ```
      <!-- using rails method of validation
      <% if @review.errors.any? %>
        <div class="errors">
          <% @review.errors.full_messages.each do |message| %>
            <p>
              <%= message %>
            </p>
          <% end %>
        </div>
      <% end %>
      <!-- using rails method of validation -->
    ```

--------------------------------------------------------------------------------

# Highlighting our links with active_link_to

  - Using 'active_link_to' gem to help improve ux when user click on links
  - Otherwise, we'll have to use alot of ifs statement
      ```
        gem 'active_link_to'
      ```
  - and run ``` bundle install```

  - make sure you'll have added css class first

  - then inside filter 'app/views/reviews/index.html.erb' change all 'link_to' => 'active_link_to'
      ```
        <%= active_link_to ... %>
      ```
  - We'll now need to add some filter as all of our link on the current page.
      ```
        ... , active: { price: "Cheap"} %>
      ```

  - for "all restaurant" we need to tweak this since we're always on the root_path, so add additional filter so that it will not highlights all the time only when the following params are nil
    ```
      <%= active_link_to "All Restaurants", root_path, active: { price: nil, cuisine: nil, location: nil} %>
    ```

--------------------------------------------------------------------------------

# Adding the Comment model

  - Creating a comment feature, this will a new model which has one-to-many relationship. i.e One review with many comments

  - in the command, run the following
    ```
      rails generate model Comment body:text review:belongs_to
    ```
  - Remember model will always be singular and capital at the begining. ``` rails generate [name of model] [name of columnn: type of data] [relationship to which model:belong_to]

  - It will now add all all of the comments and also the code for the model

  - Once we've checked the details in 'db/migrate' we can run `rails db:migrate`

  - The next thing we'll do is to connect both models 'app/models/comment.rb' & 'app/models/review.rb'

  - Inside 'app/models/review.rb' is let it know it has potential multiple comments (top of the page)
      ```
        # add an association that has 1-to-many relationship
        has_many :comments
      ```
  - we'll now go 'app/models/comment.rb' and add one extra line (validation)
      ```
        # adding validation for the body no empty comments
        validates :body, presence: true
      ```

--------------------------------------------------------------------------------

# Creating a comments controller

  - Create a comment controller where user can add comments, we generate a new controller
      ```
        rails generate controller comments
      ```
  - remember the name will be plurals with no caps ``` rails generate [name of controller]
  - The next thing we're going to fix is url for the comment to be added. Inside 'config/routes.rb'
      ```
        resources :reviews do
          # tie comments as part of reviews
          resources :comments
        end
      ```
  - the next thing we'll do add a comment form inside reviews "views" 'app/views/reviews/show.html.erb'
      ```
        <h3>Add a comment</h3>
        <!--This is how we tie comments inside review [(take from @variable), (make latest from Model)] -->
        <%= simple_form_for [@review, Comment.new] do |f| %>
          <!-- This is where the form goes -->
          <%= f.input :body %>
          <%= f.button :submit, "Add comment" %>
        <% end %>
      ```
  - Next, we'll need to add 'create' action to the commentController in 'app/controllers/comments_controller.rb'
      ```
        #take the body that we pass through and find the review
        def create
          # find the review based on resources set in config/routes.rb
          @review = Review.find(params[:review_id])
          #make a brand new comments using form params and only take the body based on @review
          @comment = @review.comments.new(params.require(:comment).permit(:body))
          #save the new comment
          @comment.save
          # redirect back show page
          redirect_to review_path(@review)
        end
      ```
--------------------------------------------------------------------------------

# Letting our users comment on reviews

  - inside 'app/views/reviews/show.html.erb' we can show added comments as follow
      ```
        <h3>Comments</h3>
        <!-- loop through each comments by descending order |[name of action]| -->
        <% @review.comments.order("created_at desc").each do |comment| %>
          <div class="comment">
            <!-- simple_format is ruby helper -->
            <%= simple_format comment.body %>
            <!-- another ruby helper time_ago_in_words -->
            <p class="posted"> Posted at <%= time_ago_in_words comment.created_at %> ago</p>
          </div>
        <% end %>
      ```

--------------------------------------------------------------------------------

# Displaying how many comments in each reviews

  - inside 'app/views/reviews/index.html.erb' inside the loop, update the code to the following
      ```
        <!-- ruby for loop. within this area, repeat each @reviews items -->
        <% @reviews.each do |review| %>
          <div class="review">
            <!-- linking to corresponding reviews -->
            <%= link_to review_path(review) do %>
              <!-- grabbing the following inside each loop -->
              <h2><%= review.title %></h2>
              <p>
                <!-- ruby helper pluralize -->
                <%= review.cuisine %> - <%= pluralize review.comments.count, "comment" %>
              </p>
            <% end %>
          </div>
        <% end%>
      ```
      ```

--------------------------------------------------------------------------------

# Deploying our site using Heroku

- sign up for heroku (personal) account.
- make sure that heroku cli is installed as well as posgrestsql
- make sure you ``` heroku login ```
- once in, we need to swap our sqlite3 => postgrest. so we will update gemfile where we set sqlite3 for dev, posgrest for production 'Gemfile'
    ```
      # Use sqlite3 as the database for Active Record - only do sqlite3 in development mode
      group :development do
        gem 'sqlite3'
      end
      # when in production mode - we use posgrestsql for heroku
      group :production do
        gem 'pg'
      end
    ```
- run ``` bundle install ```

- Next, we need to specify heroku which version of ruby in app. check ``` ruby -v```  once command provide the reply, add it in gemfile
  ```
    # heroku which version of ruby
     ruby '2.4.1'
  ```
- since we will deploy on heroku via git, make sure we commit any changes on project/branch

- once code is committed, we now log back in to heroku via terminal
    ```
      heroku create
    ```
- once entered, it will provide the url
- now we need to push our code to heroku
    ```
      git push heroku master
    ```

- once its deployed, we now need to set up our database for heroku (posgrest), the way we talk is like below
    ```
      heroku run rails db:migrate
    ```

- the site should be up and running

--------------------------------------------------------------------------------

# User login set up

  - User sign up
  - User log in
  - Showing that we're logged in
  - User log ot
  - Hooking up reviews and comments
  - Authorization
  - bookmarking / favourting

  - In this app, we will need to create user association within our existing models: Review and comment.
      - Review (one[has_many]) => Comment (many [belongs_to])
      - User(one) => Review (many) => Comment (many)
      - So we need to update this in our code

--------------------------------------------------------------------------------

  - What is a user model
    - Username (unique, required)
    - Email (unique, required)
    - Password_digest
    - real_name

  - We will be using ```gem 'bcrypt'``` as our password. This is already in our gem file so all we need to do is run bundle install

--------------------------------------------------------------------------------

# The User model

    - in command prompt do the following:
      ```
        rails generate model User username:string email:string password_digest:string real_name:string
      ```
    - Remember model will always be singular and capital at the begining. ``` rails generate [name of model] [name of columnn: type of data] [relationship to which model:belong_to]
    - once we've checked and see all of the information are correct, we can then sync it to database by running the following
      ```
        rails db:migrate
      ```
    -  Keep the typo in there, then run rails
        ```
          db:rollback
        ```
      which will move the migration back one step to before you ran it, fix the typo again, then run rails db:migrate to re-run the migration again but with the fix

    - Next in our user model 'app/models/user.rb'  we need to set secure password like the following:
        ```
          # add secure data
          has_secure_password
          # make sure there's field entered and unique
          validates :username, presence: true, uniqueness: true
          validates :email, presence: true, uniqueness: true
        ```

--------------------------------------------------------------------------------

# Adding our users controller

  - The next thing we need to do is create sign up flow (user controller).
    - Index
    - Show
    - New (sign up flow)
    - Create (sign up flow)

  - so in the command line run the following
      ```
        rails generate controller users
      ```
  - remember the name will be plurals with no caps ``` rails generate [name of controller] ```

  - once this is generated, we now need to add routes for user to go to. inside 'config/routes.rb'
      ```
        #sign up path
        resources :users
      ```
  - once route is defined, we go back to 'app/controllers/users_controller.rbb' and create the following
    ```
      # form for adding new user
      def new
        # this new user will be defined in our form
        @user = User.new

      end

    ```
  - we then go inside our 'app/views/users' and create a new.html.erb.
  - We can now start adding form fields in this file
    ```
      <!-- this is a new form for @user added in controller. The text between the |[name of variable]| characters are the new variable in view folder  -->
      <%= simple_form_for @user do |f| %>
        <%= f.input :username %>
        <%= f.input :email %>

        <%= f.button :submit, 'Sign up' %>
      <% end %>
    ```
  - based on has_secure_password, we need to the following
    ```
      <%= f.input :password %>
      <%= f.input :password_confirmation %>
    ```

--------------------------------------------------------------------------------

# Creating users

  - We need to now define the create controller in our  'app/controllers/users_controller.rb'
    ```
      #creating a new user on sign up
      def create
        #take the params from the form
        #create a new user,
        @user = User.new(form_params)
        #if valid saves, go to list users page
        if @user.save
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
    ```
--------------------------------------------------------------------------------

# Listing all users

  - To create a list of all users, do the following
    ```
      #creating all of users
      def index
        @users = User.all
      end
    ```
  - Dont forget, to then add the index view 'app/views/users/index.html.erb'
    ```
      <!-- loop all all users -->
      <% @users.each do |user| %>
        <p>
          <%= user.username %> (<%= user.email %>)
        </p>

      <% end %>
    ```
--------------------------------------------------------------------------------

# Implementing sessions

 - session stays with you through different page views. So for logged in user, we will one one session each time. We will add a session controller that will show:
   - form(new action),
   - create,
   - destroy.

 - sessions itself is built onto rails, therefore we dont need any model. So with this, we can go to View  & Controller.

 - so in the command line run the following
     ```
       rails generate controller sessions
     ```
 - remember the name will be plurals with no caps ``` rails generate [name of controller] ```

 - we do not need to worry about migration for this one.

 - The next thing we'll need to do is create the url first, inside 'config/routes.rb'
    ```
      #the session url is not reliant on anything, its a completely different flow so we do the following
      resources :sessions
    ```

 - inside the new controller app/controllers/sessions_controller.rb, we'll do the following:
    ```
      #this is where the logged in user will be directed to
      def new
        #login form
      end

      def create
        #actually try and log in
      end

      def destroy
        #log us out
      end
    ```
    - the next this we'll do is to create the following views 'app/views/sessions/new.html.erb' and add a simpleform
     ```
     <!-- this is a placeholder for session so URL will be use in the POST method-->
     <%= simple_form_for :session, url: sessions_path do |f| %>
       <%= f.input :username %>
       <%= f.input :password %>

       <%= f.button :submit, "log in" %>
    ```

    - the next this after the form is created, we need to define 'def create' in the controller so that we tell rails what to do.

      ```
        #actually try and log in
        def create

          #take the data entered and see if it matches with existing users
          @form_data = params.require(:session)
          #pull out the username and password form the form data (from object data)
          @username = form_data[:username]
          @password = form_data[:password]

          #lets check the user is who they say they are (checking username and match it with the password stored)
          @user = User.find_by(username: @username).try(:authenticate, @password)

          if @user
            #if user is present, redirect to home page
            redirect_to root_path
          else
            #if not, show the form again with error (preloaded via simple_form)
            render "new"
          end

        end
      ```
      ```
--------------------------------------------------------------------------------

# Adding a session on login

  - We now need to 'hold' the user as they navigate through the website. Inside 'app/controllers/sessions_controller.rb' we need to add the following

  - session is like hash similar to '[:username]' '[:password]'
    ```
      if @user
        # we also want to 'store' the user id as they navigate around the website
        session[:user_id] = @user.id
        #if user is present, redirect to home page
        redirect_to root_path
      else
        #if not, show the form again with error (preloaded via simple_form)
        render "new"
      end
    ```
  - The next thing we want to do, we can add user identification in our 'app/views/layouts/application.html.erb'
    ```
      <nav>
        <!-- user identification via "session" -->
        User ID: <%= session[:user_id] %>
        <!-- rails built-in helpers to link within site -->
        <%= link_to "Add a review", new_review_path %>
      </nav>
    ```
--------------------------------------------------------------------------------

# Adding a session on signup

  - We also need to do the same for sign up, inside the 'app/controllers/users_controller.rb' we can add the following after user is saved
    ```
      if @user.save
        # add in 'session' after user signed up
        session[:user_id] = @user.id
        redirect_to users_path

      else
    ```

--------------------------------------------------------------------------------

# Adding sign up and log in links

  - we can now add conditions based on sessions. in this case, we can show sign up and log in if there's no session present, we need to modify the following inside 'app/views/layouts/application.html.erb'

    ```
      <nav>
        <!-- if statement to see if user has session -->
        <% if session[:user_id].present? %>
          <!-- rails built-in helpers to link within site -->
          <!-- user identification via "session" -->
          User ID: <%= session[:user_id] %>
          <%= link_to "Add a review", new_review_path %>
        <% else %>
          <!-- if not signed up/login show the links -->
          <%= link_to "Sign up", new_user_path %>
          <%= link_to "Log in", new_session_path %>
        <% end %>
      </nav>

    ```
--------------------------------------------------------------------------------

# Singular resources and log out

  - We can easily change session to handle only one at a time. inside 'config/routes.rb', change the following:
    ```
      #the session url is not reliant on anything, its a completely different flow so we do the following
      resource :session
    ```
  - now inside 'app/views/layouts/application.html.erb' we add a link in the nav
    ```
      ...
        <!-- remove session with method "delet" -->
        <%= link_to "Log out", session_path, method: :delete  %>
      ...
    ```
  - Do not forget to also update the log in to a singular session like below 'app/views/sessions/new.html.erb':
    ```
      ...
        <%= simple_form_for :session, url: session_path do |f| %>
      ...
    ```
  - We now need to complete the log out functionality, we go to 'app/controllers/sessions_controller.rb'
    ```
      def destroy
        #log us out by remove the session completely
        #this is built into rails helper, control within rails itself
        reset_session
        #take them to login page
        redirect_to new_session_path
      end
    ```
--------------------------------------------------------------------------------

# The application controller

  - 'app/controllers/application_controller.rb' sits above every other controllers. this means its their 'boss' i.e it controls every other controller what to do.

  - So we can use some code everywhere on the site by add it in the application_controller. We do this by creating function like below:
    ```
      #before any page loads find current_user
      #this is built into rails - action is an index, show, view, update and destroy
      before_action :find_current_user

      #creating function to find current user
      def find_current_user
        # adding if to prevent rails from checking user when logged out
        if session[:user_id].present?
          #save to a variable
          @current_user = User.find(session:[:user_id]);
        else
          @current_user = nill
        end
      end
    ```
  - adding function to check login status to prevent user from performing logged in function like adding review .etc
    ```
      #check login status
      def login_status
        #see if user id present
        if session[:user_id].present?
          #all good
        else
          #take them to login page
          redirect_to new_session_path
        end
      end
    ```

  - We can update our 'app/controllers/reviews_controller.rb' to check if user logged in
    ```
      # check if logged in from application_controller function. we can also add exceptions after commas exept[(:action), :action)]
      before_action :login_status, except: [:index, :show]
    ```

  - we can now go inside the 'app/views/layouts/application.html.erb' and identify the current user like so:
    ```
      ...
        <!-- user identification via "session" -->
        <%= @current_user.username %>
      ...
    ```

  - final tweaks to the site
    ```
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
          @current_user = nill
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
    ```
--------------------------------------------------------------------------------

# Updating our previous models

  - we now need to tweak our database (model) so that each comment and review to have user id.
  - In our command prompt we're going to make a new migration as we're changing the database
      ```
        rails generate migration hook_up_comments_reviews_to_users
      ```
    remember its: rails generate migration [name of migration]

  - we now need to make two changes in the new generated migration file
    ```
      def change
        add_column :reviews, :user_id, :integer
        add_column :comments, :user_id, :integer
      end
    ```

  - once the spelling is correct, we'll then run migration
    ```
      rails db:migrate
    ```
  - once done, we now need to tell the models that we hooked up a certain way. first for 'app/models/user.rb'
    ```
      #user updating model hook up
      has_many :reviews
      has_many :comments
    ```
  - now, go to our review 'app/models/review.rb'
    ```
      add an association to user
      belongs_to :user
    ```
  - remember this is always singular

  - also lastly in our 'app/models/comment.rb'
    ```
      belongs_to :user
    ```
--------------------------------------------------------------------------------

# Adding users to controllers

  - since we've already got most of the code in our ApplicationController, we just need to update on a few things.

  - inside 'app/controllers/reviews_controller.rb' we're going to add in in the create function inside the model
    ```
      # and then associate it with a user
      @review.user = @current_user
    ```

  - We do the same thing for our comment user 'app/controllers/comments_controller.rb'
      ```
        #before we save the comment
        @comment.user = @current_user
      ```

  - we can now showcase the user posted comments 'app/views/reviews/show.html.erb'
    ```
      <!-- adding user posted -->
      <p class="posted">
        Posted by
        <% if comment.user.present? %>
          <%= link_to  comment.user.username, user_path(comment.user) %>
        <% else %>
          anontmous
        <% end %>

      </p>
    ```

--------------------------------------------------------------------------------

# Creating a user profile page

  - we will create a user profile so that user can click through the profile page, inside 'app/controllers/users_controller.rb' we will create a 'show' function
    ```
      #creating the user profile page
      def show
        @user = User.find_by(username: params[:id])
      end
    ```
  - we now need to create a show page in the views app/views/users/show.html.erb. we'll use @user
    ```
      <h2>
        <%= @user.username %>
      </h2>
      <p>
        Their email is <%= @user.email %>
      </p>
    ```
  - we can update the url by changing the params in our model
    ```
      # creating the url for user profile, overidding the default 'app/models/user.rb'
      def to_param
        username
      end
    ```

--------------------------------------------------------------------------------

# Removing actions

  - we can create an if to only let particular user to edit/remove reviews. inside 'app/views/reviews/show.html.erb'
    ```
      <!-- if statement validation if you're the posted reviewer -->
      <% if @review.user == @current_user %>
        <div class="actions">
          <!--adding button to edit current review -->
          <%= link_to "Edit this review", edit_review_path(@review) %>
          <!-- adding the button that will delete with confirmation  -->
          <%= link_to "Delete this review", review_path(@review), method: :delete, data: {confirm: "Are you sure?"}  %>
        </div>
      <% end %>
    ```
  - we also need to authorise a user so that they can't edit via typing in the url path. inside 'app/controllers/reviews_controller.rb' change inside the edit/destroy function

    ```
      #adding new function to edit review
      def edit
        #find the individual review to edit
        @review = Review.find(params[:id])
        # make sure non posted user can edit without the url (!= is not)
        if @review. user != @current_user
          # take it back to homepage
          redirect_to root_path
        end
      end
    ```
  - we also need to stop hackers from destroying the entry, inside the destroy function
      ```
        # check if user is current poster
        if @review.user == @current_user
          #destroy it
            @review.destroy
        end
      ```
  - we also do this for update function too
    ```
      # adding new function to update the editted review
      def update
        #find the individual review
        @review = Review.find(params[:id])

        #check to see if you're the poster
        if @review.user != @current_user
          #take it back to homepage
          redirect_to root_path
        else
          #update the new info from the form - update with new info from the form
          if @review.update(form_params)
            #redirect to individual show page
            redirect_to review_path(@review)
          else
            # using this it will render any validation to the main edit page
            render "edit"
          end
        end
      end
    ```

--------------------------------------------------------------------------------

#  The bookmark model

  - Creating the bookmark model which is going to be similar process. In the command prompt
    ```
      rails generate model Bookmark review:belongs_to user:belongs_to
    ```
  - Remember model will always be singular and capital at the begining. ``` rails generate [name of model] [name of columnn: type of data] [relationship to which model:belong_to]

  - Always check the migration once we can run ``` rails db:migrate ```

  - once done, the next thing we're going to do is link up bookmark => users and reviews

  - in the 'app/models/review.rb' and 'app/models/user.rb' we need to add the following
    ```
      # add an association that has 1-to-many relationship
      has_many :bookmarks
    ```
  - the last thing we need to do in 'app/models/bookmark.rb'
    ```
      #making it unique per user per review by adding scope { scope: [type of model]}
      validates :review, uniqueness: {scope: :user}
    ```

--------------------------------------------------------------------------------

#  Creating bookmarks

  - The next thing we'll do generate the model

  - so in the command line run the following
      ```
        rails generate controller bookmarks
      ```
  - remember the name will be plurals with no caps ``` rails generate [name of controller] ```

  - now, we'll need to specify the url 'config/routes.rb'
    ```
      resources :reviews do
        # tie comments as part of reviews
        resources :comments
        #bookmark going to be in comments and review. One per user therefore singular
        resource :bookmark

      end
    ```
  - by looking at the review_bookmark, we'll be focusing on POST and DELETE methods.

  - We're going to specify where we can 'bookmark' the 'app/views/reviews/show.html.erb'
    ```
      <!-- adding bookmark only if youre logged in -->
      <% if is_logged_in? %>
        <!-- linking which bookmark to linked to (review) -->
        <p>
          <%= link_to "Bookmark", review_bookmark_path(@review), method: :post %>
        </p>

      <% end %>
    ```
  - we now need to add the POST bookmark method controller 'app/controllers/bookmarks_controller.rb'
    ```
      # this bookmark feature is only for logged in user (in ApplicationController)
      before_action :check_login

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
      ```
--------------------------------------------------------------------------------

# Un-bookmarking

  - we can add conditional if statement that will look at all current users and set conditions
    ```
      <!-- adding bookmark only if youre logged in -->
      <% if is_logged_in? %>
        <!-- linking which bookmark to linked to (review) -->
        <p>
          <!-- This if statment will produce an array of all users that currently bookmarked  -->
          <% if @review.bookmarks.where(user: @current_user).any? %>
            <!-- if current user bookmarked this already, can unbookmark -->
            Unbookmark
          <% else %>
            <!-- the produced array, user hasn't bookmark this already, can bookmark -->
            <%= link_to "Bookmark", review_bookmark_path(@review), method: :post %>
          <% end %>

        </p>

      <% end %>
    ```
  - we can then do the DELETE methods in the url, we update the link like so (update the bit above):
    ```
      <!-- if current user bookmarked this already, can unbookmark -->
      <%= link_to "Unbookmark", review_bookmark_path(@review), method: :delete %>
    ```
  - We now need to set the "destroy" function in our controller 'app/controllers/bookmarks_controller.rb'
    ```
      #creating the unbookmark function
      def destroy
        # find the bookmark from user
        @review = Review.find(params[:review_id])
        #unbookmark the item from particular user - see show.html.erb
        @review.bookmarks.where(user: @current_user).delete_all

        #redirect to review page
        redirect_to review_path(@review)
      end
    ```

--------------------------------------------------------------------------------

# Listing all bookmarks

  - we can list out all of the user bookmarked reviews on the page. inside 'app/views/reviews/show.html.erb'
    ```
      <!-- Show all bookmarks -->
      <h3>Bookmarked by....</h3>
      <ul>
        <!-- using rails to loop through users -->
        <% @review.bookmarks.each do |bookmark| %>
          <!-- list -->
          <li>
            <%= bookmark.user.username %>
          </li>
        <% end %>
      </ul>
    ```
