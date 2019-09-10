class Activity < ActiveRecord::Base
    has_many :records
    has_many :babies, through: :records
end
