require "spec_helper"

RSpec.describe FiveStar::RatingCalculator do
  let(:list_of_raters) { [first_rater, second_rater, third_rater] }
  subject { described_class.new(list_of_raters) }

  describe "#calculate_rating" do
    context "with no rating classes provided" do
      let(:list_of_raters) { [] }

      it "is zero" do
        expect(subject.calculate_rating).to be_zero
      end
    end

    describe "validation" do
      describe "rating" do
        let(:first_rater) { double("FiveStar::BaseRater", class: "FiveStar::BaseRater", rating: 5, weighting: 1.0) }
        let(:second_rater) { double("FiveStar::BaseRater", class: "FiveStar::ErrorRater", rating: rating, weighting: 1.0) }
        let(:third_rater) { double("FiveStar::BaseRater", class: "FiveStar::BaseRater", rating: 5, weighting: 1.0) }

        context "below minimum" do
          let(:rating) { -1 }

          it "raises error with helpful message" do
            expect{
              subject.calculate_rating
            }.to raise_error(FiveStar::RatingError).with_message("Rating -1 is invalid from FiveStar::ErrorRater")
          end
        end

        context "on minimum" do
          let(:rating) { 0 }

          it "does not raise error" do
            expect{
              subject.calculate_rating
            }.not_to raise_error
          end
        end

        context "within range" do
          let(:rating) { 5 }

          it "does not raise error" do
            expect{
              subject.calculate_rating
            }.not_to raise_error
          end
        end

        context "on maximum" do
          let(:rating) { 10 }

          it "does not raise error" do
            expect{
              subject.calculate_rating
            }.not_to raise_error
          end
        end

        context "above maximum" do
          let(:rating) { 11 }

          it "raises error with helpful message" do
            expect{
              subject.calculate_rating
            }.to raise_error(FiveStar::RatingError).with_message("Rating 11 is invalid from FiveStar::ErrorRater")
          end
        end
      end

      describe "weighting" do
        let(:first_rater) { double("FiveStar::BaseRater", class: "FiveStar::BaseRater", rating: 5, weighting: 1.0) }
        let(:second_rater) { double("FiveStar::BaseRater", class: "FiveStar::ErrorRater", rating: 5, weighting: weighting) }
        let(:third_rater) { double("FiveStar::BaseRater", class: "FiveStar::BaseRater", rating: 5, weighting: 1.0) }

        context "below minimum" do
          let(:weighting) { -1 }

          it "raises error with helpful message" do
            expect{
              subject.calculate_rating
            }.to raise_error(FiveStar::RatingError).with_message("Weighting -1 is invalid from FiveStar::ErrorRater")
          end
        end

        context "on minimum" do
          let(:weighting) { 0 }

          it "does not raise error" do
            expect{
              subject.calculate_rating
            }.not_to raise_error
          end
        end

        context "within range" do
          let(:weighting) { 0.5 }

          it "does not raise error" do
            expect{
              subject.calculate_rating
            }.not_to raise_error
          end
        end

        context "on maximum" do
          let(:weighting) { 1.0 }

          it "does not raise error" do
            expect{
              subject.calculate_rating
            }.not_to raise_error
          end
        end

        context "above maximum" do
          let(:weighting) { 1.1 }

          it "raises error with helpful message" do
            expect{
              subject.calculate_rating
            }.to raise_error(FiveStar::RatingError).with_message("Weighting 1.1 is invalid from FiveStar::ErrorRater")
          end
        end
      end
    end

    describe "rating calculation" do
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
end
