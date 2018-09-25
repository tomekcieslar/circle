require 'rails_helper'
require 'rspec_tapas/behavior_dsl'

RSpec.describe 'Showing progress summary' do
  scenario do
    behavior 'User submits valid progress checklist url for given level' do
      allow(GetGistMarkdown).to receive(:call) {
        <<~MARKDOWN
          ## Rails
            [x] Whatever :small_blue_diamond:
            [x] Writing
            [ ] Reading :small_orange_diamond: books
            [ ] Cheating
            [x] Speaking :small_blue_diamond: (check that)
          ### CRUD
            * [x] Create  :small_orange_diamond:
            * [ ] [Read :small_blue_diamond:] (http://example.com/some_resource)
            - [ ] Update
            - [ ] Delete :small_blue_diamond:
          ## Active Records
            [x] Important :small_orange_diamond:
            [x] Less Important
            [ ] Mid :small_blue_diamond:
            [ ] Top :small_orange_diamond:
        MARKDOWN
      }

      visit '/'
      fill_in 'Gist URL', with: 'https://gist.github.com/stevo/abc'
      select 'independent', from: 'Level'
      click_on 'Submit'

      expect(page).to have_selector('h1', text: 'Total: 6/13')
      expect(page).to have_selector('h2', text: 'Rails: 3/5')
      page.within('div', text: 'CRUD') do
        expect(page).to have_selector('h2', text: 'CRUD: 1/4')
        expect(page).to have_selector('h3', text: 'Missing Tasks (2)')
        expect(page).to have_list(
          have_link('Read', 'http://example.com/some_resource'),
          'Delete'
        )
      end
      page.within('div', text: 'Active Records') do
        expect(page).to have_selector('h2', text: 'Active Records: 2/4')
        expect(page).to have_selector('h3', text: 'Missing Tasks (1)')
        expect(page).to have_list('Mid')
      end
    end
  end
end
