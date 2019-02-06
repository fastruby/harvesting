require 'spec_helper'

RSpec.describe Harvesting::Models::Invoice, :vcr do
  let(:attrs) { Hash.new }
  let(:invoice) { Harvesting::Models::Invoice.new(attrs) }
  let(:client_id) { client_pepe.id }
  let(:project_id) { project_castle_building.id }
  let(:client_name) { 'Lannister Co' }
  let(:project_name) { "projectX" }
  let(:client_attrs) { { "id" => client_id, "name" => client_name } }
  let(:project_attrs) { { "id" => project_id, "name" => project_name } }


  include_context "harvest data setup"

  describe "#to_hash" do
    let(:attrs){ { "client" => client_attrs } }
    context "without line_items" do
      it 'includes the client id' do
        expect(invoice.to_hash).to include({ "client_id" => client_id })
      end
    end
    context "with line_items" do
      context "without project" do
        let(:line_items) do
          [
            {
              "kind" => "Service",
              "unit_price" => 1000.0
            }
          ]
        end
        let(:attrs) do
          {
            "client" => client_attrs,
            "line_items" => line_items
          }
        end
        let(:expected_hash) do
          {
            "client_id" => client_id,
            "line_items" => line_items
          }
        end

        it "includes line_items attributes" do
          expect(invoice.to_hash).to include(expected_hash)
        end
      end

      context "with project" do
        let(:line_items) do
          [
            {
              "project" => project_attrs
            }
          ]
        end

        context "when time and expenses attributes are not specified" do
          let(:attrs) do
            {
              "client" => client_attrs,
              "line_items" => line_items
            }
          end
          let(:line_items_import) do
            {
              "project_ids" => [project_id],
              "time" => { "summary_type" => "task" },
              "expenses" => { "summary_type" => "category" }
            }
          end
          let(:expected_hash) do
            {
              "client_id" => client_id,
              "line_items_import" => line_items_import
            }
          end
          it "includes all unbilled time entries of that project" do
            expect(invoice.to_hash).to include(expected_hash)
          end
        end

        context "when time and expenses attributes are specified" do
          let(:time_attrs){ { "summary_type" => "detailed" } }
          let(:expenses_attrs){ { "summary_type" => "people" } }
          let(:attrs) do
            {
              "client" => client_attrs,
              "line_items" => line_items,
              "time" => time_attrs,
              "expenses" => expenses_attrs
            }
          end
          let(:line_items_import) do
            {
              "project_ids" => [project_id],
              "time" => { "summary_type" => "detailed" },
              "expenses" => { "summary_type" => "people" }
            }
          end
          let(:expected_hash) do
            {
              "client_id" => client_id,
              "line_items_import" => line_items_import
            }
          end
          it "includes all unbilled time entries and expenses of that project" do
            expect(invoice.to_hash).to include(expected_hash)
          end
        end
      end
    end
  end

  describe '.get' do
    it 'provides direct access to a specific invoice' do
      invoice = Harvesting::Models::Invoice.get(invoice_for_pepe.id)
      expect(invoice.id).to eq(invoice_for_pepe.id)
      expect(invoice.client.id.to_i).to eq(client_pepe.id.to_i)
      expect(invoice.creator.id.to_i).to eq(user_me.id.to_i)
      expect(invoice.line_items.count).to eq(3)
      expect(invoice.due_amount).to eq(120.0)
    end
  end

  describe '#create' do
    context "when trying to create invoice without required attributes" do
      let(:error) do
        { message: "Currency can't be blank, Currency is not included in the list, Client can't be blank, Currency code can't be blank" }.to_json
      end

      it "fails" do
        expect do
          result = invoice.save
        end.to raise_error(Harvesting::UnprocessableRequest, error)
      end
    end

    context "when trying to create a invoice with the correct attributes" do
      let(:attrs) do
        {
          "client" => {
            "id" => client_id.to_s
          },
          "line_items" => [
            {
              "kind" => "Service",
              "unit_price" => 20.0,
              "quantity" => 50
            }
          ]
        }
      end

      it "automatically sets the id of the invoice" do
        result = invoice.save

        expect(invoice.id).not_to be_nil
        expect(invoice.amount).to eq 1000.0

        invoice.delete
      end
    end
  end

end

