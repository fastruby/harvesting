module Harvesting
  module Models
    # A line item on an invoice from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/invoices-api/invoices/invoices/
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
