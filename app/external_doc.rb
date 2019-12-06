require "faraday"

class ExternalDoc
  def self.fetch(repository:)
    url = "https://raw.githubusercontent.com/#{repository}/fix-heading-structure/DOCUMENTATION.md"

    response = Faraday.get(url)

    response.body.force_encoding("UTF-8")
  end
end
