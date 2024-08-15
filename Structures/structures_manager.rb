require 'concurrent-ruby'
require 'singleton'
require './Structures/miner'

#This holds every structure in the application
class StructuresManager
  include Singleton

  def initialize
    @structures = Concurrent::Hash.new
  end

  def register(obj_id, object)
    @structures[obj_id] = object
  end
  
  def list_structures
    @structures.each do |key, value|
      puts "#{key} : #{value}"
    end
  end
  
  def command_broker(id, command)
    @structures[id].command_list(command)
  end
end