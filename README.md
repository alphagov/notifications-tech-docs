# GOV.UK Notify – Technical Documentation

## Getting started

To preview or build the website, we need to use the terminal.

Install Ruby, perferably with a [Ruby version manager][rvm]. You will need
to download the version of Ruby that matches the one found in the `.ruby-version`
file.

Install the [Bundler gem][bundler].

```
gem install bundler
```

In the application folder type the following to install the required gems:

```
make bootstrap
```

## Making changes

To make changes edit the source files in the `source` folder.

Although a single page of HTML is generated the markdown is spread across
multiple files to make it easier to manage. They can be found in
`source/documentation`.

A new markdown file isn't automatically included in the generated output. If we
add a new markdown file at the location `source/documentation/agile/scrum.md`,
the following snippet in `source/index.html.md.erb`, includes it in the
generated output.

```
<%= partial 'documentation/agile/scrum' %>
```

Including files manually like this lets us specify the position they appear in
the page.

## Preview

Whilst writing documentation we can run a middleman server to preview how the
published version will look in the browser. After saving a change the preview in
the browser will automatically refresh.

The preview is only available on our own computer. Others won't be able to
access it if they are given the link.

Type the following to start the server:

```
make run
```

If all goes well something like the following output will be displayed:

```
== The Middleman is loading
== LiveReload accepting connections from ws://192.168.0.8:35729
== View your site at "http://Laptop.local:4567", "http://192.168.0.8:4567"
== Inspect your site configuration at "http://Laptop.local:4567/__middleman", "http://192.168.0.8:4567/__middleman"
```

You should now be able to view a live preview at http://localhost:4567.

[rvm]: https://www.ruby-lang.org/en/documentation/installation/#managers
[bundler]: http://bundler.io/

## Licence

Unless stated otherwise, the codebase is released under [the MIT licence](./LICENSE).

The data is [© Crown
copyright](http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/copyright-and-re-use/crown-copyright/)
and available under the terms of the [Open Government
3.0](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)
licence.
