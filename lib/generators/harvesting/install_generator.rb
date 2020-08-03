# frozen_string_literal: true

module Harvesting
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_initializer_file
        copy_file "harvest.rb", "config/initializers/harvest.rb"
      end
    end
  end
end
