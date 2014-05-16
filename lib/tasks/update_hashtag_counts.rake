task :updateHashtagCounts => :environment do
  all_hashtags = Hashtag.all
  all_hashtags.each do |hashtag|
    user = User.find(hashtag.challenge.user_id)
    @client = Twitter::REST::Client.new(
      consumer_key: ENV["TWITTER_CONSUMER_KEY"], 
      consumer_secret: ENV["TWITTER_CONSUMER_SECRET"], 
      access_token: user[:oauth_access_token], 
      access_token_secret: user[:oauth_access_secret])
    # calculate the max_attempts to query per user
    # by dividing 90 by the total number of hashtags to be processed
    num_hashtags = user.challenges.length * 2
    max_attempts_total = 90 # per 10 mins
    max_attempts = max_attempts_total / num_hashtags
    num_attempts = 0
    puts num_attempts

    def count_nextpage_tweets(hashtag, max_id, num_attempts, max_attempts)
  
      puts "Max attempt IS " + max_attempts.to_s
      num_attempts += 1
      puts num_attempts
      if num_attempts >= max_attempts
      else
        next_results = @client.search("##{hashtag.name}", {result_type:"recent", max_id: max_id, since_id: hashtag.since_id.to_i}).attrs
        new_count = hashtag.count + next_results[:statuses].length
        hashtag.update_attributes(count: new_count)
        puts "next page count at: " + hashtag.count.to_s
        puts "increased by: " + next_results[:statuses].length.to_s
        if !next_results[:search_metadata][:next_results].nil?
          max_id = next_results[:search_metadata][:next_results].split("max_id=")[1].split("&")[0].to_i
          count_nextpage_tweets(hashtag, max_id, num_attempts, max_attempts)
        end
      end
    end

    if hashtag.challenge.end_date - Date.today > 0 # only process current challenges
      num_attempts += 1
      puts num_attempts
      results = @client.search("##{hashtag.name}", {result_type:"recent", until: hashtag.challenge.end_date, since_id: hashtag.since_id.to_i}).attrs
      
      # Step 1: count the first page's statuses
      new_count = hashtag.count + results[:statuses].length
      puts hashtag.count.to_s + " count is now " + new_count.to_s
      hashtag.update_attributes(count: new_count)

      # Step 2: count statuses on additional pages of results
      if !results[:search_metadata][:next_results].nil?
        max_id = results[:search_metadata][:next_results].split("max_id=")[1].split("&")[0].to_i
        count_nextpage_tweets(hashtag, max_id, num_attempts, max_attempts)
      end

      # Step 3: update the since_id
      new_since_id = results[:search_metadata][:max_id]
      hashtag.update_attributes(since_id: new_since_id)
      puts "new since id...now " + hashtag.since_id.to_s
    end
  end
end