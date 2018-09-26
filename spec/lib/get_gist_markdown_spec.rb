require 'rails_helper'

RSpec.describe GetGistMarkdown do
  describe '.call' do
    it 'return body of website as a MARKDOWN' do
      stub_request(:get, 'https://gist.githubusercontent.com/abc/1234/raw')
        .to_return(status: 200, body: "##Rails \n  [ ] Boom boom \n [x] Task")

      result = GetGistMarkdown.call('https://gist.github.com/abc/1234#heheh')

      expect(result).to eq "##Rails \n  [ ] Boom boom \n [x] Task"
    end
  end
end
