require "spec_helper"

describe FiveStar::Rateable do
  class Rater
    def self.build(_); self; end
  end

  subject(:dummy_class) {
    Class.new do
      include FiveStar::Rateable
      rate_with(Rater, Rater, Rater)
    end
  }

  describe ".rate_with" do
    it "sets class" do
      expect(dummy_class.rating_klasses).to eq [Rater, Rater, Rater]
    end
  end

  describe "#rating" do
    before do
      allow(FiveStar::RatingCalculator).to receive(:rate).and_return(5)
    end

    it "passes raters to calculation class" do
      expect(FiveStar::RatingCalculator).to receive(:rate).with([Rater, Rater, Rater])

      dummy_class.new.rating
    end

    it "returns value from calculation" do
      expect(dummy_class.new.rating).to eq 5
    end
  end

  describe "#rating_descriptions" do
    before do
      allow(Rater).to receive(:description).and_return("A", "B", "C")
    end

    it "returns descriptions from raters in order" do
      expect(dummy_class.new.rating_descriptions).to eq ["A", "B", "C"]
    end
  end

  describe "integration specs" do
    class FirstRater
      def self.build(_); self; end
      def self.description; "A"; end
      def self.rating; 2; end
      def self.weighting; 0.6; end
    end

    class SecondRater
      def self.build(_); self; end
      def self.description; "B"; end
      def self.rating; 7; end
      def self.weighting; 0.4; end
    end

    class ThirdRater
      def self.build(_); self; end
      def self.description; "C"; end
      def self.rating; 6; end
      def self.weighting; 0.3; end
    end

    subject(:dummy_class) {
      Class.new do
        include FiveStar::Rateable
        rate_with(FirstRater, SecondRater, ThirdRater)
      end
    }

    describe "#rating" do
      it "is the weighted average" do
        expect(dummy_class.new.rating).to be_within(0.0001).of 4.4615
      end
    end

    describe "#rating_descriptions" do
      it "returns descriptions from raters in order" do
        expect(dummy_class.new.rating_descriptions).to eq ["A", "B", "C"]
      end
    end
  end
end
