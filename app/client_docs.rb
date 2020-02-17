class ClientDocs
  CLIENTS = %w[
    java
    net
    node
    php
    python
    ruby
  ].freeze

  def self.pages
    CLIENTS.map { |client| Page.new(client) }
  end

  class Page
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def repository
      "alphagov/notifications-#{client}-client"
    end

    def title
      client_titles = {
        "java" => "Java",
        "net" => ".NET",
        "node" => "Node.js",
        "php" => "PHP",
        "python" => "Python",
        "ruby" => "Ruby",
      }

      "#{client_titles[client]} client documentation"
    end
  end
end
