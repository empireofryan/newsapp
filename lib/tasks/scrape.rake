namespace :scrape do
  task :moneymaker => [ :environment ] do
  desc '$$$ making paper $$$'
  require 'phantomjs'
  require 'watir'
  require 'nokogiri'
  require 'date'
  require 'time'
  require 'chronic'
  require 'active_support/all'
  require 'timeout'
  TIMEOUT = 10 # seconds
# begin
#   Timeout::timeout(TIMEOUT) do
#     # your http call
#   end
# rescue Timeout::Error
#   # handle http call timed out
# end


  # def init_scrape_monitor
  #   @props_found = 0
  #   @props_created = 0
  #   @props_updated = 0
  #   @started_at = Time.now.in_time_zone
  # end

  # def notify_scrape_monitor(name)
  #   ScrapeMonitor.create!(name: name, ran_at: @started_at,
  #   props_found: @props_found, props_created: @props_created, props_updated: @props_updated)
  # end

  puts ' ____  __.__        __                              _________'
  puts '|    |/ _|__| ____ |  | _______    ______ ______   /   _____/ ________________  ______   ___________'
  puts '|      < |  |/ ___\|  |/ /\__  \  /  ___//  ___/   \_____  \_/ ___\_  __ \__  \ \____ \_/ __ \_  __ \ '
  puts '|    |  \|  \  \___|    <  / __ \_\___ \ \___ \    /        \  \___|  | \// __ \|  |_> >  ___/|  | \/ '
  puts '|____|__ \__|\___  >__|_ \(____  /____  >____  >  /_______  /\___  >__|  (____  /   __/ \___  >__| '
  puts '        \/       \/     \/     \/     \/     \/           \/     \/           \/|__|        \/        '
  puts ' '
  puts 'Bringing you the best of the web...'
  puts ' '
  t1 = Time.now
  puts 'time begun ' + t1.to_s

  #movies #run movies scraper
  medium
end

  def movies
    b = Watir::Browser.new(:phantomjs)
    b.goto 'https://www.rottentomatoes.com/top/'

    doc = Nokogiri::HTML(b.html)

    a = doc.css('.movie_list')[8]
    b = a.css('tr td a')
    c = a.css('tr td').first.attr('href')
    d = a.css('tr td').first.attr('value')
    e = a.css('tr td').first.attr(['href'])
    f = a.css('tr td').first.attr(['value'])
    z = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    z.each do |i|
      link = b[i]['href']
      puts link
      url = 'http://www.rottentomatoes.com' + link
      title = b[i].text
      puts title
      @movie = Movie.find_or_create_by(title: title, url: url)
      @movie.save
      puts 'Movie created!'
      puts " "
    end
    end
  end # end movies

  def medium
    b = Watir::Browser.new(:phantomjs)
    b.goto 'https://medium.com/browse/top'

    doc = Nokogiri::HTML(b.html)
    a = doc.css('.postArticle-content a h3')
    b = doc.css('.postArticle-content a')
    c = a.count.to_i
    c = c - 1
    z = (0..c).to_a
    puts z
     z.each do |i|
       link = b[i]['href']
       puts link
       url = link
       title = a[i.to_i].text
       puts title
       @medium = Medium.find_or_create_by(title: title, url: url)
       @medium.save
       puts 'Medium article created!'
       puts " "
     end

    # a.each do |article|
    #   puts article.text
    #   link = article['href']
    #   puts link
    # end
  end
