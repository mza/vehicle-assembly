module VehicleAssembly
  module Machinery
    class Database < VehicleAssembly::Machine
            
      def master_slave
        logger.debug "Master/slave config"
      end
      
      # Define the deployment task here
      def task
        describe_task "database" do
          run "bootstrap:cold"
        end
      end
            
    end
  end
end