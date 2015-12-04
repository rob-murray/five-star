require "spec_helper"

RSpec.describe FiveStar do
  describe ".rateable" do
    it "is the rateable module" do
      expect(FiveStar.rateable).to eq(FiveStar::Rateable)
    end
  end

  describe ".base_rater" do
    it "is the base rater class" do
      expect(FiveStar.base_rater).to eq(FiveStar::BaseRater)
    end
  end
end
