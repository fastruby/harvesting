module Harvesting
  module Models
    class Base
      # @return [Hash]
      attr_accessor :attributes
      # @return [Harvesting::Model::Client]
      attr_reader :harvest_client

      def initialize(attrs, opts = {})
        @models = {}
        @attributes = attrs.dup
        @harvest_client = opts[:harvest_client] || Harvesting::Client.new(**opts)
      end

      # It calls `create` or `update` depending on the record's ID. If the ID
      # is present, then it calls `update`. Otherwise it calls `create`
      #
      # @see Client#create
      # @see Client#update
      def save
        id.nil? ? create : update
      end

      # It creates the record.
      #
      # @see Client#create
      # @return [Harvesting::Models::Base]
      def create
        @harvest_client.create(self)
      end

      # It updates the record.
      #
      # @see Client#update
      # @return [Harvesting::Models::Base]
      def update
        @harvest_client.update(self)
      end

      # It removes the record.
      #
      # @see Client#delete
      # @return [Harvesting::Models::Base]
      def delete
        @harvest_client.delete(self)
      end

      # It returns keys and values for all the attributes of this record.
      #
      # @return [Hash]
      def to_hash
        @attributes
      end

      # It loads a new record from your Harvest account.
      #
      # @return [Harvesting::Models::Base]
      def fetch
        self.class.new(@harvest_client.get(path), harvest_client: @harvest_client)
      end

      # Retrieves an instance of the object by ID
      #
      # @param id [Integer] the id of the object to retrieve
      # @param opts [Hash] options to pass along to the `Harvesting::Client`
      #   instance
      def self.get(id, opts = {})
        client = opts[:harvest_client] || Harvesting::Client.new(**opts)
        self.new({ 'id' => id }, opts).fetch
      end

      protected

      # Class method to define attribute methods for accessing attributes for
      # a record
      #
      # It needs to be used like this:
      #
      #     class Contact < HarvestRecord
      #       attributed :id,
      #                  :title,
      #                  :first_name
      #       ...
      #     end
      #
      # @param attribute_names [Array] A list of attributes
      def self.attributed(*attribute_names)
        attribute_names.each do |attribute_name|
          define_method(attribute_name) do
            @attributes[__method__.to_s]
          end
          define_method("#{attribute_name}=") do |value|
            @attributes[__method__.to_s.chop] = value
          end
        end
      end

      # Class method to define nested resources for a record.
      #
      # It needs to be used like this:
      #
      #     class Contact < HarvestRecord
      #       modeled client: Client
      #       ...
      #     end
      #
      # @param opts [Hash] key = symbol that needs to be the same as the one returned by the Harvest API. value = model class for the nested resource.
      def self.modeled(opts = {})
        opts.each do |attribute_name, model|
          attribute_name_string = attribute_name.to_s
          Harvesting::Models::Base.send :define_method, attribute_name_string do
            @models[attribute_name_string] ||= model.new(@attributes[attribute_name_string] || {}, harvest_client: harvest_client)
          end
        end
      end
    end
  end
end
