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
  #awwwards #run awwwards scraper
  deals
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

  def deals
    url = 'https://www.amazon.com/gp/goldbox/ref=gbps_ftr_s-3_3422_wht_1040660?gb_f_GB-SUPPLE=sortOrder:BY_DISCOUNT_DESCENDING,enforcedCategories:7192394011%252C7147440011%252C2619525011%252C2102313011%252C2858778011%252C2617941011%252C15684181%252C165796011%252C7147444011%252C3760911%252C283155%252C7147443011%252C502394%252C2335752011%252C4991425011%252C541966%252C7586165011%252C1233514011%252C228013%252C2625373011%252C172282%252C1063306%252C7147442011%252C16310101%252C3760901%252C1055398%252C16310091%252C133140011%252C284507%252C9479199011%252C679255011%252C6358539011%252C1040658%252C7147441011%252C11091801%252C1064954%252C2972638011%252C2619533011%252C3375251%252C165793011%252C679337011%252C6358543011%252C1040660&pf_rd_p=2609053422&pf_rd_s=slot-3&pf_rd_t=701&pf_rd_i=gb_main&pf_rd_m=ATVPDKIKX0DER&pf_rd_r=F76CPB8VFZY5TYSDDWJB&nocache=1474582112196'
    # agent = Mechanize.new
    # agent.set_proxy '78.186.178.123', 8080
    # page = agent.get('http://ipaddresslocation.org')
    # puts page
  #  browser = Watir::Browser.new :chrome, :switches => ['--proxy-server=88.12.44.205:3128']
  #  b = Watir::Browser.start url
  #  puts browser.goto 'http://ipaddresslocation.org'
    # puts browser
#    b = Watir::Browser.new(:phantomjs)
#    b.goto 'https://www.amazon.com/gp/goldbox/ref=gbps_ftr_s-3_3422_wht_1040660?gb_f_GB-SUPPLE=sortOrder:BY_DISCOUNT_DESCENDING,enforcedCategories:7192394011%252C7147440011%252C2619525011%252C2102313011%252C2858778011%252C2617941011%252C15684181%252C165796011%252C7147444011%252C3760911%252C283155%252C7147443011%252C502394%252C2335752011%252C4991425011%252C541966%252C7586165011%252C1233514011%252C228013%252C2625373011%252C172282%252C1063306%252C7147442011%252C16310101%252C3760901%252C1055398%252C16310091%252C133140011%252C284507%252C9479199011%252C679255011%252C6358539011%252C1040658%252C7147441011%252C11091801%252C1064954%252C2972638011%252C2619533011%252C3375251%252C165793011%252C679337011%252C6358543011%252C1040660&pf_rd_p=2609053422&pf_rd_s=slot-3&pf_rd_t=701&pf_rd_i=gb_main&pf_rd_m=ATVPDKIKX0DER&pf_rd_r=F76CPB8VFZY5TYSDDWJB&nocache=1474582112196'

  b = Watir::Browser.start url
#  b.select_list(:id => '#100_dealView_13').wait_until_present
  b.driver.manage.timeouts.implicit_wait = 8
#    doc = Nokogiri::HTML(b.html)
    # a = doc.css('.widgetContainer .a-fixed-left-grid-inner .rightCol .padCenterContainer .padCenter #widgetContent #100_dealView_0 .dealContainer .a-section .layer')
    # puts a
    # b = doc.css('.dealContainer .priceBlock span')
    # puts b
    c = doc.css('.widgetContainer .a-fixed-left-grid-inner .rightCol .padCenterContainer .padCenter #widgetContent #100_dealView_13 .dealContainer .a-section .dealTile .priceBlock span').text
    puts c
#    d = doc.css('.widgetContainer .a-fixed-left-grid-inner .rightCol .padCenterContainer .padCenter #widgetContent #100_dealView_13')
#    puts d
  end
