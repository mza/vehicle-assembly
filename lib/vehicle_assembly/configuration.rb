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
        
    def method_missing(method_name, *args, &block)
      class_name = "VehicleAssembly::Machinery::#{method_name.to_s.camelize}"
      logger.debug "Setting up #{class_name}"
      machinery = class_name.constantize.new
      machinery.instance_eval(&block)
      vehicle.machinery << machinery
    end
  
  end
end