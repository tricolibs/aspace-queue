require 'bunny'
require 'json'


# # this is the job call that is used by resque. 
# class CreateJob
#   # the name of the queue we want in Redis. This can be anything we want. 
#   @queue = :record_created

#   # this is called when the job is enqueue. you can do other fun stuff here, if you want
#   def self.perform
#     begin
#       $stderr.puts "PUTTING IT ON THE Q!"
#     rescue => e
#       $stderr.puts e.backtrace
#     end 
#   end

# end

# # this overrides our indexers
# class CommonIndexer

#   # we add a new hook when the indexeres are created
#   add_indexer_initialize_hook do |indexer|
#     # and we add a hook that happens when the record is being prepared for indexing
#     # record = the ASPACE record
#     # doc = the document being put to SOLR
#     indexer.add_document_prepare_hook {|doc, record|
#       Resque.enqueue(CreateJob, record)
#     }
#   end

# end

class Publish
  attr_accessor :conf, :conn, :ch, :queue
  
  def initialize 
    initialize_bunny
  end

  def initialize_bunny
    self.conn = Bunny.new(host: 'message.tricolib.brynmawr.edu', user: AppConfig[:message_user], pass: AppConfig[:message_password], vhost: AppConfig[:message_vhost])
    conn.start
    self.ch = conn.create_channel
    self.queue = ch.queue(AppConfig[:message_queue], durable: true)
  end

  def send_record(aspace_record)
    message = aspace_record.to_json
    queue.publish(message, persistent: true)
  end

end

# this overrides our indexers
class IndexerCommon
  # connect with message server
  messenger = Publish.new()
  # we add a new hook when the indexeres are created
  add_indexer_initialize_hook do |indexer|
    # and we add a hook that happens when the record is being prepared for indexing
    # record = the ASPACE record
    # doc = the document being put to SOLR
    indexer.add_document_prepare_hook {|doc, record|
      action = { action: "aspace_record_updated" }
      aspace_record = action.merge(record)
      messenger.send_record(aspace_record)
    }
    indexer.add_delete_hook { |doc, record|
      action = { action: "aspace_record_deleted" }
      aspace_record = action.merge(record)
      messenger.send_record(aspace_record)
    }
  end

end
