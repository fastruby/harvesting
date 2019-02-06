require 'spec_helper'

RSpec.describe Harvesting::Models::Project, :vcr do
  let(:attrs) { Hash.new }
  let(:project) { Harvesting::Models::Project.new(attrs) }
  let(:project_id) { 19815868 }

  include_context "harvest data setup"

  describe '.new' do
    context 'with client attributes in attrs' do
      let(:project_id) { '1235' }
      let(:project_name) { 'Lannister Co' }
      let(:client_attrs) { { "id" => project_id, "name" => project_name } }
      let(:attrs) { { "client" => client_attrs } }

      it 'provides access to a client object with the specified attributes' do
        expect(project.client.id).to eq(project_id)
        expect(project.client.name).to eq(project_name)
      end
    end
  end

  describe '.get' do
    it 'provides direct access to a specific project' do
      project = Harvesting::Models::Project.get(project_id)
      expect(project.id).to eq(project_id)
      expect(project.name).to eq("X")
    end
  end

  describe "#time_entries" do
    it "loads associated time entries" do
      project = Harvesting::Models::Project.get(project_id)

      expect(project.time_entries.size).to eq(1)
      expect(project.time_entries.first.hours).to eq(1.25)
    end
  end

  describe "#user_assignments", :vcr do
    context "as an admin user" do
      subject { Harvesting::Client.new(access_token: admin_access_token, account_id: account_id) }

      it 'retrieves project user assignments for castle building project' do
        user_assignments = project_castle_building.user_assignments
        users = user_assignments.map { |ua| ua.user.id }.uniq
        expect(users).to contain_exactly(user_john_smith.id, user_me.id)
      end
    end
  end

  describe '#task_assignments' do
    context "as an admin user" do
      subject { Harvesting::Client.new(access_token: admin_access_token, account_id: account_id) }

      it 'retrieves project task assignments for the castle building project' do
        task_assignments = project_castle_building.task_assignments
        tasks = task_assignments.map { |ta| ta.task.id }.uniq
        expect(tasks).to contain_exactly(task_coding.id)
      end
    end
  end


end
