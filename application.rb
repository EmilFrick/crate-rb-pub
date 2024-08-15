require 'thread'
require './Structures/miner.rb'

class Application
  attr_accessor :running

  def initialize
    @services = { }
    @running = true
  end
  
  def start_service(name, service_class)
    command_queue = Queue.new
    service = service_class.new(name, command_queue)
    thread = Thread.new { service.start }
    @services[name] = { service: service, thread: thread, command_queue: command_queue }
  end
  
  def send_command(name, command)
    if @services.key?(name)
      @services[name][:command_queue] << command
    else
      puts "Service not found: #{name}"
    end
  end
end
