require 'rspec/expectations'

RSpec::Matchers.define :have_list do |*expected_list_items|
  match do |page|
    @missing_elements = []
    expected_list_items.each do |expected_list_item|
      if expected_list_item.respond_to?(:matches?)
        list_items = page.find_all('li')
        unless list_items.any? { |list_item| expected_list_item.matches?(list_item) }
          @missing_elements << expected_list_item.description.sub('have ', '').delete('"')
        end
      else
        @missing_elements << 'text ' + expected_list_item unless page.has_selector?(
          'li', text: expected_list_item
        )
      end
    end
    @missing_elements.blank?
  end
  failure_message do
    "Expected list to include item with #{@missing_elements.join(', ')}, but none was found"
  end
end
