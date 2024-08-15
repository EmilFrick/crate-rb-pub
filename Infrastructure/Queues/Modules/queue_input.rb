module QueueInput
  def enqueue_operation(operation, filter: nil, document: nil, update:nil)
    @client.lpush("db_operations_queue", {operation: operation, filter: filter, document:document, update:update}.to_json)
  end
end