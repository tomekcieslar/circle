require 'rails_helper'
require 'rspec_tapas/behavior_dsl'

RSpec.describe 'Showing progress summary' do
  scenario do
    behavior 'User submits valid progress checklist url for given level' do
      allow(GetGistMarkdown).to receive(:call) {
        <<~MARKDOWN
          ## Rails :small_blue_diamond:
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
      fill_in 'progress_summary[url]', with: 'https://gist.github.com/stevo/abc'
      select 'independent', from: 'progress_summary[level]'
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
  scenario do
    behavior 'User submits more valid progress checklist urls for given level' do
      allow(GetGistMarkdown).to receive(:call).with('https://gist.github.com/stevo/abc') {
        <<~MARKDOWN
          ## Rails
            [x] Whatever
            [ ] [Writing :small_blue_diamond:] (http://writing.com/some_resource)
            [x] Reading :small_orange_diamond: books
            [ ] Cheating
            [x] Speaking :small_blue_diamond: (check that)
        MARKDOWN
      }
      allow(GetGistMarkdown).to receive(:call).with('https://gist.github.com/deadpool/yey') {
        <<~MARKDOWN
          ### DURC
            * [x] Delete  :small_orange_diamond:
            * [ ] [Update :small_blue_diamond:] (http://example.com/some_resource)
            - [ ] Read
            - [ ] Create :small_blue_diamond:
        MARKDOWN
      }

      visit '/'
      fill_in 'progress_summary[url]', with: 'https://gist.github.com/stevo/abc https://gist.github.com/deadpool/yey'
      select 'independent', from: 'progress_summary[level]'
      click_on 'Submit'

      expect(page).to have_selector('h1', text: 'Total: 3/5')
      expect(page).to have_selector('h2', text: 'Rails: 3/5')
      page.within('div', text: 'Rails') do
        expect(page).to have_selector('h3', text: 'Missing Tasks (1)')
        expect(page).to have_list(
          have_link('Writing', 'http://writing.com/some_resource')
        )
      end
      expect(page).to have_selector('h1', text: 'Total: 1/4')
      expect(page).to have_selector('h2', text: 'DURC: 1/4')
      page.within('div', text: 'DURC') do
        expect(page).to have_selector('h3', text: 'Missing Tasks (2)')
        expect(page).to have_list(
          have_link('Update', 'http://example.com/some_resource'),
          'Create'
        )
      end
    end
  end
end
