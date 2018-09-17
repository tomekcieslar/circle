require 'rails_helper'

RSpec.describe Line::Text do
  describe '#to_s ' do
    context 'when parsed text is not header or checlist item' do
      it 'return same text' do
        expect(Line::Text.new('abc').to_s).to eq 'abc'
      end
    end

    context 'hen parsed text is header' do
      it 'return same text' do
        expect(Line::Text.new('###  abc').to_s).to eq '###  abc'
      end
    end

    context 'hen parsed text is checklist item' do
      it 'return same text' do
        expect(Line::Text.new('[ ] abc').to_s).to eq '[ ] abc'
      end
    end
  end
end
