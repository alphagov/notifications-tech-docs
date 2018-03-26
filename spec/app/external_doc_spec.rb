require './app/external_doc'

RSpec.describe ExternalDoc do
  describe '.fetch' do
    let(:repository) { 'alphagov/client-library' }

    before do
      stub_request(:get, "https://raw.githubusercontent.com/#{repository}/master/DOCUMENTATION.md").
        to_return(body: File.read('spec/fixtures/markdown.md'))
    end

    it 'returns a GitHub page as a string' do
      page_contents = ExternalDoc.fetch(repository: repository)

      expect(page_contents).to be_a(String)
      expect(page_contents).to include("Example markdown file")
    end
  end
end
