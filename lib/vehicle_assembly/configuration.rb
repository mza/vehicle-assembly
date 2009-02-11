module VehicleAssembly
  class Configuration

    include VehicleAssembly::Machinery

    attr_accessor :vehicle, :logger
                        
    def self.start_countdown_for(filename)
      config = self.new
      config.instance_eval(File.read(filename), filename)
      config
    end
    
    def initialize
      self.vehicle = VehicleAssembly::Vehicle.new
      self.logger = Logger.new STDOUT
    end
    
    def infrastructure(options, &block)
      logger.debug "Preparing for: #{options[:for]}"
      vehicle.name = options[:for]
      self.instance_eval(&block)
    end
    
    def load_balancer(&block)
      balancer = VehicleAssembly::Machinery::LoadBalancer.new
      balancer.instance_eval(&block)
      vehicle.machinery << balancer
    end
    
    def database(&block)
      database = Database.new
      database.instance_eval(&block)
      vehicle.machinery << database
    end
  
  end
end