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
          Harvesting::Models::Base.send :define_method, attribute_name.to_s do
            @attributes[__method__.to_s]
          end
          Harvesting::Models::Base.send :define_method, "#{attribute_name.to_s}=" do |value|
            puts "Setting name #{__method__.to_s} to: #{value}"
            @attributes[__method__.to_s.chomp('=')] = value
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
