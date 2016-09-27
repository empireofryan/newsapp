class WelcomeController < ApplicationController
  def index
    @movies = Movie.all
    @mediums = Medium.all
    @awwwards = Awwward.all
    @economists = Economist.all
    @vimeos = Vimeo.all
    @deals = Amazon.all
    @twitters = Twitter.all
    @nytimes = Nytime.all
    @googles = Google.all
    @nextwebs = Thenextweb.all
  end
end
