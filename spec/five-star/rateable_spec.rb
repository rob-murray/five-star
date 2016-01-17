require "spec_helper"

RSpec.describe FiveStar::Rateable do
  class Rater
    def self.build(_); self; end
    def self.description; end
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
      expect(FiveStar::RatingCalculator).to receive(:rate).with(anything, [Rater, Rater, Rater])

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
    context "without any raters" do
      subject(:dummy_class) {
        Class.new do
          include FiveStar::Rateable
          def rateable_name
            "Dummy rater"
          end
        end
      }

      describe "#rating" do
        it "is has a default value" do
          expect(dummy_class.new.rating).to eq 0.0
        end
      end

      describe "#rating_descriptions" do
        it "returns empty descriptions" do
          expect(dummy_class.new.rating_descriptions).to eq []
        end
      end
    end

    context "with invalid rater" do
      class BadRater < FiveStar.base_rater
        def rating; 200; end
        def weighting; 1.0; end
      end

      subject(:dummy_class) {
        Class.new do
          include FiveStar::Rateable
          rate_with(BadRater)
          def rateable_name
            "Dummy rater"
          end
        end
      }

      describe "#rating" do
        it "raises error with helpful message" do
          expect{
            dummy_class.new.rating
          }.to raise_error(FiveStar::RatingError).with_message("Rating 200.0 is invalid from BadRater")
        end
      end
    end

    context "with valid raters" do
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
          "ThirdRater rated #{rateable.rateable_name} at #{rating} with weighting of #{weighting}"
        end
        def rating; 6; end
        def weighting; 0.3; end
      end

      subject(:dummy_class) {
        Class.new do
          include FiveStar::Rateable
          rate_with(FirstRater, SecondRater, ThirdRater)
          def rateable_name
            "Dummy rater"
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
          expect(dummy_class.new.rating_descriptions).to eq ["A", "SecondRater rated Dummy rater at 7 with weighting of 0.4", "ThirdRater rated Dummy rater at 6 with weighting of 0.3"]
        end
      end
    end
  end
end
