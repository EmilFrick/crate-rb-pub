# mongo_operations.rb
require 'mongo'
require 'openssl'

module MongoOperations
  attr_accessor :client, :collection

  def connect(connection_string, ssl_cert_path)
    ssl_options = {
      ssl_cert: ssl_cert_path,
      ssl_verify: false # Disable SSL verification for the emulator
    }
    @client = Mongo::Client.new(connection_string, ssl: ssl_options)
  end

  def set_collection(collection_name)
    @collection = @client[collection_name]
  end

  def insert_document(document)
    result = @collection.insert_one(document)
    puts "[Thread #{Thread.current.object_id}] Inserted document: #{document}"
    result.inserted_id
  end

  def update_document(filter, update)
    result = @collection.update_one(filter, update)
    puts "[Thread #{Thread.current.object_id}] Updated document: #{result.modified_count}"
  end

  def list_documents(filter = {})
    @collection.find(filter).to_a
  end

  def watch_changes
    @collection.watch.each do |change|
      puts "Change detected: #{change.inspect}"
    end
  end
end
