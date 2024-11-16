# frozen_string_literal: true

RSpec.describe Wh3n do
  it "has a version number" do
    expect(Wh3n::VERSION).not_to be nil
  end

  describe ".intersects" do
    let!(:event1) { Event.create!(starts_at: Date.yesterday.to_time, ends_at: Date.today.to_time.to_time) }
    let!(:event2) { Event.create!(starts_at: Date.today.to_time, ends_at: Date.tomorrow.to_time) }
    let!(:event3) { Event.create!(starts_at: Date.tomorrow.to_time, ends_at: Date.tomorrow.to_time + 1.day) }
    
    it "does something useful" do
      expect(Event.intersects(Date.today.to_time..Date.tomorrow.to_time))
        .to contain_exactly(event2)
    end
  end

  describe "#time_range" do
    let(:event) { Event.create!(starts_at: Date.today.to_time, ends_at: Date.tomorrow.to_time) }

    it "returns a range" do
      expect(event.time_range).to eq(Date.today.to_time..Date.tomorrow.to_time)
    end
  end

  shared_examples 'it returns a duration of' do |starts_at:, ends_at:, duration:|
    context "for starts_at: #{starts_at}, ends_at: #{ends_at}" do
      subject(:duration) { Event.new(starts_at: starts_at.to_time, ends_at: ends_at.to_time).duration }

      it { is_expected.to eq(duration) }
    end
  end

  describe "#duration" do
    include_examples 'it returns a duration of', starts_at: Date.today, ends_at: Date.tomorrow, duration: 1.day
    include_examples 'it returns a duration of', starts_at: Date.today.to_time, ends_at: Date.today.to_time + 2.hour, duration: 2.hours
    include_examples 'it returns a duration of', starts_at: Date.today.to_time + 17.seconds, ends_at: Date.today.to_time + 34.seconds, duration: 17.seconds
  end

  describe "#intersects" do
    let(:event) { Event.create!(starts_at: Date.today.to_time, ends_at: Date.tomorrow.to_time) }

    it "returns true if time or object's overlaps" do
      expect(event.intersects(Date.today.to_time..Date.tomorrow.to_time)).to be true
      expect(event.intersects(Event.new(starts_at: Date.today.to_time, ends_at: Date.tomorrow.to_time))).to be true
    end

    it "returns true if time or object's overlaps" do
      expect(event.intersects(Date.yesterday.to_time..Date.today.to_time)).to be false
      expect(event.intersects(Event.new(starts_at: Date.yesterday.to_time, ends_at: Date.today.to_time))).to be false
      expect(event.intersects(Date.tomorrow.to_time..(Date.tomorrow + 1.day).to_time)).to be false
      expect(event.intersects(Event.new(starts_at: Date.tomorrow.to_time, ends_at: (Date.tomorrow + 1.day).to_time))).to be false
    end
  end
end
