class Record < ActiveRecord::Base
    belongs_to :babies
    belongs_to :activities
end
