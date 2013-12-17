module AbstractInterface

  class InterfaceNotImplementedError < NoMethodError
  end
  # include and extend module on every class inherit from the interface
  def self.included(klass)
    klass.send(:include, AbstractInterface::Methods)
    klass.send(:extend, AbstractInterface::Methods)
    klass.send(:extend, AbstractInterface::ClassMethods)
  end

  module Methods
    # raise error if method not implemented
    def api_not_implemented(klass, method_name = nil)
      if method_name.nil?
        caller.first.match(/in \`(.+)\'/)
        method_name = $1
      end
      raise AbstractInterface::InterfaceNotImplementedError.new("#{klass.class.name} needs to implement '#{method_name}' for interface #{self.name}!")
    end

  end

  module ClassMethods
    # this method call in your interface to tell sub classes the method that must be implemented
    # method type to define that method needs implementation is a class method or instance method
    def needs_implementation(methodType, name, *args)
        method_name = {:class => :instance_eval, :instance => :class_eval}
        self.send ("#{method_name[methodType]}") do
          define_method(name) do |*args|
            BasicConnectorInterface.api_not_implemented(self, name)
          end
        end
    end

  end

end

class BasicConnectorInterface
  include AbstractInterface

  needs_implementation :instance ,:update, :args
  needs_implementation :class ,:find, :id
  needs_implementation :class ,:to_object, :record
  needs_implementation :class ,:all
end
