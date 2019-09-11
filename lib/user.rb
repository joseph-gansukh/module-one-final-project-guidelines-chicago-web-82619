class User < ActiveRecord::Base
    has_many :baby_users
    has_many :babies, through: :baby_users

    def self.existing_users
        User.all.select do |user|
            puts user.name
        end
    end

    def create_user
        puts "What is your name?"
        name = gets.chomp
        new_user = self.create(name: name)    
        puts "Your username is #{new_user.name} and your user id is #{new_user.id}!"
    end

    def existing_user?
    end

end
