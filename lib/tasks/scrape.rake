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

  b = Watir::Browser.new(:phantomjs)

  b.goto 'https://www.rottentomatoes.com/top/'

  doc = Nokogiri::HTML(b.html)

  #puts doc.to_html
  #ONLY RETURN LINKS
  sites = []
  a = doc.css('.movie_list')[8]
  b = a.css('tr td a')
  #binding.pry
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
  puts ' '
#  b.each do |movie|
#    title = movie.text
#    puts title
#    if title.present?
#        puts title
        # if Movie.find_by(title: title)
        #   puts 'Movie already there!'
        # else
#          @movie = Movie.find_or_create_by(title: title, url: url)
#          @movie.save
#          puts 'Movie created!'
#          puts " "
        # end
        # end
    end
#  end
#end


end
