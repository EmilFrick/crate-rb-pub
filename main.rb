require './Structures/miner.rb'
require './Structures/structures_manager.rb'

#puts "Starting Main"


#app = Application.new
#controller = ApplicationController.new(app)

# Start the controller in a separate thread
#controller_thread = Thread.new do
#  puts "in the controller thread"
#  controller.run
#end

# Simulate sending commands from another thread
#Thread.new do
#  sleep(10)
#  app.send_command('Miner1', :calculate_resources)
#end

#Thread.new do
#  sleep(2)
#  app.send_command('Miner2', :increase_rate)
#  sleep(3)
#  app.send_command('Miner2', :increase_rate)
#  sleep(3)
#  app.send_command('Miner2', :increase_rate)
#  sleep(3)
#end
#puts "Starting Miner1 service"
#app.start_service('Miner1', Miner)

#app.start_service('Miner2', Miner)

# Wait for the controller thread to finish
#controller_thread.join

#puts "Main script finished"

miner = Miner.new