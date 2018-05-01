module Harvesting
  module Models
    class Base
      attr_reader :client
      
      def initialize(attrs, opts = {})
        @attributes = attrs
        @client = opts[:client]
      end

      def self.attributed(*values)
        values.each do |value|
          define_method value.to_s do
            @attributes[value.to_s]
          end
        end
      end
    end
  end
end
