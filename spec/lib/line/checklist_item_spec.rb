require 'rails_helper'

RSpec.describe Line::ChecklistItem  do
  describe '.new' do
    context "when there is Text format of text" do
      it "raises invalid format exception" do
        expect { Line::ChecklistItem.new('abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is Header format of text" do
      it "raises invalid format exception" do
        expect { Line::ChecklistItem.new('### abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is invalid format of ChecklistItem [    ]" do
      it "raises invalid format exception" do
        expect { Line::ChecklistItem.new('[    ] abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is invalid format of ChecklistItem []" do
      it "raises invalid format exception" do
        expect { Line::ChecklistItem.new('[] abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is invalid checked format of ChecklistItem [y]" do
      it "raises invalid format exception" do
        expect { Line::ChecklistItem.new('[y] abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is empty ChecklistItem name" do
      it "raises invalid format exception" do
      expect {Line::ChecklistItem.new('[ ] ') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is empty checked ChecklistItem name" do
      it "raises invalid format exception" do
        expect {Line::ChecklistItem.new('[x]') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context "when there is correct unchecked format of ChecklistItem" do
      it "raises invalid format exception" do
        expect(Line::ChecklistItem.new('[ ] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end

    context "when there is correct checked format of ChecklistItem" do
      it "raises invalid format exception" do
        expect(Line::ChecklistItem.new('[x] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end

    context "when there is correct checked format of ChecklistItem" do
      it "raises invalid format exception" do
        expect(Line::ChecklistItem.new('- [ ] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end

    context "when there is other correct format of ChecklistItem" do
      it "raises invalid format exception" do
        expect(Line::ChecklistItem.new('* [ ] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end
  end

  describe '#to_s' do
    context "when there is [ ]" do
      it "returns name of name without [ ] " do
        expect(Line::ChecklistItem.new('[ ] abc').to_s).to eq 'abc'
      end
    end

    context "when there is * [ ]" do
      it "returns name of name without [ ] " do
        expect(Line::ChecklistItem.new('* [ ] abc').to_s).to eq 'abc'
      end
    end

    context "when there is - [ ]" do
      it "returns name of name without [ ] " do
        expect(Line::ChecklistItem.new('- [ ] abc').to_s).to eq 'abc'
      end
    end

    context "when there is [ ]    " do
      it "returns name of name without [ ] " do
        expect(Line::ChecklistItem.new('[ ]    abc').to_s).to eq 'abc'
      end
    end

    context "when there is [x]" do
      it "returns name of name without [ ] " do
        expect(Line::ChecklistItem.new('[x] abc').to_s).to eq 'abc'
      end
    end
  end

  describe '#checked?' do
    context "when it is checked" do
      it "returns true" do
        expect(Line::ChecklistItem.new('[x] abc').checked?).to eq true
      end
    end

    context "when it is not checked" do
      it "returns false" do
        expect(Line::ChecklistItem.new('[ ]  abc').checked?).to eq false
      end
    end
  end
end
