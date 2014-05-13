class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.where(:user_id => current_user)
  end
  def create
    # Create challenge
    Challenge.create!(user_id: current_user.id, end_date: params[:challenge][:end_date])

    # set the since_id with most recent search's max_id
    h1_since_id = current_user.twitter.search("##{:hashtag1} since:#{Date.today}", {result_type: "recent", count: 1})
      .attrs[:search_metadata][:max_id]
    h2_since_id = current_user.twitter.search("##{:hashtag2} since:#{Date.today}", {result_type: "recent", count: 1})
      .attrs[:search_metadata][:max_id]

    # Create hashtags from params
    challenge = Challenge.where(user_id: current_user.id).last
    challenge.hashtags.create!(name: params[:challenge][:hashtag1], since_id: h1_since_id)
    challenge.hashtags.create!(name: params[:challenge][:hashtag2], since_id: h2_since_id)
    redirect_to "/challenges"
  end

  def show
    @challenge = Challenge.find(params[:id])
  end
end
