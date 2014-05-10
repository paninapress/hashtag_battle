class CreateHashtagchallenges < ActiveRecord::Migration
  def change
    create_table :hashtagchallenges do |t|
      t.date :end_date
      t.string :hashtag1
      t.string :hashtag2
      t.integer :count1, :default => 0
      t.integer :count2, :default => 0
      t.string :ht1_since_id
      t.string :ht2_since_id

      t.timestamps
    end
  end
end
