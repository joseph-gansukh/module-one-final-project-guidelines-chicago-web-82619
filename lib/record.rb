class Record < ActiveRecord::Base
    belongs_to :baby 
    belongs_to :activity
end
