namespace :scrape2 do
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

  # movies   #run movies scraper
  # medium   #run medium scraper
  # awwwards #run awwwards scraper
  # deals_pt1
  #  economists
  #  vimeo
  #  twitter
    next_web
    google
    nytimes
  imgur
  puts 'Scraper successfully executed.'
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

  def deals_pt1
    url = 'https://www.amazon.com/gp/goldbox/ref=gbps_ftr_s-3_3422_wht_1040660?gb_f_GB-SUPPLE=sortOrder:BY_DISCOUNT_DESCENDING,enforcedCategories:7192394011%252C7147440011%252C2619525011%252C2102313011%252C2858778011%252C2617941011%252C15684181%252C165796011%252C7147444011%252C3760911%252C283155%252C7147443011%252C502394%252C2335752011%252C4991425011%252C541966%252C7586165011%252C1233514011%252C228013%252C2625373011%252C172282%252C1063306%252C7147442011%252C16310101%252C3760901%252C1055398%252C16310091%252C133140011%252C284507%252C9479199011%252C679255011%252C6358539011%252C1040658%252C7147441011%252C11091801%252C1064954%252C2972638011%252C2619533011%252C3375251%252C165793011%252C679337011%252C6358543011%252C1040660&pf_rd_p=2609053422&pf_rd_s=slot-3&pf_rd_t=701&pf_rd_i=gb_main&pf_rd_m=ATVPDKIKX0DER&pf_rd_r=F76CPB8VFZY5TYSDDWJB&nocache=1474582112196'

    b = Watir::Browser.new(:phantomjs)
    b.goto url
    doc = Nokogiri::HTML(b.html)
    z = (0..6).to_a
    z.each do |i|
      # a = doc.css('.dealContainer')[i]
      # puts a
      b = doc.css('.dealContainer .priceBlock span')[i-1]
      price_a = b.text
      puts price_a
      #c = doc.css('.widgetContainer .a-fixed-left-grid-inner .rightCol .padCenterContainer .padCenter #widgetContent #100_dealView_13 .dealContainer .a-section .dealTile .priceBlock span').text
  #   works refactor for iterator  #c = doc.css('.dealContainer .a-spacing-mini .hiddenCss').text
      c = doc.css('.dealContainer .a-spacing-mini .hiddenCss')[i].text
      title = c.strip
      puts 'title'
      puts title
      puts 'discount'
      d = doc.css('.dealContainer .a-spacing-mini .a-spacing-top-mini span[3]')[i].text unless nil
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
    a = doc.css('.story-title')
     puts a
     a.each_with_index do |article, index|
       begin
         title = article.text
         puts title
         url = article.css('a')[0]['href']
         puts url
         @next_web = Thenextweb.find_or_create_by(title: title, url: url)
         @next_web.save
         puts 'Next Web entry created!'
       rescue
        'new web rescued'
       end
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

  def nytimes
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
#dont need an end
