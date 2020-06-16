require 'English'

# Basic markdown preprocessing.
#
# Adds variable substitution when generating `Kit::Doc` documentation, while staying compatible with Github markdown previews.
#
# This is particularly helpful for versionned link references in Guides.
#
module Kit::Doc::Services::MarkdownPreprocessor

  # Simple regex to identify `$variable_name` patterns.
  #
  # Only alpha-numerical characters and _ are accepted.
  #
  # Preffixing the `$` sign with a backslash deactivates it.
  #
  # ### References
  # - https://regex101.com/r/faq07d/1
  VARIABLES_REGEX = %r{(?<!\\)(?:\$)(?<variable_name>[A-Za-z0-9_]+)}m

  # Replace variables name patterns identified with `variables_regex` with values from `variables` hash in `content:`.
  #
  # ### Examples
  # ```irb
  # irb> preproc_variables({
  #   content:   'Current version is $version!',
  #   variables: { version: 'v0.1.0' }
  # })
  # [:ok, processed_content: 'Current version is v0.1.0!']
  # ```
  def self.preproc_variables(content:, variables: {}, variables_regex: VARIABLES_REGEX)
    processed_content = content.gsub(variables_regex) do |_matched_text|
      variable_name = $LAST_MATCH_INFO[:variable_name]
      variables[variable_name] || variables[variable_name.to_sym] || ''
    end

    [:ok, processed_content: processed_content]
  end

  # Simple regex to identify preprocessing comments.
  #
  # ### Examples
  # ```markdown
  # <!--\pp -->
  # [Doc - GitHub Link](https://docs.rubykit.org/kit/edge)
  # <!-- { [Doc - Kit Link](https://docs.rubykit.org/kit/$VERSION) } pp-->
  #
  # Will generate a match from `<!--pp` to `pp-->`,
  #   with the content inside `{}` captured in a group named `prepoc_content`:
  #
  # [Doc - Kit Link](https://docs.rubykit.org/kit/$VERSION)
  # ```
  #
  # The regex simply match `<!--pp`, comment content inside `{}`, and a closing `--pp>`.
  #
  # ### References
  # - https://regex101.com/r/BNbn0Y/8
  PREPROC_REGEX = %r{(?:<!--pp )(?:.*?)(?<!\\)(?:{)(?:\n| )?(?<prepoc_content>[^\>]*?)(?:\n| )?(?<!\\)(?:}){1}(?:.*?)(?:pp-->)}ms

  # Replace static content: by dynamic one hidden in html comments.
  #
  # Also calls `preproc_variables` to resolve dynamic values in preprocessing comments.
  #
  # ### Examples
  # ```irb
  # irb> preproc_conditionals({
  #   content:   <<~TEXT,
  #     <!--\pp -->
  #     [Doc - GitHub Link](https://docs.rubykit.org/kit/edge)
  #     <!-- { [Doc - Kit Link](https://docs.rubykit.org/kit/$VERSION) } pp-->
  #   TEXT
  #   variables: { VERSION: 'v0.1.0' }
  # })
  # [:ok, processed_content: '[Doc - Kit Link](https://docs.rubykit.org/kit/v0.1.0)']
  # ```
  #
  def self.preproc_conditionals(content:, variables:, preproc_regex: PREPROC_REGEX)
    processed_content = content

    processed_content = processed_content.gsub(preproc_regex) do |_matched_text|
      preproc_variables({
        content:   $LAST_MATCH_INFO[:prepoc_content],
        variables: variables,
      })[1][:processed_content]
    end

    # Remove the backslack in front of `pp` now that the preprocessing is done.
    # This allows to display it in the doc.
    processed_content = processed_content.gsub('<!--\\pp', '<!--pp')

    [:ok, processed_content: processed_content]
  end

end
