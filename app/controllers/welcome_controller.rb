class WelcomeController < ApplicationController
  def index
    @movies = Movie.all
    @mediums = Medium.all
    @awwwards = Awwward.all
    @economists = Economist.all
    @vimeos = Vimeo.all
    @twitters = Twitter.all
  end
end
