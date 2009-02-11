module VehicleAssembly
  module Machinery
    class LoadBalancer < VehicleAssembly::Machine
      
      def use(type)
        logger.debug "MACHINERY TYPE: #{self.class.to_s}: #{type}"
      end
      
      def redundant
        logger.debug "Redundant balancer for fast failover"
      end
      
    end
  end
end