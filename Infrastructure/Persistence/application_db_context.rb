require 'singleton'
require 'mongo'
require 'json'
require 'concurrent'

# ApplicationDbContext is a singleton class that manages the MongoDB connection and provides methods to interact with the database.
#
# @example Inserting a document
#   obj = { index: 1, description: "init" }
#   ApplicationDbContext.instance.insert_one("collection", obj)
#
# @example Updating multiple documents
#   filter = { index: 1 }
#   update = { description: "updated value", status: "active" }
#   ApplicationDbContext.instance.update_many("collection", filter, update)
#
# @example Deleting a document
#   filter = { index: 1 }
#   ApplicationDbContext.instance.delete_one("collection", filter)
#
# @example Dropping a collection
#   ApplicationDbContext.instance.drop_collection("collection")
#
# @example Outputting all documents in a collection
#   ApplicationDbContext.instance.output_collection("collection")
class ApplicationDbContext
  include Singleton
  
  def initialize
    connection = "mongodb://localhost:C2y6yDjf5%2FR%2Bob0N8A7Cgv30VRDJIWEHLM%2B4QDU5DE2nQ9nDuVTqobD4b8mGGyPMbIZnqyMsEcaGQy67XIw%2FJw%3D%3D@localhost:10255/admin?ssl=true"

    # Client options for SSL connection
    ssl_options = {
      ssl_verify: false,
      max_pool_size: 50
    }
    @client = Mongo::Client.new(connection, ssl_options)
    @context = @client.database
  end
  
  # Inserts a single document into the specified collection.
  #
  # @param collection [String] the name of the collection
  # @param obj [Hash] the document to insert
  #
  # @example
  #   obj = { index: 1, description: "init" }
  #   ApplicationDbContext.instance.insert_one("collection", obj)
  def insert_one(collection, obj)
    @context[collection].insert_one(obj)
  end
  
  def update_one(collection, filter, update)
    @context[collection].update_one(filter, update)
  end
  
  # Updates multiple documents in the specified collection based on a filter.
  #
  # @param collection [String] the name of the collection
  # @param filter [Hash] the filter criteria for selecting documents to update
  # @param update [Hash] the update operations to apply to the selected documents
  #
  # @example
  #   filter = { index: 1 }
  #   update = { description: "updated value", status: "active" }
  #   ApplicationDbContext.instance.update_many("collection", filter, update)
  def update_many(collection, filter, update)
    @context[collection].update_many(filter, collection_set(update))
  end

  # Deletes a single document from the specified collection based on a filter.
  #
  # @param collection [String] the name of the collection
  # @param filter [Hash] the filter criteria for selecting the document to delete
  #
  # @example
  #   filter = { index: 1 }
  #   ApplicationDbContext.instance.delete_one("collection", filter)
  def delete_one(collection, filter)
    @context[collection].delete_one(filter)
  end

  # Drops the specified collection from the database.
  #
  # @param collection [String] the name of the collection to drop
  #
  # @example
  #   ApplicationDbContext.instance.drop_collection("collection")
  def drop_collection(collection)
    @context[collection].drop
  end

  # Outputs all documents in the specified collection to the console.
  #
  # @param collection [String] the name of the collection
  #
  # @example
  #   ApplicationDbContext.instance.output_collection("collection")
  def output_collection(collection)
    documents = []
    @context[collection].find.each do |doc|
      documents << doc
      puts JSON.pretty_generate(doc)
    end
    documents
  end
  
  def get_all_as_json(collection)
    @context[collection].find.map { |doc| doc.to_json }
  end

  def process_batch(collection, batch)
    result = @context[collection].bulk_write(batch)
    # result = map_result(result)
    #@context["reports"].insert_one(result)
  end
  
  def pooled_process_batch(collection, partitioned_batches)
    partitioned_batches
    
    pool = Concurrent::FixedThreadPool.new(10)

    partitioned_batches.each do |bulk_operations|
      pool.post do
        process_batch(collection, bulk_operations)
      end
    end

    #pool.shutdown
    #pool.wait_for_termination
  end
  
  def map_result(results)
    { inserted_count: results.inserted_count,
      upserted_count: results.upserted_count,
      deleted_count: results.deleted_count,
      inserted_ids: results.inserted_ids,  
      upserted_ids: results.upserted_ids,
    }
  end
  
  private
  
  # Helper method to create a MongoDB update operation with the $set operator.
  #
  # @param values [Hash] the values to set in the update operation
  #
  # @return [Hash] the update operation
  #
  # @example
  #   update = { description: "updated value", status: "active" }
  #   ApplicationDbContext.instance.collection_set(update)
  #   # => { "$set" => { "description" => "updated value", "status" => "active" } }
  def collection_set(values)
    { "$set" => values }
  end
end

#ApplicationDbContext.instance.drop_collection("mining")
#p ApplicationDbContext.instance.output_collection("reports")