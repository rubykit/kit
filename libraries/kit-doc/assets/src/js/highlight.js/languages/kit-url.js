/*
Language: URL documentation
Author: Nathan APPERE <nathan@rubykit.org>
Category: common
*/

export default function(hljs) {

  var KEYWORDS = {
    literal: 'DELETE GET HEAD OPTIONS PATCH POST PUT',
  };

  var PATH = {
    className:    'attribute',
    begin: /(?<=(\/))/, end: /(?=(\?))/,
  };

  var QUERY_PARAMS_NAMES = {
    className:    'attribute',
    begin: /(?<=(\?|\&))/, end: /(?=(\[|\=))/,
  };

  var QUERY_PARAMS_ARRAY_VALUE = {
    className:    'string',
    begin: /(?<=\[)/, end: /(?=\])/,
  };

  var QUERY_PARAMS_VALUE = {
    className:    'keyword',
    begin: /(?<=(\=))/, end: /(?=(\&|$s))/,
  };

  var CHARACTERS = {
    className:  'comment',
    begin:      /\&|\=|\?|\[|\]/,
  };

  return {
    name:     'Url Documentation',
    keywords: KEYWORDS,
    contains: [
      hljs.HASH_COMMENT_MODE,
      //PATH,
      QUERY_PARAMS_NAMES,
      //QUERY_PARAMS_VALUE,
      QUERY_PARAMS_ARRAY_VALUE,
      CHARACTERS,
    ],
  };

}
