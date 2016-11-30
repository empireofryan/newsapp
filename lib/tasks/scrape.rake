namespace :scrape do
  desc '$$$ making paper $$$'
  require 'phantomjs'
  require 'watir'
  require 'nokogiri'
  require 'date'
  require 'time'
  require 'chronic'
  require 'active_support/all'
  require 'timeout'
  require 'pry'
  require 'rspec/retry'
#  require 'httparty'
  require 'net/http'
  require 'json'

task :sources => [ :environment ] do

  url = 'https://newsapi.org/v1/sources'
  uri = URI(url)
  response = Net::HTTP.get(uri)
  @tags = response2 = JSON.parse(response)['sources']
  #puts response2['sources']['id']
  @tags.each do |item|
    puts item["id"]
  end
end

task :cnn => [ :environment ] do

  url = 'https://newsapi.org/v1/articles?source=cnn&apiKey=8297a15e41fb4d47993c6f8392ad09f4'
  uri = URI(url)
  response = Net::HTTP.get(uri)
  # puts response
  @tags = JSON.parse(response)['articles']
  # #puts response2['sources']['id']
  #  @tags.each do |item|
  #    puts item["title"]
  #  end
  @tags.each do |item|
    puts item["title"]
    title = item["title"]
    author = item['author']
    description = item['description']
    url = item['url']
    image = item['urlToImage']
    published = item['publishedAt']
    @cnn = Cnn.find_or_create_by(title: title, url: url, description: description, image: image, published: published)
    puts 'created cnn entry'
  end
end

task :reddit => [ :environment ] do

  url = 'https://newsapi.org/v1/articles?source=reddit-r-all&sortBy=top&apiKey=8297a15e41fb4d47993c6f8392ad09f4'
  uri = URI(url)
  response = Net::HTTP.get(uri)
  # puts response
  @tags = JSON.parse(response)['articles']
  @tags.each do |item|
    puts item["title"]
    title = item["title"]
    author = item['author']
    description = item['description']
    url = item['url']
    image = item['urlToImage']
    published = item['publishedAt']
    @reddit = Reddit.find_or_create_by(title: title, url: url, description: description, image: image, published: published)
    puts 'created cnn entry'
  end
end

task :sources => [ :environment ] do
url = 'https://newsapi.org/v1/sources'
uri = URI(url)
response = Net::HTTP.get(uri)
@tags = JSON.parse(response)['sources']
end

task :economist2  => [ :environment ] do

  url = 'https://newsapi.org/v1/articles?source=the-economist&sortBy=top&apiKey=8297a15e41fb4d47993c6f8392ad09f4'
  uri = URI(url)
  response = Net::HTTP.get(uri)
  # puts response
  @tags = JSON.parse(response)['articles']
  @tags.each do |item|
    puts item["title"]
    title = item["title"]
    author = item['author']
    description = item['description']
    url = item['url']
    image = item['urlToImage']
    published = item['publishedAt']
    @economist = Economist2.find_or_create_by(title: title, url: url, description: description, image: image, published: published)
    puts 'created economist entry'
  end
end

task :hackernews  => [ :environment ] do

  url = 'https://newsapi.org/v1/articles?source=hacker-news&sortBy=top&apiKey=8297a15e41fb4d47993c6f8392ad09f4'
  uri = URI(url)
  response = Net::HTTP.get(uri)
  # puts response
  @tags = JSON.parse(response)['articles']
  @tags.each do |item|
    puts item["title"]
    title = item["title"]
    author = item['author']
    description = item['description']
    url = item['url']
    image = item['urlToImage']
    published = item['publishedAt']
    @hackernews = Hackernew.find_or_create_by(title: title, url: url, description: description, image: image, published: published)
    puts 'created hacker news entry'
  end
end

