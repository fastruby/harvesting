require 'spec_helper'

RSpec.describe Harvesting::Models::ProjectTaskAssignment, :vcr do
  let(:attrs) { Hash.new }
  let(:task_assignment) { Harvesting::Models::ProjectTaskAssignment.new(attrs) }

  describe '#path' do
    context 'without a task assignment id' do
      let(:attrs) do
        {
            'project' => {
                'id' => '1234'
            }
        }
      end
      it 'includes the project id' do
        expect(task_assignment.path).to eq('projects/1234/task_assignments')
      end
    end

    context 'with a task assignment id' do
      let(:attrs) do
        {
            'id' => '1111',
            'project' => {
                'id' => '2222'
            }
        }
      end
      it 'includes project id and task assignment id' do
        expect(task_assignment.path).to eq(
          'projects/2222/task_assignments/1111'
        )
      end
    end
  end
end
