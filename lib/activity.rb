class Activity < ActiveRecord::Base
    has_many :babies, through: :babyactivities
end
