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
end
