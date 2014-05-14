task :updateHashtagCounts => :environment do
  all_hashtags = Hashtag.all
  all_hashtags.each do |hashtag|
    user = User.find(hashtag.challenge.user_id)
    @client = Twitter::REST::Client.new(
      consumer_key: ENV["TWITTER_CONSUMER_KEY"], 
      consumer_secret: ENV["TWITTER_CONSUMER_SECRET"], 
      access_token: user[:oauth_access_token], 
      access_token_secret: user[:oauth_access_secret])

    def count_nextpage_tweets(hashtag, max_id)
      next_results = @client.search("##{hashtag.name}", {result_type:"recent", max_id: max_id, since_id: hashtag.since_id.to_i}).attrs
      new_count = hashtag.count + next_results[:statuses].length
      hashtag.update_attributes(count: new_count)
      puts "next page: " + hashtag.count.to_s
      puts "amount: " + next_results[:statuses].length.to_s
      if !next_results[:search_metadata][:next_results].nil?
        max_id = next_results[:search_metadata][:next_results].split("max_id=")[1].split("&")[0].to_i
        count_nextpage_tweets(hashtag, max_id)
      end
    end

    if hashtag.challenge.end_date - Date.today > 0 # only process current challenges
      results = @client.search("##{hashtag.name}", {result_type:"recent", until: hashtag.challenge.end_date, since_id: hashtag.since_id.to_i}).attrs
      
      # Step 1: count the first page's statuses
      new_count = hashtag.count + results[:statuses].length
      hashtag.update_attributes(count: new_count)
      puts hashtag.count.to_s + " count is now " + new_count.to_s

      # Step 2: count statuses on additional pages of results
      if !results[:search_metadata][:next_results].nil?
        max_id = results[:search_metadata][:next_results].split("max_id=")[1].split("&")[0].to_i
        count_nextpage_tweets(hashtag, max_id)
      end

      # Step 3: update the since_id
      new_since_id = results[:search_metadata][:max_id]
      hashtag.update_attributes(since_id: new_since_id)
      puts "new since id...now " + hashtag.since_id.to_s
    end
  end
end