task :wsj  => [ :environment ] do

  url = 'https://newsapi.org/v1/articles?source=the-wall-street-journal&sortBy=top&apiKey=8297a15e41fb4d47993c6f8392ad09f4'
  uri = URI(url)
  response = Net::HTTP.get(uri)
  # puts response
  @tags = JSON.parse(response)['articles']
  @tags.each do |item|
    puts item["title"]
    title = item["title"]
    author = item['author']
    description = item['description']
    url = item['url']
    image = item['urlToImage']
    published = item['publishedAt']
    @wsjs = Wsj.find_or_create_by(title: title, url: url, description: description, image: image, published: published)
    puts 'created WSJ entry'
  end
end

task :time  => [ :environment ] do
  url = 'https://newsapi.org/v1/articles?source=time&sortBy=top&apiKey=8297a15e41fb4d47993c6f8392ad09f4'
  uri = URI(url)
  response = Net::HTTP.get(uri)
  # puts response
  @tags = JSON.parse(response)['articles']
  @tags.each do |item|
    puts item["title"]
    title = item["title"]
    author = item['author']
    description = item['description']
    url = item['url']
    image = item['urlToImage']
    published = item['publishedAt']
    @times = Time2.find_or_create_by(title: title, url: url, description: description, image: image, published: published)
    puts 'created Time entry'
  end
end

task :usatoday  => [ :environment ] do
  url = 'https://newsapi.org/v1/articles?source=usa-today&sortBy=latest&apiKey=8297a15e41fb4d47993c6f8392ad09f4'
  uri = URI(url)
  response = Net::HTTP.get(uri)
  # puts response
  @tags = JSON.parse(response)['articles']
  @tags.each do |item|
    puts item["title"]
    title = item["title"]
    author = item['author']
    description = item['description']
    url = item['url']
    image = item['urlToImage']
    published = item['publishedAt']
    @usatodays = Usatoday.find_or_create_by(title: title, url: url, description: description, image: image, published: published)
    puts 'created Usa Today entry'
  end
end

task :newsweek  => [ :environment ] do
  url = 'https://newsapi.org/v1/articles?source=newsweek&sortBy=top&apiKey=8297a15e41fb4d47993c6f8392ad09f4'
  uri = URI(url)
  response = Net::HTTP.get(uri)
  # puts response
  @tags = JSON.parse(response)['articles']
  @tags.each do |item|
    puts item["title"]
    title = item["title"]
    author = item['author']
    description = item['description']
    url = item['url']
    image = item['urlToImage']
    published = item['publishedAt']
    @newsweeks = Newsweek.find_or_create_by(title: title, url: url, description: description, image: image, published: published)
    puts 'created Usa Today entry'
  end
end

task :newsweek1  => [ :environment ] do
  b = Watir::Browser.new(:phantomjs)
  b.goto 'https://twitter.com/Newsweek'
  doc = Nokogiri::HTML(b.html)
  array = []
  # title = a[i.to_i].text
   tweet = doc.css('.TweetTextSize')
  # num_tweet = tweet.count.to_i
  # num_tweet = num_tweet - 1
  # z = (0..num_tweet).to_a
  # puts z
  # z.each do |i|
  #   title = tweet[i.to_i].text
  # end
  tweet.each do |entry|
    puts entry.text
  end




end

task :newsweek2 => [ :environment ] do
  BASE_NEWSWEEK_URL = 'http://newsweek.com'
  b = Watir::Browser.new(:phantomjs)
  b.goto 'http://newsweek.com'
  doc = Nokogiri::HTML(b.html)
#  array = []
  # title = a[i.to_i].text
#   tweet = doc.css('.TweetTextSize')

  #rows[1..-2].each do |row|

  hrefs = doc.css("a").map{ |a|
    a['href'] if a['href'] =~ /^\/2016\//
  }.compact.uniq

  hrefs.each do |href|
    remote_url = BASE_NEWSWEEK_URL + href
    puts remote_url
  end # done: hrefs.each
end

task :newsweek3 => [ :environment ] do
  BASE_NEWSWEEK_URL = 'http://newsweek.com/2016/12/02/issue.html'
  b = Watir::Browser.new(:phantomjs)
  b.goto BASE_NEWSWEEK_URL
  doc = Nokogiri::HTML(b.html)
