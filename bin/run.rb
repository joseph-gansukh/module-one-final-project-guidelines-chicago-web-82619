require_relative '../config/environment'

font = TTY::Font.new(:doom)
pastel = Pastel.new
puts pastel.red(font.write("Baby    Activity"))
puts pastel.red(font.write("                  Tracker"))

def welcome
    spinner = TTY::Spinner.new("Loading App :spinner ... ", format: :spin_2)
    8.times do
    spinner.spin
    sleep(0.1)
    end
    spinner.stop('done loading.')
    puts " "
    puts "Welcome to the Baby Activity Tracker"
    puts " "
end

def login
    prompt = TTY::Prompt.new
    answer = prompt.select("Login as:", %w(Existing_User New_User))
    if answer == "Existing_User"
        username = prompt.ask('Please enter your username:')
        
        puts " "
        
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
        #create new user
        # puts "Please fill out the following to create new user:"
        # new_user = prompt.collect do
        #     key(:name).ask('Name?')
        #     key(:username).ask('Username?')
        # end

        # # Baby.create(name: "#{new_user[:baby_name]}")
        create_user

        puts ""

        spinner = TTY::Spinner.new("Registering new user :spinner ... ", format: :spin_2)
        7.times do
        spinner.spin
        sleep(0.1)
        end
        spinner.stop('Registered successfully')

        puts " "
        
        puts "Logged in as #{new_user[:name].upcase}"

        puts " "

        main_menu
    end    
end

def babies
    prompt = TTY::Prompt.new
    answer = prompt.select("Choose one:", %w(View_Baby New_Baby Delete_Baby))
    if answer == "View_Baby"
        self.babies
    elsif answer == "New_Baby"
        puts "What is the name of the baby?"
        new_baby = gets.chomp
        puts "What was the baby's birthdate? (YYYYMMDD HH:SS)"
        birth_date = gets.chomp
        puts "What is the baby's sex?"
        sex = gets.chomp
        babe = Baby.create(name: new_baby, birth_date: birth_date, sex: sex)
        puts "Your new baby is: name: #{babe.name}, birth date: #{babe.birth_date}, sex: #{babe.sex}"
        
        babies
    elsif answer == "Delete_Baby"
        p delete baby
    end

end

def log_activity
    prompt = TTY::Prompt.new
    prompt.select("Choose one:", %w(Choose_Baby Choose_Activity))
    #which baby is it?
    #what type of activity?
    #for activity, add info?
    #icebox: edit info? delete activity, etc
end

def view_activities
    prompt = TTY::Prompt.new
    prompt.select("View Activities:", %w(For_Today Past_7_day Past_30_day By_Type All_Activities By_User By_Baby))
    #how do you want to view your activites
        #by day
        #by week
        #by month
        #by type
        #by all
        #icebox by user
        #by baby
end

def resources #icebox feature
    #growth measurements
    puts 'selected resources'
end

def logout
    #goes bag to login
    login
end

def exit_app
    #exits CLI
    exit
end

def main_menu
    puts " "
    prompt = TTY::Prompt.new
    selection = prompt.select("You are at the main menu. Please select an option:", %w(Babies Log_Activity View_Activities Resources Log_Out Exit))
    # conditionals dictating where to go.

    case selection 
    when "Babies"
        babies
    when "Log_Activity"
        log_activity
    when "View_Activities"
        view_activities
    when "Resources"
        resources
    when "Log_Out"
        puts "Logged out"
        logout
    when "Exit"
        puts "Thank you for using Baby Activity Tracker. Bye for now!"
        exit
    else
        main_menu
    end
end 

welcome
login
# if login == true
#     main_menu
# else
#     login
# end
# exit