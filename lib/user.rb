class User < ActiveRecord::Base
    has_many :baby_users
    has_many :babies, through: :baby_users

    attr_accessor :current_user, :selected_baby, :today, :todays_month, :todays_year

    @todays_day = Time.now.day
    @todays_month = Time.now.month 
    @todays_year = Time.now.year

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

    # def add_baby_to_another_user
    #     select_baby
    #     add_nanny create_or_findby
    #     shovel baby << user 
    # end

    def select_baby
        prompt = TTY::Prompt.new
        baby = self.babies
      menu = baby.map do |babe|
                    babe.name
                end
                puts " "
        answer = prompt.select("Select a baby", menu, %w(back))
        if answer == "back"
            main_menu
        end
        answer

    end

    def self.babies
        prompt = TTY::Prompt.new
        answer = prompt.select("Choose one:", %w(View/Edit_Baby New_Baby Back))
        if answer == "View/Edit_Baby"
            @current_user.reload
            # binding.pry
            # puts @current_user.babies.first
            if !@current_user.babies.empty?
                system 'clear'
                tp @current_user.babies, :name, :birth_date, :sex
                # tp @current_user.babies

                if @current_user.babies.count == 1 
                    @selected_baby = @current_user.babies.name
                else
                    baby_selection = @current_user.select_baby
                    puts "Selected #{baby_selection}."
                    puts "Please choose one of the following:"
                    @selected_baby = Baby.find_by(name: baby_selection)
                end
                
                answer = prompt.select("", %w(Edit Remove Main_Menu Exit))

                case answer 
                when "Edit"
                    answer = prompt.select("", %w(Edit_Name Edit_BirthDate Edit_Sex Main_Menu))
                    system 'clear'
                    case answer
                    when "Edit_Name"
                        puts "Current Name: #{@selected_baby.name}"
                        answer = prompt.ask("New Name:")
                        puts "Changed name to #{answer}"
                        baby_to_update_name = Baby.find_by(name: @selected_baby.name)
                        baby_to_update_name.name = answer
                        baby_to_update_name.save
                        @current_user.reload
                    when "Edit_BirthDate"
                        puts "Current Birthdate: #{@selected_baby.birth_date}"
                        answer = prompt.ask("New Birthday? YYYYMMDD:")
                        puts "Changed birthday to #{answer}"
                        baby_to_update_bday = Baby.find_by(name: @selected_baby.name)
                        baby_to_update_bday.birth_date = answer
                        baby_to_update_bday.save
                        @current_user.reload
                    when "Edit_Sex"
                        puts "Current Sex: #{@selected_baby.sex}"
                        answer = prompt.ask("New Sex:")
                        puts "Changed sex to #{answer}"
                        baby_to_update_sex = Baby.find_by(name: @selected_baby.name)
                        baby_to_update_sex.sex = answer
                        baby_to_update_sex.save
                        @current_user.reload
                    when "Main_Menu"
                        main_menu 
                    else
                        exit
                    end
                when "Remove"
                    puts "Removed #{@selected_baby.name}."
                    @selected_baby.destroy
                when "Main_Menu"
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
            puts "What was the baby's birthdate? (YYYYMMDD)"
            birth_date = gets.chomp
            puts "What is the baby's sex?"
            sex = gets.chomp
            babe = Baby.create(name: new_baby, birth_date: birth_date, sex: sex)
            @current_user.babies << babe
            # new_baby_user = BabyUser.create(user_id: @current_user.id, baby_id: babe.id)
            puts "Your new baby is: name: #{babe.name}, birth date: #{babe.birth_date}, sex: #{babe.sex}"
            babies
        else 
            system 'clear'
            main_menu
        end
    end

    def self.activity_menu
        prompt = TTY::Prompt.new
        selection = prompt.select("Select one:", %w(Add_Activity Edit_Activity Delete_Activity back))
