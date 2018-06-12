require 'fluent/filter'

module Fluent
  class KubeletFilter < Filter
    Fluent::Plugin.register_filter('kubelet', self)
    def configure(conf)
      super
    end

    def start
      super
    end

    def shutdown
      super
    end
 	      
   def filter_stream(tag,es)
        new_es = MultiEventStream.new
        es.each{|time,record|
        begin
          new_record = record.clone
          message = new_record['MESSAGE']
          log_level = message.split(" ")[0]

          if(log_level =~ /^W/)
            new_record['severity']='warning'
            new_record['message']=message.split(" ").join(" ")
  			    result = new_record
              
          elsif(log_level =~ /^E/)
            new_record['severity']='error'
            new_record['message']=message.split(" ").join(" ")
			      result = new_record

		      else
            new_record["severity"]='info'
            new_record['message']=message.split(" ").join(" ")
            result = new_record

          end
          new_es.add(time,result)
        end
        }
        new_es
    end	
  end
end
