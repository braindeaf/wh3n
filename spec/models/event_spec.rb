require 'spec_helper'

RSpec.describe Event, type: :model do
  it 'is a thing' do
    expect(Event.count).to eq(1)
  end
end