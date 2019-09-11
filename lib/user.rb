class User < ActiveRecord::Base
    has_many :baby_users
    has_many :babies, through: :baby_users

    def self.existing_users
        User.all.select do |user|
            puts user.name
        end
    end

    def self.create_user
        puts "What is your name?"
        name = gets.chomp
        if self.existing_user(name)
            puts "Username already exist"
            login
        else 
            new_user = self.create(name: name)    
        puts "Your username is #{new_user.name} and your user id is #{new_user.id}!"
        new_user
        end
    end

    def self.existing_user(name)
        self.all.find_by(name: name)
    end


    def existing_user?
    end

    def create_baby
        puts "What is your baby's name?"
        baby_name = gets.chomp
        puts "What is your baby's birthdate? YYYYMMDD HHMMSS"
        baby_birthdate = gets.chomp
        puts "What is the sex of your baby?"
        baby_sex = gets.chomp
        new_baby = Baby.create(name: baby_name, birthdate: baby_birthdate, sex: baby_sex)
        self.babies << new_baby
        BabyUser.create(user_id: self.id, baby_id: new_baby.id)
        puts "Your new baby is #{new_baby.name}. It was born #{new_baby.birthdate}. It's assigned sex at birth was #{new_baby.sex}"
        new_baby
    end

    def self.login
        prompt = TTY::Prompt.new
        answer = prompt.select("Login as:", %w(Existing_User New_User))
    
        if answer == "Existing_User"
            username = prompt.ask('Please enter your username:')
            current_user ||= User.existing_user(username)
            if current_user
                puts "You are logged in as #{current_user.name}."
            else
                puts "Invalid user."
                login
            end
        
            
            spinner = TTY::Spinner.new("Logging in :spinner ... ", format: :spin_2)
            5.times do
            spinner.spin
            sleep(0.1)
            end
            spinner.stop('Logged in successfully')
            
            puts ""
            
            puts "Welcome back, #{username.upcase}! "
            main_menu
        else
            current_user ||= User.create_user
            binding.pry
            puts " "
            
            spinner = TTY::Spinner.new("Registering new user :spinner ... ", format: :spin_2)
            7.times do
                spinner.spin
                sleep(0.1)
            end
            spinner.stop('Registered successfully')
            
            puts " "
            
            puts " "
            main_menu
        end    
        binding.pry
    end
end
