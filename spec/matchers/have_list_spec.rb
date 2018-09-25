require 'rails_helper'

RSpec.describe 'have_list matcher' do
  context 'when list contains expected data' do
    it 'ensures that page have list with given data' do
      page = Capybara.string <<-HTML
        <ul>
          <li>Delete</li>
          <li>
            <a href="https://something.com/abc"> Create </a>
          </li>
        </ul>
      HTML

      expect(page).to have_list(
        'Delete',
        have_link('Create', 'https://something.com/abc')
      )
    end
  end

  context 'when list contains link which does not exist' do
    it 'returns error message' do
      page = Capybara.string <<-HTML
        <ul>
          <li>Create</li>
          <li>
            <a href="https://something.com/abc">Delete</a>
          </li>
        </ul>
      HTML

      expect do
        expect(page).to have_list(
          have_link('Create', 'https://something.com/abc')
        )
      end.to fail_with(
        'Expected list to include item with link Create, https://something.com/abc, but none was found'
      )
    end
  end

  context 'when expected link in list is not found' do
    it 'returns error message' do
      page = Capybara.string <<-HTML
        <ul>
          <li>Delete</li>
        </ul>
      HTML

      expect do
        expect(page).to have_list('Create')
      end.to fail_with(
        'Expected list to include item with text Create, but none was found'
      )
    end
  end
end
