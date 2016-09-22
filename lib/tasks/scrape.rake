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
  #g = b.css('tr td').first.attr('href')
  #h  = b.css('tr td').first.attr('value')
  #i  = b.css('tr td').first.attr(['href'])
  #j  = b.css('tr td').first.attr(['value'])
  z = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  z.each do |i|
    puts b[i]['href']
  end
  # e = b[0]['href']
  # f = b[1]['href']
  # g = b[2]['href']
  # h = b[3]['href']
  # i = b[4]['href']
  # j = b[5]['href']
  # k = b[6]['href']
  # l = b[7]['href']
  # m = b[8]['href']
  # f = b.each_with_index do |link, index|
  #   puts link[ {index} ]['href']
  # end
  #g = b.length
  # for i == g do
  #   puts b[i]['href']
  #   i++
  puts ' '
  puts b.text

  # c.each do |i|
  #   sites << i
  # end
  # puts c
  # puts d
  # puts e
  # puts f
  # puts g
  #  puts h
  #  puts i
  #  puts j
  #  puts k
  #  puts l
  #  puts m

  # d = c.map { |link| link['href'] }
  # puts d.first
  end

end
