class User < ActiveRecord::Base
    has_many :baby_users
    has_many :babies, through: :baby_users
end
