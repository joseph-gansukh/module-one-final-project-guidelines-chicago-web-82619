class Baby < ActiveRecord::Base
    has_many :records
    has_many :activities, through: :records
end
