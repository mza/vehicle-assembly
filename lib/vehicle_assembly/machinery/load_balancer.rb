module VehicleAssembly
  module Machinery
    class LoadBalancer
      
      def use(type)
        puts "MACHINERY TYPE: #{self.class.to_s}: #{type}"
      end
      
      def redundant
        puts "Redundant balancer for fast failover"
      end
      
    end
  end
end