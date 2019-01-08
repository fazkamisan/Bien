class PagesController < ApplicationController

  # creating a function for this "about.html.erb" to dynamically edit in active admin
  def home
    #grabbing the page content via the url
    @content = Page.find_by(url: "home")

    #grabbing high 8 review - pulling from review model
    @highly_rated_reviews = Review.where("score >= 8")

    # grabbing the cureated review
    @featured_reviews = Review.where(is_featured: true)
  end

  def about
    #grabbing the page content via the url
    @content = Page.find_by(url: "about")
  end

  def terms
    #grabbing the page content via the url
    @content = Page.find_by(url: "terms")
  end



end
