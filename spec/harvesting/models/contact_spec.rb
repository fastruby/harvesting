require 'spec_helper'

RSpec.describe Harvesting::Models::Contact, :vcr do
  let(:attrs) { Hash.new }
  let(:contact) { Harvesting::Models::Contact.new(attrs) }

  include_context "harvest data setup"

  describe '.new' do
    context 'with client attributes in attrs' do
      let(:contact_id) { '1235' }
      let(:contact_name) { 'Lannister Co' }
      let(:client_attrs) { { "id" => contact_id, "name" => contact_name } }
      let(:attrs) { { "client" => client_attrs } }

      it 'provides access to a client object with the specified attributes' do
        expect(contact.client.id).to eq(contact_id)
        expect(contact.client.name).to eq(contact_name)
      end
    end
  end

  describe '.get' do
    it 'provides direct access to a specific contact' do
      contact = Harvesting::Models::Contact.get(contact_jon_snow.id)
      expect(contact.id).to eq(contact_jon_snow.id)
      expect(contact.first_name).to eq(contact_jon_snow.first_name)
      expect(contact.last_name).to eq(contact_jon_snow.last_name)
      expect(contact.client.id.to_i).to eq(contact_jon_snow.client.id.to_i)
    end
  end

end
