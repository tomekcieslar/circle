require 'rails_helper'

RSpec.describe Line::Text do
  describe "#to_s " do
    context "when line is text without any type" do
      it "return same text as a string" do
        expect(Line::Text.new('abc').to_s).to eq 'abc'
      end
    end

    context "when line is text with # signs" do
      it "return same text wtih Header signs as a string" do
        expect(Line::Text.new('###  abc').to_s).to eq '###  abc'
      end
    end

    context "when line is with [ ] sign " do
      it "return same text with ChceckListItem sign" do
        expect(Line::Text.new('[ ] abc').to_s).to eq '[ ] abc'
      end
    end
  end
end
