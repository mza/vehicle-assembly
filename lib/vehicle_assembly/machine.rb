module VehicleAssembly
  class Machine

    attr_accessor :task_name, :task, :logger

    def initialize
      self.task_name = "Task for #{self.class}"
      self.logger = Logger.new STDOUT
      self.logger.level = Logger::DEBUG
    end

    def use(type)
      logger.debug "MACHINERY TYPE: #{self.class.to_s}: #{type}"
    end
        
     def describe_task(name, &block)
       self.task_name = name
       self.task = block
     end
        
  end
end
