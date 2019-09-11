class ChangeBabyGenderToSex < ActiveRecord::Migration[5.0]
  def change
    rename_column :babies, :gender, :sex
  end
end
