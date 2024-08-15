# This is a commandQueue and has the ability to receive commands via the queue_command method 
module CommandQueue
  
  # The method used to receive commands
  def queue_command(cmd)
    @command_queue << cmd
    process_commands
  end

  #Fail safe and showing the developer that they haven't done the prerequisites to use this module.
  def process_commands
    raise NotOveriddenError
  end
end
