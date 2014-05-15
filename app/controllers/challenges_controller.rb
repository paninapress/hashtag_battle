class ChallengesController < ApplicationController
  def index
    @challenges = Challenge.where(:user_id => current_user)
    @current_time = Time.parse(Time.now.to_s).utc
  end
  def create
    # set both initial since_ids with most recent tweets's max_id
    initial_since_id = current_user.twitter.search("##{:hashtag1} since:#{Date.today}", {result_type: "recent", count: 1}).attrs[:search_metadata][:max_id]
    # Create challenge and hashtags from params
    if params[:challenge][:end_date] != ""
      end_date = params[:challenge][:end_date]
    else
      end_date = Date.today + 365.days
    end
    
    Challenge.create!(user_id: current_user.id, end_date: end_date).hashtags.create!(
      name: params[:challenge][:hashtag1], since_id: initial_since_id)

    challenge = Challenge.where(user_id: current_user.id).last
    challenge.hashtags.create!(name: params[:challenge][:hashtag2], since_id: initial_since_id)
    redirect_to challenges_path
  end

  def show
    @challenge = Challenge.find(params[:id])
  end
end
