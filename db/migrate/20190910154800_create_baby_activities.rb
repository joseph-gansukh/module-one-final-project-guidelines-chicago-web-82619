class CreateBabyActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :baby_activities do |t|
      t.integer :activity_id
      t.integer :baby_id
      t.string :caregiver
    end
  end
end
