require 'rails_helper'

RSpec.describe Line do
  describe ".parse" do
    context "when line is text without any type" do
      fit "describe line kind as a text  " do
        expect(Line.parse('abc')).to be_kind_of(Line::Text)
      end
    end

    context "when line is text with # sign" do
      it "describe line kind as a Header  " do
        expect(Line.parse('# abc')).to be_kind_of(Line::Header)
      end
    end

    context "when line is with more # signs" do
      it "describe line kind as a Header  " do
        expect(Line.parse('### abc')).to be_kind_of(Line::Header)
      end
    end

    context "when line is with [ ] sign " do
      it "describe line kind as a ChceckListItem" do
        expect(Line.parse('[ ] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end

    context "when line is with [x] sign " do
      it "describe line kind as a ChceckListItem" do
        expect(Line.parse('[x] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end

    context "when line is empty" do
      it "raises a wrong number arguments given exception" do
        expect { Line.parse() }.to raise_exception(ArgumentError, 'wrong number of arguments (given 0, expected 1)')
      end
    end

    context "when argument is nil" do
      it "raises a wrong argument given exception" do
        expect { Line.parse(nil) }.to raise_error(ArgumentError,  'you need to provide a string as an argument')
      end
    end
  end
  
  describe ".new" do
    context "when try to create new line" do
      it "raises unaccepttable initialization abstract class exception " do
        expect { Line.new('a') }.to raise_exception(Line::NotImplementedError, 'Line is an abstract class and cannot be instantiated.')
      end
    end
  end
end