#  array = []
  # title = a[i.to_i].text
#   tweet = doc.css('.TweetTextSize')

  #rows[1..-2].each do |row|

  hrefs = doc.css("a").map{ |a|
    a['href'] if a['href'] =~ /^\/2016\//
  }.compact.uniq

  hrefs.each do |href|
    remote_url = 'http://www.newsweek.com' + href
    puts remote_url
  end # done: hrefs.each
end

task :nytimes3 => [ :environment ] do
  BASE_NEWSWEEK_URL = 'http://www.nytimes.com/pages/todayspaper/index.html?action=Click&module=HPMiniNav&region=TopBar&WT.nav=page&contentCollection=TodaysPaper&pgtype=Homepage'
  b = Watir::Browser.new(:phantomjs)
  b.goto BASE_NEWSWEEK_URL
  doc = Nokogiri::HTML(b.html)
  hrefs = doc.css("a")
  puts hrefs
  puts 'now only special links'
  puts hrefs.count
  @counter = 0
  hrefs.each do |href|
    link = href['href'] rescue nil
    title = href.text rescue nil
    begin
      if (link.include?('2016')) && (!link.include?('indexes')) && (link.include?('nytimes')) && (!link.include?('adx'))
      @counter +=1
      @remote_url = link
      @new_title = title
      puts @new_title
      puts @remote_url
      end
    rescue
    end
    @nytime = Nytime.find_or_create_by!(url: @remote_url, title: @new_title)
  end # done: hrefs.each
  puts @counter

  puts 'entries saved to nytime model'
end #end task nytimes3 do

task :huffpost => [ :environment ] do
  BASE_URL = 'http://www.huffingtonpost.com/'
  b = Watir::Browser.new(:phantomjs)
  b.goto BASE_URL
  doc = Nokogiri::HTML(b.html)
  hrefs = doc.css("a")
  puts hrefs
   puts 'now only special links'
   puts hrefs.count
   @counter = 0
   hrefs.each do |href|
     link = href['href'] rescue nil
     title = href.text rescue nil
    begin
      if (link.include?('entry'))
        @counter +=1
        @remote_url = link
        if (!title.include?('/n'))
          @new_title = title
          puts @new_title
        end
        puts @remote_url
      end
    rescue
    end
    @huffpost = Huffpost.find_or_create_by!(url: @remote_url, title: @new_title)
  end # done: hrefs.each
  puts @counter

  puts 'entries saved to huffpost model'
end #end task huffpost do

task :cnn_3 => [ :environment ] do
  BASE_URL = 'http://www.cnn.com/'
  b = Watir::Browser.new(:phantomjs)
  b.goto BASE_URL
  doc = Nokogiri::HTML(b.html)
  hrefs = doc.css("a")
  puts hrefs
   puts 'now only special links'
   puts hrefs.count
   @counter = 0
   hrefs.each do |href|
     link = href['href'] rescue nil
     title = href.text rescue nil
    begin
      if ((link.include?('2016')) && (!title.nil?))
        @counter +=1
        if (link.include?('cnn')) && (!link.include?('videos'))
          @remote_url = link
        elsif (link.include?('videos'))
          @remote_url = 'http://cnn.com' + link
        else
          @remote_url = 'http://cnn.com' + link
        end
        if (!title.include?('alt'))
          @new_title = title
          puts @new_title
        end
        puts @remote_url
        @cnn = Cnn.find_or_create_by!(url: @remote_url, title: @new_title)
      end
    rescue
    end
  end # done: hrefs.each
  puts @counter
  puts 'entries saved to cnn model'
end #end task cnn do

