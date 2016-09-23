class WelcomeController < ApplicationController
  def index
    @movies = Movie.all
    @mediums = Medium.all
    @awwwards = Awwward.all
    @economists = Economist.all
  end
end
