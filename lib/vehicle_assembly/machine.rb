module VehicleAssembly
  class Machine

    def use(type)
      puts "MACHINERY TYPE: #{self.class.to_s}: #{type}"
    end
    
    def task
      nil
    end
    
    def task_name
      "MACHINE"
    end
    
  end
end
