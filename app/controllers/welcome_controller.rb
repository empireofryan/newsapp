class WelcomeController < ApplicationController
  def index
    @movies = Movie.all
    @mediums = Medium.all
    @awwwards = Awwward.all
  end
end
