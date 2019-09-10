class Baby < ActiveRecord::Base
    has_many :activities, through: :babyactivities

end
