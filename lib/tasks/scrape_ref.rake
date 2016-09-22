namespace :scrape2 do
  task :bullseye => [ :environment ] do
  desc 'scraped auct.com and zestimates properties'
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
  puts 'Please hold while a list of auctions is generated...'
  puts ' '
  t1 = Time.now
  puts 'time begun' + t1.to_s

  b = Watir::Browser.new(:phantomjs)
  i = 27
  num = 50
  while i < num do
    start_page = i.to_s
    b.goto 'https://www.auction.com/residential/aed_st/48_rpp/' + start_page + '_cp/'
    i += 1

    doc = Nokogiri::HTML(b.html)

    #ONLY RETURN LINKS
    sites = []
    doc.css('[target="_self"]').each do |i|
      sites << i['href']
    end
    #ONLY AUCTION SITES
    sites.select! { |str| str.to_s.include?('https://www.auction.com/details/')  }
    auction_sites_double = sites
    # only returns auction sites once
    auction_sites = auction_sites_double.values_at(* auction_sites_double.each_index.select {|i| i.even?})
    puts auction_sites
    t2 = Time.now
    alpha = t2 - t1
    puts alpha.to_s + 'time elapsed'

  puts ' '
  puts '                                  ,           ,     '
  puts '                                 /             \    '
  puts '                                ((__-^^-,-^^-__))    '
  puts '                                 `-_---`` `---_-"    '
  puts '                                  <__|o` `o|__>    '
  puts '                                     \  `  /    '
  puts '                                      ): :(    '
  puts '                                      :o_o:    '
  puts '                                       "-"    '
  puts "Now for the good stuff..."
  puts ' '
  t3 = Time.now
  bravo = t3 - t1
  puts bravo.to_s + 'time elapsed'



  b = Watir::Browser.new(:phantomjs)
  auction_sites.each do |a|
  b.goto a

  doc = Nokogiri::HTML(b.html)
  t4 = Time.now
  charlie = t4 - t1
  puts charlie.to_s + 'time elapsed'
  puts '~~ Property ' + a + '~~'
  auction_url = a
  puts " "
  puts 'Address'
  puts doc.css('.address-header1').text
  street = doc.css('.address-header1').text
  puts doc.css('.address-header2').text
  city_state_zip = doc.css('.address-header2').text
  city_state_zip = city_state_zip.split(" ")
  # city = city_state_zip[0].chomp(',')
  # state = city_state_zip[1]
  # zip = city_state_zip[2]
  puts " "
  puts ' -------------------- '
  puts " "
  puts 'Current Auction Price'
  puts doc.css('[data-elm-id="bid_current_amount"]').text
  auction_price = doc.css('[data-elm-id="bid_current_amount"]').text
  if auction_price.present?

    puts '1' + auction_price
    auction_price = auction_price[1..-1]
    puts 'post slice' + auction_price
    auction_price = auction_price.gsub(",","")
    puts 'wgsub: ' + auction_price
    auction_price = auction_price.to_i
    puts 'to i: '
    auction_price
  end

  if auction_price.present?
    puts " "
    puts ' --------------------  '
    puts " "
    puts 'ZEstimate Params'
    rillow = Rillow.new('X1-ZWz1etdfu1l1qj_3l8b3')
    result = rillow.get_search_results(street, city_state_zip)
    zillow_hash = result.to_hash
    puts zillow_hash
    puts " "
    #dig not working for this version of ruby
    #puts zillow_hash.dig[:zestimate][:content]
    puts 'zestimate response:'
    if zillow_hash['response']
      puts zillow_hash['response']
      puts " "
      puts 'zestimate result'
      puts zillow_hash['response'][0]['results'] if zillow_hash['response']
      puts 'zestimate results result'
      puts zillow_hash['response'][0]['results'][0]['result']
      puts " "
      puts 'zestimate zpid'
      puts zillow_hash['response'][0]['results'][0]['result'][0]['zpid']
      puts " "
      puts 'zestimate homedetails link'
      puts zillow_hash['response'][0]['results'][0]['result'][0]['links'][0]['homedetails']
      puts " "
      puts 'zestimate graphsanddata link'
      puts zillow_hash['response'][0]['results'][0]['result'][0]['links'][0]['graphsanddata']
      puts " "
      puts 'zestimate mapthishome link'
      puts zillow_hash['response'][0]['results'][0]['result'][0]['links'][0]['mapthishome']
      puts " "
      puts 'street'
      address = zillow_hash['response'][0]['results'][0]['result'][0]['address'][0]['street'].join
      puts street
      puts " "
      puts 'zipcode'
      zipcode =  zillow_hash['response'][0]['results'][0]['result'][0]['address'][0]['zipcode'].join
      puts zipcode
      puts " "
      puts 'city'
      city = zillow_hash['response'][0]['results'][0]['result'][0]['address'][0]['city'].join
      puts city
      puts " "
      puts 'state'
      state = zillow_hash['response'][0]['results'][0]['result'][0]['address'][0]['state'].join
      puts state
      puts " "
      puts 'zestimate comparables link'
      puts zillow_hash['response'][0]['results'][0]['result'][0]['links'][0]['comparables']
      puts " "
      puts 'zestimate zestimate'
      zestimate = zillow_hash['response'][0]['results'][0]['result'][0]['zestimate'][0]['amount'][0]['content'].to_i
      puts zillow_hash['response'][0]['results'][0]['result'][0]['zestimate'][0]['amount'][0]['content']
      puts " "
      puts " "
      puts ' -------------------- '
      puts " "
      puts 'Time to end of auction'
      puts doc.css('[data-elm-id="auction_status_counter"]').text
      auction_end = doc.css('[data-elm-id="auction_status_counter"]').text
      puts " "
      puts ' -------------------- '
      puts " "
    end
  end

  if auction_price.present?
      puts address
      if ScraperUsa.find_by(address: address)
        @property = ScraperUsa.with_deleted.find_by(address: address)
        @property.update_attributes(
          current_price: auction_price,
          time_remaining: auction_end
        )
        @property.save
        puts 'property attribute updated'
      else
      # if Property.where("street like ?", "%street%")
      #   obj = Property.where("street like ?", "%street%")
      #   attributes = {comparables: auction_end, graphsanddata: auction_price}
      #   obj.update_attributes(attributes)
      # else
        @property = ScraperUsa.find_or_create_by(address: address, city: city, state: state, zip: zipcode, time_remaining: auction_end, current_price: auction_price, zestimate: zestimate, auction_url: auction_url)
        @property.save
        puts 'property created'
        puts " "
      end
      # end
  end
  notify_scrape_monitor('Auction.com 2.0')
  end
end




end #while loop

end
