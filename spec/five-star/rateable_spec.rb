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
    class FirstRater < FiveStar.base_rater
      def description; "A"; end
      def rating; 2; end
      def weighting; 0.6; end
    end

    class SecondRater < FiveStar.base_rater
      def rating; 7; end
      def weighting; 0.4; end
    end

    class ThirdRater < FiveStar.base_rater
      def description
        "ThirdRater rated #{rateable.name} at #{rating} with weighting of #{weighting}"
      end
      def rating; 6; end
      def weighting; 0.3; end
    end

    subject(:dummy_class) {
      Class.new do
        include FiveStar::Rateable
        rate_with(FirstRater, SecondRater, ThirdRater)
        def name
          "DummyClass"
        end
      end
    }

    describe "#rating" do
      it "is the weighted average" do
        expect(dummy_class.new.rating).to be_within(0.0001).of 4.4615
      end
    end

    describe "#rating_descriptions" do
      it "returns descriptions from raters in order" do
        expect(dummy_class.new.rating_descriptions).to eq ["A", "SecondRater rated DummyClass at 7 with weighting of 0.4", "ThirdRater rated DummyClass at 6 with weighting of 0.3"]
      end
    end
  end
end
