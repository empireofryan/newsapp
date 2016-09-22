class WelcomeController < ApplicationController
  def index
    @movies = Movie.all
  end
end
