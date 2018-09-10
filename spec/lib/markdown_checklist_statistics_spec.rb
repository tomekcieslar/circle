require 'rails_helper'

RSpec.describe MarkdownChecklistStatistics do
  describe '#each' do
    context 'when there are no checklist items in source' do
      it 'yields header name and items summary which is 0' do

        markdown_checklist = instance_double(MarkdownChecklist)

        allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
        allow(markdown_checklist).to receive(:each).
            and_yield()

        markdown_checklist_statistics = MarkdownChecklistStatistics.new(source)

        expect { |b| markdown_checklist_statistics.each(&b) }.not_to yield_control

      end
    end

    context 'when there checklist items in source' do
      context 'when there was no header specified before checklist items' do
        it 'yields summary of items and their status ' do
          markdown_checklist = instance_double(MarkdownChecklist)

          allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
          allow(markdown_checklist).to receive(:each).
              and_yield([], {'Plants' => false, 'Rooms' => true})

          markdown_checklist_statistics = MarkdownChecklistStatistics.new(source)

          expect { |b| markdown_checklist_statistics.each(&b) }.to \
              yield_with_args([], { total: 2, checked: 1 })
        end
      end

      context "when there was one header specifed before checklist items" do
        it 'yields subject name and all of items summary of items and their status' do

          markdown_checklist = instance_double(MarkdownChecklist)

          allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
          allow(markdown_checklist).to receive(:each).
              and_yield(['Home'], { 'Plants' => false, 'Rooms' => true})

          markdown_checklist_statistics = MarkdownChecklistStatistics.new(markdown_checklist)


          expect { |b| markdown_checklist_statistics.each(&b) }.to \
              yield_with_args(['Home'], { total: 2, checked: 1 })
          end
        end
      end

      context "when there was header nested in other header" do
        context "when there was header nested in other header before checklist items " do
          it "yiels names of subjects and nested subject's items summary of items and their status " do
            markdown_checklist = instance_double(MarkdownChecklist)

            allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
            allow(markdown_checklist).to receive(:each).
                and_yield(['Home', 'Rooms'], {'Bedroom' => false, 'Livingroom' => true})

            markdown_checklist_statistics = MarkdownChecklistStatistics.new(source)

            expect { |b| markdown_checklist_statistics.each(&b) }.to \
                yield_with_args(['Home', 'Rooms'], {total: 2, checked: 1 })

          end
        end

        context "when there was header nested in other header between checklists items " do
          it "yiels names of subjects and nested subject's items summary of items and their status " do
            markdown_checklist = instance_double(MarkdownChecklist)

            allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
            allow(markdown_checklist).to receive(:each).
                and_yield(['Home'], {'First floor' => false, 'Second floor' => true }).
                and_yield(['Home', 'Rooms'], {'Bedroom' => false, 'Livingroom' => true})

            markdown_checklist_statistics = MarkdownChecklistStatistics.new(source)

            expect { |b| markdown_checklist_statistics.each(&b) }.to \
              yield_successive_args([['Home'],  { total: 2, checked: 1}],[['Home', 'Rooms'],  {total: 2, checked: 1}])
          end
        end

        context "when there were more headers nested in other header before checklist items " do
          it "yiels names of all subjects and nested subject's items summary of items and their status " do
            markdown_checklist = instance_double(MarkdownChecklist)

            allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
            allow(markdown_checklist).to receive(:each).
                and_yield(['Home', 'Rooms', 'Furniture'], {'Desk' => false, 'Sofa' => true})

            markdown_checklist_statistics = MarkdownChecklistStatistics.new(source)

            expect { |b| markdown_checklist_statistics.each(&b) }.to \
                yield_with_args(['Home', 'Rooms', 'Furniture'], {total: 2, checked: 1 })
          end
        end

        context "when there was header nested and nested level increase more then 1  " do
          it "yiels names of all subjects and nested subject's items wsummary of items and their status but nested deeper " do
            markdown_checklist = instance_double(MarkdownChecklist)

            allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
            allow(markdown_checklist).to receive(:each).
                and_yield(['Home', 'Furniture'], {'Desk' => false, 'Sofa' => true})

            markdown_checklist_statistics = MarkdownChecklistStatistics.new(source)

            expect { |b| markdown_checklist_statistics.each(&b) }.to \
                yield_with_args(['Home', 'Furniture'], {total: 2, checked: 1 })
          end
        end

        context "when there were more headers nested and nested level increase irregular  " do
          it "it should treat like subject like header from previous nested level " do
            markdown_checklist = instance_double(MarkdownChecklist)

            allow(MarkdownChecklist).to receive(:new) { markdown_checklist }
            allow(markdown_checklist).to receive(:each).
                and_yield(['Home', 'Rooms'], {'Bedroom' => false, 'Livingroom' => true }).
                and_yield(['Home', 'Furniture'], { 'Desk' => false, 'Sofa' => true})

            markdown_checklist_statistics = MarkdownChecklistStatistics.new(source)

            expect { |b| markdown_checklist_statistics.each(&b) }.to \
              yield_successive_args([['Home', 'Rooms'],  { total: 2, checked: 1}],[['Home', 'Furniture'],  {total: 2, checked: 1}])
          end
        end
    end
  end
end
