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
  # References:
  # - https://regex101.com/r/faq07d/1
  VARIABLES_REGEX = %r{(?<!\\)(?:\$)(?<variable_name>[A-Za-z0-9_]+)}m

  # Replace variables name patterns identified with `variables_regex` with values from `variables` hash in `content:`.
  def self.preproc_variables(content:, variables: {}, variables_regex: VARIABLES_REGEX)
    processed_content = content.gsub(variables_regex) do |_matched_text|
      variable_name = $LAST_MATCH_INFO[:variable_name]
      variables[variable_name] || variables[variable_name.to_sym] || ''
    end

    [:ok, processed_content: processed_content]
  end

  # Simple regex to identify preprocessing comments.
  #
  # Example:
  # ```markdown
  # <!--pp {
  # [KitDoc link](https://github.com/rubykit/kit/blob/$VERSION/libraries/kit-doc)
  # } -->
  # [GitHub link](https://github.com/rubykit/kit/tree/master/libraries/kit-doc)
  # <!-- pp-->
  # ```
  #
  # Will generate a match on the whole content:, with a capture group `prepoc_content` with the value:
  # ```markdown
  # [KitDoc link](https://github.com/rubykit/kit/blob/$VERSION/libraries/kit-doc)
  # ```
  #
  # The regex simply match `<!--pp`, comment content inside `{}`, and a closing `--pp>`.
  #
  # References:
  # - https://regex101.com/r/BNbn0Y/5
  PREPROC_REGEX = %r{(?:<!--pp {)(?:\n| )?(?<prepoc_content>[^\>]*?)(?:\n| )?(?<!\\)(?:}){1}(?:.*?)(?:pp-->)}ms

  # Replace static content: by dynamic one hidden in html comments.
  #
  # Also calls `preproc_variables` to resolve dynamic values in preprocessing comments.
  #
  # Example with the default `PREPROC_REGEX`:
  # ```markdown
  # <!--pp {
  # [KitDoc link](https://github.com/rubykit/kit/blob/$VERSION/libraries/kit-doc)
  # } -->
  # [GitHub link](https://github.com/rubykit/kit/tree/master/libraries/kit-doc)
  # <!-- pp-->
  # ```
  # Will be resolved as:
  # ```markdown
  # [KitDoc link](https://github.com/rubykit/kit/blob/v0.0.1/libraries/kit-doc)
  # ```
  #
  # References:
  # - https://regex101.com/r/BNbn0Y/5
  def self.preproc_conditionals(content:, variables:, preproc_regex: PREPROC_REGEX)
    processed_content = content

    processed_content = processed_content.gsub(preproc_regex) do |_matched_text|
      preproc_variables({
        content:   $LAST_MATCH_INFO[:prepoc_content],
        variables: variables,
      })[1][:processed_content]
    end

    [:ok, processed_content: processed_content]
  end

end
