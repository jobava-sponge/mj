require 'mongo'

module Helpers
  class Database  
    def connect
      db = Mongo::Connection.new('localhost', 27017).db('hackathon')
      return db
    end
  end
end