task :espn_3 => [ :environment ] do
  BASE_URL = 'http://www.espn.com/'
  b = Watir::Browser.new(:phantomjs)
  b.goto BASE_URL
  doc = Nokogiri::HTML(b.html)
  hrefs = doc.css("a")
  puts hrefs
   puts 'now only special links'
   puts hrefs.count
   @counter = 0
   hrefs.each do |href|
     link = href['href'] rescue nil
     title = href.text rescue nil
    begin
      if ((link.include?('story')) && (!title.nil?))

         if ((link.include?('http')))
           @remote_url = link
         else
           @remote_url = 'http://espn.com' + link
         end
        # if (!title.include?('alt'))
          @new_title = title
          puts @new_title
        # end

      #  if !Espn.where(url: @remote_url).present?
          @counter +=1
          puts @remote_url
          @espn = Espn.find_or_create_by!(url: @remote_url, title: @new_title)
      #  end
      end
    rescue
    end
  end # done: hrefs.each
  puts @counter
  puts 'entries saved to espn model'
end #end task cnn do


task :moneymaker => [ :environment ] do

RSpec.configure do |config|
  # show retry status in spec process
  config.verbose_retry = true
  # Try twice (retry once)
  config.default_retry_count = 3
  # Only retry when Selenium raises Net::ReadTimeout
  config.exceptions_to_retry = [Net::ReadTimeout]
end
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
  puts '  9$" @@@ $$ $$F @@@ $N '
  puts '   9$  `` $$ $$L `` $$ '
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

  movie
#  movies   #run movies scraper
  mediu   #run medium scraper
  awwward #run awwwards scraper
  # deals_pt1
  #  economists
  #  vimeo
  #  twitter
  #  next_web
  #  google
  #  nytimes
  #imgur
  puts 'Scraper successfully executed.'
end

def movie
  b = Watir::Browser.new(:phantomjs)
  b.goto 'https://www.rottentomatoes.com/top/'
  doc = Nokogiri::HTML(b.html)
  a = doc.css('.movie_list')[8]
  g = a.css('tr td a')
#  puts g
  # b.goto 'http://www.google.com/'
  # doc = Nokogiri::HTML(b.html)
  # puts doc
  z = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  z.each do |i|
    link = g[i]['href']
    puts link
    url = 'http://www.rottentomatoes.com' + link
    title = g[i].text
    puts title
    b.goto url rescue Net::ReadTimeout
    movie_page = Nokogiri::HTML(b.html)
    poster = movie_page.css('.posterImage')[0]['src']
    puts poster
    @movie = Movie.find_or_create_by(title: title, url: url, poster: poster)
    @movie.save
    puts 'Movie created!'
    puts " "
  end
