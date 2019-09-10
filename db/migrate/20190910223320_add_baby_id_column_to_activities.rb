class AddBabyIdColumnToActivities < ActiveRecord::Migration[5.0]
  def change
    add_column :activities, :baby_id, :integer
  end
end
