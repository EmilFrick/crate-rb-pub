require 'singleton'
require 'redis'
require 'json'
require "./Infrastructure/Persistence/application_db_context"
require './Infrastructure/Queues/Modules/queue_input'
require './Infrastructure/Queues/Modules/queue_output'

class CrateRedisClient
  include Singleton
  attr_reader :client
  
  def initialize
    @client = Redis.new(host: '127.0.0.1', port: 6379)
  end
  
  class Queue
    include QueueInput
    include QueueOutput
    
    attr_reader :collection
    
    class << self
      def mining
        new("mining")
      end
    end
    
    def get_length
      @client.llen("db_operations_queue")
    end
    
    def empty
      @client.del("db_operations_queue")
    end
    private
    
    def initialize(collection)
      @collection = collection
      @client = CrateRedisClient.instance.client
    end
  end
end
# Step 0
# Add <Mongo::BulkWrite::Result:0x000001ff311fff90 @results={"n_inserted"=>5, "n"=>5, "inserted_ids"=>[BSON::ObjectId('66acfc43e09ff0ce4c35a7c0'), BSON::ObjectId('66acfc43e09ff0ce4c35a7c1'), BSON::ObjectId('66acfc43e09ff0ce4c35a7c2'), BSON::ObjectId('66acfc43e09ff0ce4c35a7c3'), BSON::ObjectId('66acfc43e09ff0ce4c35a7c4')]}>
# to collection reports in the end of the batch_processing

# Step 1
# try out the queue service with creating multiple miners

# Step 2
# create tests for this part of the application