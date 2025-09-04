require 'rails_helper'

RSpec.describe 'Environment Setup', type: :system do
  it 'has correct Ruby version' do
    expect(RUBY_VERSION).to start_with("3.3")
  end

  it 'can connect to database' do
    expect(ActiveRecord::Base.connection).to be_active
  end
end
