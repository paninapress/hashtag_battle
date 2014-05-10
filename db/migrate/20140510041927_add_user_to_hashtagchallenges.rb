class AddUserToHashtagchallenges < ActiveRecord::Migration
  def change
    add_reference :hashtagchallenges, :user, index: true
  end
end
