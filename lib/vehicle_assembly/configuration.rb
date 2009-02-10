module VehicleAssembly
  class Configuration

    attr_accessor :vehicle
                        
    def self.start_countdown_for(filename)
      config = self.new
      config.instance_eval(File.read(filename), filename)
      config
    end
    
    def initialize
      self.vehicle = VehicleAssembly::Vehicle.new
    end
    
    def load_balancer(&block)
      balancer = VehicleAssembly::Machinery::LoadBalancer.new
      balancer.instance_eval(&block)
      self.vehicle.machinery << balancer
    end
        
  end
end