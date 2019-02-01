require 'spec_helper'
require 'pry'

RSpec.describe Harvesting::Models::Invoice, :vcr do
  let(:attrs) { Hash.new }
  let(:invoice) { Harvesting::Models::Invoice.new(attrs) }

  include_context "harvest data setup"

  describe '.new' do
    context 'with client attributes in attrs' do
      let(:client_id) { '1235' }
      let(:client_name) { 'Lannister Co' }
      let(:creator_id) { '1224' }
      let(:creator_name) { 'Panda' }
      let(:project_id) { '4443' }
      let(:project_name) { "projectX" }
      let(:client_attrs) { { "id" => client_id, "name" => client_name } }
      let(:creator_attrs) { { "id" => creator_id, "name" => creator_name } }
      let(:project_attrs) { { "id" => project_id, "name" => project_name } }
      let(:total_line_items) { 1 }
      let(:line_items) do
        [
          {
            "project" => project_attrs
          }
        ]
      end

      let(:attrs) do 
        { 
          "client" => client_attrs, 
          "creator" => creator_attrs, 
          "line_items" => line_items 
        } 
      end

      it 'provides access to a client and a creator object with the specified attributes' do
        expect(invoice.client.id).to eq(client_id)
        expect(invoice.client.name).to eq(client_name)
        expect(invoice.creator.id).to eq(creator_id)
        expect(invoice.creator.name).to eq(creator_name)
      end

      it 'provides access to line_items and project object with the specified attributes' do
        expect(invoice.line_items.count).to eq(total_line_items)
        expect(invoice.line_items.first.project.id).to eq(project_id)
        expect(invoice.line_items.first.project.name).to eq(project_name)
      end
    end
  end

  # describe '.get' do
  #   it 'provides direct access to a specific invoice' do
  #     invoice = Harvesting::Models::Invoice.get(toto_invoice.id)
  #     expect(invoice.id).to eq(toto_invoice.id)
  #     expect(invoice.client.id.to_i).to eq(toto_invoice.client.id.to_i)
  #     expect(invoice.creator.id.to_i).to eq(toto_invoice.creator.id.to_i)
  #     expect(invoice.line_items.count).to eq(1)
  #     expect(invoice.line_items.first.project.id.to_i).to eq(toto_invoice.line_items.first.project.id.to_i)
  #   end
  # end

end
