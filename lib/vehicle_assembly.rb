prefix = "#{File.dirname(__FILE__)}"

require "#{prefix}/vehicle_assembly/machine"
require "#{prefix}/vehicle_assembly/machinery"

# Load all Machinery
Dir.new("#{prefix}/vehicle_assembly/machinery/").entries.select { |f| ![ ".", ".." ].include? f }.each do |file|
  require "#{prefix}/vehicle_assembly/machinery/#{file}"
end

require "#{prefix}/vehicle_assembly/parser"
require "#{prefix}/vehicle_assembly/task"
require "#{prefix}/vehicle_assembly/configuration"
require "#{prefix}/vehicle_assembly/vehicle"