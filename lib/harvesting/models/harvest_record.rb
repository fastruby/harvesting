module Harvesting
  module Models
    class HarvestRecord < Base

      def save
        id.nil? ? create : update
      end

      def create
        harvest_client.create(self)
      end

      def update
        harvest_client.update(self)
      end
    end
  end
end
