require 'zillow'

namespace :scrape do
  desc 'scraped auct.com and zestimates properties'
  require 'capybara'
  require 'capybara/dsl'
  require 'capybara/rails'
  require 'capybara/poltergeist'
  require 'open-uri'
  require 'phantomjs'
  require 'wait_for_ajax'
  # require 'HTTParty'

  def configure_capybara
    include Capybara::DSL
    include WaitForAjax

    Capybara.configure do |c|
      c.javascript_driver = :poltergeist
      c.default_driver = :poltergeist
      c.current_driver = :poltergeist
      c.app_host = "http://localhost:3000"
    end

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, { js_errors: false, timeout: 5.minutes, phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes']})
    end
  end

  def init_scrape_monitor
    @props_found = 0
    @props_created = 0
    @props_updated = 0
    @started_at = Time.now.in_time_zone
  end

  def notify_scrape_monitor(name)
    ScrapeMonitor.create!(name: name, ran_at: @started_at, props_found: @props_found, props_created: @props_created, props_updated: @props_updated)
  end

  task homes: :environment do
    Rake::Task['scrape:auction_1'].invoke
  #  Rake::Task['scrape:homesearch'].invoke
  #  Rake::Task['scrape:hudson_n_marshal'].invoke
    Rake::Task['scrape:hubzu'].invoke
  #  Rake::Task['scrape:williams_auction'].invoke
  end

  task gsa_auctions: :environment do
    #init_scrape_monitor

    configure_capybara
    visit "http://gsaauctions.gov"
    all('div#menu ul li')[2].click
    all('div#sidebar-1 ul li').first.find('a').click

    properties = all('div#content table tr')

    if properties.size > 0
      0.upto(properties.size - 1) do |i|
        property = all('div#content table tr')[i]
        property.all('td')[1].find('a').click
        sleep(3)
        image = all('div#sidebar div.panel-body img')[0]['src']
        puts 'image... ' + image.inspect
        all('div#menu ul li')[2].click
        all('div#sidebar-1 ul li').first.find('a').click
        #all('ul.breadcrumb li')[1].find('a').click
        sleep(3)
      end
    end
    #notify_scrape_monitor('GSAAuctions.gov')
  end

  task hubzu: :environment do
    init_scrape_monitor

    configure_capybara

    ZipCode.all.shuffle.each do |zipcode|
      begin
        puts "getting homes from zipcode: #{zipcode.zip}"
        visit "http://www.hubzu.com/portal/suggest?query=#{zipcode.zip}"
        zip = ActiveSupport::JSON.decode(find('body pre').text)['suggestions']['Place']['ZIP']

        next if zip.blank?
        site_zip_id = zip[0]['id']

        visit "http://www.hubzu.com/searchResult/zip/#{site_zip_id}/#{zipcode.zip}?searchBy=#{zipcode.zip}&bed=2&propertySubType=SF&propertySubType=CO"
        #visit "http://www.hubzu.com/searchResult/state/0000000/allstates?searchBy=All%20States&listingType=AUCN"
        # paginate and load all properties till "Show more" button
        # is visible
        more_button = all('button#showMoreProp')
        while(more_button.size > 0)
          click_on('showMoreProp')
          more_button = all('button#showMoreProp')
        end

        properties = all('#srpTuppleData div.propList')

        properties.each do |property|
          @props_found += 1

          if property.all('div.addressBG #auctionEnd').size > 0
            next
          end

          city_state_zip = property.find('address h2 a span.srpTxt').text
          prop_link = property.find('address h2 a')
          street_raw = prop_link.text.gsub(city_state_zip, '').strip
          street = URI::encode(street_raw)
          city = city_state_zip.split(',').first
          city_state_zip = URI::encode(city_state_zip)
          auction_url = 'http://www.hubzu.com' + prop_link['href'] rescue nil
          image = 'http:' + property.find('div.imgBG img')['src'] rescue nil
          counter = property.all('div.addressBG tr.counter td')

          auction_time = Time.now.in_time_zone + counter[0].text.to_i.days + counter[2].text.to_i.hours + counter[4].text.to_i.minutes

          lookup_and_create_property(street, street_raw, city_state_zip, city, nil, nil, auction_time, image, auction_url)
        end
      rescue
        puts 'Browser error... rescued'
      end
    end

    notify_scrape_monitor('Hubzu.com')
  end

  task williams_auction: :environment do
    init_scrape_monitor

    configure_capybara

    ZipCode.all.shuffle.each do |zipcode|
      puts "getting homes from zipcode: #{zipcode.zip}"

      #visit "https://www.williamsauction.com/residential-real-estate-home-auction/california"
      visit "https://www.williamsauction.com/search/#{zipcode.zip}"

      find('div.FilterHeaderRightItem div.FilterActionLabel').trigger('click')
      find('div.FilterDivisionItem input#cbResidential').trigger('click')
      #all('div.FilterDivisionContentContainer div.FilterItemsRow')[0].
      all('div.FilterItemsColumn')[0].all('div.FilterItemsInput')[0].find('input.FitlerInputCheckbox').trigger('click')
      all('input.FitlerInputExcludeCheckbox')[1].trigger('click')
      page.evaluate_script('applyFilters();')
      sleep(5)

      #properties_count = find('div.FilterHeaderContainer div.ResultsHeader').text
      #puts 'Page counts....' + properties_count.inspect

      properties = all('div#tileMain div.ResultsTileParentContainer')
      puts 'properties size...' + properties.size.inspect

      properties.each do |property|
        property_url = property.find('div.ResultsPropertyAddress a')['href']
        auction_url = property_url
        image = property.find('div.ResultsTileImage a img')['src']

        bid = property.find('div.ResultsBidInformation').all('div.ResultsBidInfoItemValue').first.text
        bid = Float(bid).to_s rescue nil

        tab1 = Capybara::Session.new(:poltergeist)
        tab1.visit property_url

        address = tab1.all('div.PropertyContentHeader h1').first
        if address.present?
          address = address.text.split(',')
        else
          next
        end
        city_state_zip = "#{address[1]} + #{address[2]}".strip
        street_raw = address[0]
        street = URI::encode(address[0])
        city = address[1].strip
        city_state_zip = URI::encode(city_state_zip)

        auction_date = nil
        nodes = tab1.all('div#infoContent div.DescriptionContent p')
        nodes.each do |node|
          content = node.all('span.TabContentLabel')
          if content.present? && 'Auction Ends:' == content.first.text
            puts 'date..' + node.find('span.TabContentText').text.inspect
            auction_date = Time.parse(node.find('span.TabContentText').text) rescue nil
          end
        end

        lookup_and_create_property(street, street_raw, city_state_zip, city, nil, bid, auction_date, image, auction_url)
        tab1.driver.quit
      end
    end

    notify_scrape_monitor('WilliamsAuction.com')
  end

  task williams_auction_old: :environment do
    init_scrape_monitor

    configure_capybara
#>>>>>>> fd516e089adc2083174f28edf8012d5a69e49af3

    # ZipCode.all.shuffle.each do |zipcode|
    #   puts "getting homes from zipcode: #{zipcode.zip}"

    #   visit "http://www.williamsauction.com/real-estate-auction/#{zipcode.zip}"
    #   properties_count = find('.propertycountcontainer .propertycount').text.to_i
    #   page_count = 1

    #   if properties_count > 10
    #     pagination = all('div.pagination').first
    #     page_count = pagination.all('a').size + pagination.all('span').size - 2
    #     puts 'page counts...' + page_count.inspect
    #   end

    #   if properties_count > 0
    #     1.upto(page_count) do |i|
    #       all(:link, i.to_s).first.click if(i > 1)

    #       wait_for_ajax
    #       properties = all("div#page_#{i*10} div.gradient")
    #       #puts 'properties count...' + properties.first['id'].inspect
    #       puts 'properties count...' + properties.size.inspect

    #       properties.each do |property|
    #         @props_found += 1
    #         #address = property.find('div.contentholder div.content_title').text
    #         contents = property.all('.content_copy')
    #         auction_type = contents[3].text
    #         if auction_type =~ /Online/
    #           address = property.find('div.contentholder div.content_title').text.split(' - ')
    #           city_state_zip = address[0]
    #           street_raw = address[1]
    #           street = URI::encode(address[1])
    #           city = city_state_zip.split(', ')[0]

    #           property_url = 'http://www.williamsauction.com' + property.all('div a').first['href'] rescue nil
    #           auction_url = property_url
    #           image =  'http://www.williamsauction.com' + property.all('div a img').first['src'] rescue nil
    #           bid = contents[2].text.slice(/\$[\d,]+/)
    #           auction_date = contents[4].text.slice(/Auction Ends: .+/)[14..-1].split('EST') rescue nil

    #           if auction_date.present?
    #             auction_date = Time.parse("#{auction_date[1]} #{auction_date[0]} EST") rescue nil
    #           end

    #           lookup_and_create_property(street, street_raw, city_state_zip, city, nil, bid, auction_date, image, auction_url)
    #         end
    #       end
    #     end
    #   end
    # end

    # notify_scrape_monitor('WilliamsAuction.com')
  end


  task hudson_n_marshal: :environment do
    init_scrape_monitor

    configure_capybara

    ZipCode.all.shuffle.each do |zipcode|
    #[ZipCode.find(1)].each do |zipcode|
      puts "getting homes from zipcode: #{zipcode.zip}"

      visit "http://www.hudsonandmarshall.com/PropertySearch?address=#{zipcode.zip}&radius=50"
      sleep 5
      properties = []

      if all('span#zeroResults').size > 0 || all('div#noResults').size > 0
        next
      end

      properties = all('#searchResultsList tr')
      puts 'properties found.....' + properties.size.inspect

      properties.each do |property|
        @props_found += 1

        city_state_zip = property.all('div.property div').last.all('h4 small').first.text
        street_raw = property.all('div.property div').last.all('h4').last.text
        street_raw.slice!(city_state_zip)
        street = URI::encode(street_raw)
        city = city_state_zip.split(',')[0]
        property_id = property['id']
        city_state_zip = URI::encode(city_state_zip)

        tab1 = Capybara::Session.new(:poltergeist)
        #property_url = 'https://www.hudsonandmarshall.com/propertysearch/florida/1608-dam-rd-bradenton-fl-34212/a98b7beb-c47d-43df-81c6-cdbabb33c18d'
        property_url = "http://www.hudsonandmarshall.com/Property/ViewProperty/#{property['id']}"
        tab1.visit property_url
        sleep 5
        auction_url = property_url
        image = tab1.all('.ribbonContainer').first.all('img').first['src']

        bid = tab1.all('div.propertyDetails').first.find('h3').text rescue nil
        bid.slice!('Starting Bid ') if bid.present?

        auction_date = tab1.all('div.propertyDetails').first.all('h4 small').first.text.slice(/Auction Begin Closing: [A-Za-z]+ \d+ at [0-9:]+ (AM|PM)/) rescue nil

        if auction_date.blank?
          auction_date = tab1.all('div.propertyDetails').first.all('h4 small')[1].text.slice(/Auction Begin Closing: [A-Za-z]+ \d+ at [0-9:]+ (AM|PM)/) rescue nil
        end
        puts 'auction_date...' + auction_date.inspect
        if auction_date.present?
          auction_date.slice!(0, 23)
          auction_parsed = Time.parse("#{auction_date} CST -06:00") rescue nil
        end

        tab1.driver.quit
        #Time.parse('December 8 at 12:45 PM CST -06:00')
        lookup_and_create_property(street, street_raw, city_state_zip, city, nil, bid, auction_parsed, image, auction_url)
      end
    end

    notify_scrape_monitor('HudsonAndMarshall.com')

  end

  task homesearch: :environment do
    init_scrape_monitor

    configure_capybara

    page_count = 0
    ZipCode.all.shuffle.each do |zipcode|
      puts "getting homes from zipcode: #{zipcode.zip}"

      visit "https://www.homesearch.com/Browse?fulltextquery=#{zipcode.zip}&type=a&viewType=photo&occupied=false"
      page_elements = all('.search-pagination li')

      if page_elements.present?
        if page_elements.size > 1
          page_count = page_elements[page_elements.size - 2].text.to_i
        else
          page_count = 1
        end
      end

      puts "page count: #{page_count}"

      if page_count > 0
        1.upto(page_count) do |i|
          page_url = "https://www.homesearch.com/Browse?fulltextquery=#{zipcode.zip}&type=a&occupied=false&viewType=photo&page=#{i - 1}"
          visit page_url

          all('.tile-view-container').each do |property|
             @props_found += 1

            auction_type = property.all('.tile-auction-time', text: /Auction/)
            if auction_type.count > 0
              address = property.find('.result-location').text.gsub(/ County: (.)+/, '').split(', ')
              street_raw = address[0]
              street = URI::encode(address[0])
              city_state_zip = "#{address[1]}, #{address[2]}"
              city = address[1]
              debt = nil
              auction_url = property.all('div.pdpLink').first['data-url']
              if auction_url.present?
                auction_url = 'https://www.homesearch.com' + auction_url
              end
              bid = property.find('.bid-amt').text
              auction = property.all('.tile-auction-time span.datetime').last.text
              auction_parsed = Time.parse(auction) rescue nil
              image = property.find('.address-link img')['src']
              city_state_zip = URI::encode(city_state_zip)
              lookup_and_create_property(street, street_raw, city_state_zip, city, debt, bid, auction_parsed, image, auction_url)
            end
          end
        end
      end
    end
    notify_scrape_monitor('HomeSearch.com')
  end

  task auction_1: :environment do
    init_scrape_monitor

    configure_capybara

    # visit 'http://www.auction.com/residential/'

    ZipCode.first(100).each do |zipcode|
      puts "getting homes from zipcode: #{zipcode.zip}"

      # visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/1_cp/list_vt/"
      # page_count = pages
      #
      # puts "page count: #{page_count}"

  #    1.upto(page_count) do |i|
      #  visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/#{i}_cp/list_vt/"
        visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/1_cp/list_vt/"
        puts all('body').text
        sleep(3)
        puts all('.property-card').text
        all('.property-card').each do |property|
          @props_found += 1
          puts 'auction.com property found'
          street_raw = property.find('.property-card-address').text
          street = URI::encode(street_raw)
          city_state_zip_array = property.find('.property-card-city').text.split(',').first 2
          city_state_zip = URI::encode(city_state_zip_array.join(','))
          city = city_state_zip_array.first
          debt = property.find('.estDebt').text if property.all('.estDebt').count > 0
          bid_to_parse = property.find('.property-card-bid-data').text if property.all('.property-card-bid-data').present?
          bid = bid_to_parse[13..-1]
          auction_to_parse = property.find('.property-card-footer').text if property.find('.property-card-footer').present?
          if auction_to_parse.present?
            auction_to_parse_a = auction_to_parse.gsub!(/.*?(?=Online)/im, "") rescue nil
            auction_to_parse_a
            auction = auction_to_parse_a[16..-1] rescue nil
          end
          image = property.find('.property-card-image-container img')['src']
          auction_url = property.find('.property-card-image-container a')['href'] rescue nil
          auction_parsed = Time.parse(auction)+1.day rescue nil
        # deprecated by auction.com's site changes  auction_type = property.all('.cardFooter', text: /Online/).count > 0

          if street
            lookup_and_create_property(street, street_raw, city_state_zip, city, debt, bid, auction_parsed, image, auction_url)
            puts 'auction.com property created'
          end #end if street
        end #end property-card each do property
    end #end zipcode each

    notify_scrape_monitor('Auction.com Pt 1')
  end #end auction task

  task auction_2: :environment do
    init_scrape_monitor

    configure_capybara

    # visit 'http://www.auction.com/residential/'

    ZipCode.where(id: 101..200).each do |zipcode|
      puts "getting homes from zipcode: #{zipcode.zip}"

      # visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/1_cp/list_vt/"
      # page_count = pages
      #
      # puts "page count: #{page_count}"

  #    1.upto(page_count) do |i|
      #  visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/#{i}_cp/list_vt/"
        visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/1_cp/list_vt/"
        puts all('body').text
        sleep(3)
        puts all('.property-card').text
        all('.property-card').each do |property|
          @props_found += 1
          puts 'auction.com property found'
          street_raw = property.find('.property-card-address').text
          street = URI::encode(street_raw)
          city_state_zip_array = property.find('.property-card-city').text.split(',').first 2
          city_state_zip = URI::encode(city_state_zip_array.join(','))
          city = city_state_zip_array.first
          debt = property.find('.estDebt').text if property.all('.estDebt').count > 0
          bid_to_parse = property.find('.property-card-bid-data').text if property.all('.property-card-bid-data').present?
          bid = bid_to_parse[13..-1]
          auction_to_parse = property.find('.property-card-footer').text if property.find('.property-card-footer').present?
          if auction_to_parse.present?
            auction_to_parse_a = auction_to_parse.gsub!(/.*?(?=Online)/im, "") rescue nil
            auction_to_parse_a
            auction = auction_to_parse_a[16..-1] rescue nil
          end
          image = property.find('.property-card-image-container img')['src']
          auction_url = property.find('.property-card-image-container a')['href'] rescue nil
          auction_parsed = Time.parse(auction)+1.day rescue nil
        # deprecated by auction.com's site changes  auction_type = property.all('.cardFooter', text: /Online/).count > 0

          if street
            lookup_and_create_property(street, street_raw, city_state_zip, city, debt, bid, auction_parsed, image, auction_url)
            puts 'auction.com property created'
          end #end if street
        end #end property-card each do property
    end #end zipcode each

    notify_scrape_monitor('Auction.com Pt 2')
  end #end auction task

  task auction_3: :environment do
    init_scrape_monitor

    configure_capybara

    # visit 'http://www.auction.com/residential/'

    ZipCode.where(id: 201..400).each do |zipcode|
      puts "getting homes from zipcode: #{zipcode.zip}"

      # visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/1_cp/list_vt/"
      # page_count = pages
      #
      # puts "page count: #{page_count}"

  #    1.upto(page_count) do |i|
      #  visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/#{i}_cp/list_vt/"
        visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/1_cp/list_vt/"
        puts all('body').text
        sleep(3)
        puts all('.property-card').text
        all('.property-card').each do |property|
          @props_found += 1
          puts 'auction.com property found'
          street_raw = property.find('.property-card-address').text
          street = URI::encode(street_raw)
          city_state_zip_array = property.find('.property-card-city').text.split(',').first 2
          city_state_zip = URI::encode(city_state_zip_array.join(','))
          city = city_state_zip_array.first
          debt = property.find('.estDebt').text if property.all('.estDebt').count > 0
          bid_to_parse = property.find('.property-card-bid-data').text if property.all('.property-card-bid-data').present?
          bid = bid_to_parse[13..-1]
          auction_to_parse = property.find('.property-card-footer').text if property.find('.property-card-footer').present?
          if auction_to_parse.present?
            auction_to_parse_a = auction_to_parse.gsub!(/.*?(?=Online)/im, "") rescue nil
            auction_to_parse_a
            auction = auction_to_parse_a[16..-1] rescue nil
          end
          image = property.find('.property-card-image-container img')['src']
          auction_url = property.find('.property-card-image-container a')['href'] rescue nil
          auction_parsed = Time.parse(auction)+1.day rescue nil
        # deprecated by auction.com's site changes  auction_type = property.all('.cardFooter', text: /Online/).count > 0
          puts 'raw_street'
          puts raw_street rescue nil
          puts 'street'
          puts street rescue nil
          puts 'city state zip'
          puts city_state_zip rescue nil
          puts 'city'
          puts city rescue nil
          puts 'bid'
          puts bid rescue nil
          puts 'image'
          puts image rescue nil
          puts 'auction_parsed'
          puts auction_parsed rescue nil
          puts 'auction_url'
          puts auction_url rescue nil
          if street
            lookup_and_create_property(street, street_raw, city_state_zip, city, debt, bid, auction_parsed, image, auction_url)
            puts 'sent to lookup_and_create_property'
          end #end if street
        end #end property-card each do property
    end #end zipcode each

    notify_scrape_monitor('Auction.com Pt 3')
  end #end auction task

  task auction_4: :environment do
    init_scrape_monitor

    configure_capybara

    # visit 'http://www.auction.com/residential/'

    ZipCode.where(id: 401..651).each do |zipcode|
      puts "getting homes from zipcode: #{zipcode.zip}"

      # visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/1_cp/list_vt/"
      # page_count = pages
      #
      # puts "page count: #{page_count}"

  #    1.upto(page_count) do |i|
      #  visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/#{i}_cp/list_vt/"
        visit "http://www.auction.com/residential/#{zipcode.zip}_zp/vacant_os/active_as/bm_st/48_rpp/1_cp/list_vt/"
        puts all('body').text
        sleep(3)
        puts all('.property-card').text
        all('.property-card').each do |property|
          @props_found += 1
          puts 'auction.com property found'
          street_raw = property.find('.property-card-address').text
          street = URI::encode(street_raw)
          city_state_zip_array = property.find('.property-card-city').text.split(',').first 2
          city_state_zip = URI::encode(city_state_zip_array.join(','))
          city = city_state_zip_array.first
          debt = property.find('.estDebt').text if property.all('.estDebt').count > 0
          bid_to_parse = property.find('.property-card-bid-data').text if property.all('.property-card-bid-data').present?
          bid = bid_to_parse[13..-1]
          auction_to_parse = property.find('.property-card-footer').text if property.find('.property-card-footer').present?
          if auction_to_parse.present?
            auction_to_parse_a = auction_to_parse.gsub!(/.*?(?=Online)/im, "") rescue nil
            auction_to_parse_a
            auction = auction_to_parse_a[16..-1] rescue nil
          end
          image = property.find('.property-card-image-container img')['src']
          auction_url = property.find('.property-card-image-container a')['href'] rescue nil
          auction_parsed = Time.parse(auction)+1.day rescue nil
        # deprecated by auction.com's site changes  auction_type = property.all('.cardFooter', text: /Online/).count > 0

          if street
            lookup_and_create_property(street, street_raw, city_state_zip, city, debt, bid, auction_parsed, image, auction_url)
            puts 'auction.com property created'
          end #end if street
        end #end property-card each do property
    end #end zipcode each

    notify_scrape_monitor('Auction.com Pt 4')
  end #end auction task

  def pages
    all('li.utk-pagination-item').size
  end

  def lookup_and_create_property(street, street_raw, city_state_zip, city, debt, bid, auction, image, auction_url)
    return false if auction.blank?
    # look up property by street
    puts street_raw
    property = Property.with_deleted.find_by(raw_street: street_raw)

    puts "property.city is: #{property.city}" if property.present?
    puts "city is: #{city}"
    # if property city match
    if property.present?
      if property.deleted?
        puts 'Property is deleted. No further action required...'
        return
      end

      puts 'same property!'
      # it is the same property
      # if the auction date does not match
      puts "datbase auction date: #{property.auction_date}"
      puts "scraped auction date: #{auction}"
      puts "equality is :#{property.auction_date == auction}"
      if property.auction_date != auction
        puts 'auction date does not match! ...'
        # it is being re auctioned so update the record
        zpid = Zillow.request_zpid(street, city_state_zip)
        zest = Zillow.request_zestimate(zpid) if zpid
        if zest.present?
          if property.workflow_state == 'reserve_not_met'
            property.workflow_state = nil
          end
          updated = property.update_zillow_info(zest, debt, bid, auction, image)
          @props_updated += 1 if updated
        end
      end
    else
      puts 'new property!'
      # this is a new property
      # create the record
      puts 'looking up the zpid!!'
      zpid = Zillow.request_zpid(street, city_state_zip)
      zest = Zillow.request_zestimate(zpid) if zpid
      puts 'ZPID:'
      puts zpid
      puts 'ZEST:'
      puts zest
      if zest.present?
        created = Property.create_scraped(zest, debt, bid, auction, image, street_raw, auction_url)
        @props_created += 1 if created
        puts 'zestimate found, property created'
      end
    end
  end
end
