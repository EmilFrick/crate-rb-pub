module BaseCommands
  def self.base_commands
    cmds = {
      resource_increment: method(:resource_increment),
      increase_rate: method(:increase_rate)
    }
  end

  
end
