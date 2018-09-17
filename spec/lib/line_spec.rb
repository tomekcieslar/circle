require 'rails_helper'

RSpec.describe Line do
  describe '.parse' do
    context 'when parsed text is not header or checlist item' do
      fit 'describe line kind as a Line::Text' do
        expect(Line.parse('abc')).to be_kind_of(Line::Text)
      end
    end

    context 'when parsed text is header' do
      it 'describe line kind as a Line::Header' do
        expect(Line.parse('# abc')).to be_kind_of(Line::Header)
      end
    end

    context 'when parsed text is a header nested in other header' do
      it 'describe line kind as a Line::Header' do
        expect(Line.parse('### abc')).to be_kind_of(Line::Header)
      end
    end

    context 'when parsed text is unchecked checlist item' do
      it 'describe line kind as a Line::ChecklistItem' do
        expect(Line.parse('[ ] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end

    context 'when parsed text is checked checlist item' do
      it 'describe line kind as a Line::ChecklistItem' do
        expect(Line.parse('[x] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end

    context 'when line is empty' do
      it 'raises a ArgumentError exception with message' do
        expect { Line.parse }.to raise_exception(
          ArgumentError, 'wrong number of arguments (given 0, expected 1)'
        )
      end
    end

    context 'when argument is nil' do
      it 'raises ArgumentError exception with message' do
        expect { Line.parse(nil) }.to raise_error(
          ArgumentError, 'you need to provide a string as an argument'
        )
      end
    end
  end

  describe '.new' do
    context 'when try to create new line' do
      it 'raises unaccepttable initialization abstract class exception ' do
        expect { Line.new('a') }.to raise_exception(
          Line::NotImplementedError, 'Line is an abstract class and cannot be instantiated.'
        )
      end
    end
  end
end
