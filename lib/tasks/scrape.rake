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

  puts '!WWWWWeeu..   ..ueeWWWWW! '
  puts ' "$$(    R$$e$$R    )$$" '
  puts '  "$8oeeo. "*" .oeeo8$" '
  puts '  .$$#"""*$i i$*"""#$$. '
  puts '  9$" @*c $$ $$F @*c $N '
  puts '   9$  NeP $$ $$L NeP $$ '
  puts '  `$$uuuuo$$ $$uuuuu$$" '
  puts '  x$P**$$P*$"$P#$$$*R$L '
  puts "  x$$   $$k $$F :$P` '$$i "
  puts ' $$     #$  #  $$     #$k '
  puts 'd$"     "$L   x$F     "$$ '
  puts "$$      '$E   9$>      9$>"
  puts "$6       $F   ?$>      9$>"
  puts "$$      d$    '$&      8$"
  puts '"$k    x$$     !$k    :$$'
  puts ' #$b  u$$L      9$b.  $$"'
  puts ' "#$od$#$$u....u$P$Nu@$"'
  puts '  ..?$R)..?R$$$$*"  #$P'
  puts ' $$$$$$$$$$$$$$@WWWW$NWWW'
  puts ' `````""3$F""""#$F"""""""'
  puts "        @$.... '$B"
  puts '       d$$$$$$$$$$:'
  puts '       ````````````'

  t1 = Time.now
  puts 'time begun ' + t1.to_s

  #movies   #run movies scraper
  #medium   #run medium scraper
  awwwards #run awwwards scraper
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
  end # end of medium

  def awwwards
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://www.awwwards.com/awards-of-the-day/'

    doc = Nokogiri::HTML(b.html)
    a = doc.css('.inner .rollover')
    b = doc.css('.inner .rollover a[2]')
    c = doc.css('.inner .rollover img')
    puts a
    z = (0..11).to_a
    puts z
     z.each do |i|
       url = b[i]['href']
       puts url
       rough_title = c[i]['alt']
       title_refactor = rough_title.slice(0..(rough_title.index('|')))
       title = title_refactor[0..-3]
       puts title
       @awward = Awwward.find_or_create_by(title: title, url: url)
       @awward.save
       puts 'Awwward entry created!'
       puts " "
     end
  end #end of awwwards
