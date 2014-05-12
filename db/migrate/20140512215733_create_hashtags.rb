class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :name
      t.integer :count, :default => 0
      t.string :since_id
      t.integer :challenge_id

      t.timestamps
    end
  end
end
