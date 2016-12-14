desc "This task is called by the Heroku scheduler add-on"
task :update_news => :environment do
  puts "Updating news..."
  Rake::Task['scrape:newsweek3'].invoke
  Rake::Task['scrape:nytimes3'].invoke
  Rake::Task['scrape:huffpost'].invoke
  Rake::Task['scrape:cnn_3'].invoke
  Rake::Task['scrape:espn_3'].invoke
  Rake::Task['scrape:foxnews_3'].invoke
  Rake::Task['scrape:buzzfeed_3'].invoke
  Rake::Task['scrape:washingtonpost_3'].invoke
  Rake::Task['scrape:drudge_3'].invoke
  puts "done."
end

task :send_reminders => :environment do
  User.send_reminders
end
