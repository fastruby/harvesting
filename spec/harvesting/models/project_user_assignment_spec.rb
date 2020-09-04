require 'spec_helper'

RSpec.describe Harvesting::Models::ProjectUserAssignment, :vcr do
  let(:attrs) { {} }
  let(:user_assignment) { Harvesting::Models::ProjectUserAssignment.new(attrs) }

  describe '#create' do
    context 'without a project id' do
      let(:attrs) do
        {
          'project' => { 'id' => nil },
          'user' => { 'id' => '5678' }
        }
      end

      it 'raises Harvesting::RequestNotFound error' do
        expect { user_assignment.create }.to raise_error(Harvesting::RequestNotFound)
      end
    end

    context 'with a project id' do
      let(:attrs) do
        {
          'project' => { 'id' => '1234' },
          'user' => { 'id' => '5678' }
        }
      end
      it 'creates the user assignment' do
        user_assignment.create
        expect(user_assignment.id).to eq(125_068_758)
      end
    end
  end
end
