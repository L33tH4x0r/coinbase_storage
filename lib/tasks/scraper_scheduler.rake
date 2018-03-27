task :update_feed => :environment do
  puts "Updating feed..."
  CryptoPanicService.new.call
  puts "done."
end
