import ruby from 'highlight.js/lib/languages/ruby'

export default function(hljs) {
  var defaults = ruby(hljs);

  // In the Ruby language, prompt are categorized as `meta`, and simple `irb>` prompts do not match.
  // This add a new category to make it unselectable.
  var IRB_PROMPT = [
    {
      className: 'prompt',
      begin: /^irb\>/,
    }
  ];

  defaults.contains = defaults.contains.concat(IRB_PROMPT);

  return defaults;
}
