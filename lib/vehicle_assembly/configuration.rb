module VehicleAssembly
  class Configuration

    include VehicleAssembly::Machinery

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
    
    def database(&block)
      database = Database.new
      database.instance_eval(&block)
      self.vehicle.machinery << database
    end
  
  end
end