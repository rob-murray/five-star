require "spec_helper"

describe FiveStar::RatingCalculator do
  let(:list_of_raters) { [first_rater, second_rater, third_rater] }
  subject { described_class.new(list_of_raters) }

  describe "#calculate_rating" do
    context "with no rating classes provided" do
      let(:list_of_raters) { [] }

      it "is zero" do
        expect(subject.calculate_rating).to be_zero
      end
    end

    context "with rating classes" do
      context "having zero rating" do
        let(:first_rater) { double("FiveStar::BaseRater", rating: 0, weighting: 1.0) }
        let(:second_rater) { double("FiveStar::BaseRater", rating: 0, weighting: 1.0) }
        let(:third_rater) { double("FiveStar::BaseRater", rating: 0, weighting: 1.0) }

        it "is zero" do
          expect(subject.calculate_rating).to be_zero
        end
      end

      context "having identical weighting" do
        let(:first_rater) { double("FiveStar::BaseRater", rating: 2, weighting: 1.0) }
        let(:second_rater) { double("FiveStar::BaseRater", rating: 7, weighting: 1.0) }
        let(:third_rater) { double("FiveStar::BaseRater", rating: 6, weighting: 1.0) }

        it "is the average" do
          expect(subject.calculate_rating).to eq 5
        end
      end

      context "having varying weights" do
        let(:first_rater) { double("FiveStar::BaseRater", rating: 2, weighting: 0.6) }
        let(:second_rater) { double("FiveStar::BaseRater", rating: 7, weighting: 0.4) }
        let(:third_rater) { double("FiveStar::BaseRater", rating: 6, weighting: 0.3) }

        it "is the weighted average" do
          expect(subject.calculate_rating).to be_within(0.0001).of 4.4615
        end
      end
    end
  end
end
