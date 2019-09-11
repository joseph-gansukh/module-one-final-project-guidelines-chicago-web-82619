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
        @user = self.create(name: name)    
        puts "Your username is #{@user.name} and your user id is #{@user.id}!"
    end

    def existing_user?
    end

end
