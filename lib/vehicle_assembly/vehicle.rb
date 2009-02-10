module VehicleAssembly
  class Vehicle
    
    attr_accessor :machinery
            
    def initialize
      self.machinery = []
    end
    
    def launch
      puts "LAUNCHING with #{self.machinery.size} machines"
    end
    
  end
end