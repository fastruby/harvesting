require 'spec_helper'

RSpec.describe Harvesting::Models::TimeEntry, :vcr do
  let(:attrs) { Hash.new }
  let(:time_entry) { Harvesting::Models::TimeEntry.new(attrs) }
  let(:date) { "2018-05-14" }
  let(:started_time) { "8:00am" }
  let(:ended_time) { "9:00am" }
  let(:project_id) { '17367712' }
  let(:task_id) { '9713395' }
  let(:user_id) { '2108614' }

  before do
    stub_const("ENV", {
      'HARVEST_ACCESS_TOKEN' => "1484959.pt.abcdef",
      'HARVEST_ACCOUNT_ID' => "715808"
    })
  end

  describe "#save" do
    context "when id is nil" do
      it "calls create" do
        allow(time_entry).to receive(:create)

        time_entry.save

        expect(time_entry).to have_received(:create)
      end
    end

    context "when id is not nil" do
      let(:attrs) { Hash.new('id' => 123) }

      it "calls update" do
        allow(time_entry).to receive(:update)

        time_entry.save

        expect(time_entry).to have_received(:update)
      end
    end
  end

  describe "#create" do
    context "when trying to create a time entry without required attributes" do
      let(:error) do
        { message: "Project can't be blank, Task can't be blank, Spent date can't be blank, Spent date is not a valid date" }.to_json
      end

      it "fails" do
        expect do
          result = time_entry.save
        end.to raise_error(Harvesting::UnprocessableRequest, error)
      end
    end

    context "when trying to create a time entry with the required attributes" do
      let(:attrs) do
        {
          'project_id' => project_id, 'task_id' => task_id, 'spent_date' => date,
          'hours' => '1.0', 'user_id' => user_id,
          'is_running' => 'false', 'notes' => 'hacked the things'
        }
      end

      it "automatically sets the id of the time entry" do
        result = time_entry.save

        expect(time_entry.id).not_to be_nil
        expect(time_entry.hours).to eq 1
      end
    end
  end

  describe "#update" do
    let(:attrs) do
      {
        'project_id' => project_id, 'task_id' => task_id, 'spent_date' => date,
        'hours' => '1.0', 'user_id' => user_id,
        'is_running' => 'false', 'notes' => 'hacked the things'
      }
    end

    context "when updating an existing time entry" do
      xit "updates the amount of hours" do
        # TODO: fixme
      end
    end
  end

  describe "initialize" do
    let(:project_name) { 'Harvesting' }
    let(:attrs) do
        {
          'spent_date' => date,
          'project' => {
            'name' => project_name,
            'id' => project_id
          }
        }
      end

    it 'creates accessors for top-level attributes' do
      expect(time_entry.spent_date).to eq(date)
    end

    it 'creates accessors for nested attributes' do
      expect(time_entry.project.name).to eq(project_name)
      expect(time_entry.project.id).to eq(project_id)
    end

    it 'does not throw when parent is nil' do
      expect(time_entry.user.id).to eq(nil)
    end
  end
end
