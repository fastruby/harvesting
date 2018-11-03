module Harvesting
  module Models
    class Base
      attr_accessor :attributes
      attr_reader :harvest_client

      def initialize(attrs, opts = {})
        @attributes = attrs.dup
        @harvest_client = opts[:client] || Harvesting::Client.new(opts)
      end

      def self.attributed(*attribute_names)
        attribute_names.each do |attribute_name|
          Harvesting::Models::Base.send :define_method, attribute_name.to_s do
            @attributes[__method__.to_s]
          end
        end
      end

      def save
        id.nil? ? create : update
      end

      def create
        @harvest_client.create(self)
      end

      def update
        @harvest_client.update(self)
      end

      def delete
        @harvest_client.delete(self)
      end

      def to_hash
        @attributes
      end
    end
  end
end
