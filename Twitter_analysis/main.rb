load 'config.rb'

client = Twitter::REST::Client.new(config.consumer_data)

