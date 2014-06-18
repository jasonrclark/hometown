require "hometown/creation_tracer"
require "hometown/disposal_tracer"
require "hometown/trace"
require "hometown/version"

module Hometown
  HOMETOWN_TRACE_ON_INSTANCE = :@__hometown_creation_backtrace

  @creation_tracer = Hometown::CreationTracer.new
  @disposal_tracer = Hometown::DisposalTracer.new

  def self.creation_tracer
    @creation_tracer
  end

  def self.disposal_tracer
    @disposal_tracer
  end

  def self.watch(clazz)
    @creation_tracer.patch(clazz)
  end

  def self.watch_for_disposal(clazz, disposal_method)
    @disposal_tracer.patch(clazz, disposal_method)
  end

  def self.for(instance)
    instance.instance_variable_get(HOMETOWN_TRACE_ON_INSTANCE)
  end

  def self.undisposed
    @disposal_tracer.undisposed()
  end
end
