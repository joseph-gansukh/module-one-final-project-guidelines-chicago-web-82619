class Baby < ActiveRecord::Base
    has_many :activities
    has_many :baby_users
    has_many :users, through: :baby_users

    # def self.whos_baby_is_this?(name)
    #     parent_id = Baby.all.find(baby_id: name)
    #     parent_id
    # end
end
