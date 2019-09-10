class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.integer :activity_id
      t.integer :baby_id
      t.string :caregiver
    end
  end
end
