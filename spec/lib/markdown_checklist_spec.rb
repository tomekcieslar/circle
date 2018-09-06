require 'rails_helper'

RSpec.describe MarkdownChecklist do
  describe '#each' do
    context 'when there are no checklist items in source' do
      it 'yields noting' do
        source = <<~MARKDOWN
        ##  Home
        MARKDOWN

        markdown_checklist = MarkdownChecklist.new(source)

        expect { |b| markdown_checklist.each(&b) }.not_to yield_control
      end
    end

    context 'when there checklist items in source' do
      context 'when there was no header specified before checklist items' do
        it 'yields all items with their status for nil subject ' do
          source = <<~MARKDOWN
            [ ] Plants
            [x] Rooms
          MARKDOWN

          markdown_checklist = MarkdownChecklist.new(source)

          expect { |b| markdown_checklist.each(&b) }.to \
            yield_with_args([], {'Plants' => false, 'Rooms' => true})
        end
      end

      context "when there was one header specifed before checklist items" do
        it 'yields subject name and all of items with their status' do
          source = <<~MARKDOWN
            ## Home
            [ ] Plants
            [x] Rooms
          MARKDOWN

          markdown_checklist = MarkdownChecklist.new(source)

          expect { |b| markdown_checklist.each(&b) }.to \
            yield_with_args(['Home'], {'Plants' => false, 'Rooms' => true} )
        end
      end

      context "when there was header nested in other header" do
        context "when there was header nested in other header before checklist items " do
          it "yiels names of subjects and nested subject's items with their status " do
            source = <<~MARKDOWN
            ## Home
            ### Rooms
              [ ] Bedroom
              [x] Livingroom
            MARKDOWN

            markdown_checklist = MarkdownChecklist.new(source)

            expect { |b| markdown_checklist.each(&b) }.to \
              yield_with_args(['Home', 'Rooms'], {'Bedroom' => false, 'Livingroom' => true} )
          end
        end

        context "when there was header nested in other header between checklists items " do
          it "yiels names of subjects and nested subject's items with their status " do
            source = <<~MARKDOWN
            ## Home
              [ ] First floor
              [x] Second floor
            ### Rooms
              [ ] Bedroom
              [x] Livingroom
            MARKDOWN

            markdown_checklist = MarkdownChecklist.new(source)

            expect { |b| markdown_checklist.each(&b) }.to \
              yield_successive_args([['Home'],  {'First floor' => false, 'Second floor' => true}],[ ['Home', 'Rooms'],  {'Bedroom' => false, 'Livingroom' => true} ])
          end
        end

        context "when there were more headers nested in other header before checklist items " do
          it "yiels names of all subjects and nested subject's items with their status " do
            source = <<~MARKDOWN
            ## Home
            ### Rooms
            #### Furniture
              [ ] Desk
              [x] Sofa
            MARKDOWN

            markdown_checklist = MarkdownChecklist.new(source)

            expect { |b| markdown_checklist.each(&b) }.to \
            yield_with_args(['Home', 'Rooms', 'Furniture'],  {'Desk' => false, 'Sofa' => true})
          end
        end

        context "when there was header nested and nested level increase more then 1  " do
          it "yiels names of all subjects and nested subject's items with their status but nested deeper " do
            source = <<~MARKDOWN
            ## Home
            #### Furniture
              [ ] Desk
              [x] Sofa
            MARKDOWN

            markdown_checklist = MarkdownChecklist.new(source)

            expect { |b| markdown_checklist.each(&b) }.to \
            yield_with_args(['Home', 'Furniture'],  {'Desk' => false, 'Sofa' => true})
          end
        end

        context "when there were more headers nested and nested level increase irregular  " do
          it "it should treat like subject like header from previous nested level " do
            source = <<~MARKDOWN
            ## Home
            #### Rooms
              [ ] Bedroom
              [x] Livingroom
            ### Furniture
              [ ] Desk
              [x] Sofa
            MARKDOWN

            markdown_checklist = MarkdownChecklist.new(source)
            expect { |b| markdown_checklist.each(&b) }.to \
              yield_successive_args([['Home', 'Rooms'],  {'Bedroom' => false, 'Livingroom' => true}],[['Home', 'Furniture'], {'Desk' => false, 'Sofa' => true}])
          end
        end
      end

      context "when there are subjects with same names on same nasted level " do
        it "raises duplicate subjects names exception" do
          source = <<~MARKDOWN
          ## Home
            [ ] First floor
            [x] Second floor
          ## Home
            [ ] First floor
            [x] Second floor
          MARKDOWN

          markdown_checklist = MarkdownChecklist.new(source)

          expect { |b| markdown_checklist.each(&b) }.to \
            raise_exception(MarkdownChecklist::DuplicateSubjectNames)
        end
      end

      context "when there are items with same names in same subject " do
        it "raises duplicate items names exception" do
          source = <<~MARKDOWN
          ## Rooms
            [ ] Livingroom
            [x] Livingroom
          MARKDOWN

          markdown_checklist = MarkdownChecklist.new(source)

          expect { |b| markdown_checklist.each(&b) }.to \
            raise_exception(MarkdownChecklist::DuplicateItemNames)
        end
      end
    end
  end
end
