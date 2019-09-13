require_relative '../config/environment'

font = TTY::Font.new(:doom)
pastel = Pastel.new
system 'clear'
puts pastel.red(font.write("         BOBI            "))
puts pastel.red(font.write("The     Baby    Activity"))
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

def resources #icebox feature
    #growth measurements
    puts 'selected resources'
end

def logout
    #goes bag to login
    @current_user = nil
    login
end

def exit_app
    #exits CLI
    exit
end

def main_menu
    puts " "
    prompt = TTY::Prompt.new
    
    menu = %w(Babies Activity_Menu View_Activities Resources Log_Out Exit)

    selection = prompt.select("You are at the main menu. Please select an option:", menu)
    # conditionals dictating where to go.

    case selection 
    when "Babies"
        User.babies
    when "Activity_Menu"
        User.activity_menu
    when "View_Activities"
        User.view_activities
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
User.login

# if login == true
#     main_menu
# else
#     login
# end
# exit