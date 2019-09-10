class CreateBabies < ActiveRecord::Migration[5.0]
  def change
    create_table :babies do |t|
      t.string :name
      t.date :birth_date
      t.date :due_date
      t.string :gender
    end
  end
end
