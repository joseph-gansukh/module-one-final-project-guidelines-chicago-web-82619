class User < ActiveRecord::Base
    has_many :baby_users
    has_many :babies, through: :baby_users

    attr_accessor :current_user

    def self.reload
        reset
        load
    end

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
        @current_user = new_user
        end
    end

    def self.existing_user(name)
        self.all.find_by(name: name)
    end

    def self.login
        prompt = TTY::Prompt.new
        answer = prompt.select("Login as:", %w(Existing_User New_User \ Exit))
    
        if answer == "Existing_User"
            username = prompt.ask('Please enter your username:')
            @current_user ||= User.existing_user(username)
            if @current_user
                puts "You are logged in as #{@current_user.name}."
                # binding.pry
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
            # binding.pry
        elsif answer == "New_User"
            @current_user ||= User.create_user
            # binding.pry
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
        else
            exit
        end    
        # binding.pry
    end

    def self.babies
        prompt = TTY::Prompt.new
        answer = prompt.select("Choose one:", %w(View_Baby New_Baby Delete_Baby Back))
        if answer == "View_Baby"
            @current_user.reload
            # puts @current_user.babies.first
            if !@current_user.babies.empty?
                @current_user.babies.each do |baby|
                    puts baby.name
                end
            else 
                system 'clear'
                puts " "
                puts "Please add a baby".red
                puts " "
            end
        
            babies
        elsif answer == "New_Baby"
            # @current_user.create_baby
            puts "What is the name of the baby?"
            new_baby = gets.chomp
            puts "What was the baby's birthdate? (YYYYMMDD HH:SS)"
            birth_date = gets.chomp
            puts "What is the baby's sex?"
            sex = gets.chomp
            babe = Baby.create(name: new_baby, birth_date: birth_date, sex: sex)
            new_baby_user = BabyUser.create(user_id: @current_user.id, baby_id: babe.id)
            puts "Your new baby is: name: #{babe.name}, birth date: #{babe.birth_date}, sex: #{babe.sex}"
            babies
        elsif answer == "Delete_Baby"
            p delete baby
        else 
            system 'clear'
            main_menu
        end
    end
end
