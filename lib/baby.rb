class Baby < ActiveRecord::Base
    has_many :activities
    has_many :baby_users
    has_many :users, through: :baby_users

end
