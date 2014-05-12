task :updateHashtagCounts => :environment do
  allChallenges = Hashtagchallenge.all
  allChallenges.each do |challenge|
    print challenge
    user = User.where(id: challenge.user_id)
    oauth_access_token = user[0][:oauth_access_token]
    oauth_access_secret = user[0][:oauth_access_secret]
    @client = Twitter::REST::Client.new(consumer_key: ENV["TWITTER_CONSUMER_KEY"], consumer_secret: ENV["TWITTER_CONSUMER_SECRET"], access_token: oauth_access_token, access_token_secret: oauth_access_secret)

    query1 = @client.search("##{challenge.hashtag1}", {result_type:"recent", until: challenge.end_date, since_id:challenge.ht1_since_id}).attrs
    
    new_since_id = query1[:search_metadata][:max_id]
    challenge.count1 += query1[:statuses].length
    challenge.save!
    print "First count is"
    print challenge.count1

    def count_nextpage_tweets(challenge, max_id)
      query2 = @client.search("##{challenge.hashtag1}", {result_type:"recent", max_id: max_id, since_id:challenge.ht1_since_id}).attrs
      challenge.count1 += query2[:statuses].length
      challenge.save!
      print "Second count IS:"
      print challenge.count1
      if !query2[:search_metadata][:next_results].nil?
        max_id = query2[:search_metadata][:next_results].split("max_id=")[1].split("&")[0].to_i
        count_nextpage_tweets(challenge, max_id)
      else
        print "all counted out!"
      end
    end

    if !query1[:search_metadata][:next_results].nil?
      max_id = query1[:search_metadata][:next_results].split("max_id=")[1].split("&")[0].to_i
      count_nextpage_tweets(challenge, max_id)
    else
      print "must be nil???"
    end


      # if !query1[:search_metadata][:next_results].nil?
      #   # continue down tweet stack by setting max_id
      #   # equal to last processed tweet id minus 1
      #   max_id1 = query1[:statuses].last[:id] - 1
      #   print max_id1
      #   query1 = @client.search("##{challenge.hashtag1}", {result_type:"recent",until: challenge.end_date, since_id:challenge.ht1_since_id, max_id: max_id1}).attrs
      # end
    #end
    # challenge[:ht1_since_id] = new_since_id


    # query2 = @client.search("##{challenge.hashtag2}", {result_type:"recent",until: challenge.end_date, since_id:challenge.ht2_since_id}).attrs
    # new_since_id2 = query2[:search_metadata][:max_id]
    # until query2[:search_metadata][:next_results].nil? && query2[:statuses].length == 0
    #   challenge[:count2] += query2[:statuses].length
    #   if !query2[:search_metadata][:next_results].nil?
    #     # continue down tweet stack by setting max_id
    #     # equal to last processed tweet id minus 1
    #     max_id2 = query2[:statuses].last[:id] - 1
    #     query2 = @client.search("##{challenge.hashtag2}", {result_type:"recent",until: challenge.end_date, since_id:challenge.ht2_since_id, max_id: max_id2}).attrs
    #   end
    # end
    # challenge[:ht2_since_id] = new_since_id2
  end
end
  