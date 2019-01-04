RSpec.shared_context "harvest data setup" do

  let(:account_first_name) { ENV["HARVEST_FIRST_NAME"] }
  let(:account_last_name) { ENV["HARVEST_LAST_NAME"] }

  let(:admin_account_id) { ENV["HARVEST_ACCOUNT_ID"] }
  let(:non_admin_account_id) { ENV["HARVEST_NON_ADMIN_ACCOUNT_ID"] }

  let(:admin_access_token) { ENV["HARVEST_ACCESS_TOKEN"] }
  let(:non_admin_access_token) { ENV["HARVEST_NON_ADMIN_ACCESS_TOKEN"] }

  let(:admin_full_name) { ENV["HARVEST_ADMIN_FULL_NAME"] }

  let(:access_token) { non_admin_access_token }
  let(:account_id) { non_admin_account_id }

  let(:one_day) { 24 * 60 * 60 }

  let!(:harvest_client) do
    VCR.use_cassette('harvest_data_setup/harvest_client', :record => :once, :allow_playback_repeats => true) do
      harvest_client = Harvesting::Client.new(
        access_token: admin_access_token,
        account_id: admin_account_id
      )
      harvest_client
    end
  end

  before do
    VCR.use_cassette('harvest_data_setup/clear_data', :record => :once, :allow_playback_repeats => true) do
      harvest_client.time_entries.to_a.each do |time_entry|
        time_entry.delete
      end

      harvest_client.tasks.to_a.each do |task|
        task.delete
      end

      harvest_client.projects.to_a.each do |project|
        project.delete
      end

      harvest_client.invoices.to_a.each do |invoice|
        invoice.delete
      end

      harvest_client.clients.to_a.each do |client|
        client.delete
      end
    end
  end

  let!(:client_pepe) do
    VCR.use_cassette('harvest_data_setup/client_pepe', :record => :once, :allow_playback_repeats => true) do
      pepe = Harvesting::Models::Client.new(
        {
          "name" => "Pepe"
        },
        client: harvest_client
      )
      pepe.save
      pepe
    end
  end

  let!(:client_toto) do
    VCR.use_cassette('harvest_data_setup/client_toto', :record => :once, :allow_playback_repeats => true) do
      toto = Harvesting::Models::Client.new(
        {
          "name" => "Toto"
        },
        client: harvest_client
      )
      toto.save
      toto
    end
  end

  let!(:user_me) do
    VCR.use_cassette('harvest_data_setup/user_me', :record => :once, :allow_playback_repeats => true) do
      harvest_client.me
    end
  end

  let!(:contact_jon_snow) do
    VCR.use_cassette('harvest_data_setup/contact_jon_snow', :record => :once, :allow_playback_repeats => true) do
      jon_snow = Harvesting::Models::Contact.new(
        {
          "first_name" => "Jon",
          "last_name" => "Snow",
          "client" => {
              "id" => client_pepe.id.to_s
          }
        },
        client: harvest_client
      )
      jon_snow.save
      jon_snow
    end
  end

  let!(:project_castle_building) do
    VCR.use_cassette('harvest_data_setup/project_castle_building', :record => :once, :allow_playback_repeats => true) do
      castle_building = Harvesting::Models::Project.new(
        {
          "client" => {
              "id" => client_pepe.id.to_s
          },
          "name" => "Castle Building",
          "is_billable" => "true",
          "bill_by" => "Tasks",
          "budget_by" => "person"
        },
        client: harvest_client
      )
      castle_building.save
      castle_building
    end
  end

  let!(:task_coding) do
    VCR.use_cassette('harvest_data_setup/task_coding', :record => :once, :allow_playback_repeats => true) do
      coding = Harvesting::Models::Task.new(
        {
          "name" => "Coding"
        },
        client: harvest_client
      )
      coding.save
      coding
    end
  end

  let!(:task_assigment_castle_building_coding) do
    VCR.use_cassette('harvest_data_setup/task_assigment_castle_building_coding', :record => :once, :allow_playback_repeats => true) do
      castle_building_coding = Harvesting::Models::TaskAssignment.new(
        {
            "project" => {
                "id" => project_castle_building.id.to_s
            },
            "task" => {
                "id" => task_coding.id.to_s
            }
        },
        client: harvest_client
      )
      castle_building_coding.save
      castle_building_coding
    end
  end

  let!(:project_assignment_castle_building_non_admin) do
    VCR.use_cassette('harvest_data_setup/project_assignment_castle_building_non_admin', :record => :once, :allow_playback_repeats => true) do
      project_assignment = Harvesting::Models::ProjectUserAssignment.new(
        {
          "project" => {
            "id" => project_castle_building.id.to_s
          },
          "user" => {
            "id" => non_admin_account_id.to_s
          }
        },
        client: harvest_client
      )
      project_assignment.save
      project_assignment
    end
  end

  let!(:contact_cersei_lannister) do
    VCR.use_cassette('harvest_data_setup/contact_cersei_lannister', :record => :once, :allow_playback_repeats => true) do
      cersei_lannister = Harvesting::Models::Contact.new(
        {
          "first_name" => "Cersei",
          "last_name" => "Lannister",
          "client" => {
              "id" => client_toto.id.to_s
          }
        },
        client: harvest_client
      )
      cersei_lannister.save
      cersei_lannister
    end
  end

  let!(:time_entries) do
    result = []
    VCR.use_cassette('harvest_data_setup/time_entries', :record => :once, :allow_playback_repeats => true) do
      119.times do |iteration|
        time = Harvesting::Models::TimeEntry.new(
          {
            "project" => {
                "id" => project_castle_building.id.to_s
            },
            "task" => {
                "id" => task_coding.id.to_s
            },
            "spent_date" => (Time.now - one_day * (iteration + 1)).iso8601.to_s,
            "hours" => 6.to_s
          },
          client: harvest_client
        )
        time.save
        result << time
      end
    end
    result
  end

end
