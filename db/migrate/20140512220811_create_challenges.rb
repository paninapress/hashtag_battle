class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.date :end_date

      t.timestamps
    end
  end
end
