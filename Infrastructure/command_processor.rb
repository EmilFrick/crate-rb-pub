require_relative 'command_queue'

# This is a CommandProcessor
module CommandProcessor
  include CommandQueue
  
  #This is the main method that runs all of the queued commands 
  def process_commands
    return if @running 
    @running = true
    until @command_queue.empty?
      cmd = @command_queue.pop
      command_list(cmd)
    end
    @running = false
  end
  
  #Fail safe and showing the developer that they haven't done the prerequisites to use this module.
  def command_list(cmd)
    raise NotImplementedError(Module.nesting[0].name, self.class.name, __method__)
  end
end