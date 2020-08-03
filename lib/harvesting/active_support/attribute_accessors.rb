# frozen_string_literal: true

# Extends the module object with class/module and instance accessors for
# class/module attributes, just like the native attr* accessors for instance
# attributes.
module Harvesting
  module ActiveSupport
    module AttributeAccessors
      # Defines a class attribute and creates a class and instance reader methods.
      # The underlying class variable is set to +nil+, if it is not previously
      # defined. All class and instance methods created will be public, even if
      # this method is called with a private or protected access modifier.
      def mattr_reader(*syms, instance_reader: true, instance_accessor: true, default: nil, location: nil)
        raise TypeError, "module attributes should be defined directly on class, not singleton" if singleton_class?
        location ||= caller_locations(1, 1).first

        definition = []
        syms.each do |sym|
          raise NameError.new("invalid attribute name: #{sym}") unless /\A[_A-Za-z]\w*\z/.match?(sym)

          definition << "def self.#{sym}; @@#{sym}; end"

          if instance_reader && instance_accessor
            definition << "def #{sym}; @@#{sym}; end"
          end

          sym_default_value = (block_given? && default.nil?) ? yield : default
          class_variable_set("@@#{sym}", sym_default_value) unless sym_default_value.nil? && class_variable_defined?("@@#{sym}")
        end

        module_eval(definition.join(";"), location.path, location.lineno)
      end
      alias :cattr_reader :mattr_reader

      # Defines a class attribute and creates a class and instance writer methods to
      # allow assignment to the attribute. All class and instance methods created
      # will be public, even if this method is called with a private or protected
      # access modifier.
      def mattr_writer(*syms, instance_writer: true, instance_accessor: true, default: nil, location: nil)
        raise TypeError, "module attributes should be defined directly on class, not singleton" if singleton_class?
        location ||= caller_locations(1, 1).first

        definition = []
        syms.each do |sym|
          raise NameError.new("invalid attribute name: #{sym}") unless /\A[_A-Za-z]\w*\z/.match?(sym)
          definition << "def self.#{sym}=(val); @@#{sym} = val; end"

          if instance_writer && instance_accessor
            definition << "def #{sym}=(val); @@#{sym} = val; end"
          end

          sym_default_value = (block_given? && default.nil?) ? yield : default
          class_variable_set("@@#{sym}", sym_default_value) unless sym_default_value.nil? && class_variable_defined?("@@#{sym}")
        end

        module_eval(definition.join(";"), location.path, location.lineno)
      end
      alias :cattr_writer :mattr_writer

      # Defines both class and instance accessors for class attributes.
      # All class and instance methods created will be public, even if
      # this method is called with a private or protected access modifier.
      def mattr_accessor(*syms, instance_reader: true, instance_writer: true, instance_accessor: true, default: nil, &blk)
        location = caller_locations(1, 1).first
        mattr_reader(*syms, instance_reader: instance_reader, instance_accessor: instance_accessor, default: default, location: location, &blk)
        mattr_writer(*syms, instance_writer: instance_writer, instance_accessor: instance_accessor, default: default, location: location)
      end
      alias :cattr_accessor :mattr_accessor
    end
  end
end
