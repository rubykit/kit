require 'yard'
#require 'yard-kit'

require_relative 'version'

SOURCE_FILES = {
  'kit/libs/kit-json-api'   => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
  'kit/libs/kit-organizer'  => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
  'kit/libs/kit-pagination' => {
    include: %w[
      lib/**/*.rb
      app/**/*.rb
    ],
  },
}

EXTRA_FILES = {
  'docs/guides' => {
    include: %w[
      **/*.md
    ],
  },
}

YARD::Rake::YardocTask.new do |t|
  t.name = 'yardoc:all'

  files = []

  files << SOURCE_FILES
    .map do |lib_path, data|
      (data[:include] || []).map { |path| "#{ lib_path }/#{ path }" }
    end

  files << ['-']

  files << EXTRA_FILES
    .map do |lib_path, data|
      (data[:include] || []).map { |path| Dir["#{ lib_path }/#{ path }"] }
    end

  files = files.flatten

  t.files = files
  t.options = [
    '--plugin',           'yard-kit', # Redundant with `.yardopts`?
    '--output-dir',       "docs/versions/#{ Kit::VERSION::STRING }",
    '--asset',            'docs/assets:images',
    '--markup-provider',  'redcarpet',
    '--markup',           'markdown',
  ]
end
