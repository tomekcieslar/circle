require 'rails_helper'

RSpec.describe Line::Header do
  describe '.new' do
    context 'when parsed text has name before header sign' do
      it 'raises Line::InvalidFormat exception ' do
        expect { Line::Header.new('abc #') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text is not header' do
      it 'raises iLine::InvalidFormat exception ' do
        expect { Line::Header.new('abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text is not header but checklist item' do
      it 'raises Line::InvalidFormat exception ' do
        expect { Line::Header.new('[ ] abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text has header signs but name is empty' do
      it 'raises Line::InvalidFormat exception ' do
        expect { Line::Header.new('##') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text is header' do
      it 'describe line kind as a Header' do
        expect(Line::Header.new('## abc')).to be_kind_of(Line::Header)
      end
    end
  end

  describe '#to_s' do
    context 'when parsed text is header' do
      it 'returns name of hader without # signs' do
        expect(Line::Header.new('### abc').to_s).to eq 'abc'
      end
    end

    context 'when parsed text is header but there are too many spaces between name and header' do
      it 'returns name without header signs and spaces' do
        expect(Line::Header.new('###   abc').to_s).to eq 'abc'
      end
    end

    context 'when parsed text is header with single header sign' do
      it 'returns name without header sign' do
        expect(Line::Header.new('# abc').to_s).to eq 'abc'
      end
    end
  end

  describe '#nesting' do
    context 'when header is nested' do
      it 'retrun number of headers signs ' do
        expect(Line::Header.new('### abc').nesting).to eq 3
      end
    end

    context 'when header is nested' do
      it 'retrun number of headers signs ' do
        expect(Line::Header.new('# abc').nesting).to eq 1
      end
    end
  end
end
