class HashtagsController < ApplicationController
  def index
    
  end
  def create
    # Step 1: Get the params we're working with
    hashtag_challenge_info = params[:hashtagchallenge].permit(:hashtag1, :hashtag2, :end_date)
    hashtag_challenge_info[:user_id] = current_user.id

    # set the since_id with most recent search's max_id
    hashtag_challenge_info[:ht1_since_id] = current_user.twitter.search("##{:hashtag1} since:#{Date.today}", {result_type: "recent", count: 1})
      .attrs[:search_metadata][:max_id]
    hashtag_challenge_info[:ht2_since_id] = current_user.twitter.search("##{:hashtag2} since:#{Date.today}", {result_type: "recent", count: 1})
      .attrs[:search_metadata][:max_id]

    Hashtagchallenge.create(hashtag_challenge_info)
    redirect_to "/hashtags"
  end
  def show
    @hashtagchallenge = Hashtagchallenge.where(:user_id => current_user)
  end
end
