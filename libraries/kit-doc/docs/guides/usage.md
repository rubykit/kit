[Kit::Doc]: https://github.com/rubykit/kit/tree/master/libraries/kit-doc

# Getting started

Here are the steps to add [Kit::Doc] to your project.

## Adding the gem

1 - Add the following line to your `Gemfile`:

  ```
  gem 'kit-doc'
  ```

2 - Run `bundle install`

## Generating Kit::Doc config

1 - Run the generator:

```sh
$ rails generate kit-doc:install
```

This will create the following files:
```
docs/
  assets/
  dist/
  guides/
  VERSIONS
tasks/
  documentation.rake
```

2 - Add this to your `Rakefile`:
```
import 'tasks/documentation.rake'
```

3 - Add this to your `.gitignore`:
```
docs/dist
```

By default, the documentation is generated in `docs/dist`. There is no need to git version this (please don't ;).


## Edit your project info

1 - Edit the generated `tasks/documentation.rake`:

You may want to set `:project`, `:source_url` and `:documentation_url`. If not, you can do it later!

```ruby
require 'kit-doc'

DOC_CONFIG = Kit::Doc::Services::Config.create_config(
  project:           'YOUR_PROJECT_NAME',
  source_url:        'https://github.com/YOUR_GITHUB_ORG_NAME/YOUR_GITHUB_REPO_NAME',
  documentation_url: 'https://YOUR_GITHUB_ORG_NAME.github.io/YOUR_GITHUB_REPO_NAME',

  # The top level directory of your project, relative to this file:
  project_path:      File.expand_path('..', __dir__),
  # The path to your project git repo. Remove if you don't have one (you should though ;).
  git_project_path:  File.expand_path('..', __dir__),
  # The path to the VERSIONS file that was generated, it contains the list of versions to generate documentation for.
  all_versions:      File.expand_path('../docs/VERSIONS', __dir__),

  # The files you want to generate documentation for:
  files_modules:     { './' => { include: %w[lib/**/*.rb app/**/*.rb] },
  # Extra `.md` files to include as guides:
  files_extras:      {
    '.'           => { include: %w[README.md] },
    'docs/guides' => { include: %w[**/*.md] },
  },
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_generate!(
  config:           DOC_CONFIG,
  # By default, the documentation is generated in `docs/dist`.
  #   It will run `rm -rf docs/dist/*` before each run if this is set to true.
  clean_output_dir: true,
)

Kit::Doc::Services::Tasks.create_rake_task_documentation_all_versions!(
  config: DOC_CONFIG,
)
```

2 - Optional: edit `docs/VERSIONS` to choose the versions that should have documentation.

The default is:
```
edge:master
```

3 - Add it to your project `Rakefile`:
```
import 'tasks/documentation.rake'
```

## Generate documentation

Now you are ready to generate your project documentation.

1 - Run:

```shell
$ bundle exec rake documentation:generate
```

Documentation should be generated in `/docs/dist/dev`.

You can open `/docs/dist/dev/index.html`.