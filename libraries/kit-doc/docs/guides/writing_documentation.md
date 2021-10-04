[Kit::Doc]: https://github.com/rubykit/kit/tree/main/libraries/kit-doc

# Writing Documentation

In this document you will learn how to write documentation for [Kit::Doc](https://github.com/rubykit/kit/tree/main/libraries/kit-doc).

## Markdown

[Kit::Doc] documentation is written using Markdown. There are plenty of guides on Markdown online, we recommend the ones available at GitHub as a getting started point:

  * [Basic writing and formatting syntax](https://help.github.com/articles/basic-writing-and-formatting-syntax/)
  * [Mastering Markdown](https://guides.github.com/features/mastering-markdown/)
  * [GitHub Flavored Markdown Spec](https://github.github.com/gfm/)

## Documentation format

Documentation is added in comments written before the module / method / constant definition.

```ruby
# This is the Hello module.
#
# @since '1.0.0'
module MyApp::Hello

  # Outputs hello to the given `name`.
  #   Defaults to `World` if `name` is nil.
  #
  # ### Examples
  # ```irb
  # irb> MyApp::Hello.world(name: 'John')
  # 'Hello John!'
  # ```
  #
  # ### References
  # - https://en.wikipedia.org/wiki/%22Hello,_World!%22_program
  #
  # @since "1.3.0"
  def self.world(name: 'World') do
    puts "Hello #{ name }!"
  end

end
```

## Documentation metadata

Documentation tools often use metadata to provide more info to readers and to enrich the user experience.

This is achieved through [YARD meta-tags](https://www.rubydoc.info/gems/yard/file/docs/Tags.md).

### Common meta-tags

  - `@deprecated`: emits a warning in the documentation, explaining that its usage is discouraged.

  - `@since`: annotates in which version that particular module, method or constant was added.

## Recommendations

When writing documentation:

  * Keep the first paragraph of the documentation concise and simple, typically one-line. YARD use the first line to generate a summary.

  * Reference modules by their full name.
    Markdown uses backticks (`` ` ``) to quote code. Kit::Doc automatically generate links when module or method names are referenced. For this reason, always use full module names. If you have a module called `Services::Signup`, always reference it as `` `Services::Signup` `` and never as `` `Signup` ``.

  * Start new sections with second level Markdown headers `##`. First level headers are reserved for module and method names.

  * Use the `@since` tag in the documentation metadata to annotate whenever new methods or modules are added to your API.

## Documentation != Code comments

Documentation and code comments are different concepts. Documentation is an explicit contract between you and users of your Application Programming Interface (API), be them third-party developers, co-workers, or your future self. Modules and methods must always be documented if they are part of your API.

Code comments are aimed at developers reading the code. They are useful for marking improvements, leaving notes (for example, why you had to resort to a workaround due to a bug in a library), and so forth. They are tied to the source code: you can completely rewrite a function and remove all existing code comments, and it will continue to behave the same, with no change to either its behaviour or its documentation.

Beware of redundant code comments, such as the ones describing the exact same that the code does:

```ruby
# Total is the sum of the batch and individual entries
total = batch_sum + individual_sum
```

In summary, documentation is a contract with users of your API, who may not necessarily have access to the source code; whereas code comments are for those who interact directly with the source. You can learn and express different guarantees about your software by separating those two concepts.

## Hiding Internal Modules and Methods

Besides the modules & methods libraries provide as part of their public interface, libraries may also implement important functionality that is not part of their API. While these modules & methods can be accessed, they are meant to be internal to the library and thus should not have documentation for end users.

There are two ways to flag these modules or methods:

```ruby
# Some internals for our library.
module MyApp::Internals

  # This method will appear in the generated docs, but flagged as private.
  #
  # @api private
  def self.method_that_will_be_listed_but_flagged_as_private
    # ...
  end

  # This method won't appear in the generated docs.
  #
  # @doc false
  def self.method_that_wont_be_listed_in_docs
    # ...
  end

end
```

Keep in mind that these meta-tags have no bearing on [Ruby method visibility](http://rubylearning.com/satishtalim/ruby_access_control.html), they only apply to generated documentation.


