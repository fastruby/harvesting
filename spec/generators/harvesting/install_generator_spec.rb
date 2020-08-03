# frozen_string_literal: true

require 'generator_spec'
require File.expand_path('../../../lib/generators/harvesting/install_generator.rb', __dir__)

RSpec.describe Harvesting::Generators::InstallGenerator, type: :generator do
  destination File.expand_path('../../../tmp', __dir__)

  before(:all) do
    prepare_destination
    run_generator
  end

  describe '.setup' do
    context 'when generator is called' do
      it 'creates an initializer file' do
        assert_file 'config/initializers/harvest.rb'
      end

      specify do
        destination_root.should have_structure {
          no_file 'harvest.rb'

          directory 'config' do
            directory 'initializers' do
              file 'harvest.rb' do
                contains '# Place your access_token and account_id here'
              end
            end
          end
        }
      end
    end
  end
end
