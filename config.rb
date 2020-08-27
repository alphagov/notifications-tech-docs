require 'govuk_tech_docs'
require 'app/client_docs'
require 'app/external_doc'

GovukTechDocs.configure(self)

ClientDocs.pages.each do |page|
  proxy "/#{page.client}.html", "client_template.html", locals: {
    client: page.client,
    repo: page.repository,
    title: page.title
  }, ignore: true
end
