/* globals searchNodes, searchNodesDigest */

// Search
// ======

// Dependencies
// ------------

import $ from 'jquery'
import lunr from 'lunr'
import resultsTemplate from './templates/search-results.handlebars'

// Local Variables
// ---------------

const $search = $('#search')
const $input = $('.sidebar-search input')

// Local Methods
// -------------

function fillResults (results) {
  var contents = searchNodes
  var matches = []

  results.forEach(function (element) {
    // If the docs are regenerated without changing its version,
    // a reference may have been doc'ed false in the code but
    // still available in the cached index, so we skip it here.
    var item = contents.find(i => i.ref === element.ref)
    if (item) {
      var metadata = element.matchData.metadata
      item.metadata = metadata
      item.excerpts = getExcerpts(item, metadata)
      matches.push(item)
    }
  })

  return matches
}

function getExcerpts (item, metadata) {
  var terms = Object.keys(metadata)
  var excerpts = []
  var nchars = 80

  terms.forEach(function (term) {
    if ('doc' in metadata[term]) {
      metadata[term].doc.position.forEach(function (matchPos) {
        var startPos = matchPos[0] - nchars > 0 ? matchPos[0] - nchars : 0
        var endPos = matchPos[0] + matchPos[1] + nchars > item.doc.length
          ? item.doc.length : matchPos[0] + matchPos[1] + nchars
        var excerpt =
          (startPos > 0 ? '...' : '') +
          item.doc.slice(startPos, matchPos[0]) +
          '<em>' +
          item.doc.slice(matchPos[0], matchPos[0] + matchPos[1]) +
          '</em> ' +
          item.doc.slice(matchPos[0] + matchPos[1], endPos) +
          (endPos < item.doc.length ? '...' : '')
        excerpts.push(excerpt)
      })
    }
  })
  if (excerpts.length === 0) {
    excerpts.push(item.doc.slice(0, nchars * 2) + (nchars * 2 < item.doc.length ? '...' : ''))
  }
  return excerpts.slice(0, 1)
}

export function search (value) {
  if (value.replace(/\s/, '') !== '') {
    $input.val(value)
    var idx = getIndex()
    var results, errorMessage

    try {
      results = fillResults(idx.search(value.replace(':', '')))
    } catch (error) {
      errorMessage = error.message
    }

    var resultsHtml = resultsTemplate({
      value: value,
      results: results,
      errorMessage: errorMessage
    })

    $search.html(resultsHtml)
  } else {
    $search.html('<h1>Search</h1>')
  }
}

function getIndex () {
  var projectMeta = getProjectMeta()
  var sessionStorageKey = `${projectMeta}-${searchNodesDigest}`
  var stored = sessionStorage.getItem(sessionStorageKey)

  try {
    if (stored == null) throw 'create and save'
    return lunr.Index.load(JSON.parse(stored))
  } catch {
    var idx = createIndex()
    var stringified = JSON.stringify(idx)

    try {
      sessionStorage.setItem(sessionStorageKey, stringified)
    } catch {
    }

    return idx
  }
}

function getProjectMeta () {
  return document.head.querySelector('meta[name=project][content]').content
}

function titleExtractor (document) {
  var title = document['title']
  var type  = document['type']
  var orig  = title

  if (type == 'module' || type == 'constant' || type == 'class' || type == 'namespace') {
    let idx = orig.lastIndexOf('::')
    if (idx != -1) {
      title = title + ' ' + orig.substr(0, idx) + ' ' + orig.substr(idx + 2)
    }
  }
  else if (type.includes('method') || type.includes('attribute')) {
    let sep   = orig.includes('.') ? '.' : '#'
    let split = orig.split(sep)
    title = title + ' ' + split.join(' ') + ' ' + sep + split.slice(-1)[0]
  }

  return title
}

function createIndex () {
  return lunr(function () {
    this.ref('ref')
    this.field('title', {boost: 3, extractor: titleExtractor})
    this.field('doc')
    this.metadataWhitelist = ['position']
    this.pipeline.remove(lunr.stopWordFilter)

    searchNodes.forEach(function (doc) {
      this.add(doc)
    }, this)
  })
}
