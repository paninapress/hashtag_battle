class User < ActiveRecord::Base
  has_many :challenges
  
  def self.from_omniauth(auth)
    user = where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
    user.oauth_access_token = auth["extra"]["access_token"].token
    user.oauth_access_secret = auth["extra"]["access_token"].secret
    user.save!
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

  def twitter
    if provider == "twitter"
      @twitter ||= Twitter::REST::Client.new(consumer_key: ENV["TWITTER_CONSUMER_KEY"], consumer_secret: ENV["TWITTER_CONSUMER_SECRET"], access_token: oauth_access_token, access_token_secret: oauth_access_secret)
    end
  end
end
