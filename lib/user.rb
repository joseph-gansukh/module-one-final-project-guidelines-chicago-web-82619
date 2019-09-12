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
        system 'clear'
        puts "New user registraton".green
        puts " "
        puts "What is your name?"
        name = gets.chomp
        if self.existing_user(name)
            puts " "
            puts "Username already exists.".red
            puts " "
            login
        else 
            new_user = self.create(name: name)    
        
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
                system 'clear'
                puts "Invalid user. Please retry.".red
                puts " "
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
            puts "Logged in as #{@current_user.name}!"
        
            main_menu
        else
            exit
        end    
        # binding.pry
    end

    def select_baby
        prompt = TTY::Prompt.new
        baby = self.babies
                menu = baby.map do |babe|
                    babe.name
                end
                puts " "
            prompt.select("Select a baby", menu)
    end

    def self.babies
        prompt = TTY::Prompt.new
        answer = prompt.select("Choose one:", %w(View_Baby New_Baby Delete_Baby Back))
        if answer == "View_Baby"
            @current_user.reload
            # binding.pry
            # puts @current_user.babies.first
            if !@current_user.babies.empty?
                system 'clear'
                # tp @current_user.babies, :name, :birth_date, :sex
                tp @current_user.babies

                @current_user.select_baby
                # binding.pry

                answer = prompt.select("", %w(Go_Back Exit))
                if answer == "Go_back"
                    main_menu 
                else
                    exit
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


    def self.add_activity
        baby_list =  "Your babies are "
        # binding.pry
        babies_array = @current_user.babies
        babies_array.each_with_index do |baby, index|
            baby_list << " #{index + 1}, #{baby.name}"
        end
        # binding.pry
        puts baby_list + "."
        puts "For which baby would you like to add an activity?"
        puts "Enter a baby name:"
        baby = gets.chomp
        baby_object = Baby.find_by(name: baby)
        puts "You have selected #{baby_object.name}"
        puts "Please enter an activity (feeding, sleep, diaper, bath):"
        activity = gets.chomp
        if activity == "feeding"
            puts "What time was the feeding?"
            start_time = gets.chomp
            puts "What was the amount?"
            amount = gets.chomp
            puts "any notes?"
            notes = gets.chomp
            new_feeding = Activity.create(name: activity, start_time: start_time, amount: amount, notes: notes)
            # binding.pry
            baby_object.activities << new_feeding
            puts "activity: #{new_feeding.name}, time: #{new_feeding.start_time}, amount: #{new_feeding.amount}, notes: #{new_feeding.notes}"
            puts new_feeding
            puts baby_object.activities
            main_menu
        elsif activity == "sleep"
            puts "What time did the baby go to sleep?"
            start_time = gets.chomp
            puts "What time did the baby wake up?"
            end_time = gets.chomp
            puts "any notes?"
            notes = gets.chomp
            new_sleep = Activity.create(name: activity, start_time: start_time, end_time: end_time, notes: notes)
            # binding.pry
            baby_object.activities << new_sleep
            puts "activity: #{new_sleep.name}, start time: #{new_sleep.start_time}, end time: #{new_sleep.end_time}, notes: #{new_sleep.notes}"
            puts new_sleep
            puts baby_object.activities
            main_menu
        elsif activity == "diaper"
            puts "What time did you change the diaper?"
            start_time = gets.chomp
            puts "How was the baby's diaper?"
            diaper_status = gets.chomp
            puts "any notes?"
            notes = gets.chomp
            new_diaper = Activity.create(name: activity, start_time: start_time, diaper_status: diaper_status, notes: notes)
            # binding.pry
            baby_object.activities << new_diaper
            puts "activity: #{new_diaper.name}, start time: #{new_diaper.start_time}, diaper status: #{new_diaper.diaper_status}, notes: #{new_diaper.notes}"
            puts new_diaper
            puts baby_object.activities
            main_menu
        elsif activity == "bath"
            puts "What time was the bath?"
            start_time = gets.chomp
            puts "How long was the bath?"
            duration = gets.chomp
            puts "any notes?"
            notes = gets.chomp
            new_bath = Activity.create(name: activity, start_time: start_time, duration: duration, notes: notes)
            # binding.pry
            baby_object.activities << new_bath
            puts "activity: #{new_bath.name}, start time: #{new_bath.start_time}, duration #{new_bath.duration} notes: #{new_bath.notes}"
            puts new_bath
            puts baby_object.activities
            main_menu
        else
            "invalid input, try again"
            self.select_activity
        end
    end

    def self.view_activities
        prompt = TTY::Prompt.new
        selection = prompt.select("How would you like to view activities?", %w(All By_Day By_Week By_Month By_Year By_Baby By_User))
        # conditionals dictating where to go.

        case selection 
        when "All"
            
        when "By_Day"
            
        when "By_Week"
            
        when "By_Month"
            
        when "By_Year"

        when "By_Baby"
        
        when "By_User"

        else

        end
    end

    
    


end
