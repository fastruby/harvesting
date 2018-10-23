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

      def fetch
        self.class.new(@client.get(path), client: @client)
      end

      def self.get(id, opts = {})
        client = opts[:client] || Harvesting::Client.new(opts)
        self.new({ 'id' => id }, opts).fetch
      end
    end
  end
end
