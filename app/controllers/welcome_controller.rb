class WelcomeController < ApplicationController
  def index
    @movies = Movie.all
    @mediums = Medium.all
  end
end
