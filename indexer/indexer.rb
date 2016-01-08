require 'resque'


class CreateJob
  @queue = :record_created

  def self.perform
    begin
      $stderr.puts "PUTTING IT ON THE Q!"
    rescue => e
      $stderr.puts e.backtrace
    end 
  end

end


class CommonIndexer

  add_indexer_initialize_hook do |indexer|
    indexer.add_document_prepare_hook {|doc, record|
      $stderr.puts "*" * 100
      $stderr.puts record.inspect 
      $stderr.puts Resque.enqueue(CreateJob, record)
      $stderr.puts "*" * 100

    }
  end

end
