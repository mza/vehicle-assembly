module VehicleAssembly
  module Machinery
    class ElasticCluster < VehicleAssembly::Machine

      def nodes(count)
        logger.debug "Elastic cluster with #{count} nodes"
      end
            
      def monitor(options)
        logger.debug "Monitoring with: #{options[:with]}"
      end
      
      # Define the deployment task here
      def task
      end
            
    end
  end
end