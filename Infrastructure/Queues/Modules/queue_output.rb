require "./Infrastructure/Persistence/application_db_context"

module QueueOutput
  def get_operations_from_queue(max_operations = 10)
    operations = []
    time_start = Time.now
    
    results = @client.pipelined do |pipeline|
      max_operations.times do
        pipeline.rpop("db_operations_queue")
      end
    end
    
    results.each do |operation|
      break if operation.nil? 
      operations << JSON.parse(operation)
    end
    
    time_end = Time.now
    
    p "Get operations from queue took #{time_end - time_start} seconds. There are #{@client.llen("db_operations_queue")} left in the queue"
    operations
  end

  def process_queue
    operations = get_operations_from_queue(200)

    batch = []
    operations.each do |operation|
      batch << map_bulk_operation(operation)
    end

    batch 
  end


  def map_bulk_operation(msg)
    request_templates = {
      "insert_one" =>  {insert_one: msg["document"] },
      "update_one" => {update_one: { filter: msg["filter"], update: map_update(msg["update"] )}},
      "delete_one" => {delete_one: { filter: msg["filter"] }}
    }
    
    request_templates[msg["operation"]]
  end
  
  def map_update(values)
    { "$set" => values }
  end
end
