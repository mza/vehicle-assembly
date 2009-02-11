module VehicleAssembly
  module Machinery
    class Database < VehicleAssembly::Machine
            
      def master_slave
        puts "Master/slave config"
      end
      
      def task
        Proc.new do
          run "bootstrap:cold"
        end
      end
      
      def task_name
        "database"
      end
      
    end
  end
end