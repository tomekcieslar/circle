require 'rails_helper'

RSpec.describe MarkdownChecklistStatistics do
  describe '#each' do
    context 'when MarkdownChecklist yields something' do
      context 'whenMarkdownChecklist yield only items' do
        it 'yields summary of total and checked items' do
          markdown_checklist = instance_double(MarkdownChecklist)

          allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
          allow(markdown_checklist).to receive(:each)
            .and_yield([], 'Plants' => false, 'Rooms' => true)

          markdown_checklist_statistics = MarkdownChecklistStatistics.new(markdown_checklist)

          expect { |b| markdown_checklist_statistics.each(&b) }.to \
            yield_with_args([], { total: 2, checked: 1 }, 'Plants' => false, 'Rooms' => true)
        end
      end

      context 'whenMarkdownChecklist yield subject and items' do
        it 'yields subject name and summary of  total, checked items' do
          markdown_checklist = instance_double(MarkdownChecklist)

          allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
          allow(markdown_checklist).to receive(:each)
            .and_yield(['Home'], 'Plants' => false, 'Rooms' => true)

          markdown_checklist_statistics = MarkdownChecklistStatistics.new(markdown_checklist)

          expect { |b| markdown_checklist_statistics.each(&b) }.to \
            yield_with_args(['Home'], { total: 2, checked: 1 }, 'Plants' => false, 'Rooms' => true)
        end
      end
    end

    context 'when there was header nested in other header' do
      context 'when there was header nested in other header before checklist items ' do
        it "yields names of subjects and nested subject's items
        summary of total and checked items" do
          markdown_checklist = instance_double(MarkdownChecklist)

          allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
          allow(markdown_checklist).to receive(:each)
            .and_yield(%w[Home Rooms], 'Bedroom' => false, 'Livingroom' => true)

          markdown_checklist_statistics = MarkdownChecklistStatistics.new(markdown_checklist)

          expect { |b| markdown_checklist_statistics.each(&b) }.to \
            yield_with_args(
              %w[Home Rooms], { total: 2, checked: 1 },
              'Bedroom' => false, 'Livingroom' => true
            )
        end
      end

      context 'when there was header nested in other header between checklists items ' do
        it "yiels names of subjects and nested subject's
        items summary of total and checked items" do
          markdown_checklist = instance_double(MarkdownChecklist)

          allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
          allow(markdown_checklist).to receive(:each)
            .and_yield(['Home'], 'First floor' => false, 'Second floor' => true)
            .and_yield(%w[Home Rooms], 'Bedroom' => false, 'Livingroom' => true)

          markdown_checklist_statistics = MarkdownChecklistStatistics.new(markdown_checklist)

          expect { |b| markdown_checklist_statistics.each(&b) }.to \
            yield_successive_args(
              [%w[Home],
               { total: 2, checked: 1 },
               { 'First floor' => false, 'Second floor' => true }],
              [%w[Home Rooms],
               { total: 2, checked: 1 },
               { 'Bedroom' => false, 'Livingroom' => true }]
            )
        end
      end

      context 'when there were more headers nested in other header before checklist items ' do
        it "yiels names of all subjects and nested subject's
        items summary of total and checked items" do
          markdown_checklist = instance_double(MarkdownChecklist)

          allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
          allow(markdown_checklist).to receive(:each)
            .and_yield(%w[Home Rooms Furniture], 'Desk' => false, 'Sofa' => true)

          markdown_checklist_statistics = MarkdownChecklistStatistics.new(markdown_checklist)

          expect { |b| markdown_checklist_statistics.each(&b) }.to \
            yield_with_args(
              %w[Home Rooms Furniture], { total: 2, checked: 1 },
              'Desk' => false, 'Sofa' => true
            )
        end
      end
    end
  end
end