# binding.pry
        case selection
        when "Add_Activity"
            User.add_activity
        when "Edit_Activity"
            User.edit_activity
        when "Delete_Activity"
            User.delete_activity
        when "back"
            main_menu
        end
    end

    def self.delete_activity
        prompt = TTY::Prompt.new
        selected_activity = User.select_activity
        selected_activity = selected_activity.split(":").last.to_i
        @selected_activity = Activity.find_by(id:selected_activity)
        @selected_activity.destroy
        puts "Removed #{@selected_activity.name}."
        self.activity_menu
    end

    def self.select_activity
        prompt = TTY::Prompt.new
        baby_selection = @current_user.select_baby
        @selected_baby = Baby.find_by(name: baby_selection)
        # binding.pry
        activity = @selected_baby.activities
        menu = activity.map do |act|
            "type: #{act.name}, start_time: #{act.start_time}, notes: #{act.notes}, id:#{act.id}"
        end
        puts " "
        answer = prompt.select("Select an activity", menu, %w(back))
        if answer == "back"
            main_menu
        end
        answer

    end

    def self.edit_activity
        prompt = TTY::Prompt.new
        selected_activity = User.select_activity
        selected_activity = selected_activity.split(":").last.to_i
        @selected_activity = Activity.find_by(id:selected_activity)
        # binding.pry
        menu = @selected_activity.attributes.keys
        answer = prompt.select("Which field would you like edit?", menu)
        case answer
        when "id"
           puts "I'm sorry, you can't change the baby's id"
           self.edit_activity
        when "name"
            # binding.pry

            puts "Current name: #{@selected_activity.name}"
            answer = prompt.ask("New Name:")
            puts "Changed activity name to #{answer}"
            @selected_activity.name = answer
            @selected_activity.save
            @selected_activity.reload
            p @selected_activity
            @current_user.reload
            self.activity_menu
        when "start_time"
            puts "Current start time: #{@selected_activity.start_time}"
            answer = prompt.ask("New start time:")
            @selected_activity.start_time = answer
            @selected_activity.save
            @selected_activity.reload
            puts "Changed activity start time to #{answer}"
            p @selected_activity
            @current_user.reload
            self.activity_menu
        when "end_time"
            puts "Current end time: #{@selected_activity.end_time}"
            answer = prompt.ask("New end time:")
            @selected_activity.end_time = answer
            @selected_activity.save
            @selected_activity.reload
            puts "Changed activity end time to #{answer}"
            p @selected_activity
            @current_user.reload
            self.activity_menu
        when "diaper_status"
            puts "Current diaper status: #{@selected_activity.diaper_status}"
            answer = prompt.ask("New diaper status:")
            @selected_activity.diaper_status = answer
            @selected_activity.save
            @selected_activity.reload
            puts "Changed activity diaper status to #{answer}"
            p @selected_activity
            @current_user.reload
            self.activity_menu
        when "amount"
            puts "Current amount: #{@selected_activity.amount}"
            answer = prompt.ask("New amount:")
            @selected_activity.amount = answer
            @selected_activity.save
            @selected_activity.reload
            puts "Changed activity amount to #{answer}"
            p @selected_activity
            @current_user.reload
            self.activity_menu
        when "duration"
            puts "Current duration: #{@selected_activity.duration}"
            answer = prompt.ask("New duration:")
            @selected_activity.duration = answer
            @selected_activity.save
            @selected_activity.reload
            puts "Changed activity duration to #{answer}"
            p @selected_activity
            @current_user.reload
            self.activity_menu
        when "notes"
            puts "Current notes: #{@selected_activity.notes}"
            answer = prompt.ask("New notes:")
            @selected_activity.notes = answer
            @selected_activity.save
            @selected_activity.reload
            puts "Changed activity notes to #{answer}"
            p @selected_activity
            @current_user.reload
            self.activity_menu
        when "baby_id"
            puts "I'm sorry you can't change the baby's id"
            self.activity_menu
        end
    end

    def is_it_date_time?(time)
        begin
            DateTime.strptime(time,'%d-%m-%Y %I:%M:%S %p')
        rescue ArgumentError
           puts "Entry invalid. Please enter valid datetime DD-MM-YYYY HH:MM:SS AM/PM"
        end
    end

    def self.add_activity
        # binding.pry
        prompt = TTY::Prompt.new

        baby = @current_user.select_baby
        # binding.pry
        baby_object = Baby.find_by(name: baby)
        puts "You have selected #{baby_object.name}"
        activity = prompt.select("Please select an activity", %w(Feeding Sleep Diaper_change Bath Main_Menu))
        #icebox - write each of this in its own method
        if activity == "Feeding"
            puts "Time of feeding? (DD-MM-YYYY HH:MM:SS AM/PM)"
            start_time = nil
            while start_time == nil
                start_time = gets.chomp
                start_time = @current_user.is_it_date_time?(start_time)
            end
            puts "What was the amount?"
            amount = gets.chomp
            puts "any notes?"
            notes = gets.chomp
            new_feeding = Activity.create(name: activity, start_time: start_time, amount: amount, notes: notes)
            baby_object.activities << new_feeding
            puts "For #{baby_object.name}, you added the activity: #{new_feeding.name}, time: #{new_feeding.start_time}, amount: #{new_feeding.amount}, notes: #{new_feeding.notes}"
            # puts new_feeding
            # puts baby_object.activities
            main_menu

        elsif activity == "Sleep"

            puts "What time did the baby go to sleep? (DD-MM-YYYY HH:MM:SS AM/PM)"
            start_time = nil
            while start_time == nil
                start_time = gets.chomp
                start_time = @current_user.is_it_date_time?(start_time)
            end
            puts "What time did the baby wake up? (DD-MM-YYYY HH:MM:SS AM/PM)"
            end_time = nil
            while end_time == nil
                end_time = gets.chomp
                end_time = @current_user.is_it_date_time?(end_time)
            end
            puts "any notes?"
            notes = gets.chomp
            new_sleep = Activity.create(name: activity, start_time: start_time, end_time: end_time, notes: notes)
            # binding.pry
            baby_object.activities << new_sleep
            puts "For #{baby_object.name}, you added the activity: #{new_sleep.name}, start time: #{new_sleep.start_time}, end time: #{new_sleep.end_time}, notes: #{new_sleep.notes}"
            # puts new_sleep
            # puts baby_object.activities
            main_menu

        elsif activity == "Diaper_change"

            puts "What time did you change the diaper? (DD-MM-YYYY HH:MM:SS AM/PM)"
            start_time = nil
            while start_time == nil
                start_time = gets.chomp
                start_time = @current_user.is_it_date_time?(start_time)
            end
            puts "How was the baby's diaper?"
            diaper_status = gets.chomp
            puts "any notes?"
            notes = gets.chomp
            new_diaper = Activity.create(name: activity, start_time: start_time, diaper_status: diaper_status, notes: notes)
            # binding.pry
            baby_object.activities << new_diaper
            puts "For #{baby_object.name}, you added the activity: #{new_diaper.name}, start time: #{new_diaper.start_time}, diaper status: #{new_diaper.diaper_status}, notes: #{new_diaper.notes}"
            # puts new_diaper
            # puts baby_object.activities
            main_menu

        elsif activity == "Bath"

            puts "What time was the bath? (DD-MM-YYYY HH:MM:SS AM/PM)"
            start_time = nil
            while start_time == nil
                start_time = gets.chomp
                start_time = @current_user.is_it_date_time?(start_time)
            end
            puts "How long was the bath?"
            duration = gets.chomp
            puts "any notes?"
            notes = gets.chomp
            new_bath = Activity.create(name: activity, start_time: start_time, duration: duration, notes: notes)
            # binding.pry
            baby_object.activities << new_bath
            puts "For #{baby_object.name}, you added the activity: #{new_bath.name}, start time: #{new_bath.start_time}, duration: #{new_bath.duration} notes: #{new_bath.notes}"
            # puts new_bath
            # puts baby_object.activities
            main_menu
        elsif activity == "Main_Menu"
            main_menu
        else
            "invalid input, try again"
            self.select_activity
        end
    end

    def test_method
        @selected_baby.activities.select do |activity|
            activity.start_time != nil && activity.start_time.day == 2
        end
    end

    def self.view_activities
        prompt = TTY::Prompt.new

        if @current_user.babies.count == 1 
            @selected_baby = @current_user.babies.first
            selection = prompt.select("How would you like to view activities?", %w[All For_Today 7_day By_Month By_Year By_Baby By_User Back])

        else
            baby_selection = @current_user.select_baby
            puts "Selected #{baby_selection}."
            @selected_baby = Baby.find_by(name: baby_selection)
            selection = prompt.select("How would you like to view activities?", %w[All For_Today 7_day By_Month By_Year By_Baby By_User Back])
        end
        
        puts "Actitivies for #{@selected_baby.name}"
        
        # baby_selection = @current_user.select_baby
        # @selected_baby = Baby.find_by(name: baby_selection)
        # selection = prompt.select("How would you like to view activities?", %w[All Today By_Week By_Month By_Year By_Baby By_User Back])
        # conditionals dictating where to go.
        case selection 
        when "All"
            puts " "
        tp all_activities = Activity.all.where(baby_id: @selected_baby.id), :start_time, :end_time, :name, :diaper_status, :notes
        
        User.view_activities

        when "For_Today"
            # binding.pry
            
            a = @selected_baby.activities.select do |activity|
                activity.start_time != nil && activity.start_time.day == @todays_day && activity.start_time.month == @todays_month && activity.start_time.year == @todays_year
            end

            tp a, :start_time, :end_time, :name, :diaper_status, :notes
            User.view_activities
            
        when "7_day"
            a = @selected_baby.activities.select do |activity|
                activity.start_time != nil && activity.start_time.day == @todays_day && activity.start_time.month == @todays_month && activity.start_time.year == @todays_year
            end

            b = @selected_baby.activities.select do |activity|
                activity.start_time != nil && activity.start_time.day == @todays_day - 1 && activity.start_time.month == @todays_month && activity.start_time.year == @todays_year
            end

            c = @selected_baby.activities.select do |activity|
                activity.start_time != nil && activity.start_time.day == @todays_day - 2 && activity.start_time.month == @todays_month && activity.start_time.year == @todays_year
            end

            d = @selected_baby.activities.select do |activity|
                activity.start_time != nil && activity.start_time.day == @todays_day - 3 && activity.start_time.month == @todays_month && activity.start_time.year == @todays_year
            end

            e = @selected_baby.activities.select do |activity|
                activity.start_time != nil && activity.start_time.day == @todays_day - 4 && activity.start_time.month == @todays_month && activity.start_time.year == @todays_year
            end
            f = @selected_baby.activities.select do |activity|
                activity.start_time != nil && activity.start_time.day == @todays_day - 5 && activity.start_time.month == @todays_month && activity.start_time.year == @todays_year
            end
            g = @selected_baby.activities.select do |activity|
                activity.start_time != nil && activity.start_time.day == @todays_day - 6 && activity.start_time.month == @todays_month && activity.start_time.year == @todays_year
            end

            tp a, :start_time, :end_time, :name, :diaper_status, :notes
            puts " "
            tp b, :start_time, :end_time, :name, :diaper_status, :notes
            puts " "
            tp c, :start_time, :end_time, :name, :diaper_status, :notes
            puts " "
            tp d, :start_time, :end_time, :name, :diaper_status, :notes
            puts " "
            tp e, :start_time, :end_time, :name, :diaper_status, :notes
            puts " "
            tp f, :start_time, :end_time, :name, :diaper_status, :notes
            puts " "
            tp g, :start_time, :end_time, :name, :diaper_status, :notes
            User.view_activities
            
        when "By_Month"
            
        when "By_Year"

        when "By_Baby"
        
        when "By_User"
            # @current_user.babies.select #for each baby return all activities
        #when 
        #add by type of activity
        when "Back"
            main_menu
        else
            exit
        end
    end

    

end
