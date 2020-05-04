export default function (nodeUrl, options) {
  var currentPath = window.location.pathname.split('#')[0]
  nodeUrl = nodeUrl.split('#')[0]

  if (currentPath.endsWith(nodeUrl)) {
    return options.fn(this)
  } else {
    return options.inverse(this)
  }
}
