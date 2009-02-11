module VehicleAssembly
  class Vehicle
    
    attr_accessor :machinery, :name
    
    alias :machines :machinery
    
    def initialize
      self.machinery = []
    end
        
  end
end