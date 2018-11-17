module Harvesting
  module Models
    class Base
      attr_accessor :attributes
      attr_reader :harvest_client

      def initialize(attrs, opts = {})
        @models = {}
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

      def self.modeled(opts = {})
        opts.each do |attribute_name, model|
          attribute_name_string = attribute_name.to_s
          Harvesting::Models::Base.send :define_method, attribute_name_string do
            @models[attribute_name_string] ||= model.new(@attributes[attribute_name_string] || {}, client: harvest_client)
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
