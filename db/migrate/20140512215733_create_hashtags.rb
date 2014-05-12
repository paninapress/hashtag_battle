class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :name
      t.integer :count, :default => 0
      t.string :since_id
      t.references :challenge

      t.timestamps
    end
  end
end
