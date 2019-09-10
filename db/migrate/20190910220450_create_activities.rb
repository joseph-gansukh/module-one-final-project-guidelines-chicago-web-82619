class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :name
      t.datetime :start_time
      t.datetime :end_time
      t.string :diaper_status
      t.string :amount
      t.datetime :duration
      t.string :notes
      t.timestamp
    end
  end
end
