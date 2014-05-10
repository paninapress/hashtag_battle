class CreateHashtagchallenges < ActiveRecord::Migration
  def change    
    create_table :hashtagchallenges do |t|
      t.belongs_to :user
      t.text :hashtags
      t.text :counts
      t.integer :since_id
      t.date :end_date

      t.timestamps
    end
  end
end
