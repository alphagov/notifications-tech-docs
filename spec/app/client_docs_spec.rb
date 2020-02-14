require "./app/client_docs"

RSpec.describe ClientDocs do
  describe ".pages" do
    it "returns a Page for each client" do
      client_pages = ClientDocs.pages

      expect(client_pages.count).to eq 6
      expect(client_pages.first).to be_a(ClientDocs::Page)
    end
  end
end

RSpec.describe ClientDocs::Page do
  describe "#repository" do
    it "returns the repository name for a given client" do
      page = ClientDocs::Page.new("ruby")

      expect(page.repository).to eq("alphagov/notifications-ruby-client")
    end
  end

  describe "#title" do
    it "returns the title for a given client" do
      page = ClientDocs::Page.new("node")

      expect(page.title).to eq("Node.js client documentation")
    end
  end
end
