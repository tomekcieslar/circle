require 'rails_helper'

RSpec.describe DeveloperVerificationChecklist do
  describe '#each' do
    context 'when MarkdownChecklistStatistics yields only items with emoji' do
      it 'yield subject, statistics with number of missing tasks and their names ' do
        markdown_checklist_statistics = instance_double(MarkdownChecklistStatistics)

        allow(MarkdownChecklistStatistics).to receive(:new) { markdown_checklist_statistics }
        allow(markdown_checklist_statistics).to receive(:each)
          .and_yield(
            ['Home'], { total: 2, checked: 1 },
            'Plants:smiley_face' => false, 'Rooms:smiley_face' => true
          )

        developer_verification_checklist \
        = DeveloperVerificationChecklist.new(markdown_checklist_statistics)

        expect { |b| developer_verification_checklist.each(&b) }.to \
          yield_with_args(
            ['Home'], { total: 2, checked: 1, missing_required_tasks: 1 },
            ['Plants:smiley_face']
          )
      end
    end

    context 'when MarkdownChecklistStatistics yields some items
    with emoji and some without emoji' do
      it 'yield subject, statistics with number of missing tasks with emoji and their names' do
        markdown_checklist_statistics = instance_double(MarkdownChecklistStatistics)

        allow(MarkdownChecklistStatistics).to receive(:new) { markdown_checklist_statistics }
        allow(markdown_checklist_statistics).to receive(:each)
          .and_yield(
            ['Home'], { total: 3, checked: 1 },
            'Plants:smiley_face' => false, 'Rooms:smiley_face' => true, 'Furniture' => false
          )

        developer_verification_checklist \
        = DeveloperVerificationChecklist.new(markdown_checklist_statistics)

        expect { |b| developer_verification_checklist.each(&b) }.to \
          yield_with_args(
            ['Home'], { total: 3, checked: 1, missing_required_tasks: 0 },
            ['Plants:smiley_face']
          )
      end
    end

    context 'when every task with emoji is check and task wtihout emoji is unchecked' do
      it 'yield subject, statistics with number of missing tasks' do
        markdown_checklist_statistics = instance_double(MarkdownChecklistStatistics)

        allow(MarkdownChecklistStatistics).to receive(:new) { markdown_checklist_statistics }
        allow(markdown_checklist_statistics).to receive(:each)
          .and_yield(
            ['Home'], { total: 3, checked: 2 },
            'Plants:smiley_face' => true, 'Rooms:smiley_face' => true, 'Furniture' => false
          )

        developer_verification_checklist \
        = DeveloperVerificationChecklist.new(markdown_checklist_statistics)

        expect { |b| developer_verification_checklist.each(&b) }.to \
          yield_with_args(['Home'], { total: 3, checked: 2, missing_required_tasks: 0 }, [])
      end
    end

    context 'when some task are nested in other subject' do
      it 'yield subject, statistics with number of missing tasks' do
        markdown_checklist_statistics = instance_double(MarkdownChecklistStatistics)

        allow(MarkdownChecklistStatistics).to receive(:new) { markdown_checklist_statistics }
        allow(markdown_checklist_statistics).to receive(:each)
          .and_yield(
            ['Home'], { total: 2, checked: 1 },
            'Plants:smiley_face' => false, 'Rooms:smiley_face' => true
          )
          .and_yield(
            %w[Home Furniture], { total: 3, checked: 1 },
            'Table:smiley_face' => false, 'Chair:smiley_face' => true, 'Mirror' => false
          )

        developer_verification_checklist =
          DeveloperVerificationChecklist.new(markdown_checklist_statistics)

        expect { |b| developer_verification_checklist.each(&b) }.to \
          yield_successive_args(
            [%w[Home], { total: 2, checked: 0, missing_required_tasks: 2 },
             ['Plants:smiley_face', 'Rooms:smiley_face']],
            [%w[Home Furniture], { total: 3, checked: 1, missing_required_tasks: 1 },
             ['Table:smiley_face']]
          )
      end
    end

    context 'when there are tasks with different emoji' do
      it 'yield subject, statistics with number of missing tasks of chosen emoji and their names' do
        markdown_checklist_statistics = instance_double(MarkdownChecklistStatistics)

        allow(MarkdownChecklistStatistics).to receive(:new) { markdown_checklist_statistics }
        allow(markdown_checklist_statistics).to receive(:each)
          .and_yield(
            ['Home'], { total: 3, checked: 2 },
            'Plants:smiley_face' => true, 'Rooms:dancer' => true, 'Furniture:dancer' => false
          )

        developer_verification_checklist \
        = DeveloperVerificationChecklist.new(markdown_checklist_statistics)

        expect { |b| developer_verification_checklist.each(&b) }.to \
          yield_with_args(
            ['Home'], { total: 3, checked: 2, missing_required_tasks: 0 }, []
          )
      end
    end
  end
end
