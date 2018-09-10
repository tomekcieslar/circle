require 'rails_helper'

RSpec.describe Line::Header do
  describe '.new' do
    context "when there is invalid Header format" do
      it "raises invalid format exception " do
        expect { Line::Header.new('abc #') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is Text format of text" do
      it "raises invalid formmat exception " do
        expect { Line::Header.new('abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is ChecklistItem format of text" do
      it "raises invalid format exception " do
        expect { Line::Header.new('[ ] abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is Header format without name only header signs" do
      it "raises invalid format exception " do
        expect { Line::Header.new('##') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is correct Header format" do
      it "describe line kind as a Header" do
        expect(Line::Header.new('## abc')).to be_kind_of(Line::Header)
      end
    end
  end

  describe '#to_s' do
    context "when there is header type with # signs" do
      it "returns name of hader without # signs" do
        expect(Line::Header.new('### abc').to_s).to eq 'abc'
      end
    end

    context "when there is header type with with large space between hader name and signs" do
      it "returns name of hader without # signs and spaces" do
        expect(Line::Header.new('###   abc').to_s).to eq 'abc'
      end
    end

    context "when there is header type with single header sign #" do
      it "returns name of hader without # sign" do
        expect(Line::Header.new('# abc').to_s).to eq 'abc'
      end
    end
  end
  
  describe '#nesting' do
    context "when there is text with some header signs " do
      it "retrun number of headers signs " do
        expect(Line::Header.new('### abc').nesting).to eq 3
      end
    end

    context "when there is text with single header signs " do
      it "retrun number of headers signs " do
        expect(Line::Header.new('# abc').nesting).to eq 1
      end
    end
  end
end
