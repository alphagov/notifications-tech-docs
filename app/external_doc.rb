require 'faraday'

class ExternalDoc
  def self.fetch(repository: )
    url = "https://raw.githubusercontent.com/#{repository}/master/README.md"

    response = Faraday.get(url)

    response.body.force_encoding("UTF-8")
  end
end
