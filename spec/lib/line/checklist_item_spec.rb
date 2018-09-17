require 'rails_helper'

RSpec.describe Line::ChecklistItem do
  describe '.new' do
    context 'when parsed text is not a checklist item' do
      it 'raises Line::InvalidFormat exception' do
        expect { Line::ChecklistItem.new('abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text is not a checklist item' do
      it 'raises Line::InvalidFormat exception' do
        expect { Line::ChecklistItem.new('### abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text has too wide inset' do
      it 'raises Line::InvalidFormat exception' do
        expect { Line::ChecklistItem.new('[    ] abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text has too tight inset' do
      it 'raises Line::InvalidFormat exception' do
        expect { Line::ChecklistItem.new('[] abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text inset is checked by wrong sign' do
      it 'raises Line::InvalidFormat exception' do
        expect { Line::ChecklistItem.new('[y] abc') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text inset name is empty' do
      it 'raises Line::InvalidFormat exception' do
        expect { Line::ChecklistItem.new('[ ] ') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text inset is checked but name is empty' do
      it 'raises Line::InvalidFormat exception' do
        expect { Line::ChecklistItem.new('[x]') }.to raise_exception(Line::InvalidFormat)
      end
    end

    context 'when parsed text inset is not checked' do
      it 'parsed text kind is Line::ChecklistItem' do
        expect(Line::ChecklistItem.new('[ ] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end

    context 'when parsed text inset is checked' do
      it 'parsed text kind is Line::ChecklistItem' do
        expect(Line::ChecklistItem.new('[x] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end

    context 'when parsed text inset is nested' do
      it 'parsed text kind is Line::ChecklistItem' do
        expect(Line::ChecklistItem.new('- [ ] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end

    context 'when there is other correct format of ChecklistItem' do
      it 'parsed text kind is Line::ChecklistItem' do
        expect(Line::ChecklistItem.new('* [ ] abc')).to be_kind_of(Line::ChecklistItem)
      end
    end
  end

  describe '#to_s' do
    context 'when there is inst' do
      it 'returns name without inset' do
        expect(Line::ChecklistItem.new('[ ] abc').to_s).to eq 'abc'
      end
    end

    context 'when there is other kind of inst' do
      it 'returns name without inset' do
        expect(Line::ChecklistItem.new('* [ ] abc').to_s).to eq 'abc'
      end
    end

    context 'when there is - [ ]' do
      it 'returns name without inset' do
        expect(Line::ChecklistItem.new('- [ ] abc').to_s).to eq 'abc'
      end
    end

    context 'when there is to many speces betwet inset and name' do
      it 'returns name without inset and spaces' do
        expect(Line::ChecklistItem.new('[ ]    abc').to_s).to eq 'abc'
      end
    end

    context 'when inset is checked' do
      it 'returns name without inset' do
        expect(Line::ChecklistItem.new('[x] abc').to_s).to eq 'abc'
      end
    end
  end

  describe '#checked?' do
    context 'when inset is checked' do
      it 'returns true' do
        expect(Line::ChecklistItem.new('[x] abc').checked?).to eq true
      end
    end

    context 'when inset is not checked' do
      it 'returns false' do
        expect(Line::ChecklistItem.new('[ ]  abc').checked?).to eq false
      end
    end
  end
end
