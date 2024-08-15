class ApplicationController
  def initialize(application)
    @application = application
  end

  def run
    while true
      puts "Enter command: <controller> <action> <service>"
      input = gets.chomp
      controller, action, name = input.split

      case controller
      when 'miner'
        handle_miner_command(action, name)
      when 'exit'
        @application.stop_all_services
        break
      else
        puts "Unknown controller"
      end

      sleep(1)
    end
  end
  
  def handle_miner_command(action, name)
    case action
    when 'start'
      @application.start_service(name, Miner)
    when 'stop'
      @application.stop_service(name)
    when 'increase_rate'
      @application.send_command(name, :increase_rate)
    when 'add_entry'
      @application.send_command(name, :add_entry)
    when 'calculate_resources'
      @application.send_command(name, :calculate_resources)
    else
      puts "Unknown action for miner"
    end
  end
end
