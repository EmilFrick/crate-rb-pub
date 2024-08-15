require './Infrastructure/Queues/redis_client'
require './Infrastructure/Persistence/application_db_context'
require './Helpers/arr_helpers'

module PersistenceService
  @@store = []
  
  def self.start_queue_service
    ApplicationDbContext.instance.drop_collection("mining")
    mining_client = CrateRedisClient::Queue.mining
    mining_client.empty
    
    Thread.new do
      loop do
        operations = mining_client.process_queue

        partitioned_operations = ArrayHelpers.split_into_five_arrays(operations)
        ApplicationDbContext.instance.pooled_process_batch("mining", partitioned_operations)
        
        #if operations.count > 0
        time_start = Time.now 
        
        # ApplicationDbContext.instance.process_batch(mining_client.collection, operations)
        time_end = Time.now
        
        p "Bulk write operations took #{time_end - time_start} seconds." 
        
        #end
        sleep(1)
      end
    end
  end

  def self.start_queue_service_test_instance
    mining_client = CrateRedisClient::Queue.mining

    Thread.new do
      loop do
        operations = mining_client.get_operations_from_queue(50)
        @@store << operations

        p operations.count

        # store the operations
        sleep(1)
      end
    end
  end
  def self.queue_test
    mining_client = CrateRedisClient::Queue.mining
    count = 0
    
    while count < 200
      count += 1
      mining_client.enqueue_operation(:insert_one,document: {index: count })

      count += 1
      mining_client.enqueue_operation(:insert_one,document: {index: count })

      count += 1
      mining_client.enqueue_operation(:insert_one,document: {index: count })

      count += 1
      mining_client.enqueue_operation(:insert_one,document: {index: count })

      sleep(0.2)
    end


    values = []

    @@store.each do |col|
      col.each do |el|
        val = el["document"]["index"]
        values << val
      end
    end

    sleep(4)

    required_values = (1..190).to_a
    p values.sort & required_values
    p (values.sort & required_values) == required_values
  end
end