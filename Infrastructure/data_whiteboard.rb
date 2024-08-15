require './Infrastructure/Queues/redis_client'
require './Infrastructure/Persistence/application_db_context'
require './Infrastructure/Services/persistence_pipeline'
require './Structures/miner'
require './Infrastructure/Websocket/server'

# Register services that should work during the life time 
# Queue pipeline
PersistenceService.start_queue_service

# Websocket
WebsocketService.run_websocket


loop do
  Miner.new
  p BaseStructure.get_all
  sleep(1)
end

# PersistenceService.queue_test

#client.enqueue_operation(:insert_one,document: {index: 2, meow: 2000 })
#client.enqueue_operation(:insert_one,document: {index: 3, meow: 3000 })
#client.enqueue_operation(:insert_one,document: {index: 4, meow: 4000 })
#client.enqueue_operation(:insert_one,document: {index: 6, meow: 5000 })

#client.process_queue


#sleep(5)