end

  # def movies
  #   b = Watir::Browser.new(:phantomjs)
  #   b.goto 'https://www.rottentomatoes.com/top/'
  #   doc = Nokogiri::HTML(b.html)
  #   puts doc
  #   a = doc.css('.movie_list')[8]
  #   g = a.css('tr td a')
  #   c = a.css('tr td').first.attr('href')
  #   d = a.css('tr td').first.attr('value')
  #   e = a.css('tr td').first.attr(['href'])
  #   f = a.css('tr td').first.attr(['value'])
  #   z = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  #   z.each do |i|
  #     link = g[i]['href']
  #     puts link
  #     url = 'http://www.rottentomatoes.com' + link
  #     title = g[i].text
  #     puts title
  #       b.goto url
  #       movie_page = Nokogiri::HTML(b.html)
  #       puts movie_page
  #     @movie = Movie.find_or_create_by(title: title, url: url)
  #     @movie.save
  #     puts 'Movie created!'
  #     puts " "
  #   end
  #   end
  # end # end movies

  def mediu
    b = Watir::Browser.new(:phantomjs)
    b.goto 'https://medium.com/browse/top'

    doc = Nokogiri::HTML(b.html)
    a = doc.css('.postArticle-content a h3')
    b = doc.css('.postArticle-content a')
    d = doc.css('.postArticle-content img')
    puts d
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
       begin
       picture = d[i]['src']
       puts picture
       rescue
         'nilclass rescue'
       end
       @medium = Medium.find_or_create_by(title: title, url: url, picture: picture)
       @medium.save
       puts 'Medium article created!'
       puts " "
     end
  end # end of medium

  def awwward
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://www.awwwards.com/awards-of-the-day/'
    doc = Nokogiri::HTML(b.html)
    a = doc.css('.inner .rollover')
    b = doc.css('.inner .rollover a[2]')
    c = doc.css('.inner .rollover img')
  #  puts a
    z = (0..11).to_a
    puts z
     z.each do |i|
       url = b[i]['href']
       puts url
       screenshot = c[i]['src']
       puts screenshot
       rough_title = c[i]['alt']
       title_refactor = rough_title.slice(0..(rough_title.index('|')))
       title = title_refactor[0..-3]
       puts title
       @awward = Awwward.find_or_create_by(title: title, url: url, screenshot: screenshot)
       @awward.save
       puts 'Awwward entry created!'
       puts " "
     end
  end #end of awwwards

  def awwwards
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://www.awwwards.com/awards-of-the-day/'

    doc = Nokogiri::HTML(b.html)
    a = doc.css('.inner .rollover')
    b = doc.css('.inner .rollover a[2]')
    c = doc.css('.inner .rollover img')
  #  puts a
    z = (0..11).to_a
    puts z
     z.each do |i|
       url = b[i]['href']
       #puts url
       screenshot = c[i]['src']
       puts screenshot
       binding.pry
       rough_title = c[i]['alt']
       title_refactor = rough_title.slice(0..(rough_title.index('|')))
       title = title_refactor[0..-3]
      # puts title
       @awward = Awwward.find_or_create_by(title: title, url: url, screenshot: screenshot)
       @awward.save
       puts 'Awwward entry created!'
       puts " "
     end
  end #end of awwwards

  def deals_pt1
    url = 'https://www.amazon.com/gp/goldbox/ref=gbps_ftr_s-3_3422_wht_1040660?gb_f_GB-SUPPLE=sortOrder:BY_DISCOUNT_DESCENDING,enforcedCategories:7192394011%252C7147440011%252C2619525011%252C2102313011%252C2858778011%252C2617941011%252C15684181%252C165796011%252C7147444011%252C3760911%252C283155%252C7147443011%252C502394%252C2335752011%252C4991425011%252C541966%252C7586165011%252C1233514011%252C228013%252C2625373011%252C172282%252C1063306%252C7147442011%252C16310101%252C3760901%252C1055398%252C16310091%252C133140011%252C284507%252C9479199011%252C679255011%252C6358539011%252C1040658%252C7147441011%252C11091801%252C1064954%252C2972638011%252C2619533011%252C3375251%252C165793011%252C679337011%252C6358543011%252C1040660&pf_rd_p=2609053422&pf_rd_s=slot-3&pf_rd_t=701&pf_rd_i=gb_main&pf_rd_m=ATVPDKIKX0DER&pf_rd_r=F76CPB8VFZY5TYSDDWJB&nocache=1474582112196'
    b = Watir::Browser.new(:phantomjs)
    b.goto url
    doc = Nokogiri::HTML(b.html)
    z = (0..6).to_a
    z.each do |i|
      begin
        # a = doc.css('.dealContainer')[i]
        # puts a
        b = doc.css('.dealContainer .priceBlock span')[i]
        price_a = b.text
        puts price_a
        #c = doc.css('.widgetContainer .a-fixed-left-grid-inner .rightCol .padCenterContainer .padCenter #widgetContent #100_dealView_13 .dealContainer .a-section .dealTile .priceBlock span').text
    #   works refactor for iterator  #c = doc.css('.dealContainer .a-spacing-mini .hiddenCss').text
        c = doc.css('.dealContainer .a-spacing-mini span #dealtitle')[i].text
        title = c.strip
        puts 'title'
        puts title
        puts 'discount'
        d = doc.css('.dealContainer .a-spacing-mini .a-spacing-top-mini span[3]')[i].text
    #   d = doc.css('.widgetContainer .a-fixed-left-grid-inner .rightCol .padCenterContainer .padCenter #widgetContent #100_dealView_13')
        discount_a = d.strip
        discount_a[0] = ''
        discount_a[-1] = ''

        puts discount_a
        puts 'url'
        url = doc.css('.dealContainer .a-spacing-mini a')[i]['href']
        puts url
        @deal = Amazon.find_or_create_by(title: title, url: url,
          price_a: price_a, discount_a: discount_a)
        @deal.save
        puts 'Amazon Deal entry created!'
      rescue
        puts 'rescued'
      end
    end
  end

  #not working just loading
  # def deals_pt2
  #   url = 'https://www.amazon.com/gp/goldbox/ref=gbps_ftr_s-3_3422_page_2?gb_f_GB-SUPPLE=enforcedCategories:7192394011%252C7147440011%252C2619525011%252C2102313011%252C2858778011%252C2617941011%252C15684181%252C165796011%252C7147444011%252C3760911%252C283155%252C7147443011%252C502394%252C2335752011%252C4991425011%252C541966%252C7586165011%252C1233514011%252C228013%252C2625373011%252C172282%252C1063306%252C7147442011%252C16310101%252C3760901%252C1055398%252C16310091%252C133140011%252C284507%252C9479199011%252C679255011%252C6358539011%252C1040658%252C7147441011%252C11091801%252C1064954%252C2972638011%252C2619533011%252C3375251%252C165793011%252C679337011%252C6358543011%252C1040660,page:2,sortOrder:BY_DISCOUNT_DESCENDING,dealsPerPage:32&pf_rd_p=2609053422&pf_rd_s=slot-3&pf_rd_t=701&pf_rd_i=gb_main&pf_rd_m=ATVPDKIKX0DER&pf_rd_r=WCCZMK5T7Q5W6JYM7DV4&nocache=1474582112196'
  #   b = Watir::Browser.new(:phantomjs)
  #   b.goto url
  #
  #   doc = Nokogiri::HTML(b.html)
  #   b.element(:id => 'dealTitle').wait_until_present(timeout=10)
  #   b = doc.css('#widgetContent')
  #   puts b
  # end

  #dont work either
  # def deals_pt3
  #   agent = Mechanize.new
  #   agent.user_agent_alias = 'Mac Safari'
  #   page = agent.get('https://www.amazon.com/gp/goldbox/ref=gbps_ftr_s-3_3422_page_2?gb_f_GB-SUPPLE=enforcedCategories:7192394011%252C7147440011%252C2619525011%252C2102313011%252C2858778011%252C2617941011%252C15684181%252C165796011%252C7147444011%252C3760911%252C283155%252C7147443011%252C502394%252C2335752011%252C4991425011%252C541966%252C7586165011%252C1233514011%252C228013%252C2625373011%252C172282%252C1063306%252C7147442011%252C16310101%252C3760901%252C1055398%252C16310091%252C133140011%252C284507%252C9479199011%252C679255011%252C6358539011%252C1040658%252C7147441011%252C11091801%252C1064954%252C2972638011%252C2619533011%252C3375251%252C165793011%252C679337011%252C6358543011%252C1040660,page:2,sortOrder:BY_DISCOUNT_DESCENDING,dealsPerPage:32&pf_rd_p=2609053422&pf_rd_s=slot-3&pf_rd_t=701&pf_rd_i=gb_main&pf_rd_m=ATVPDKIKX0DER&pf_rd_r=WCCZMK5T7Q5W6JYM7DV4&nocache=1474582112196')
  #   sleep 10
  #   puts page.content.strip
  # end

  # def deals_pt4
  #   b = Watir::Browser.new
  #   b.goto('https://www.amazon.com/gp/goldbox/ref=gbps_ftr_s-3_3422_page_2?gb_f_GB-SUPPLE=enforcedCategories:7192394011%252C7147440011%252C2619525011%252C2102313011%252C2858778011%252C2617941011%252C15684181%252C165796011%252C7147444011%252C3760911%252C283155%252C7147443011%252C502394%252C2335752011%252C4991425011%252C541966%252C7586165011%252C1233514011%252C228013%252C2625373011%252C172282%252C1063306%252C7147442011%252C16310101%252C3760901%252C1055398%252C16310091%252C133140011%252C284507%252C9479199011%252C679255011%252C6358539011%252C1040658%252C7147441011%252C11091801%252C1064954%252C2972638011%252C2619533011%252C3375251%252C165793011%252C679337011%252C6358543011%252C1040660,page:2,sortOrder:BY_DISCOUNT_DESCENDING,dealsPerPage:32&pf_rd_p=2609053422&pf_rd_s=slot-3&pf_rd_t=701&pf_rd_i=gb_main&pf_rd_m=ATVPDKIKX0DER&pf_rd_r=WCCZMK5T7Q5W6JYM7DV4&nocache=1474582112196')
  #   puts b.span(:id, 'dealTitle').when_present.text
  # end

  def economists
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://www.economist.com/'
    doc = Nokogiri::HTML(b.html)
    # def one
      begin
      a = doc.css('.hero-item-1')
      b = doc.css('.hero-item-1 a')[1]['href']
      url = 'http://www.theeconomist.com' + b.to_s
      puts url
      c = doc.css('.hero-item-1 .fly-title')
      title = c.text
      puts title
      d = doc.css('.hero-item-1 .headline')
      subtitle = d.text
      puts subtitle
      @economist = Economist.find_or_create_by(title: title, subtitle: subtitle, url: url)
      @economist.save
      puts 'Economist entry created!'
    # end
    # def two
      a = doc.css('.hero-item-2')
      b = doc.css('.hero-item-2 a')[0]['href']
      url = 'http://www.theeconomist.com' + b.to_s
      puts url
      c = doc.css('.hero-item-2 .fly-title')
      title = c.text
      puts title
      d = doc.css('.hero-item-2 .headline')
      subtitle = d.text
      puts subtitle
      @economist = Economist.find_or_create_by(title: title, subtitle: subtitle, url: url)
      @economist.save
      puts 'Economist entry created!'
    # end
    # def three
      a = doc.css('.hero-item-3')
      b = doc.css('.hero-item-3 a')[1]['href']
      url = 'http://www.theeconomist.com' + b.to_s
      puts url
      c = doc.css('.hero-item-3 .fly-title')
      title = c.text
      puts title
      d = doc.css('.hero-item-3 .headline')
      subtitle = d.text
      puts subtitle
      @economist = Economist.find_or_create_by(title: title, subtitle: subtitle, url: url)
      @economist.save
      puts 'Economist entry created!'
    # end
    # def four
      a = doc.css('.hero-item-4')
      b = doc.css('.hero-item-4 a')[1]['href']
      url = 'http://www.theeconomist.com' + b.to_s
      puts url
      c = doc.css('.hero-item-4 .fly-title')
      title = c.text
      puts title
      d = doc.css('.hero-item-4 .headline')
      subtitle = d.text
      puts subtitle
      @economist = Economist.find_or_create_by(title: title, subtitle: subtitle, url: url)
      @economist.save
      puts 'Economist entry created!'
    # end
    rescue NoMethodError
      puts "No method error"
    end
    # homepage center
    f = doc.css('#homepage-center-inner article')
    puts 'number of articles'
    c = f.count.to_i
    c = c - 1
    z = (0..c).to_a
    puts 'number of z'
    puts z
    z.each do |i|
      begin
      a = doc.css('#homepage-center-inner .news-package')[i]
      b = doc.css('#homepage-center-inner article a')[0]['href']
      url = 'http://www.theeconomist.com' + b.to_s
      puts url
      c = doc.css('#homepage-center-inner article .headline')[i]
      title = c.text
      puts 'title'
      puts title
      d = doc.css('#homepage-center-inner article .rubric')[i]
      subtitle = d.text[0..-10].strip
      puts 'subtitle'
      puts subtitle
      @economist = Economist.find_or_create_by(title: title, subtitle: subtitle, url: url)
      @economist.save
      puts 'Economist entry created!'
      rescue NoMethodError
        puts "No method error"
      end
    end
  end # end of economists

  def vimeo
    b = Watir::Browser.new(:phantomjs)
    z = (1..3).to_a
    z.each do |i|
      b.goto 'https://vimeo.com/channels/staffpicks/page:' + i.to_s
      doc = Nokogiri::HTML(b.html)
      a = doc.css('#gallery ol li')
    #  puts a
      a.each do |video|
        url = video.css('a')[0]['href']
        puts url
        title = video.css('a')[0]['title']
        puts title
        picture = video.css('img')[0]['src']
        puts picture
        @vimeo = Vimeo.find_or_create_by(title: title, picture: picture, url: url)
        @vimeo.save
        puts 'Vimeo entry created!'
      end
    end
  end# end vimeo

  def twitter
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://trends24.in/united-states/'
    doc = Nokogiri::HTML(b.html)
    a = doc.css('.trend-card__list li')
    # puts a
    # b = doc.css('.trend-items .trend-item')
    # puts b
     a.each do |twitter|
       hashtag = twitter.text
       puts hashtag
       url = twitter.css('a')[0]['href']
      #  hashtag = video.css('a')[0]['title']
       puts url
      @twitter = Twitter.find_or_create_by(hashtag: hashtag, url: url)
      @twitter.save
      puts 'Twitter entry created!'
    end #end a.each
  end # end twitter

  def next_web
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://thenextweb.com/'
    doc = Nokogiri::HTML(b.html)
    a = doc.css('.section-popular-trigger')
    # puts a
     a.each do |article|
       title = article
       puts title
