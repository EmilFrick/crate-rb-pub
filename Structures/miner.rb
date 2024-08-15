require './Infrastructure/command_processor'
require './Structures/base_structure'

class Miner < BaseStructure 
  include CommandProcessor
  def initialize
    super("type", "input", "output")
    @command_queue = Queue.new
    @running = false
  end
end