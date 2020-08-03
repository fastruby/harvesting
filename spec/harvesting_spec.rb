# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Harvesting do
  it 'has a version number' do
    expect(Harvesting::VERSION).not_to be nil
  end

  it 'setup block yields self' do
    Harvesting::Client.setup do |config|
      expect(Harvesting::Client).to eq(config)
    end
  end
end
