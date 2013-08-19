require 'spec_helper'

describe Point do
  it 'has a valid factory' do
    expect(create :point).to be_valid
  end

  describe '.today' do
    let!(:yesterday_point) { create :point, created_at: 1.day.ago }
    let!(:today_point) { create :point }

    it 'gets only today points' do
      expect(Point.today).to eq [today_point]
    end
  end

  describe '.last_week' do
    let!(:last_week_point) { create :point, created_at: 1.week.ago }
    let!(:this_week_point) { create :point }

    it 'gets only last week points' do
      expect(Point.this_week).to eq [this_week_point]
    end
  end
end
