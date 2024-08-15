require 'mongo'
require 'json'
require './Infrastructure/Persistence/application_db_context'

ApplicationDbContext.instance.drop_collection("miners")