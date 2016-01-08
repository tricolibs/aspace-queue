require 'resque'


# this is the job call that is used by resque. 
class CreateJob
  # the name of the queue we want in Redis. This can be anything we want. 
  @queue = :record_created

  # this is called when the job is enqueue. you can do other fun stuff here, if you want
  def self.perform
    begin
      $stderr.puts "PUTTING IT ON THE Q!"
    rescue => e
      $stderr.puts e.backtrace
    end 
  end

end

# this overrides our indexers
class CommonIndexer

  # we add a new hook when the indexeres are created
  add_indexer_initialize_hook do |indexer|
    # and we add a hook that happens when the record is being prepared for indexing
    # record = the ASPACE record
    # doc = the document being put to SOLR
    indexer.add_document_prepare_hook {|doc, record|
      Resque.enqueue(CreateJob, record)
    }
  end

end
