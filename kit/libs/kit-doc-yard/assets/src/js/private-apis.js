// Dependencies
// ------------

import $ from 'jquery'

// Constants
// ---------

const body = $('body')
const localStorageKey = 'private-apis'
const cssClassKey = 'hide-private-apis'
const privateApisToggleSelector = '.private-apis-toggle'

function activate () {
  body.addClass(cssClassKey)
  try { localStorage.setItem(localStorageKey, true) } catch (e) { }
}

function deactivate () {
  body.removeClass(cssClassKey)
  try { localStorage.setItem(localStorageKey, false) } catch (e) { }
}

function check () {
  try {
    const userWantsToHide = localStorage.getItem(localStorageKey)

    if (userWantsToHide != null) {
      if (userWantsToHide === true || userWantsToHide === 'true') {
        activate()
      }
    }
  } catch (e) { }
}

function togglePrivateApis () {
  if (body.hasClass(cssClassKey)) {
    deactivate()
  } else {
    activate()
  }
}

// Public Methods
// --------------

export {togglePrivateApis}

export function initialize () {
  check()

  body.on('click', privateApisToggleSelector, function () {
    togglePrivateApis()
  })
}
