require "spec_helper"

RSpec.describe FiveStar::BaseRater do
  let(:rateable) { double("Rateable", name: "Rateable") }
  subject { described_class.new(rateable) }

  describe ".build" do
    it "returns new instance" do
      expect(described_class.build(rateable)).to be_instance_of described_class
    end
  end

  describe ".rating_weight" do
    after { described_class.rating_weight(nil) }

    it "sets weighting value" do
      expect {
        described_class.rating_weight(0.5)
      }.to change { described_class.weighting }.to 0.5
    end
  end

  describe ".rating_weight" do
    context "when no weighting set" do
      it "uses default value" do
        expect(described_class.weighting).to eq 1.0
      end
    end

    context "when set" do
      before { described_class.rating_weight(0.1) }
      after { described_class.rating_weight(nil) }

      it "uses correct value" do
        expect(described_class.weighting).to eq 0.1
      end
    end
  end

  describe "#rating" do
    it "is zero by default" do
      expect(subject.rating).to be_zero
    end
  end

  describe "#description" do
    it "includes rater class name" do
      expect(subject.description).to include "Rateable"
    end

    it "has rating" do
      expect(subject.description).to include "0"
    end

    it "has weighting" do
      expect(subject.description).to include "1.0"
    end
  end

  describe "#weighting" do
    it "is correct weighting for class" do
      expect(subject.weighting).to eq described_class.weighting
    end
  end
end
