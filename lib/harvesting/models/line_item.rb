module Harvesting
  module Models
    class LineItem < HarvestRecord
      attributed :id,
                 :kind,
                 :description,
                 :quantity,
                 :unit_price,
                 :amount,
                 :taxed,
                 :taxed2

      modeled project: Project

    end
  end
end
