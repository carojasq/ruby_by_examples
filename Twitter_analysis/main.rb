require_relative 'config'
require 'twitter'
require 'irb/completion'
require 'set'
require "i18n"

# To filter words
COMMON_WORDS = {
  :spanish    => ["a", "ante", "bajo", "cabe", "con", "contra", "de", "desde", "durante", "en", "entre", "hacia", "hasta" \
  		"hacia", "hasta", "mediante", "para", "por", "según", "sin", "so", "sobre", "tras", "versus", "la", "que", "y", \
  		 "no", "es", "los", "una", "las", "como", "de", "cuando", "mas", "ahora", "qué", "son", "les", "bien", "del", \
  		 "pero", "the", "esto", "esta"],  
}

# To obtain twitter data
client = Twitter::REST::Client.new(CONSUMER_DATA)

# a_user = client.user("alejo0317")
def client.collect_with_max_id(collection=[], max_id=nil, &block)
  response = yield(max_id)
  collection += response
  2800 <= collection.count || response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
end

def client.get_all_tweets(user)
  collect_with_max_id do |max_id|
    options = {:count => 200, :include_rts => true}
    options[:max_id] = max_id unless max_id.nil?
    user_timeline(user, options)
  end   
end
if ARGV[0].downcase =~ /^[a-z0-9\_]+$/
  username = ARGV[0]
else 
  puts "#{ARGV[0]} is not a valid username"
  exit
end

tweets_dump_f = username + "_tweets.dump"

# Using marshal for tweets persistence
if File.exist?(tweets_dump_f)
	puts "Loading tweets from cache for user @#{username}"
	tweets = nil
	File.open(tweets_dump_f,"rb") {|f| tweets = Marshal.load(f)}
else
  begin
    puts "Fetching tweets of @#{username}, please wait"
	  tweets = client.get_all_tweets(username)
  rescue
    puts "Can't fetch tweets, check your internet conection or the username inputted"
    exit
  end
	dmp = Marshal.dump(tweets)
	File.open(tweets_dump_f, 'w') {|f| f.write(dmp) }

end
# Extracting useful info
puts "There are #{tweets.count} tweets"
all_text = ""
tweets.collect{|t| all_text += t.text}
words = all_text.downcase.gsub("\n",' ').split(' ')
# Clean accents
# words = I18n.transliterate(all_text).downcase.gsub("\n",' ').split(' ')
tags = words.select { |f| f =~ /^#.*$/ }
others = words.select { |f| f =~ /^@.*$/ }
only_urls = words.select{|f| f =~ /^https\/\/.*$/}
only_words = words.reject{|f| f =~ /^#.*$/ || f =~ /^@.*$/ ||  f.length <= 2  || f =~ /^https\/\/.*$/ } # || PREPOSITIONS[:spanish].include? f

puts "Counting words"
word_count = { }
words_set = only_words.to_set - COMMON_WORDS[:spanish].to_set
words_set.each do |word|
	word_count[word] = only_words.select{|w| w == word}.count
end

puts "Sorting"
sorted = word_count.sort_by { |word, count| count }
elements_n = sorted.count
sorted.each do |s| 
  elements_n -=  1
  puts elements_n.to_s+". Word: "+s[0]+", count: "+s[1].to_s 
end

#puts tweet_class.to_s
#puts tweet_class.methods
# XXX A pythons ipdb equivalent for debugging in rubyh