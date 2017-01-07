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
    @imgurs = Imgur.all
    @cnns = Cnn.all
    @reddits = Reddit.all
    @economists2 = Economist2.all
    @hackernews = Hackernew.all
    @wsjs = Wsj.all
    @times = Time2.all
    @usatodays = Usatoday.all
    @newsweeks = Newsweek.all
    @huffpost = Huffpost.all
    @espns = Espn.all
    @foxnews = Foxnew.all
    @buzzfeeds = Buzzfeed.all
    @washingtonposts = Washingtonpost.all
    @drudges = Drudge.all
    @newyorktimes = Newyorktime.al
    @total_articles = Nytime.past_day.all.count

  #  Movie.first_three
    @chart = Fusioncharts::Chart.new({
        width: "600",
        height: "400",
        type: "mscolumn2d",
        renderAt: "chartContainer",
        dataSource: {
            chart: {
            caption: "Comparison of Quarterly Revenue",
            subCaption: "Harry's SuperMart",
            xAxisname: "Quarter",
            yAxisName: "Amount ($)",
            numberPrefix: "$",
            theme: "fint",
            exportEnabled: "1",
            },
            categories: [{
                    category: [
                        { label: "Q1" },
                        { label: "Q2" },
                        { label: "Q3" },
                        { label: "Q4" }
                    ]
                }],
                dataset: [
                    {
                        seriesname: "Previous Year",
                        data: [
                            { value: "10000" },
                            { value: "11500" },
                            { value: "12500" },
                            { value: "15000" }
                        ]
                    },
                    {
                        seriesname: "Current Year",
                        data: [
                            { value: "25400" },
                            { value: "29800" },
                            { value: "21800" },
                            { value: "26800" }
                        ]
                    }
              ]
        }
    })
  end
  def refresh_part
    # get whatever data you need to a variable named @data
    @data = Nytime.all.last
    respond_to do |format|
      format.js
    end
  end
end
