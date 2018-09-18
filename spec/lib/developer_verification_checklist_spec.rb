require 'rails_helper'

RSpec.describe DeveloperVerificationChecklist do
  describe '#each' do
    describe 'statistics (2nd block value)' do
      it 'includes amount of missing required checklist items
      for given level identified by LEVEL_SYMBOL_MAPPING' do
        stub_const('DeveloperVerificationChecklist::LEVEL_SYMBOL_MAPPING', { independent: :dancer })
        markdown_checklist_statistics = instance_double(MarkdownChecklistStatistics)

        allow(MarkdownChecklistStatistics).to receive(:new) { markdown_checklist_statistics }
        allow(markdown_checklist_statistics).to receive(:each)
          .and_yield(
            ['Home'],
            { total: 3, checked: 2 },
            'Plants :smiley_face: ' => true, 'Rooms :dancer: wow' => true,
            'Furniture and desk :dancer: ' => false, 'Floors & Doors  :dancer: first' => false
          )
          developer_verification_checklist =
            DeveloperVerificationChecklist.new(markdown_checklist_statistics, :independent)

          expect { |b| developer_verification_checklist.each(&b) }.to \
            yield_with_args(
              anything, hash_including(missing_required_tasks: 2), kind_of(Array)
            )
      end
    end
    describe "missing_required_tasks (3rd block value)" do
      it 'includes all missing required checklist items' do
        stub_const('DeveloperVerificationChecklist::LEVEL_SYMBOL_MAPPING', { independent: :dancer })
        markdown_checklist_statistics = instance_double(MarkdownChecklistStatistics)

        allow(MarkdownChecklistStatistics).to receive(:new) { markdown_checklist_statistics }
        allow(markdown_checklist_statistics).to receive(:each)
          .and_yield(
            ['Home'],
            { total: 3, checked: 2 },
            'Plants :smiley_face: ' => true, 'Rooms :dancer: wow' => true,
            'Furniture and desk :dancer: ' => false, 'Floors & Doors  :dancer: first' => false
          )
          developer_verification_checklist =
            DeveloperVerificationChecklist.new(markdown_checklist_statistics, :independent)

          expect { |b| developer_verification_checklist.each(&b) }.to \
            yield_with_args(
              kind_of(Array), kind_of(Hash), ['Furniture and desk', 'Floors & Doors']
            )
      end
    end
  end
end
