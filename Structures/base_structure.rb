require 'securerandom'
require './Structures/Modules/base_commands'
require 'concurrent-ruby'
require './Infrastructure/Persistence/application_db_context'
require './Infrastructure/Queues/redis_client'

class BaseStructure
  include BaseCommands
  attr_reader :id, :structure_type, :input, :output, :accumulated, :rate, :thread, :commands
  @@created = 0
  
  def self.get_all
    @@created  
  end
  
  def initialize(type, input, output)
    @redis_client = CrateRedisClient::Queue.mining
    @id = SecureRandom.uuid
    @structure_type = type
    @input = input
    @output = output
    @accumulated = Concurrent::AtomicFixnum.new
    @rate = 1
    @thread = Thread.new { run } 
    @commands = {
      resource_increment: method(:resource_increment),
      increase_rate: method(:increase_rate)
    }
    @alive = true
    @@created += 1
    
    save_structure
  end
  
  def save_structure
    @redis_client.enqueue_operation(:insert_one, document: { index: @id})
  end
  
  def run
    while @alive 
      #puts "#{@id}: #{@accumulated.value}, there are #{@@created} created"
      #save the entity to the collection structures
      #ApplicationDbContext.instance.update_many("miners",{index: @id},{acc: @accumulated.value })

      @redis_client.enqueue_operation(:update_one, filter: {index: @id }, update:{ acc: @accumulated.value })
      @accumulated.increment(@rate)
      sleep(1)
    end
  end

  def command_list(cmd)
    cmd = @commands[cmd]
    if cmd.nil?
      puts "Invalid cmd"
    else
      cmd.call
    end
  end
  
  def resource_increment
    
  end
  
  def increase_rate
    
  end
end