class CreateBabyUsers < ActiveRecord::Migration[5.0]
    def change
      create_table :baby_users do |t|
        t.integer :user_id
        t.integer :baby_id
      end
    end
  end