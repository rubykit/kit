import bash from 'highlight.js/lib/languages/bash'

export default function(hljs) {
  var defaults = bash(hljs);

  var SHELL_PROMPT = [
    {
      className: 'prompt',
      begin: /^\$ /,
    }
  ];

  defaults.contains = defaults.contains.concat(SHELL_PROMPT);

  return defaults;
}
