module Harvesting
  module Models
    class Base
      attr_accessor :attributes
      attr_reader :client

      def initialize(attrs, opts = {})
        @attributes = attrs.dup
        @client = opts[:client] || Harvesting::Client.new(opts)
      end

      def self.attributed(*attribute_names)
        attribute_names.each do |attribute_name|
          if attribute_name.is_a?(Symbol)
            Harvesting::Models::Base.send :define_method, attribute_name.to_s do
              @attributes[__method__.to_s]
            end

          else
            key = attribute_name.keys[0]
            attribute_name[key].each do |sub_key|
              Harvesting::Models::Base.send :define_method, "#{key}_#{sub_key}" do
                @attributes.dig(key.to_s, sub_key.to_s)
              end
            end
          end
        end
      end

      def save
        id.nil? ? create : update
      end

      def create
        @client.create(self)
      end

      def update
        @client.update(self)
      end

      def to_hash
        @attributes
      end
    end
  end
end