#       url = article['href']
#       puts url
      # @next_web = Nextweb.find_or_create_by(title: title, url: url)
      # @next_web.save
      puts 'Next Web entry created!'
    end #end a.each
  end # end next_web

  def google

    b = Watir::Browser.new(:phantomjs)
    b.goto 'https://www.google.com/trends/hottrends'
    doc = Nokogiri::HTML(b.html)
      begin
    a = doc.css('.hottrends-trends-list-trend-container')
    # puts a
     a.each do |article|
       title = article.css('.hottrends-single-trend-title').text
       puts title
       a_url = article.css('.hottrends-single-trend-title-container a')[1]['href']
       url = 'http://www.google.com' + a_url
       puts url
       @google = Google.find_or_create_by(title: title, url: url)
       @google.save
      puts 'Google trending entry created!'
      end
    rescue Net::ReadTimeout
      puts 'rescued '
    end#end a.each
  end # end google

  def nytimes1
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://mobile.nytimes.com/'
    doc = Nokogiri::HTML(b.html)
    a = doc.css('.sfgAsset-li')
  #   puts a
     a.each do |article|
       begin
         a_url = article.css('a')[0]['href']
        if a_url.start_with?('/2016')
          url = 'http://www.nytimes.com' + a_url
          puts url
        end
      title = article.css('.sfgAsset-hed').text.strip
      puts title
      if url
        @nytime = Nytime.find_or_create_by(title: title, url: url)
        @nytime.save
        puts 'Next Web entry created!'
      end
    rescue NoMethodError
     puts "no method error rescued"
    end
    end #end a.each
  end # end nytimes

  def imgur
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://imgur.com/'
    doc = Nokogiri::HTML(b.html)
    a = doc.css('.cards .post')
  #   puts a
     a.each do |article|
       begin
         a_url = article.css('a')[0]['href']
        #  puts a_url
         url = 'http://www.imgur.com' + a_url
      #   puts url
         image_a = article.css('img')[0]['src']
         image_a[0..1] = ""
         image = 'http://' + image_a
         puts image
       if url
          @imgur = Imgur.find_or_create_by(image: image, url: url)
          @imgur.save
          puts 'Next Web entry created!'
        end
      rescue NoMethodError
       puts "no method error rescued"
      end
    end #end a.each
  end # end imgur
end
#dont need an end
