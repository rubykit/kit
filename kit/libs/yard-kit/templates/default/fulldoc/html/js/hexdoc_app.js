! function(n) {
 var r = {};

 function i(e) {
  if (r[e]) return r[e].exports;
  var t = r[e] = {
   i: e,
   l: !1,
   exports: {}
  };
  return n[e].call(t.exports, t, t.exports, i), t.l = !0, t.exports
 }
 i.m = n, i.c = r, i.d = function(e, t, n) {
  i.o(e, t) || Object.defineProperty(e, t, {
   enumerable: !0,
   get: n
  })
 }, i.r = function(e) {
  "undefined" != typeof Symbol && Symbol.toStringTag && Object.defineProperty(e, Symbol.toStringTag, {
   value: "Module"
  }), Object.defineProperty(e, "__esModule", {
   value: !0
  })
 }, i.t = function(t, e) {
  if (1 & e && (t = i(t)), 8 & e) return t;
  if (4 & e && "object" == typeof t && t && t.__esModule) return t;
  var n = Object.create(null);
  if (i.r(n), Object.defineProperty(n, "default", {
    enumerable: !0,
    value: t
   }), 2 & e && "string" != typeof t)
   for (var r in t) i.d(n, r, function(e) {
    return t[e]
   }.bind(null, r));
  return n
 }, i.n = function(e) {
  var t = e && e.__esModule ? function() {
   return e.default
  } : function() {
   return e
  };
  return i.d(t, "a", t), t
 }, i.o = function(e, t) {
  return Object.prototype.hasOwnProperty.call(e, t)
 }, i.p = "", i(i.s = 58)
}([function(Jt, Yt, e) {
 var en;
 /*!
  * jQuery JavaScript Library v3.4.1
  * https://jquery.com/
  *
  * Includes Sizzle.js
  * https://sizzlejs.com/
  *
  * Copyright JS Foundation and other contributors
  * Released under the MIT license
  * https://jquery.org/license
  *
  * Date: 2019-05-01T21:04Z
  */
 /*!
  * jQuery JavaScript Library v3.4.1
  * https://jquery.com/
  *
  * Includes Sizzle.js
  * https://sizzlejs.com/
  *
  * Copyright JS Foundation and other contributors
  * Released under the MIT license
  * https://jquery.org/license
  *
  * Date: 2019-05-01T21:04Z
  */
 ! function(e, t) {
  "use strict";
  "object" == typeof Jt && "object" == typeof Jt.exports ? Jt.exports = e.document ? t(e, !0) : function(e) {
   if (!e.document) throw new Error("jQuery requires a window with a document");
   return t(e)
  } : t(e)
 }("undefined" != typeof window ? window : this, function(E, e) {
  "use strict";
  var t = [],
   k = E.document,
   r = Object.getPrototypeOf,
   s = t.slice,
   g = t.concat,
   l = t.push,
   i = t.indexOf,
   n = {},
   a = n.toString,
   m = n.hasOwnProperty,
   o = m.toString,
   u = o.call(Object),
   v = {},
   y = function(e) {
    return "function" == typeof e && "number" != typeof e.nodeType
   },
   b = function(e) {
    return null != e && e === e.window
   },
   c = {
    type: !0,
    src: !0,
    nonce: !0,
    noModule: !0
   };

  function x(e, t, n) {
   var r, i, a = (n = n || k).createElement("script");
   if (a.text = e, t)
    for (r in c)(i = t[r] || t.getAttribute && t.getAttribute(r)) && a.setAttribute(r, i);
   n.head.appendChild(a).parentNode.removeChild(a)
  }

  function w(e) {
   return null == e ? e + "" : "object" == typeof e || "function" == typeof e ? n[a.call(e)] || "object" : typeof e
  }
  var d = "3.4.1",
   C = function(e, t) {
    return new C.fn.init(e, t)
   },
   f = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g;

  function p(e) {
   var t = !!e && "length" in e && e.length,
    n = w(e);
   return !y(e) && !b(e) && ("array" === n || 0 === t || "number" == typeof t && 0 < t && t - 1 in e)
  }
  C.fn = C.prototype = {
   jquery: d,
   constructor: C,
   length: 0,
   toArray: function() {
    return s.call(this)
   },
   get: function(e) {
    return null == e ? s.call(this) : e < 0 ? this[e + this.length] : this[e]
   },
   pushStack: function(e) {
    var t = C.merge(this.constructor(), e);
    return t.prevObject = this, t
   },
   each: function(e) {
    return C.each(this, e)
   },
   map: function(n) {
    return this.pushStack(C.map(this, function(e, t) {
     return n.call(e, t, e)
    }))
   },
   slice: function() {
    return this.pushStack(s.apply(this, arguments))
   },
   first: function() {
    return this.eq(0)
   },
   last: function() {
    return this.eq(-1)
   },
   eq: function(e) {
    var t = this.length,
     n = +e + (e < 0 ? t : 0);
    return this.pushStack(0 <= n && n < t ? [this[n]] : [])
   },
   end: function() {
    return this.prevObject || this.constructor()
   },
   push: l,
   sort: t.sort,
   splice: t.splice
  }, C.extend = C.fn.extend = function() {
   var e, t, n, r, i, a, o = arguments[0] || {},
    s = 1,
    l = arguments.length,
    u = !1;
   for ("boolean" == typeof o && (u = o, o = arguments[s] || {}, s++), "object" == typeof o || y(o) || (o = {}), s === l && (o = this, s--); s < l; s++)
    if (null != (e = arguments[s]))
     for (t in e) r = e[t], "__proto__" !== t && o !== r && (u && r && (C.isPlainObject(r) || (i = Array.isArray(r))) ? (n = o[t], a = i && !Array.isArray(n) ? [] : i || C.isPlainObject(n) ? n : {}, i = !1, o[t] = C.extend(u, a, r)) : void 0 !== r && (o[t] = r));
   return o
  }, C.extend({
   expando: "jQuery" + (d + Math.random()).replace(/\D/g, ""),
   isReady: !0,
   error: function(e) {
    throw new Error(e)
   },
   noop: function() {},
   isPlainObject: function(e) {
    var t, n;
    return !(!e || "[object Object]" !== a.call(e)) && (!(t = r(e)) || "function" == typeof(n = m.call(t, "constructor") && t.constructor) && o.call(n) === u)
   },
   isEmptyObject: function(e) {
    var t;
    for (t in e) return !1;
    return !0
   },
   globalEval: function(e, t) {
    x(e, {
     nonce: t && t.nonce
    })
   },
   each: function(e, t) {
    var n, r = 0;
    if (p(e))
     for (n = e.length; r < n && !1 !== t.call(e[r], r, e[r]); r++);
    else
     for (r in e)
      if (!1 === t.call(e[r], r, e[r])) break;
    return e
   },
   trim: function(e) {
    return null == e ? "" : (e + "").replace(f, "")
   },
   makeArray: function(e, t) {
    var n = t || [];
    return null != e && (p(Object(e)) ? C.merge(n, "string" == typeof e ? [e] : e) : l.call(n, e)), n
   },
   inArray: function(e, t, n) {
    return null == t ? -1 : i.call(t, e, n)
   },
   merge: function(e, t) {
    for (var n = +t.length, r = 0, i = e.length; r < n; r++) e[i++] = t[r];
    return e.length = i, e
   },
   grep: function(e, t, n) {
    for (var r = [], i = 0, a = e.length, o = !n; i < a; i++) !t(e[i], i) !== o && r.push(e[i]);
    return r
   },
   map: function(e, t, n) {
    var r, i, a = 0,
     o = [];
    if (p(e))
     for (r = e.length; a < r; a++) null != (i = t(e[a], a, n)) && o.push(i);
    else
     for (a in e) null != (i = t(e[a], a, n)) && o.push(i);
    return g.apply([], o)
   },
   guid: 1,
   support: v
  }), "function" == typeof Symbol && (C.fn[Symbol.iterator] = t[Symbol.iterator]), C.each("Boolean Number String Function Array Date RegExp Object Error Symbol".split(" "), function(e, t) {
   n["[object " + t + "]"] = t.toLowerCase()
  });
  var h =
   /*!
    * Sizzle CSS Selector Engine v2.3.4
    * https://sizzlejs.com/
    *
    * Copyright JS Foundation and other contributors
    * Released under the MIT license
    * https://js.foundation/
    *
    * Date: 2019-04-08
    */
   function(n) {
    var e, p, x, a, i, h, d, g, w, l, u, _, E, o, k, m, s, c, v, C = "sizzle" + 1 * new Date,
     y = n.document,
     T = 0,
     r = 0,
     f = le(),
     b = le(),
     S = le(),
     N = le(),
     O = function(e, t) {
      return e === t && (u = !0), 0
     },
     A = {}.hasOwnProperty,
     t = [],
     j = t.pop,
     D = t.push,
     L = t.push,
     R = t.slice,
     P = function(e, t) {
      for (var n = 0, r = e.length; n < r; n++)
       if (e[n] === t) return n;
      return -1
     },
     M = "checked|selected|async|autofocus|autoplay|controls|defer|disabled|hidden|ismap|loop|multiple|open|readonly|required|scoped",
     I = "[\\x20\\t\\r\\n\\f]",
     q = "(?:\\\\.|[\\w-]|[^\0-\\xa0])+",
     B = "\\[" + I + "*(" + q + ")(?:" + I + "*([*^$|!~]?=)" + I + "*(?:'((?:\\\\.|[^\\\\'])*)'|\"((?:\\\\.|[^\\\\\"])*)\"|(" + q + "))|)" + I + "*\\]",
     Q = ":(" + q + ")(?:\\((('((?:\\\\.|[^\\\\'])*)'|\"((?:\\\\.|[^\\\\\"])*)\")|((?:\\\\.|[^\\\\()[\\]]|" + B + ")*)|.*)\\)|)",
     H = new RegExp(I + "+", "g"),
     F = new RegExp("^" + I + "+|((?:^|[^\\\\])(?:\\\\.)*)" + I + "+$", "g"),
     $ = new RegExp("^" + I + "*," + I + "*"),
     z = new RegExp("^" + I + "*([>+~]|" + I + ")" + I + "*"),
     W = new RegExp(I + "|>"),
     U = new RegExp(Q),
     V = new RegExp("^" + q + "$"),
     G = {
      ID: new RegExp("^#(" + q + ")"),
      CLASS: new RegExp("^\\.(" + q + ")"),
      TAG: new RegExp("^(" + q + "|[*])"),
      ATTR: new RegExp("^" + B),
      PSEUDO: new RegExp("^" + Q),
      CHILD: new RegExp("^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\(" + I + "*(even|odd|(([+-]|)(\\d*)n|)" + I + "*(?:([+-]|)" + I + "*(\\d+)|))" + I + "*\\)|)", "i"),
      bool: new RegExp("^(?:" + M + ")$", "i"),
      needsContext: new RegExp("^" + I + "*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\(" + I + "*((?:-\\d)?\\d*)" + I + "*\\)|)(?=[^-]|$)", "i")
     },
     K = /HTML$/i,
     X = /^(?:input|select|textarea|button)$/i,
     Z = /^h\d$/i,
     J = /^[^{]+\{\s*\[native \w/,
     Y = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/,
     ee = /[+~]/,
     te = new RegExp("\\\\([\\da-f]{1,6}" + I + "?|(" + I + ")|.)", "ig"),
     ne = function(e, t, n) {
      var r = "0x" + t - 65536;
      return r != r || n ? t : r < 0 ? String.fromCharCode(r + 65536) : String.fromCharCode(r >> 10 | 55296, 1023 & r | 56320)
     },
     re = /([\0-\x1f\x7f]|^-?\d)|^-$|[^\0-\x1f\x7f-\uFFFF\w-]/g,
     ie = function(e, t) {
      return t ? "\0" === e ? "ï¿½" : e.slice(0, -1) + "\\" + e.charCodeAt(e.length - 1).toString(16) + " " : "\\" + e
     },
     ae = function() {
      _()
     },
     oe = xe(function(e) {
      return !0 === e.disabled && "fieldset" === e.nodeName.toLowerCase()
     }, {
      dir: "parentNode",
      next: "legend"
     });
    try {
     L.apply(t = R.call(y.childNodes), y.childNodes), t[y.childNodes.length].nodeType
    } catch (e) {
     L = {
      apply: t.length ? function(e, t) {
       D.apply(e, R.call(t))
      } : function(e, t) {
       for (var n = e.length, r = 0; e[n++] = t[r++];);
       e.length = n - 1
      }
     }
    }

    function se(t, e, n, r) {
     var i, a, o, s, l, u, c, d = e && e.ownerDocument,
      f = e ? e.nodeType : 9;
     if (n = n || [], "string" != typeof t || !t || 1 !== f && 9 !== f && 11 !== f) return n;
     if (!r && ((e ? e.ownerDocument || e : y) !== E && _(e), e = e || E, k)) {
      if (11 !== f && (l = Y.exec(t)))
       if (i = l[1]) {
        if (9 === f) {
         if (!(o = e.getElementById(i))) return n;
         if (o.id === i) return n.push(o), n
        } else if (d && (o = d.getElementById(i)) && v(e, o) && o.id === i) return n.push(o), n
       } else {
        if (l[2]) return L.apply(n, e.getElementsByTagName(t)), n;
        if ((i = l[3]) && p.getElementsByClassName && e.getElementsByClassName) return L.apply(n, e.getElementsByClassName(i)), n
       } if (p.qsa && !N[t + " "] && (!m || !m.test(t)) && (1 !== f || "object" !== e.nodeName.toLowerCase())) {
       if (c = t, d = e, 1 === f && W.test(t)) {
        for ((s = e.getAttribute("id")) ? s = s.replace(re, ie) : e.setAttribute("id", s = C), a = (u = h(t)).length; a--;) u[a] = "#" + s + " " + be(u[a]);
        c = u.join(","), d = ee.test(t) && ve(e.parentNode) || e
       }
       try {
        return L.apply(n, d.querySelectorAll(c)), n
       } catch (e) {
        N(t, !0)
       } finally {
        s === C && e.removeAttribute("id")
       }
      }
     }
     return g(t.replace(F, "$1"), e, n, r)
    }

    function le() {
     var r = [];
     return function e(t, n) {
      return r.push(t + " ") > x.cacheLength && delete e[r.shift()], e[t + " "] = n
     }
    }

    function ue(e) {
     return e[C] = !0, e
    }

    function ce(e) {
     var t = E.createElement("fieldset");
     try {
      return !!e(t)
     } catch (e) {
      return !1
     } finally {
      t.parentNode && t.parentNode.removeChild(t), t = null
     }
    }

    function de(e, t) {
     for (var n = e.split("|"), r = n.length; r--;) x.attrHandle[n[r]] = t
    }

    function fe(e, t) {
     var n = t && e,
      r = n && 1 === e.nodeType && 1 === t.nodeType && e.sourceIndex - t.sourceIndex;
     if (r) return r;
     if (n)
      for (; n = n.nextSibling;)
       if (n === t) return -1;
     return e ? 1 : -1
    }

    function pe(t) {
     return function(e) {
      return "input" === e.nodeName.toLowerCase() && e.type === t
     }
    }

    function he(n) {
     return function(e) {
      var t = e.nodeName.toLowerCase();
      return ("input" === t || "button" === t) && e.type === n
     }
    }

    function ge(t) {
     return function(e) {
      return "form" in e ? e.parentNode && !1 === e.disabled ? "label" in e ? "label" in e.parentNode ? e.parentNode.disabled === t : e.disabled === t : e.isDisabled === t || e.isDisabled !== !t && oe(e) === t : e.disabled === t : "label" in e && e.disabled === t
     }
    }

    function me(o) {
     return ue(function(a) {
      return a = +a, ue(function(e, t) {
       for (var n, r = o([], e.length, a), i = r.length; i--;) e[n = r[i]] && (e[n] = !(t[n] = e[n]))
      })
     })
    }

    function ve(e) {
     return e && void 0 !== e.getElementsByTagName && e
    }
    for (e in p = se.support = {}, i = se.isXML = function(e) {
      var t = e.namespaceURI,
       n = (e.ownerDocument || e).documentElement;
      return !K.test(t || n && n.nodeName || "HTML")
     }, _ = se.setDocument = function(e) {
      var t, n, r = e ? e.ownerDocument || e : y;
      return r !== E && 9 === r.nodeType && r.documentElement && (o = (E = r).documentElement, k = !i(E), y !== E && (n = E.defaultView) && n.top !== n && (n.addEventListener ? n.addEventListener("unload", ae, !1) : n.attachEvent && n.attachEvent("onunload", ae)), p.attributes = ce(function(e) {
       return e.className = "i", !e.getAttribute("className")
      }), p.getElementsByTagName = ce(function(e) {
       return e.appendChild(E.createComment("")), !e.getElementsByTagName("*").length
      }), p.getElementsByClassName = J.test(E.getElementsByClassName), p.getById = ce(function(e) {
       return o.appendChild(e).id = C, !E.getElementsByName || !E.getElementsByName(C).length
      }), p.getById ? (x.filter.ID = function(e) {
       var t = e.replace(te, ne);
       return function(e) {
        return e.getAttribute("id") === t
       }
      }, x.find.ID = function(e, t) {
       if (void 0 !== t.getElementById && k) {
        var n = t.getElementById(e);
        return n ? [n] : []
       }
      }) : (x.filter.ID = function(e) {
       var n = e.replace(te, ne);
       return function(e) {
        var t = void 0 !== e.getAttributeNode && e.getAttributeNode("id");
        return t && t.value === n
       }
      }, x.find.ID = function(e, t) {
       if (void 0 !== t.getElementById && k) {
        var n, r, i, a = t.getElementById(e);
        if (a) {
         if ((n = a.getAttributeNode("id")) && n.value === e) return [a];
         for (i = t.getElementsByName(e), r = 0; a = i[r++];)
          if ((n = a.getAttributeNode("id")) && n.value === e) return [a]
        }
        return []
       }
      }), x.find.TAG = p.getElementsByTagName ? function(e, t) {
       return void 0 !== t.getElementsByTagName ? t.getElementsByTagName(e) : p.qsa ? t.querySelectorAll(e) : void 0
      } : function(e, t) {
       var n, r = [],
        i = 0,
        a = t.getElementsByTagName(e);
       if ("*" !== e) return a;
       for (; n = a[i++];) 1 === n.nodeType && r.push(n);
       return r
      }, x.find.CLASS = p.getElementsByClassName && function(e, t) {
       if (void 0 !== t.getElementsByClassName && k) return t.getElementsByClassName(e)
      }, s = [], m = [], (p.qsa = J.test(E.querySelectorAll)) && (ce(function(e) {
       o.appendChild(e).innerHTML = "<a id='" + C + "'></a><select id='" + C + "-\r\\' msallowcapture=''><option selected=''></option></select>", e.querySelectorAll("[msallowcapture^='']").length && m.push("[*^$]=" + I + "*(?:''|\"\")"), e.querySelectorAll("[selected]").length || m.push("\\[" + I + "*(?:value|" + M + ")"), e.querySelectorAll("[id~=" + C + "-]").length || m.push("~="), e.querySelectorAll(":checked").length || m.push(":checked"), e.querySelectorAll("a#" + C + "+*").length || m.push(".#.+[+~]")
      }), ce(function(e) {
       e.innerHTML = "<a href='' disabled='disabled'></a><select disabled='disabled'><option/></select>";
       var t = E.createElement("input");
       t.setAttribute("type", "hidden"), e.appendChild(t).setAttribute("name", "D"), e.querySelectorAll("[name=d]").length && m.push("name" + I + "*[*^$|!~]?="), 2 !== e.querySelectorAll(":enabled").length && m.push(":enabled", ":disabled"), o.appendChild(e).disabled = !0, 2 !== e.querySelectorAll(":disabled").length && m.push(":enabled", ":disabled"), e.querySelectorAll("*,:x"), m.push(",.*:")
      })), (p.matchesSelector = J.test(c = o.matches || o.webkitMatchesSelector || o.mozMatchesSelector || o.oMatchesSelector || o.msMatchesSelector)) && ce(function(e) {
       p.disconnectedMatch = c.call(e, "*"), c.call(e, "[s!='']:x"), s.push("!=", Q)
      }), m = m.length && new RegExp(m.join("|")), s = s.length && new RegExp(s.join("|")), t = J.test(o.compareDocumentPosition), v = t || J.test(o.contains) ? function(e, t) {
       var n = 9 === e.nodeType ? e.documentElement : e,
        r = t && t.parentNode;
       return e === r || !(!r || 1 !== r.nodeType || !(n.contains ? n.contains(r) : e.compareDocumentPosition && 16 & e.compareDocumentPosition(r)))
      } : function(e, t) {
       if (t)
        for (; t = t.parentNode;)
         if (t === e) return !0;
       return !1
      }, O = t ? function(e, t) {
       if (e === t) return u = !0, 0;
       var n = !e.compareDocumentPosition - !t.compareDocumentPosition;
       return n || (1 & (n = (e.ownerDocument || e) === (t.ownerDocument || t) ? e.compareDocumentPosition(t) : 1) || !p.sortDetached && t.compareDocumentPosition(e) === n ? e === E || e.ownerDocument === y && v(y, e) ? -1 : t === E || t.ownerDocument === y && v(y, t) ? 1 : l ? P(l, e) - P(l, t) : 0 : 4 & n ? -1 : 1)
      } : function(e, t) {
       if (e === t) return u = !0, 0;
       var n, r = 0,
        i = e.parentNode,
        a = t.parentNode,
        o = [e],
        s = [t];
       if (!i || !a) return e === E ? -1 : t === E ? 1 : i ? -1 : a ? 1 : l ? P(l, e) - P(l, t) : 0;
       if (i === a) return fe(e, t);
       for (n = e; n = n.parentNode;) o.unshift(n);
       for (n = t; n = n.parentNode;) s.unshift(n);
       for (; o[r] === s[r];) r++;
       return r ? fe(o[r], s[r]) : o[r] === y ? -1 : s[r] === y ? 1 : 0
      }), E
     }, se.matches = function(e, t) {
      return se(e, null, null, t)
     }, se.matchesSelector = function(e, t) {
      if ((e.ownerDocument || e) !== E && _(e), p.matchesSelector && k && !N[t + " "] && (!s || !s.test(t)) && (!m || !m.test(t))) try {
       var n = c.call(e, t);
       if (n || p.disconnectedMatch || e.document && 11 !== e.document.nodeType) return n
      } catch (e) {
       N(t, !0)
      }
      return 0 < se(t, E, null, [e]).length
     }, se.contains = function(e, t) {
      return (e.ownerDocument || e) !== E && _(e), v(e, t)
     }, se.attr = function(e, t) {
      (e.ownerDocument || e) !== E && _(e);
      var n = x.attrHandle[t.toLowerCase()],
       r = n && A.call(x.attrHandle, t.toLowerCase()) ? n(e, t, !k) : void 0;
      return void 0 !== r ? r : p.attributes || !k ? e.getAttribute(t) : (r = e.getAttributeNode(t)) && r.specified ? r.value : null
     }, se.escape = function(e) {
      return (e + "").replace(re, ie)
     }, se.error = function(e) {
      throw new Error("Syntax error, unrecognized expression: " + e)
     }, se.uniqueSort = function(e) {
      var t, n = [],
       r = 0,
       i = 0;
      if (u = !p.detectDuplicates, l = !p.sortStable && e.slice(0), e.sort(O), u) {
       for (; t = e[i++];) t === e[i] && (r = n.push(i));
       for (; r--;) e.splice(n[r], 1)
      }
      return l = null, e
     }, a = se.getText = function(e) {
      var t, n = "",
       r = 0,
       i = e.nodeType;
      if (i) {
       if (1 === i || 9 === i || 11 === i) {
        if ("string" == typeof e.textContent) return e.textContent;
        for (e = e.firstChild; e; e = e.nextSibling) n += a(e)
       } else if (3 === i || 4 === i) return e.nodeValue
      } else
       for (; t = e[r++];) n += a(t);
      return n
     }, (x = se.selectors = {
      cacheLength: 50,
      createPseudo: ue,
      match: G,
      attrHandle: {},
      find: {},
      relative: {
       ">": {
        dir: "parentNode",
        first: !0
       },
       " ": {
        dir: "parentNode"
       },
       "+": {
        dir: "previousSibling",
        first: !0
       },
       "~": {
        dir: "previousSibling"
       }
      },
      preFilter: {
       ATTR: function(e) {
        return e[1] = e[1].replace(te, ne), e[3] = (e[3] || e[4] || e[5] || "").replace(te, ne), "~=" === e[2] && (e[3] = " " + e[3] + " "), e.slice(0, 4)
       },
       CHILD: function(e) {
        return e[1] = e[1].toLowerCase(), "nth" === e[1].slice(0, 3) ? (e[3] || se.error(e[0]), e[4] = +(e[4] ? e[5] + (e[6] || 1) : 2 * ("even" === e[3] || "odd" === e[3])), e[5] = +(e[7] + e[8] || "odd" === e[3])) : e[3] && se.error(e[0]), e
       },
       PSEUDO: function(e) {
        var t, n = !e[6] && e[2];
        return G.CHILD.test(e[0]) ? null : (e[3] ? e[2] = e[4] || e[5] || "" : n && U.test(n) && (t = h(n, !0)) && (t = n.indexOf(")", n.length - t) - n.length) && (e[0] = e[0].slice(0, t), e[2] = n.slice(0, t)), e.slice(0, 3))
       }
      },
      filter: {
       TAG: function(e) {
        var t = e.replace(te, ne).toLowerCase();
        return "*" === e ? function() {
         return !0
        } : function(e) {
         return e.nodeName && e.nodeName.toLowerCase() === t
        }
       },
       CLASS: function(e) {
        var t = f[e + " "];
        return t || (t = new RegExp("(^|" + I + ")" + e + "(" + I + "|$)")) && f(e, function(e) {
         return t.test("string" == typeof e.className && e.className || void 0 !== e.getAttribute && e.getAttribute("class") || "")
        })
       },
       ATTR: function(n, r, i) {
        return function(e) {
         var t = se.attr(e, n);
         return null == t ? "!=" === r : !r || (t += "", "=" === r ? t === i : "!=" === r ? t !== i : "^=" === r ? i && 0 === t.indexOf(i) : "*=" === r ? i && -1 < t.indexOf(i) : "$=" === r ? i && t.slice(-i.length) === i : "~=" === r ? -1 < (" " + t.replace(H, " ") + " ").indexOf(i) : "|=" === r && (t === i || t.slice(0, i.length + 1) === i + "-"))
        }
       },
       CHILD: function(h, e, t, g, m) {
        var v = "nth" !== h.slice(0, 3),
         y = "last" !== h.slice(-4),
         b = "of-type" === e;
        return 1 === g && 0 === m ? function(e) {
         return !!e.parentNode
        } : function(e, t, n) {
         var r, i, a, o, s, l, u = v !== y ? "nextSibling" : "previousSibling",
          c = e.parentNode,
          d = b && e.nodeName.toLowerCase(),
          f = !n && !b,
          p = !1;
         if (c) {
          if (v) {
           for (; u;) {
            for (o = e; o = o[u];)
             if (b ? o.nodeName.toLowerCase() === d : 1 === o.nodeType) return !1;
            l = u = "only" === h && !l && "nextSibling"
           }
           return !0
          }
          if (l = [y ? c.firstChild : c.lastChild], y && f) {
           for (p = (s = (r = (i = (a = (o = c)[C] || (o[C] = {}))[o.uniqueID] || (a[o.uniqueID] = {}))[h] || [])[0] === T && r[1]) && r[2], o = s && c.childNodes[s]; o = ++s && o && o[u] || (p = s = 0) || l.pop();)
            if (1 === o.nodeType && ++p && o === e) {
             i[h] = [T, s, p];
             break
            }
          } else if (f && (p = s = (r = (i = (a = (o = e)[C] || (o[C] = {}))[o.uniqueID] || (a[o.uniqueID] = {}))[h] || [])[0] === T && r[1]), !1 === p)
           for (;
            (o = ++s && o && o[u] || (p = s = 0) || l.pop()) && ((b ? o.nodeName.toLowerCase() !== d : 1 !== o.nodeType) || !++p || (f && ((i = (a = o[C] || (o[C] = {}))[o.uniqueID] || (a[o.uniqueID] = {}))[h] = [T, p]), o !== e)););
          return (p -= m) === g || p % g == 0 && 0 <= p / g
         }
        }
       },
       PSEUDO: function(e, a) {
        var t, o = x.pseudos[e] || x.setFilters[e.toLowerCase()] || se.error("unsupported pseudo: " + e);
        return o[C] ? o(a) : 1 < o.length ? (t = [e, e, "", a], x.setFilters.hasOwnProperty(e.toLowerCase()) ? ue(function(e, t) {
         for (var n, r = o(e, a), i = r.length; i--;) e[n = P(e, r[i])] = !(t[n] = r[i])
        }) : function(e) {
         return o(e, 0, t)
        }) : o
       }
      },
      pseudos: {
       not: ue(function(e) {
        var r = [],
         i = [],
         s = d(e.replace(F, "$1"));
        return s[C] ? ue(function(e, t, n, r) {
         for (var i, a = s(e, null, r, []), o = e.length; o--;)(i = a[o]) && (e[o] = !(t[o] = i))
        }) : function(e, t, n) {
         return r[0] = e, s(r, null, n, i), r[0] = null, !i.pop()
        }
       }),
       has: ue(function(t) {
        return function(e) {
         return 0 < se(t, e).length
        }
       }),
       contains: ue(function(t) {
        return t = t.replace(te, ne),
         function(e) {
          return -1 < (e.textContent || a(e)).indexOf(t)
         }
       }),
       lang: ue(function(n) {
        return V.test(n || "") || se.error("unsupported lang: " + n), n = n.replace(te, ne).toLowerCase(),
         function(e) {
          var t;
          do {
           if (t = k ? e.lang : e.getAttribute("xml:lang") || e.getAttribute("lang")) return (t = t.toLowerCase()) === n || 0 === t.indexOf(n + "-")
          } while ((e = e.parentNode) && 1 === e.nodeType);
          return !1
         }
       }),
       target: function(e) {
        var t = n.location && n.location.hash;
        return t && t.slice(1) === e.id
       },
       root: function(e) {
        return e === o
       },
       focus: function(e) {
        return e === E.activeElement && (!E.hasFocus || E.hasFocus()) && !!(e.type || e.href || ~e.tabIndex)
       },
       enabled: ge(!1),
       disabled: ge(!0),
       checked: function(e) {
        var t = e.nodeName.toLowerCase();
        return "input" === t && !!e.checked || "option" === t && !!e.selected
       },
       selected: function(e) {
        return e.parentNode && e.parentNode.selectedIndex, !0 === e.selected
       },
       empty: function(e) {
        for (e = e.firstChild; e; e = e.nextSibling)
         if (e.nodeType < 6) return !1;
        return !0
       },
       parent: function(e) {
        return !x.pseudos.empty(e)
       },
       header: function(e) {
        return Z.test(e.nodeName)
       },
       input: function(e) {
        return X.test(e.nodeName)
       },
       button: function(e) {
        var t = e.nodeName.toLowerCase();
        return "input" === t && "button" === e.type || "button" === t
       },
       text: function(e) {
        var t;
        return "input" === e.nodeName.toLowerCase() && "text" === e.type && (null == (t = e.getAttribute("type")) || "text" === t.toLowerCase())
       },
       first: me(function() {
        return [0]
       }),
       last: me(function(e, t) {
        return [t - 1]
       }),
       eq: me(function(e, t, n) {
        return [n < 0 ? n + t : n]
       }),
       even: me(function(e, t) {
        for (var n = 0; n < t; n += 2) e.push(n);
        return e
       }),
       odd: me(function(e, t) {
        for (var n = 1; n < t; n += 2) e.push(n);
        return e
       }),
       lt: me(function(e, t, n) {
        for (var r = n < 0 ? n + t : t < n ? t : n; 0 <= --r;) e.push(r);
        return e
       }),
       gt: me(function(e, t, n) {
        for (var r = n < 0 ? n + t : n; ++r < t;) e.push(r);
        return e
       })
      }
     }).pseudos.nth = x.pseudos.eq, {
      radio: !0,
      checkbox: !0,
      file: !0,
      password: !0,
      image: !0
     }) x.pseudos[e] = pe(e);
    for (e in {
      submit: !0,
      reset: !0
     }) x.pseudos[e] = he(e);

    function ye() {}

    function be(e) {
     for (var t = 0, n = e.length, r = ""; t < n; t++) r += e[t].value;
     return r
    }

    function xe(s, e, t) {
     var l = e.dir,
      u = e.next,
      c = u || l,
      d = t && "parentNode" === c,
      f = r++;
     return e.first ? function(e, t, n) {
      for (; e = e[l];)
       if (1 === e.nodeType || d) return s(e, t, n);
      return !1
     } : function(e, t, n) {
      var r, i, a, o = [T, f];
      if (n) {
       for (; e = e[l];)
        if ((1 === e.nodeType || d) && s(e, t, n)) return !0
      } else
       for (; e = e[l];)
        if (1 === e.nodeType || d)
         if (i = (a = e[C] || (e[C] = {}))[e.uniqueID] || (a[e.uniqueID] = {}), u && u === e.nodeName.toLowerCase()) e = e[l] || e;
         else {
          if ((r = i[c]) && r[0] === T && r[1] === f) return o[2] = r[2];
          if ((i[c] = o)[2] = s(e, t, n)) return !0
         } return !1
     }
    }

    function we(i) {
     return 1 < i.length ? function(e, t, n) {
      for (var r = i.length; r--;)
       if (!i[r](e, t, n)) return !1;
      return !0
     } : i[0]
    }

    function _e(e, t, n, r, i) {
     for (var a, o = [], s = 0, l = e.length, u = null != t; s < l; s++)(a = e[s]) && (n && !n(a, r, i) || (o.push(a), u && t.push(s)));
     return o
    }

    function Ee(p, h, g, m, v, e) {
     return m && !m[C] && (m = Ee(m)), v && !v[C] && (v = Ee(v, e)), ue(function(e, t, n, r) {
      var i, a, o, s = [],
       l = [],
       u = t.length,
       c = e || function(e, t, n) {
        for (var r = 0, i = t.length; r < i; r++) se(e, t[r], n);
        return n
       }(h || "*", n.nodeType ? [n] : n, []),
       d = !p || !e && h ? c : _e(c, s, p, n, r),
       f = g ? v || (e ? p : u || m) ? [] : t : d;
      if (g && g(d, f, n, r), m)
       for (i = _e(f, l), m(i, [], n, r), a = i.length; a--;)(o = i[a]) && (f[l[a]] = !(d[l[a]] = o));
      if (e) {
       if (v || p) {
        if (v) {
         for (i = [], a = f.length; a--;)(o = f[a]) && i.push(d[a] = o);
         v(null, f = [], i, r)
        }
        for (a = f.length; a--;)(o = f[a]) && -1 < (i = v ? P(e, o) : s[a]) && (e[i] = !(t[i] = o))
       }
      } else f = _e(f === t ? f.splice(u, f.length) : f), v ? v(null, t, f, r) : L.apply(t, f)
     })
    }

    function ke(e) {
     for (var i, t, n, r = e.length, a = x.relative[e[0].type], o = a || x.relative[" "], s = a ? 1 : 0, l = xe(function(e) {
       return e === i
      }, o, !0), u = xe(function(e) {
       return -1 < P(i, e)
      }, o, !0), c = [function(e, t, n) {
       var r = !a && (n || t !== w) || ((i = t).nodeType ? l(e, t, n) : u(e, t, n));
       return i = null, r
      }]; s < r; s++)
      if (t = x.relative[e[s].type]) c = [xe(we(c), t)];
      else {
       if ((t = x.filter[e[s].type].apply(null, e[s].matches))[C]) {
        for (n = ++s; n < r && !x.relative[e[n].type]; n++);
        return Ee(1 < s && we(c), 1 < s && be(e.slice(0, s - 1).concat({
         value: " " === e[s - 2].type ? "*" : ""
        })).replace(F, "$1"), t, s < n && ke(e.slice(s, n)), n < r && ke(e = e.slice(n)), n < r && be(e))
       }
       c.push(t)
      } return we(c)
    }
    return ye.prototype = x.filters = x.pseudos, x.setFilters = new ye, h = se.tokenize = function(e, t) {
     var n, r, i, a, o, s, l, u = b[e + " "];
     if (u) return t ? 0 : u.slice(0);
     for (o = e, s = [], l = x.preFilter; o;) {
      for (a in n && !(r = $.exec(o)) || (r && (o = o.slice(r[0].length) || o), s.push(i = [])), n = !1, (r = z.exec(o)) && (n = r.shift(), i.push({
        value: n,
        type: r[0].replace(F, " ")
       }), o = o.slice(n.length)), x.filter) !(r = G[a].exec(o)) || l[a] && !(r = l[a](r)) || (n = r.shift(), i.push({
       value: n,
       type: a,
       matches: r
      }), o = o.slice(n.length));
      if (!n) break
     }
     return t ? o.length : o ? se.error(e) : b(e, s).slice(0)
    }, d = se.compile = function(e, t) {
     var n, m, v, y, b, r, i = [],
      a = [],
      o = S[e + " "];
     if (!o) {
      for (t || (t = h(e)), n = t.length; n--;)(o = ke(t[n]))[C] ? i.push(o) : a.push(o);
      (o = S(e, (m = a, y = 0 < (v = i).length, b = 0 < m.length, r = function(e, t, n, r, i) {
       var a, o, s, l = 0,
        u = "0",
        c = e && [],
        d = [],
        f = w,
        p = e || b && x.find.TAG("*", i),
        h = T += null == f ? 1 : Math.random() || .1,
        g = p.length;
       for (i && (w = t === E || t || i); u !== g && null != (a = p[u]); u++) {
        if (b && a) {
         for (o = 0, t || a.ownerDocument === E || (_(a), n = !k); s = m[o++];)
          if (s(a, t || E, n)) {
           r.push(a);
           break
          } i && (T = h)
        }
        y && ((a = !s && a) && l--, e && c.push(a))
       }
       if (l += u, y && u !== l) {
        for (o = 0; s = v[o++];) s(c, d, t, n);
        if (e) {
         if (0 < l)
          for (; u--;) c[u] || d[u] || (d[u] = j.call(r));
         d = _e(d)
        }
        L.apply(r, d), i && !e && 0 < d.length && 1 < l + v.length && se.uniqueSort(r)
       }
       return i && (T = h, w = f), c
      }, y ? ue(r) : r))).selector = e
     }
     return o
    }, g = se.select = function(e, t, n, r) {
     var i, a, o, s, l, u = "function" == typeof e && e,
      c = !r && h(e = u.selector || e);
     if (n = n || [], 1 === c.length) {
      if (2 < (a = c[0] = c[0].slice(0)).length && "ID" === (o = a[0]).type && 9 === t.nodeType && k && x.relative[a[1].type]) {
       if (!(t = (x.find.ID(o.matches[0].replace(te, ne), t) || [])[0])) return n;
       u && (t = t.parentNode), e = e.slice(a.shift().value.length)
      }
      for (i = G.needsContext.test(e) ? 0 : a.length; i-- && (o = a[i], !x.relative[s = o.type]);)
       if ((l = x.find[s]) && (r = l(o.matches[0].replace(te, ne), ee.test(a[0].type) && ve(t.parentNode) || t))) {
        if (a.splice(i, 1), !(e = r.length && be(a))) return L.apply(n, r), n;
        break
       }
     }
     return (u || d(e, c))(r, t, !k, n, !t || ee.test(e) && ve(t.parentNode) || t), n
    }, p.sortStable = C.split("").sort(O).join("") === C, p.detectDuplicates = !!u, _(), p.sortDetached = ce(function(e) {
     return 1 & e.compareDocumentPosition(E.createElement("fieldset"))
    }), ce(function(e) {
     return e.innerHTML = "<a href='#'></a>", "#" === e.firstChild.getAttribute("href")
    }) || de("type|href|height|width", function(e, t, n) {
     if (!n) return e.getAttribute(t, "type" === t.toLowerCase() ? 1 : 2)
    }), p.attributes && ce(function(e) {
     return e.innerHTML = "<input/>", e.firstChild.setAttribute("value", ""), "" === e.firstChild.getAttribute("value")
    }) || de("value", function(e, t, n) {
     if (!n && "input" === e.nodeName.toLowerCase()) return e.defaultValue
    }), ce(function(e) {
     return null == e.getAttribute("disabled")
    }) || de(M, function(e, t, n) {
     var r;
     if (!n) return !0 === e[t] ? t.toLowerCase() : (r = e.getAttributeNode(t)) && r.specified ? r.value : null
    }), se
   }(E);
  C.find = h, C.expr = h.selectors, C.expr[":"] = C.expr.pseudos, C.uniqueSort = C.unique = h.uniqueSort, C.text = h.getText, C.isXMLDoc = h.isXML, C.contains = h.contains, C.escapeSelector = h.escape;
  var _ = function(e, t, n) {
    for (var r = [], i = void 0 !== n;
     (e = e[t]) && 9 !== e.nodeType;)
     if (1 === e.nodeType) {
      if (i && C(e).is(n)) break;
      r.push(e)
     } return r
   },
   T = function(e, t) {
    for (var n = []; e; e = e.nextSibling) 1 === e.nodeType && e !== t && n.push(e);
    return n
   },
   S = C.expr.match.needsContext;

  function N(e, t) {
   return e.nodeName && e.nodeName.toLowerCase() === t.toLowerCase()
  }
  var O = /^<([a-z][^\/\0>:\x20\t\r\n\f]*)[\x20\t\r\n\f]*\/?>(?:<\/\1>|)$/i;

  function A(e, n, r) {
   return y(n) ? C.grep(e, function(e, t) {
    return !!n.call(e, t, e) !== r
   }) : n.nodeType ? C.grep(e, function(e) {
    return e === n !== r
   }) : "string" != typeof n ? C.grep(e, function(e) {
    return -1 < i.call(n, e) !== r
   }) : C.filter(n, e, r)
  }
  C.filter = function(e, t, n) {
   var r = t[0];
   return n && (e = ":not(" + e + ")"), 1 === t.length && 1 === r.nodeType ? C.find.matchesSelector(r, e) ? [r] : [] : C.find.matches(e, C.grep(t, function(e) {
    return 1 === e.nodeType
   }))
  }, C.fn.extend({
   find: function(e) {
    var t, n, r = this.length,
     i = this;
    if ("string" != typeof e) return this.pushStack(C(e).filter(function() {
     for (t = 0; t < r; t++)
      if (C.contains(i[t], this)) return !0
    }));
    for (n = this.pushStack([]), t = 0; t < r; t++) C.find(e, i[t], n);
    return 1 < r ? C.uniqueSort(n) : n
   },
   filter: function(e) {
    return this.pushStack(A(this, e || [], !1))
   },
   not: function(e) {
    return this.pushStack(A(this, e || [], !0))
   },
   is: function(e) {
    return !!A(this, "string" == typeof e && S.test(e) ? C(e) : e || [], !1).length
   }
  });
  var j, D = /^(?:\s*(<[\w\W]+>)[^>]*|#([\w-]+))$/;
  (C.fn.init = function(e, t, n) {
   var r, i;
   if (!e) return this;
   if (n = n || j, "string" != typeof e) return e.nodeType ? (this[0] = e, this.length = 1, this) : y(e) ? void 0 !== n.ready ? n.ready(e) : e(C) : C.makeArray(e, this);
   if (!(r = "<" === e[0] && ">" === e[e.length - 1] && 3 <= e.length ? [null, e, null] : D.exec(e)) || !r[1] && t) return !t || t.jquery ? (t || n).find(e) : this.constructor(t).find(e);
   if (r[1]) {
    if (t = t instanceof C ? t[0] : t, C.merge(this, C.parseHTML(r[1], t && t.nodeType ? t.ownerDocument || t : k, !0)), O.test(r[1]) && C.isPlainObject(t))
     for (r in t) y(this[r]) ? this[r](t[r]) : this.attr(r, t[r]);
    return this
   }
   return (i = k.getElementById(r[2])) && (this[0] = i, this.length = 1), this
  }).prototype = C.fn, j = C(k);
  var L = /^(?:parents|prev(?:Until|All))/,
   R = {
    children: !0,
    contents: !0,
    next: !0,
    prev: !0
   };

  function P(e, t) {
   for (;
    (e = e[t]) && 1 !== e.nodeType;);
   return e
  }
  C.fn.extend({
   has: function(e) {
    var t = C(e, this),
     n = t.length;
    return this.filter(function() {
     for (var e = 0; e < n; e++)
      if (C.contains(this, t[e])) return !0
    })
   },
   closest: function(e, t) {
    var n, r = 0,
     i = this.length,
     a = [],
     o = "string" != typeof e && C(e);
    if (!S.test(e))
     for (; r < i; r++)
      for (n = this[r]; n && n !== t; n = n.parentNode)
       if (n.nodeType < 11 && (o ? -1 < o.index(n) : 1 === n.nodeType && C.find.matchesSelector(n, e))) {
        a.push(n);
        break
       } return this.pushStack(1 < a.length ? C.uniqueSort(a) : a)
   },
   index: function(e) {
    return e ? "string" == typeof e ? i.call(C(e), this[0]) : i.call(this, e.jquery ? e[0] : e) : this[0] && this[0].parentNode ? this.first().prevAll().length : -1
   },
   add: function(e, t) {
    return this.pushStack(C.uniqueSort(C.merge(this.get(), C(e, t))))
   },
   addBack: function(e) {
    return this.add(null == e ? this.prevObject : this.prevObject.filter(e))
   }
  }), C.each({
   parent: function(e) {
    var t = e.parentNode;
    return t && 11 !== t.nodeType ? t : null
   },
   parents: function(e) {
    return _(e, "parentNode")
   },
   parentsUntil: function(e, t, n) {
    return _(e, "parentNode", n)
   },
   next: function(e) {
    return P(e, "nextSibling")
   },
   prev: function(e) {
    return P(e, "previousSibling")
   },
   nextAll: function(e) {
    return _(e, "nextSibling")
   },
   prevAll: function(e) {
    return _(e, "previousSibling")
   },
   nextUntil: function(e, t, n) {
    return _(e, "nextSibling", n)
   },
   prevUntil: function(e, t, n) {
    return _(e, "previousSibling", n)
   },
   siblings: function(e) {
    return T((e.parentNode || {}).firstChild, e)
   },
   children: function(e) {
    return T(e.firstChild)
   },
   contents: function(e) {
    return void 0 !== e.contentDocument ? e.contentDocument : (N(e, "template") && (e = e.content || e), C.merge([], e.childNodes))
   }
  }, function(r, i) {
   C.fn[r] = function(e, t) {
    var n = C.map(this, i, e);
    return "Until" !== r.slice(-5) && (t = e), t && "string" == typeof t && (n = C.filter(t, n)), 1 < this.length && (R[r] || C.uniqueSort(n), L.test(r) && n.reverse()), this.pushStack(n)
   }
  });
  var M = /[^\x20\t\r\n\f]+/g;

  function I(e) {
   return e
  }

  function q(e) {
   throw e
  }

  function B(e, t, n, r) {
   var i;
   try {
    e && y(i = e.promise) ? i.call(e).done(t).fail(n) : e && y(i = e.then) ? i.call(e, t, n) : t.apply(void 0, [e].slice(r))
   } catch (e) {
    n.apply(void 0, [e])
   }
  }
  C.Callbacks = function(r) {
   var e, n;
   r = "string" == typeof r ? (e = r, n = {}, C.each(e.match(M) || [], function(e, t) {
    n[t] = !0
   }), n) : C.extend({}, r);
   var i, t, a, o, s = [],
    l = [],
    u = -1,
    c = function() {
     for (o = o || r.once, a = i = !0; l.length; u = -1)
      for (t = l.shift(); ++u < s.length;) !1 === s[u].apply(t[0], t[1]) && r.stopOnFalse && (u = s.length, t = !1);
     r.memory || (t = !1), i = !1, o && (s = t ? [] : "")
    },
    d = {
     add: function() {
      return s && (t && !i && (u = s.length - 1, l.push(t)), function n(e) {
       C.each(e, function(e, t) {
        y(t) ? r.unique && d.has(t) || s.push(t) : t && t.length && "string" !== w(t) && n(t)
       })
      }(arguments), t && !i && c()), this
     },
     remove: function() {
      return C.each(arguments, function(e, t) {
       for (var n; - 1 < (n = C.inArray(t, s, n));) s.splice(n, 1), n <= u && u--
      }), this
     },
     has: function(e) {
      return e ? -1 < C.inArray(e, s) : 0 < s.length
     },
     empty: function() {
      return s && (s = []), this
     },
     disable: function() {
      return o = l = [], s = t = "", this
     },
     disabled: function() {
      return !s
     },
     lock: function() {
      return o = l = [], t || i || (s = t = ""), this
     },
     locked: function() {
      return !!o
     },
     fireWith: function(e, t) {
      return o || (t = [e, (t = t || []).slice ? t.slice() : t], l.push(t), i || c()), this
     },
     fire: function() {
      return d.fireWith(this, arguments), this
     },
     fired: function() {
      return !!a
     }
    };
   return d
  }, C.extend({
   Deferred: function(e) {
    var a = [
      ["notify", "progress", C.Callbacks("memory"), C.Callbacks("memory"), 2],
      ["resolve", "done", C.Callbacks("once memory"), C.Callbacks("once memory"), 0, "resolved"],
      ["reject", "fail", C.Callbacks("once memory"), C.Callbacks("once memory"), 1, "rejected"]
     ],
     i = "pending",
     o = {
      state: function() {
       return i
      },
      always: function() {
       return s.done(arguments).fail(arguments), this
      },
      catch: function(e) {
       return o.then(null, e)
      },
      pipe: function() {
       var i = arguments;
       return C.Deferred(function(r) {
        C.each(a, function(e, t) {
         var n = y(i[t[4]]) && i[t[4]];
         s[t[1]](function() {
          var e = n && n.apply(this, arguments);
          e && y(e.promise) ? e.promise().progress(r.notify).done(r.resolve).fail(r.reject) : r[t[0] + "With"](this, n ? [e] : arguments)
         })
        }), i = null
       }).promise()
      },
      then: function(t, n, r) {
       var l = 0;

       function u(i, a, o, s) {
        return function() {
         var n = this,
          r = arguments,
          e = function() {
           var e, t;
           if (!(i < l)) {
            if ((e = o.apply(n, r)) === a.promise()) throw new TypeError("Thenable self-resolution");
            t = e && ("object" == typeof e || "function" == typeof e) && e.then, y(t) ? s ? t.call(e, u(l, a, I, s), u(l, a, q, s)) : (l++, t.call(e, u(l, a, I, s), u(l, a, q, s), u(l, a, I, a.notifyWith))) : (o !== I && (n = void 0, r = [e]), (s || a.resolveWith)(n, r))
           }
          },
          t = s ? e : function() {
           try {
            e()
           } catch (e) {
            C.Deferred.exceptionHook && C.Deferred.exceptionHook(e, t.stackTrace), l <= i + 1 && (o !== q && (n = void 0, r = [e]), a.rejectWith(n, r))
           }
          };
         i ? t() : (C.Deferred.getStackHook && (t.stackTrace = C.Deferred.getStackHook()), E.setTimeout(t))
        }
       }
       return C.Deferred(function(e) {
        a[0][3].add(u(0, e, y(r) ? r : I, e.notifyWith)), a[1][3].add(u(0, e, y(t) ? t : I)), a[2][3].add(u(0, e, y(n) ? n : q))
       }).promise()
      },
      promise: function(e) {
       return null != e ? C.extend(e, o) : o
      }
     },
     s = {};
    return C.each(a, function(e, t) {
     var n = t[2],
      r = t[5];
     o[t[1]] = n.add, r && n.add(function() {
      i = r
     }, a[3 - e][2].disable, a[3 - e][3].disable, a[0][2].lock, a[0][3].lock), n.add(t[3].fire), s[t[0]] = function() {
      return s[t[0] + "With"](this === s ? void 0 : this, arguments), this
     }, s[t[0] + "With"] = n.fireWith
    }), o.promise(s), e && e.call(s, s), s
   },
   when: function(e) {
    var n = arguments.length,
     t = n,
     r = Array(t),
     i = s.call(arguments),
     a = C.Deferred(),
     o = function(t) {
      return function(e) {
       r[t] = this, i[t] = 1 < arguments.length ? s.call(arguments) : e, --n || a.resolveWith(r, i)
      }
     };
    if (n <= 1 && (B(e, a.done(o(t)).resolve, a.reject, !n), "pending" === a.state() || y(i[t] && i[t].then))) return a.then();
    for (; t--;) B(i[t], o(t), a.reject);
    return a.promise()
   }
  });
  var Q = /^(Eval|Internal|Range|Reference|Syntax|Type|URI)Error$/;
  C.Deferred.exceptionHook = function(e, t) {
   E.console && E.console.warn && e && Q.test(e.name) && E.console.warn("jQuery.Deferred exception: " + e.message, e.stack, t)
  }, C.readyException = function(e) {
   E.setTimeout(function() {
    throw e
   })
  };
  var H = C.Deferred();

  function F() {
   k.removeEventListener("DOMContentLoaded", F), E.removeEventListener("load", F), C.ready()
  }
  C.fn.ready = function(e) {
   return H.then(e).catch(function(e) {
    C.readyException(e)
   }), this
  }, C.extend({
   isReady: !1,
   readyWait: 1,
   ready: function(e) {
    (!0 === e ? --C.readyWait : C.isReady) || (C.isReady = !0) !== e && 0 < --C.readyWait || H.resolveWith(k, [C])
   }
  }), C.ready.then = H.then, "complete" === k.readyState || "loading" !== k.readyState && !k.documentElement.doScroll ? E.setTimeout(C.ready) : (k.addEventListener("DOMContentLoaded", F), E.addEventListener("load", F));
  var $ = function(e, t, n, r, i, a, o) {
    var s = 0,
     l = e.length,
     u = null == n;
    if ("object" === w(n))
     for (s in i = !0, n) $(e, t, s, n[s], !0, a, o);
    else if (void 0 !== r && (i = !0, y(r) || (o = !0), u && (t = o ? (t.call(e, r), null) : (u = t, function(e, t, n) {
      return u.call(C(e), n)
     })), t))
     for (; s < l; s++) t(e[s], n, o ? r : r.call(e[s], s, t(e[s], n)));
    return i ? e : u ? t.call(e) : l ? t(e[0], n) : a
   },
   z = /^-ms-/,
   W = /-([a-z])/g;

  function U(e, t) {
   return t.toUpperCase()
  }

  function V(e) {
   return e.replace(z, "ms-").replace(W, U)
  }
  var G = function(e) {
   return 1 === e.nodeType || 9 === e.nodeType || !+e.nodeType
  };

  function K() {
   this.expando = C.expando + K.uid++
  }
  K.uid = 1, K.prototype = {
   cache: function(e) {
    var t = e[this.expando];
    return t || (t = {}, G(e) && (e.nodeType ? e[this.expando] = t : Object.defineProperty(e, this.expando, {
     value: t,
     configurable: !0
    }))), t
   },
   set: function(e, t, n) {
    var r, i = this.cache(e);
    if ("string" == typeof t) i[V(t)] = n;
    else
     for (r in t) i[V(r)] = t[r];
    return i
   },
   get: function(e, t) {
    return void 0 === t ? this.cache(e) : e[this.expando] && e[this.expando][V(t)]
   },
   access: function(e, t, n) {
    return void 0 === t || t && "string" == typeof t && void 0 === n ? this.get(e, t) : (this.set(e, t, n), void 0 !== n ? n : t)
   },
   remove: function(e, t) {
    var n, r = e[this.expando];
    if (void 0 !== r) {
     if (void 0 !== t) {
      n = (t = Array.isArray(t) ? t.map(V) : (t = V(t)) in r ? [t] : t.match(M) || []).length;
      for (; n--;) delete r[t[n]]
     }(void 0 === t || C.isEmptyObject(r)) && (e.nodeType ? e[this.expando] = void 0 : delete e[this.expando])
    }
   },
   hasData: function(e) {
    var t = e[this.expando];
    return void 0 !== t && !C.isEmptyObject(t)
   }
  };
  var X = new K,
   Z = new K,
   J = /^(?:\{[\w\W]*\}|\[[\w\W]*\])$/,
   Y = /[A-Z]/g;

  function ee(e, t, n) {
   var r, i;
   if (void 0 === n && 1 === e.nodeType)
    if (r = "data-" + t.replace(Y, "-$&").toLowerCase(), "string" == typeof(n = e.getAttribute(r))) {
     try {
      n = "true" === (i = n) || "false" !== i && ("null" === i ? null : i === +i + "" ? +i : J.test(i) ? JSON.parse(i) : i)
     } catch (e) {}
     Z.set(e, t, n)
    } else n = void 0;
   return n
  }
  C.extend({
   hasData: function(e) {
    return Z.hasData(e) || X.hasData(e)
   },
   data: function(e, t, n) {
    return Z.access(e, t, n)
   },
   removeData: function(e, t) {
    Z.remove(e, t)
   },
   _data: function(e, t, n) {
    return X.access(e, t, n)
   },
   _removeData: function(e, t) {
    X.remove(e, t)
   }
  }), C.fn.extend({
   data: function(n, e) {
    var t, r, i, a = this[0],
     o = a && a.attributes;
    if (void 0 !== n) return "object" == typeof n ? this.each(function() {
     Z.set(this, n)
    }) : $(this, function(e) {
     var t;
     if (a && void 0 === e) return void 0 !== (t = Z.get(a, n)) ? t : void 0 !== (t = ee(a, n)) ? t : void 0;
     this.each(function() {
      Z.set(this, n, e)
     })
    }, null, e, 1 < arguments.length, null, !0);
    if (this.length && (i = Z.get(a), 1 === a.nodeType && !X.get(a, "hasDataAttrs"))) {
     for (t = o.length; t--;) o[t] && 0 === (r = o[t].name).indexOf("data-") && (r = V(r.slice(5)), ee(a, r, i[r]));
     X.set(a, "hasDataAttrs", !0)
    }
    return i
   },
   removeData: function(e) {
    return this.each(function() {
     Z.remove(this, e)
    })
   }
  }), C.extend({
   queue: function(e, t, n) {
    var r;
    if (e) return t = (t || "fx") + "queue", r = X.get(e, t), n && (!r || Array.isArray(n) ? r = X.access(e, t, C.makeArray(n)) : r.push(n)), r || []
   },
   dequeue: function(e, t) {
    t = t || "fx";
    var n = C.queue(e, t),
     r = n.length,
     i = n.shift(),
     a = C._queueHooks(e, t);
    "inprogress" === i && (i = n.shift(), r--), i && ("fx" === t && n.unshift("inprogress"), delete a.stop, i.call(e, function() {
     C.dequeue(e, t)
    }, a)), !r && a && a.empty.fire()
   },
   _queueHooks: function(e, t) {
    var n = t + "queueHooks";
    return X.get(e, n) || X.access(e, n, {
     empty: C.Callbacks("once memory").add(function() {
      X.remove(e, [t + "queue", n])
     })
    })
   }
  }), C.fn.extend({
   queue: function(t, n) {
    var e = 2;
    return "string" != typeof t && (n = t, t = "fx", e--), arguments.length < e ? C.queue(this[0], t) : void 0 === n ? this : this.each(function() {
     var e = C.queue(this, t, n);
     C._queueHooks(this, t), "fx" === t && "inprogress" !== e[0] && C.dequeue(this, t)
    })
   },
   dequeue: function(e) {
    return this.each(function() {
     C.dequeue(this, e)
    })
   },
   clearQueue: function(e) {
    return this.queue(e || "fx", [])
   },
   promise: function(e, t) {
    var n, r = 1,
     i = C.Deferred(),
     a = this,
     o = this.length,
     s = function() {
      --r || i.resolveWith(a, [a])
     };
    for ("string" != typeof e && (t = e, e = void 0), e = e || "fx"; o--;)(n = X.get(a[o], e + "queueHooks")) && n.empty && (r++, n.empty.add(s));
    return s(), i.promise(t)
   }
  });
  var te = /[+-]?(?:\d*\.|)\d+(?:[eE][+-]?\d+|)/.source,
   ne = new RegExp("^(?:([+-])=|)(" + te + ")([a-z%]*)$", "i"),
   re = ["Top", "Right", "Bottom", "Left"],
   ie = k.documentElement,
   ae = function(e) {
    return C.contains(e.ownerDocument, e)
   },
   oe = {
    composed: !0
   };
  ie.getRootNode && (ae = function(e) {
   return C.contains(e.ownerDocument, e) || e.getRootNode(oe) === e.ownerDocument
  });
  var se = function(e, t) {
    return "none" === (e = t || e).style.display || "" === e.style.display && ae(e) && "none" === C.css(e, "display")
   },
   le = function(e, t, n, r) {
    var i, a, o = {};
    for (a in t) o[a] = e.style[a], e.style[a] = t[a];
    for (a in i = n.apply(e, r || []), t) e.style[a] = o[a];
    return i
   };

  function ue(e, t, n, r) {
   var i, a, o = 20,
    s = r ? function() {
     return r.cur()
    } : function() {
     return C.css(e, t, "")
    },
    l = s(),
    u = n && n[3] || (C.cssNumber[t] ? "" : "px"),
    c = e.nodeType && (C.cssNumber[t] || "px" !== u && +l) && ne.exec(C.css(e, t));
   if (c && c[3] !== u) {
    for (l /= 2, u = u || c[3], c = +l || 1; o--;) C.style(e, t, c + u), (1 - a) * (1 - (a = s() / l || .5)) <= 0 && (o = 0), c /= a;
    c *= 2, C.style(e, t, c + u), n = n || []
   }
   return n && (c = +c || +l || 0, i = n[1] ? c + (n[1] + 1) * n[2] : +n[2], r && (r.unit = u, r.start = c, r.end = i)), i
  }
  var ce = {};

  function de(e, t) {
   for (var n, r, i, a, o, s, l, u = [], c = 0, d = e.length; c < d; c++)(r = e[c]).style && (n = r.style.display, t ? ("none" === n && (u[c] = X.get(r, "display") || null, u[c] || (r.style.display = "")), "" === r.style.display && se(r) && (u[c] = (l = o = a = void 0, o = (i = r).ownerDocument, s = i.nodeName, (l = ce[s]) || (a = o.body.appendChild(o.createElement(s)), l = C.css(a, "display"), a.parentNode.removeChild(a), "none" === l && (l = "block"), ce[s] = l)))) : "none" !== n && (u[c] = "none", X.set(r, "display", n)));
   for (c = 0; c < d; c++) null != u[c] && (e[c].style.display = u[c]);
   return e
  }
  C.fn.extend({
   show: function() {
    return de(this, !0)
   },
   hide: function() {
    return de(this)
   },
   toggle: function(e) {
    return "boolean" == typeof e ? e ? this.show() : this.hide() : this.each(function() {
     se(this) ? C(this).show() : C(this).hide()
    })
   }
  });
  var fe = /^(?:checkbox|radio)$/i,
   pe = /<([a-z][^\/\0>\x20\t\r\n\f]*)/i,
   he = /^$|^module$|\/(?:java|ecma)script/i,
   ge = {
    option: [1, "<select multiple='multiple'>", "</select>"],
    thead: [1, "<table>", "</table>"],
    col: [2, "<table><colgroup>", "</colgroup></table>"],
    tr: [2, "<table><tbody>", "</tbody></table>"],
    td: [3, "<table><tbody><tr>", "</tr></tbody></table>"],
    _default: [0, "", ""]
   };

  function me(e, t) {
   var n;
   return n = void 0 !== e.getElementsByTagName ? e.getElementsByTagName(t || "*") : void 0 !== e.querySelectorAll ? e.querySelectorAll(t || "*") : [], void 0 === t || t && N(e, t) ? C.merge([e], n) : n
  }

  function ve(e, t) {
   for (var n = 0, r = e.length; n < r; n++) X.set(e[n], "globalEval", !t || X.get(t[n], "globalEval"))
  }
  ge.optgroup = ge.option, ge.tbody = ge.tfoot = ge.colgroup = ge.caption = ge.thead, ge.th = ge.td;
  var ye, be, xe = /<|&#?\w+;/;

  function we(e, t, n, r, i) {
   for (var a, o, s, l, u, c, d = t.createDocumentFragment(), f = [], p = 0, h = e.length; p < h; p++)
    if ((a = e[p]) || 0 === a)
     if ("object" === w(a)) C.merge(f, a.nodeType ? [a] : a);
     else if (xe.test(a)) {
    for (o = o || d.appendChild(t.createElement("div")), s = (pe.exec(a) || ["", ""])[1].toLowerCase(), l = ge[s] || ge._default, o.innerHTML = l[1] + C.htmlPrefilter(a) + l[2], c = l[0]; c--;) o = o.lastChild;
    C.merge(f, o.childNodes), (o = d.firstChild).textContent = ""
   } else f.push(t.createTextNode(a));
   for (d.textContent = "", p = 0; a = f[p++];)
    if (r && -1 < C.inArray(a, r)) i && i.push(a);
    else if (u = ae(a), o = me(d.appendChild(a), "script"), u && ve(o), n)
    for (c = 0; a = o[c++];) he.test(a.type || "") && n.push(a);
   return d
  }
  ye = k.createDocumentFragment().appendChild(k.createElement("div")), (be = k.createElement("input")).setAttribute("type", "radio"), be.setAttribute("checked", "checked"), be.setAttribute("name", "t"), ye.appendChild(be), v.checkClone = ye.cloneNode(!0).cloneNode(!0).lastChild.checked, ye.innerHTML = "<textarea>x</textarea>", v.noCloneChecked = !!ye.cloneNode(!0).lastChild.defaultValue;
  var _e = /^key/,
   Ee = /^(?:mouse|pointer|contextmenu|drag|drop)|click/,
   ke = /^([^.]*)(?:\.(.+)|)/;

  function Ce() {
   return !0
  }

  function Te() {
   return !1
  }

  function Se(e, t) {
   return e === function() {
    try {
     return k.activeElement
    } catch (e) {}
   }() == ("focus" === t)
  }

  function Ne(e, t, n, r, i, a) {
   var o, s;
   if ("object" == typeof t) {
    for (s in "string" != typeof n && (r = r || n, n = void 0), t) Ne(e, s, n, r, t[s], a);
    return e
   }
   if (null == r && null == i ? (i = n, r = n = void 0) : null == i && ("string" == typeof n ? (i = r, r = void 0) : (i = r, r = n, n = void 0)), !1 === i) i = Te;
   else if (!i) return e;
   return 1 === a && (o = i, (i = function(e) {
    return C().off(e), o.apply(this, arguments)
   }).guid = o.guid || (o.guid = C.guid++)), e.each(function() {
    C.event.add(this, t, i, r, n)
   })
  }

  function Oe(e, i, a) {
   a ? (X.set(e, i, !1), C.event.add(e, i, {
    namespace: !1,
    handler: function(e) {
     var t, n, r = X.get(this, i);
     if (1 & e.isTrigger && this[i]) {
      if (r.length)(C.event.special[i] || {}).delegateType && e.stopPropagation();
      else if (r = s.call(arguments), X.set(this, i, r), t = a(this, i), this[i](), r !== (n = X.get(this, i)) || t ? X.set(this, i, !1) : n = {}, r !== n) return e.stopImmediatePropagation(), e.preventDefault(), n.value
     } else r.length && (X.set(this, i, {
      value: C.event.trigger(C.extend(r[0], C.Event.prototype), r.slice(1), this)
     }), e.stopImmediatePropagation())
    }
   })) : void 0 === X.get(e, i) && C.event.add(e, i, Ce)
  }
  C.event = {
   global: {},
   add: function(t, e, n, r, i) {
    var a, o, s, l, u, c, d, f, p, h, g, m = X.get(t);
    if (m)
     for (n.handler && (n = (a = n).handler, i = a.selector), i && C.find.matchesSelector(ie, i), n.guid || (n.guid = C.guid++), (l = m.events) || (l = m.events = {}), (o = m.handle) || (o = m.handle = function(e) {
       return void 0 !== C && C.event.triggered !== e.type ? C.event.dispatch.apply(t, arguments) : void 0
      }), u = (e = (e || "").match(M) || [""]).length; u--;) p = g = (s = ke.exec(e[u]) || [])[1], h = (s[2] || "").split(".").sort(), p && (d = C.event.special[p] || {}, p = (i ? d.delegateType : d.bindType) || p, d = C.event.special[p] || {}, c = C.extend({
      type: p,
      origType: g,
      data: r,
      handler: n,
      guid: n.guid,
      selector: i,
      needsContext: i && C.expr.match.needsContext.test(i),
      namespace: h.join(".")
     }, a), (f = l[p]) || ((f = l[p] = []).delegateCount = 0, d.setup && !1 !== d.setup.call(t, r, h, o) || t.addEventListener && t.addEventListener(p, o)), d.add && (d.add.call(t, c), c.handler.guid || (c.handler.guid = n.guid)), i ? f.splice(f.delegateCount++, 0, c) : f.push(c), C.event.global[p] = !0)
   },
   remove: function(e, t, n, r, i) {
    var a, o, s, l, u, c, d, f, p, h, g, m = X.hasData(e) && X.get(e);
    if (m && (l = m.events)) {
     for (u = (t = (t || "").match(M) || [""]).length; u--;)
      if (p = g = (s = ke.exec(t[u]) || [])[1], h = (s[2] || "").split(".").sort(), p) {
       for (d = C.event.special[p] || {}, f = l[p = (r ? d.delegateType : d.bindType) || p] || [], s = s[2] && new RegExp("(^|\\.)" + h.join("\\.(?:.*\\.|)") + "(\\.|$)"), o = a = f.length; a--;) c = f[a], !i && g !== c.origType || n && n.guid !== c.guid || s && !s.test(c.namespace) || r && r !== c.selector && ("**" !== r || !c.selector) || (f.splice(a, 1), c.selector && f.delegateCount--, d.remove && d.remove.call(e, c));
       o && !f.length && (d.teardown && !1 !== d.teardown.call(e, h, m.handle) || C.removeEvent(e, p, m.handle), delete l[p])
      } else
       for (p in l) C.event.remove(e, p + t[u], n, r, !0);
     C.isEmptyObject(l) && X.remove(e, "handle events")
    }
   },
   dispatch: function(e) {
    var t, n, r, i, a, o, s = C.event.fix(e),
     l = new Array(arguments.length),
     u = (X.get(this, "events") || {})[s.type] || [],
     c = C.event.special[s.type] || {};
    for (l[0] = s, t = 1; t < arguments.length; t++) l[t] = arguments[t];
    if (s.delegateTarget = this, !c.preDispatch || !1 !== c.preDispatch.call(this, s)) {
     for (o = C.event.handlers.call(this, s, u), t = 0;
      (i = o[t++]) && !s.isPropagationStopped();)
      for (s.currentTarget = i.elem, n = 0;
       (a = i.handlers[n++]) && !s.isImmediatePropagationStopped();) s.rnamespace && !1 !== a.namespace && !s.rnamespace.test(a.namespace) || (s.handleObj = a, s.data = a.data, void 0 !== (r = ((C.event.special[a.origType] || {}).handle || a.handler).apply(i.elem, l)) && !1 === (s.result = r) && (s.preventDefault(), s.stopPropagation()));
     return c.postDispatch && c.postDispatch.call(this, s), s.result
    }
   },
   handlers: function(e, t) {
    var n, r, i, a, o, s = [],
     l = t.delegateCount,
     u = e.target;
    if (l && u.nodeType && !("click" === e.type && 1 <= e.button))
     for (; u !== this; u = u.parentNode || this)
      if (1 === u.nodeType && ("click" !== e.type || !0 !== u.disabled)) {
       for (a = [], o = {}, n = 0; n < l; n++) void 0 === o[i = (r = t[n]).selector + " "] && (o[i] = r.needsContext ? -1 < C(i, this).index(u) : C.find(i, this, null, [u]).length), o[i] && a.push(r);
       a.length && s.push({
        elem: u,
        handlers: a
       })
      } return u = this, l < t.length && s.push({
     elem: u,
     handlers: t.slice(l)
    }), s
   },
   addProp: function(t, e) {
    Object.defineProperty(C.Event.prototype, t, {
     enumerable: !0,
     configurable: !0,
     get: y(e) ? function() {
      if (this.originalEvent) return e(this.originalEvent)
     } : function() {
      if (this.originalEvent) return this.originalEvent[t]
     },
     set: function(e) {
      Object.defineProperty(this, t, {
       enumerable: !0,
       configurable: !0,
       writable: !0,
       value: e
      })
     }
    })
   },
   fix: function(e) {
    return e[C.expando] ? e : new C.Event(e)
   },
   special: {
    load: {
     noBubble: !0
    },
    click: {
     setup: function(e) {
      var t = this || e;
      return fe.test(t.type) && t.click && N(t, "input") && Oe(t, "click", Ce), !1
     },
     trigger: function(e) {
      var t = this || e;
      return fe.test(t.type) && t.click && N(t, "input") && Oe(t, "click"), !0
     },
     _default: function(e) {
      var t = e.target;
      return fe.test(t.type) && t.click && N(t, "input") && X.get(t, "click") || N(t, "a")
     }
    },
    beforeunload: {
     postDispatch: function(e) {
      void 0 !== e.result && e.originalEvent && (e.originalEvent.returnValue = e.result)
     }
    }
   }
  }, C.removeEvent = function(e, t, n) {
   e.removeEventListener && e.removeEventListener(t, n)
  }, C.Event = function(e, t) {
   if (!(this instanceof C.Event)) return new C.Event(e, t);
   e && e.type ? (this.originalEvent = e, this.type = e.type, this.isDefaultPrevented = e.defaultPrevented || void 0 === e.defaultPrevented && !1 === e.returnValue ? Ce : Te, this.target = e.target && 3 === e.target.nodeType ? e.target.parentNode : e.target, this.currentTarget = e.currentTarget, this.relatedTarget = e.relatedTarget) : this.type = e, t && C.extend(this, t), this.timeStamp = e && e.timeStamp || Date.now(), this[C.expando] = !0
  }, C.Event.prototype = {
   constructor: C.Event,
   isDefaultPrevented: Te,
   isPropagationStopped: Te,
   isImmediatePropagationStopped: Te,
   isSimulated: !1,
   preventDefault: function() {
    var e = this.originalEvent;
    this.isDefaultPrevented = Ce, e && !this.isSimulated && e.preventDefault()
   },
   stopPropagation: function() {
    var e = this.originalEvent;
    this.isPropagationStopped = Ce, e && !this.isSimulated && e.stopPropagation()
   },
   stopImmediatePropagation: function() {
    var e = this.originalEvent;
    this.isImmediatePropagationStopped = Ce, e && !this.isSimulated && e.stopImmediatePropagation(), this.stopPropagation()
   }
  }, C.each({
   altKey: !0,
   bubbles: !0,
   cancelable: !0,
   changedTouches: !0,
   ctrlKey: !0,
   detail: !0,
   eventPhase: !0,
   metaKey: !0,
   pageX: !0,
   pageY: !0,
   shiftKey: !0,
   view: !0,
   char: !0,
   code: !0,
   charCode: !0,
   key: !0,
   keyCode: !0,
   button: !0,
   buttons: !0,
   clientX: !0,
   clientY: !0,
   offsetX: !0,
   offsetY: !0,
   pointerId: !0,
   pointerType: !0,
   screenX: !0,
   screenY: !0,
   targetTouches: !0,
   toElement: !0,
   touches: !0,
   which: function(e) {
    var t = e.button;
    return null == e.which && _e.test(e.type) ? null != e.charCode ? e.charCode : e.keyCode : !e.which && void 0 !== t && Ee.test(e.type) ? 1 & t ? 1 : 2 & t ? 3 : 4 & t ? 2 : 0 : e.which
   }
  }, C.event.addProp), C.each({
   focus: "focusin",
   blur: "focusout"
  }, function(e, t) {
   C.event.special[e] = {
    setup: function() {
     return Oe(this, e, Se), !1
    },
    trigger: function() {
     return Oe(this, e), !0
    },
    delegateType: t
   }
  }), C.each({
   mouseenter: "mouseover",
   mouseleave: "mouseout",
   pointerenter: "pointerover",
   pointerleave: "pointerout"
  }, function(e, i) {
   C.event.special[e] = {
    delegateType: i,
    bindType: i,
    handle: function(e) {
     var t, n = e.relatedTarget,
      r = e.handleObj;
     return n && (n === this || C.contains(this, n)) || (e.type = r.origType, t = r.handler.apply(this, arguments), e.type = i), t
    }
   }
  }), C.fn.extend({
   on: function(e, t, n, r) {
    return Ne(this, e, t, n, r)
   },
   one: function(e, t, n, r) {
    return Ne(this, e, t, n, r, 1)
   },
   off: function(e, t, n) {
    var r, i;
    if (e && e.preventDefault && e.handleObj) return r = e.handleObj, C(e.delegateTarget).off(r.namespace ? r.origType + "." + r.namespace : r.origType, r.selector, r.handler), this;
    if ("object" != typeof e) return !1 !== t && "function" != typeof t || (n = t, t = void 0), !1 === n && (n = Te), this.each(function() {
     C.event.remove(this, e, n, t)
    });
    for (i in e) this.off(i, t, e[i]);
    return this
   }
  });
  var Ae = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([a-z][^\/\0>\x20\t\r\n\f]*)[^>]*)\/>/gi,
   je = /<script|<style|<link/i,
   De = /checked\s*(?:[^=]|=\s*.checked.)/i,
   Le = /^\s*<!(?:\[CDATA\[|--)|(?:\]\]|--)>\s*$/g;

  function Re(e, t) {
   return N(e, "table") && N(11 !== t.nodeType ? t : t.firstChild, "tr") && C(e).children("tbody")[0] || e
  }

  function Pe(e) {
   return e.type = (null !== e.getAttribute("type")) + "/" + e.type, e
  }

  function Me(e) {
   return "true/" === (e.type || "").slice(0, 5) ? e.type = e.type.slice(5) : e.removeAttribute("type"), e
  }

  function Ie(e, t) {
   var n, r, i, a, o, s, l, u;
   if (1 === t.nodeType) {
    if (X.hasData(e) && (a = X.access(e), o = X.set(t, a), u = a.events))
     for (i in delete o.handle, o.events = {}, u)
      for (n = 0, r = u[i].length; n < r; n++) C.event.add(t, i, u[i][n]);
    Z.hasData(e) && (s = Z.access(e), l = C.extend({}, s), Z.set(t, l))
   }
  }

  function qe(n, r, i, a) {
   r = g.apply([], r);
   var e, t, o, s, l, u, c = 0,
    d = n.length,
    f = d - 1,
    p = r[0],
    h = y(p);
   if (h || 1 < d && "string" == typeof p && !v.checkClone && De.test(p)) return n.each(function(e) {
    var t = n.eq(e);
    h && (r[0] = p.call(this, e, t.html())), qe(t, r, i, a)
   });
   if (d && (t = (e = we(r, n[0].ownerDocument, !1, n, a)).firstChild, 1 === e.childNodes.length && (e = t), t || a)) {
    for (s = (o = C.map(me(e, "script"), Pe)).length; c < d; c++) l = e, c !== f && (l = C.clone(l, !0, !0), s && C.merge(o, me(l, "script"))), i.call(n[c], l, c);
    if (s)
     for (u = o[o.length - 1].ownerDocument, C.map(o, Me), c = 0; c < s; c++) l = o[c], he.test(l.type || "") && !X.access(l, "globalEval") && C.contains(u, l) && (l.src && "module" !== (l.type || "").toLowerCase() ? C._evalUrl && !l.noModule && C._evalUrl(l.src, {
      nonce: l.nonce || l.getAttribute("nonce")
     }) : x(l.textContent.replace(Le, ""), l, u))
   }
   return n
  }

  function Be(e, t, n) {
   for (var r, i = t ? C.filter(t, e) : e, a = 0; null != (r = i[a]); a++) n || 1 !== r.nodeType || C.cleanData(me(r)), r.parentNode && (n && ae(r) && ve(me(r, "script")), r.parentNode.removeChild(r));
   return e
  }
  C.extend({
   htmlPrefilter: function(e) {
    return e.replace(Ae, "<$1></$2>")
   },
   clone: function(e, t, n) {
    var r, i, a, o, s, l, u, c = e.cloneNode(!0),
     d = ae(e);
    if (!(v.noCloneChecked || 1 !== e.nodeType && 11 !== e.nodeType || C.isXMLDoc(e)))
     for (o = me(c), r = 0, i = (a = me(e)).length; r < i; r++) s = a[r], l = o[r], void 0, "input" === (u = l.nodeName.toLowerCase()) && fe.test(s.type) ? l.checked = s.checked : "input" !== u && "textarea" !== u || (l.defaultValue = s.defaultValue);
    if (t)
     if (n)
      for (a = a || me(e), o = o || me(c), r = 0, i = a.length; r < i; r++) Ie(a[r], o[r]);
     else Ie(e, c);
    return 0 < (o = me(c, "script")).length && ve(o, !d && me(e, "script")), c
   },
   cleanData: function(e) {
    for (var t, n, r, i = C.event.special, a = 0; void 0 !== (n = e[a]); a++)
     if (G(n)) {
      if (t = n[X.expando]) {
       if (t.events)
        for (r in t.events) i[r] ? C.event.remove(n, r) : C.removeEvent(n, r, t.handle);
       n[X.expando] = void 0
      }
      n[Z.expando] && (n[Z.expando] = void 0)
     }
   }
  }), C.fn.extend({
   detach: function(e) {
    return Be(this, e, !0)
   },
   remove: function(e) {
    return Be(this, e)
   },
   text: function(e) {
    return $(this, function(e) {
     return void 0 === e ? C.text(this) : this.empty().each(function() {
      1 !== this.nodeType && 11 !== this.nodeType && 9 !== this.nodeType || (this.textContent = e)
     })
    }, null, e, arguments.length)
   },
   append: function() {
    return qe(this, arguments, function(e) {
     1 !== this.nodeType && 11 !== this.nodeType && 9 !== this.nodeType || Re(this, e).appendChild(e)
    })
   },
   prepend: function() {
    return qe(this, arguments, function(e) {
     if (1 === this.nodeType || 11 === this.nodeType || 9 === this.nodeType) {
      var t = Re(this, e);
      t.insertBefore(e, t.firstChild)
     }
    })
   },
   before: function() {
    return qe(this, arguments, function(e) {
     this.parentNode && this.parentNode.insertBefore(e, this)
    })
   },
   after: function() {
    return qe(this, arguments, function(e) {
     this.parentNode && this.parentNode.insertBefore(e, this.nextSibling)
    })
   },
   empty: function() {
    for (var e, t = 0; null != (e = this[t]); t++) 1 === e.nodeType && (C.cleanData(me(e, !1)), e.textContent = "");
    return this
   },
   clone: function(e, t) {
    return e = null != e && e, t = null == t ? e : t, this.map(function() {
     return C.clone(this, e, t)
    })
   },
   html: function(e) {
    return $(this, function(e) {
     var t = this[0] || {},
      n = 0,
      r = this.length;
     if (void 0 === e && 1 === t.nodeType) return t.innerHTML;
     if ("string" == typeof e && !je.test(e) && !ge[(pe.exec(e) || ["", ""])[1].toLowerCase()]) {
      e = C.htmlPrefilter(e);
      try {
       for (; n < r; n++) 1 === (t = this[n] || {}).nodeType && (C.cleanData(me(t, !1)), t.innerHTML = e);
       t = 0
      } catch (e) {}
     }
     t && this.empty().append(e)
    }, null, e, arguments.length)
   },
   replaceWith: function() {
    var n = [];
    return qe(this, arguments, function(e) {
     var t = this.parentNode;
     C.inArray(this, n) < 0 && (C.cleanData(me(this)), t && t.replaceChild(e, this))
    }, n)
   }
  }), C.each({
   appendTo: "append",
   prependTo: "prepend",
   insertBefore: "before",
   insertAfter: "after",
   replaceAll: "replaceWith"
  }, function(e, o) {
   C.fn[e] = function(e) {
    for (var t, n = [], r = C(e), i = r.length - 1, a = 0; a <= i; a++) t = a === i ? this : this.clone(!0), C(r[a])[o](t), l.apply(n, t.get());
    return this.pushStack(n)
   }
  });
  var Qe = new RegExp("^(" + te + ")(?!px)[a-z%]+$", "i"),
   He = function(e) {
    var t = e.ownerDocument.defaultView;
    return t && t.opener || (t = E), t.getComputedStyle(e)
   },
   Fe = new RegExp(re.join("|"), "i");

  function $e(e, t, n) {
   var r, i, a, o, s = e.style;
   return (n = n || He(e)) && ("" !== (o = n.getPropertyValue(t) || n[t]) || ae(e) || (o = C.style(e, t)), !v.pixelBoxStyles() && Qe.test(o) && Fe.test(t) && (r = s.width, i = s.minWidth, a = s.maxWidth, s.minWidth = s.maxWidth = s.width = o, o = n.width, s.width = r, s.minWidth = i, s.maxWidth = a)), void 0 !== o ? o + "" : o
  }

  function ze(e, t) {
   return {
    get: function() {
     if (!e()) return (this.get = t).apply(this, arguments);
     delete this.get
    }
   }
  }! function() {
   function e() {
    if (l) {
     s.style.cssText = "position:absolute;left:-11111px;width:60px;margin-top:1px;padding:0;border:0", l.style.cssText = "position:relative;display:block;box-sizing:border-box;overflow:scroll;margin:auto;border:1px;padding:1px;width:60%;top:1%", ie.appendChild(s).appendChild(l);
     var e = E.getComputedStyle(l);
     n = "1%" !== e.top, o = 12 === t(e.marginLeft), l.style.right = "60%", a = 36 === t(e.right), r = 36 === t(e.width), l.style.position = "absolute", i = 12 === t(l.offsetWidth / 3), ie.removeChild(s), l = null
    }
   }

   function t(e) {
    return Math.round(parseFloat(e))
   }
   var n, r, i, a, o, s = k.createElement("div"),
    l = k.createElement("div");
   l.style && (l.style.backgroundClip = "content-box", l.cloneNode(!0).style.backgroundClip = "", v.clearCloneStyle = "content-box" === l.style.backgroundClip, C.extend(v, {
    boxSizingReliable: function() {
     return e(), r
    },
    pixelBoxStyles: function() {
     return e(), a
    },
    pixelPosition: function() {
     return e(), n
    },
    reliableMarginLeft: function() {
     return e(), o
    },
    scrollboxSize: function() {
     return e(), i
    }
   }))
  }();
  var We = ["Webkit", "Moz", "ms"],
   Ue = k.createElement("div").style,
   Ve = {};

  function Ge(e) {
   var t = C.cssProps[e] || Ve[e];
   return t || (e in Ue ? e : Ve[e] = function(e) {
    for (var t = e[0].toUpperCase() + e.slice(1), n = We.length; n--;)
     if ((e = We[n] + t) in Ue) return e
   }(e) || e)
  }
  var Ke = /^(none|table(?!-c[ea]).+)/,
   Xe = /^--/,
   Ze = {
    position: "absolute",
    visibility: "hidden",
    display: "block"
   },
   Je = {
    letterSpacing: "0",
    fontWeight: "400"
   };

  function Ye(e, t, n) {
   var r = ne.exec(t);
   return r ? Math.max(0, r[2] - (n || 0)) + (r[3] || "px") : t
  }

  function et(e, t, n, r, i, a) {
   var o = "width" === t ? 1 : 0,
    s = 0,
    l = 0;
   if (n === (r ? "border" : "content")) return 0;
   for (; o < 4; o += 2) "margin" === n && (l += C.css(e, n + re[o], !0, i)), r ? ("content" === n && (l -= C.css(e, "padding" + re[o], !0, i)), "margin" !== n && (l -= C.css(e, "border" + re[o] + "Width", !0, i))) : (l += C.css(e, "padding" + re[o], !0, i), "padding" !== n ? l += C.css(e, "border" + re[o] + "Width", !0, i) : s += C.css(e, "border" + re[o] + "Width", !0, i));
   return !r && 0 <= a && (l += Math.max(0, Math.ceil(e["offset" + t[0].toUpperCase() + t.slice(1)] - a - l - s - .5)) || 0), l
  }

  function tt(e, t, n) {
   var r = He(e),
    i = (!v.boxSizingReliable() || n) && "border-box" === C.css(e, "boxSizing", !1, r),
    a = i,
    o = $e(e, t, r),
    s = "offset" + t[0].toUpperCase() + t.slice(1);
   if (Qe.test(o)) {
    if (!n) return o;
    o = "auto"
   }
   return (!v.boxSizingReliable() && i || "auto" === o || !parseFloat(o) && "inline" === C.css(e, "display", !1, r)) && e.getClientRects().length && (i = "border-box" === C.css(e, "boxSizing", !1, r), (a = s in e) && (o = e[s])), (o = parseFloat(o) || 0) + et(e, t, n || (i ? "border" : "content"), a, r, o) + "px"
  }

  function nt(e, t, n, r, i) {
   return new nt.prototype.init(e, t, n, r, i)
  }
  C.extend({
   cssHooks: {
    opacity: {
     get: function(e, t) {
      if (t) {
       var n = $e(e, "opacity");
       return "" === n ? "1" : n
      }
     }
    }
   },
   cssNumber: {
    animationIterationCount: !0,
    columnCount: !0,
    fillOpacity: !0,
    flexGrow: !0,
    flexShrink: !0,
    fontWeight: !0,
    gridArea: !0,
    gridColumn: !0,
    gridColumnEnd: !0,
    gridColumnStart: !0,
    gridRow: !0,
    gridRowEnd: !0,
    gridRowStart: !0,
    lineHeight: !0,
    opacity: !0,
    order: !0,
    orphans: !0,
    widows: !0,
    zIndex: !0,
    zoom: !0
   },
   cssProps: {},
   style: function(e, t, n, r) {
    if (e && 3 !== e.nodeType && 8 !== e.nodeType && e.style) {
     var i, a, o, s = V(t),
      l = Xe.test(t),
      u = e.style;
     if (l || (t = Ge(s)), o = C.cssHooks[t] || C.cssHooks[s], void 0 === n) return o && "get" in o && void 0 !== (i = o.get(e, !1, r)) ? i : u[t];
     "string" === (a = typeof n) && (i = ne.exec(n)) && i[1] && (n = ue(e, t, i), a = "number"), null != n && n == n && ("number" !== a || l || (n += i && i[3] || (C.cssNumber[s] ? "" : "px")), v.clearCloneStyle || "" !== n || 0 !== t.indexOf("background") || (u[t] = "inherit"), o && "set" in o && void 0 === (n = o.set(e, n, r)) || (l ? u.setProperty(t, n) : u[t] = n))
    }
   },
   css: function(e, t, n, r) {
    var i, a, o, s = V(t);
    return Xe.test(t) || (t = Ge(s)), (o = C.cssHooks[t] || C.cssHooks[s]) && "get" in o && (i = o.get(e, !0, n)), void 0 === i && (i = $e(e, t, r)), "normal" === i && t in Je && (i = Je[t]), "" === n || n ? (a = parseFloat(i), !0 === n || isFinite(a) ? a || 0 : i) : i
   }
  }), C.each(["height", "width"], function(e, l) {
   C.cssHooks[l] = {
    get: function(e, t, n) {
     if (t) return !Ke.test(C.css(e, "display")) || e.getClientRects().length && e.getBoundingClientRect().width ? tt(e, l, n) : le(e, Ze, function() {
      return tt(e, l, n)
     })
    },
    set: function(e, t, n) {
     var r, i = He(e),
      a = !v.scrollboxSize() && "absolute" === i.position,
      o = (a || n) && "border-box" === C.css(e, "boxSizing", !1, i),
      s = n ? et(e, l, n, o, i) : 0;
     return o && a && (s -= Math.ceil(e["offset" + l[0].toUpperCase() + l.slice(1)] - parseFloat(i[l]) - et(e, l, "border", !1, i) - .5)), s && (r = ne.exec(t)) && "px" !== (r[3] || "px") && (e.style[l] = t, t = C.css(e, l)), Ye(0, t, s)
    }
   }
  }), C.cssHooks.marginLeft = ze(v.reliableMarginLeft, function(e, t) {
   if (t) return (parseFloat($e(e, "marginLeft")) || e.getBoundingClientRect().left - le(e, {
    marginLeft: 0
   }, function() {
    return e.getBoundingClientRect().left
   })) + "px"
  }), C.each({
   margin: "",
   padding: "",
   border: "Width"
  }, function(i, a) {
   C.cssHooks[i + a] = {
    expand: function(e) {
     for (var t = 0, n = {}, r = "string" == typeof e ? e.split(" ") : [e]; t < 4; t++) n[i + re[t] + a] = r[t] || r[t - 2] || r[0];
     return n
    }
   }, "margin" !== i && (C.cssHooks[i + a].set = Ye)
  }), C.fn.extend({
   css: function(e, t) {
    return $(this, function(e, t, n) {
     var r, i, a = {},
      o = 0;
     if (Array.isArray(t)) {
      for (r = He(e), i = t.length; o < i; o++) a[t[o]] = C.css(e, t[o], !1, r);
      return a
     }
     return void 0 !== n ? C.style(e, t, n) : C.css(e, t)
    }, e, t, 1 < arguments.length)
   }
  }), ((C.Tween = nt).prototype = {
   constructor: nt,
   init: function(e, t, n, r, i, a) {
    this.elem = e, this.prop = n, this.easing = i || C.easing._default, this.options = t, this.start = this.now = this.cur(), this.end = r, this.unit = a || (C.cssNumber[n] ? "" : "px")
   },
   cur: function() {
    var e = nt.propHooks[this.prop];
    return e && e.get ? e.get(this) : nt.propHooks._default.get(this)
   },
   run: function(e) {
    var t, n = nt.propHooks[this.prop];
    return this.options.duration ? this.pos = t = C.easing[this.easing](e, this.options.duration * e, 0, 1, this.options.duration) : this.pos = t = e, this.now = (this.end - this.start) * t + this.start, this.options.step && this.options.step.call(this.elem, this.now, this), n && n.set ? n.set(this) : nt.propHooks._default.set(this), this
   }
  }).init.prototype = nt.prototype, (nt.propHooks = {
   _default: {
    get: function(e) {
     var t;
     return 1 !== e.elem.nodeType || null != e.elem[e.prop] && null == e.elem.style[e.prop] ? e.elem[e.prop] : (t = C.css(e.elem, e.prop, "")) && "auto" !== t ? t : 0
    },
    set: function(e) {
     C.fx.step[e.prop] ? C.fx.step[e.prop](e) : 1 !== e.elem.nodeType || !C.cssHooks[e.prop] && null == e.elem.style[Ge(e.prop)] ? e.elem[e.prop] = e.now : C.style(e.elem, e.prop, e.now + e.unit)
    }
   }
  }).scrollTop = nt.propHooks.scrollLeft = {
   set: function(e) {
    e.elem.nodeType && e.elem.parentNode && (e.elem[e.prop] = e.now)
   }
  }, C.easing = {
   linear: function(e) {
    return e
   },
   swing: function(e) {
    return .5 - Math.cos(e * Math.PI) / 2
   },
   _default: "swing"
  }, C.fx = nt.prototype.init, C.fx.step = {};
  var rt, it, at, ot, st = /^(?:toggle|show|hide)$/,
   lt = /queueHooks$/;

  function ut() {
   it && (!1 === k.hidden && E.requestAnimationFrame ? E.requestAnimationFrame(ut) : E.setTimeout(ut, C.fx.interval), C.fx.tick())
  }

  function ct() {
   return E.setTimeout(function() {
    rt = void 0
   }), rt = Date.now()
  }

  function dt(e, t) {
   var n, r = 0,
    i = {
     height: e
    };
   for (t = t ? 1 : 0; r < 4; r += 2 - t) i["margin" + (n = re[r])] = i["padding" + n] = e;
   return t && (i.opacity = i.width = e), i
  }

  function ft(e, t, n) {
   for (var r, i = (pt.tweeners[t] || []).concat(pt.tweeners["*"]), a = 0, o = i.length; a < o; a++)
    if (r = i[a].call(n, t, e)) return r
  }

  function pt(a, e, t) {
   var n, o, r = 0,
    i = pt.prefilters.length,
    s = C.Deferred().always(function() {
     delete l.elem
    }),
    l = function() {
     if (o) return !1;
     for (var e = rt || ct(), t = Math.max(0, u.startTime + u.duration - e), n = 1 - (t / u.duration || 0), r = 0, i = u.tweens.length; r < i; r++) u.tweens[r].run(n);
     return s.notifyWith(a, [u, n, t]), n < 1 && i ? t : (i || s.notifyWith(a, [u, 1, 0]), s.resolveWith(a, [u]), !1)
    },
    u = s.promise({
     elem: a,
     props: C.extend({}, e),
     opts: C.extend(!0, {
      specialEasing: {},
      easing: C.easing._default
     }, t),
     originalProperties: e,
     originalOptions: t,
     startTime: rt || ct(),
     duration: t.duration,
     tweens: [],
     createTween: function(e, t) {
      var n = C.Tween(a, u.opts, e, t, u.opts.specialEasing[e] || u.opts.easing);
      return u.tweens.push(n), n
     },
     stop: function(e) {
      var t = 0,
       n = e ? u.tweens.length : 0;
      if (o) return this;
      for (o = !0; t < n; t++) u.tweens[t].run(1);
      return e ? (s.notifyWith(a, [u, 1, 0]), s.resolveWith(a, [u, e])) : s.rejectWith(a, [u, e]), this
     }
    }),
    c = u.props;
   for (! function(e, t) {
     var n, r, i, a, o;
     for (n in e)
      if (i = t[r = V(n)], a = e[n], Array.isArray(a) && (i = a[1], a = e[n] = a[0]), n !== r && (e[r] = a, delete e[n]), (o = C.cssHooks[r]) && "expand" in o)
       for (n in a = o.expand(a), delete e[r], a) n in e || (e[n] = a[n], t[n] = i);
      else t[r] = i
    }(c, u.opts.specialEasing); r < i; r++)
    if (n = pt.prefilters[r].call(u, a, c, u.opts)) return y(n.stop) && (C._queueHooks(u.elem, u.opts.queue).stop = n.stop.bind(n)), n;
   return C.map(c, ft, u), y(u.opts.start) && u.opts.start.call(a, u), u.progress(u.opts.progress).done(u.opts.done, u.opts.complete).fail(u.opts.fail).always(u.opts.always), C.fx.timer(C.extend(l, {
    elem: a,
    anim: u,
    queue: u.opts.queue
   })), u
  }
  C.Animation = C.extend(pt, {
   tweeners: {
    "*": [function(e, t) {
     var n = this.createTween(e, t);
     return ue(n.elem, e, ne.exec(t), n), n
    }]
   },
   tweener: function(e, t) {
    for (var n, r = 0, i = (e = y(e) ? (t = e, ["*"]) : e.match(M)).length; r < i; r++) n = e[r], pt.tweeners[n] = pt.tweeners[n] || [], pt.tweeners[n].unshift(t)
   },
   prefilters: [function(e, t, n) {
    var r, i, a, o, s, l, u, c, d = "width" in t || "height" in t,
     f = this,
     p = {},
     h = e.style,
     g = e.nodeType && se(e),
     m = X.get(e, "fxshow");
    for (r in n.queue || (null == (o = C._queueHooks(e, "fx")).unqueued && (o.unqueued = 0, s = o.empty.fire, o.empty.fire = function() {
      o.unqueued || s()
     }), o.unqueued++, f.always(function() {
      f.always(function() {
       o.unqueued--, C.queue(e, "fx").length || o.empty.fire()
      })
     })), t)
     if (i = t[r], st.test(i)) {
      if (delete t[r], a = a || "toggle" === i, i === (g ? "hide" : "show")) {
       if ("show" !== i || !m || void 0 === m[r]) continue;
       g = !0
      }
      p[r] = m && m[r] || C.style(e, r)
     } if ((l = !C.isEmptyObject(t)) || !C.isEmptyObject(p))
     for (r in d && 1 === e.nodeType && (n.overflow = [h.overflow, h.overflowX, h.overflowY], null == (u = m && m.display) && (u = X.get(e, "display")), "none" === (c = C.css(e, "display")) && (u ? c = u : (de([e], !0), u = e.style.display || u, c = C.css(e, "display"), de([e]))), ("inline" === c || "inline-block" === c && null != u) && "none" === C.css(e, "float") && (l || (f.done(function() {
       h.display = u
      }), null == u && (c = h.display, u = "none" === c ? "" : c)), h.display = "inline-block")), n.overflow && (h.overflow = "hidden", f.always(function() {
       h.overflow = n.overflow[0], h.overflowX = n.overflow[1], h.overflowY = n.overflow[2]
      })), l = !1, p) l || (m ? "hidden" in m && (g = m.hidden) : m = X.access(e, "fxshow", {
      display: u
     }), a && (m.hidden = !g), g && de([e], !0), f.done(function() {
      for (r in g || de([e]), X.remove(e, "fxshow"), p) C.style(e, r, p[r])
     })), l = ft(g ? m[r] : 0, r, f), r in m || (m[r] = l.start, g && (l.end = l.start, l.start = 0))
   }],
   prefilter: function(e, t) {
    t ? pt.prefilters.unshift(e) : pt.prefilters.push(e)
   }
  }), C.speed = function(e, t, n) {
   var r = e && "object" == typeof e ? C.extend({}, e) : {
    complete: n || !n && t || y(e) && e,
    duration: e,
    easing: n && t || t && !y(t) && t
   };
   return C.fx.off ? r.duration = 0 : "number" != typeof r.duration && (r.duration in C.fx.speeds ? r.duration = C.fx.speeds[r.duration] : r.duration = C.fx.speeds._default), null != r.queue && !0 !== r.queue || (r.queue = "fx"), r.old = r.complete, r.complete = function() {
    y(r.old) && r.old.call(this), r.queue && C.dequeue(this, r.queue)
   }, r
  }, C.fn.extend({
   fadeTo: function(e, t, n, r) {
    return this.filter(se).css("opacity", 0).show().end().animate({
     opacity: t
    }, e, n, r)
   },
   animate: function(t, e, n, r) {
    var i = C.isEmptyObject(t),
     a = C.speed(e, n, r),
     o = function() {
      var e = pt(this, C.extend({}, t), a);
      (i || X.get(this, "finish")) && e.stop(!0)
     };
    return o.finish = o, i || !1 === a.queue ? this.each(o) : this.queue(a.queue, o)
   },
   stop: function(i, e, a) {
    var o = function(e) {
     var t = e.stop;
     delete e.stop, t(a)
    };
    return "string" != typeof i && (a = e, e = i, i = void 0), e && !1 !== i && this.queue(i || "fx", []), this.each(function() {
     var e = !0,
      t = null != i && i + "queueHooks",
      n = C.timers,
      r = X.get(this);
     if (t) r[t] && r[t].stop && o(r[t]);
     else
      for (t in r) r[t] && r[t].stop && lt.test(t) && o(r[t]);
     for (t = n.length; t--;) n[t].elem !== this || null != i && n[t].queue !== i || (n[t].anim.stop(a), e = !1, n.splice(t, 1));
     !e && a || C.dequeue(this, i)
    })
   },
   finish: function(o) {
    return !1 !== o && (o = o || "fx"), this.each(function() {
     var e, t = X.get(this),
      n = t[o + "queue"],
      r = t[o + "queueHooks"],
      i = C.timers,
      a = n ? n.length : 0;
     for (t.finish = !0, C.queue(this, o, []), r && r.stop && r.stop.call(this, !0), e = i.length; e--;) i[e].elem === this && i[e].queue === o && (i[e].anim.stop(!0), i.splice(e, 1));
     for (e = 0; e < a; e++) n[e] && n[e].finish && n[e].finish.call(this);
     delete t.finish
    })
   }
  }), C.each(["toggle", "show", "hide"], function(e, r) {
   var i = C.fn[r];
   C.fn[r] = function(e, t, n) {
    return null == e || "boolean" == typeof e ? i.apply(this, arguments) : this.animate(dt(r, !0), e, t, n)
   }
  }), C.each({
   slideDown: dt("show"),
   slideUp: dt("hide"),
   slideToggle: dt("toggle"),
   fadeIn: {
    opacity: "show"
   },
   fadeOut: {
    opacity: "hide"
   },
   fadeToggle: {
    opacity: "toggle"
   }
  }, function(e, r) {
   C.fn[e] = function(e, t, n) {
    return this.animate(r, e, t, n)
   }
  }), C.timers = [], C.fx.tick = function() {
   var e, t = 0,
    n = C.timers;
   for (rt = Date.now(); t < n.length; t++)(e = n[t])() || n[t] !== e || n.splice(t--, 1);
   n.length || C.fx.stop(), rt = void 0
  }, C.fx.timer = function(e) {
   C.timers.push(e), C.fx.start()
  }, C.fx.interval = 13, C.fx.start = function() {
   it || (it = !0, ut())
  }, C.fx.stop = function() {
   it = null
  }, C.fx.speeds = {
   slow: 600,
   fast: 200,
   _default: 400
  }, C.fn.delay = function(r, e) {
   return r = C.fx && C.fx.speeds[r] || r, e = e || "fx", this.queue(e, function(e, t) {
    var n = E.setTimeout(e, r);
    t.stop = function() {
     E.clearTimeout(n)
    }
   })
  }, at = k.createElement("input"), ot = k.createElement("select").appendChild(k.createElement("option")), at.type = "checkbox", v.checkOn = "" !== at.value, v.optSelected = ot.selected, (at = k.createElement("input")).value = "t", at.type = "radio", v.radioValue = "t" === at.value;
  var ht, gt = C.expr.attrHandle;
  C.fn.extend({
   attr: function(e, t) {
    return $(this, C.attr, e, t, 1 < arguments.length)
   },
   removeAttr: function(e) {
    return this.each(function() {
     C.removeAttr(this, e)
    })
   }
  }), C.extend({
   attr: function(e, t, n) {
    var r, i, a = e.nodeType;
    if (3 !== a && 8 !== a && 2 !== a) return void 0 === e.getAttribute ? C.prop(e, t, n) : (1 === a && C.isXMLDoc(e) || (i = C.attrHooks[t.toLowerCase()] || (C.expr.match.bool.test(t) ? ht : void 0)), void 0 !== n ? null === n ? void C.removeAttr(e, t) : i && "set" in i && void 0 !== (r = i.set(e, n, t)) ? r : (e.setAttribute(t, n + ""), n) : i && "get" in i && null !== (r = i.get(e, t)) ? r : null == (r = C.find.attr(e, t)) ? void 0 : r)
   },
   attrHooks: {
    type: {
     set: function(e, t) {
      if (!v.radioValue && "radio" === t && N(e, "input")) {
       var n = e.value;
       return e.setAttribute("type", t), n && (e.value = n), t
      }
     }
    }
   },
   removeAttr: function(e, t) {
    var n, r = 0,
     i = t && t.match(M);
    if (i && 1 === e.nodeType)
     for (; n = i[r++];) e.removeAttribute(n)
   }
  }), ht = {
   set: function(e, t, n) {
    return !1 === t ? C.removeAttr(e, n) : e.setAttribute(n, n), n
   }
  }, C.each(C.expr.match.bool.source.match(/\w+/g), function(e, t) {
   var o = gt[t] || C.find.attr;
   gt[t] = function(e, t, n) {
    var r, i, a = t.toLowerCase();
    return n || (i = gt[a], gt[a] = r, r = null != o(e, t, n) ? a : null, gt[a] = i), r
   }
  });
  var mt = /^(?:input|select|textarea|button)$/i,
   vt = /^(?:a|area)$/i;

  function yt(e) {
   return (e.match(M) || []).join(" ")
  }

  function bt(e) {
   return e.getAttribute && e.getAttribute("class") || ""
  }

  function xt(e) {
   return Array.isArray(e) ? e : "string" == typeof e && e.match(M) || []
  }
  C.fn.extend({
   prop: function(e, t) {
    return $(this, C.prop, e, t, 1 < arguments.length)
   },
   removeProp: function(e) {
    return this.each(function() {
     delete this[C.propFix[e] || e]
    })
   }
  }), C.extend({
   prop: function(e, t, n) {
    var r, i, a = e.nodeType;
    if (3 !== a && 8 !== a && 2 !== a) return 1 === a && C.isXMLDoc(e) || (t = C.propFix[t] || t, i = C.propHooks[t]), void 0 !== n ? i && "set" in i && void 0 !== (r = i.set(e, n, t)) ? r : e[t] = n : i && "get" in i && null !== (r = i.get(e, t)) ? r : e[t]
   },
   propHooks: {
    tabIndex: {
     get: function(e) {
      var t = C.find.attr(e, "tabindex");
      return t ? parseInt(t, 10) : mt.test(e.nodeName) || vt.test(e.nodeName) && e.href ? 0 : -1
     }
    }
   },
   propFix: {
    for: "htmlFor",
    class: "className"
   }
  }), v.optSelected || (C.propHooks.selected = {
   get: function(e) {
    var t = e.parentNode;
    return t && t.parentNode && t.parentNode.selectedIndex, null
   },
   set: function(e) {
    var t = e.parentNode;
    t && (t.selectedIndex, t.parentNode && t.parentNode.selectedIndex)
   }
  }), C.each(["tabIndex", "readOnly", "maxLength", "cellSpacing", "cellPadding", "rowSpan", "colSpan", "useMap", "frameBorder", "contentEditable"], function() {
   C.propFix[this.toLowerCase()] = this
  }), C.fn.extend({
   addClass: function(t) {
    var e, n, r, i, a, o, s, l = 0;
    if (y(t)) return this.each(function(e) {
     C(this).addClass(t.call(this, e, bt(this)))
    });
    if ((e = xt(t)).length)
     for (; n = this[l++];)
      if (i = bt(n), r = 1 === n.nodeType && " " + yt(i) + " ") {
       for (o = 0; a = e[o++];) r.indexOf(" " + a + " ") < 0 && (r += a + " ");
       i !== (s = yt(r)) && n.setAttribute("class", s)
      } return this
   },
   removeClass: function(t) {
    var e, n, r, i, a, o, s, l = 0;
    if (y(t)) return this.each(function(e) {
     C(this).removeClass(t.call(this, e, bt(this)))
    });
    if (!arguments.length) return this.attr("class", "");
    if ((e = xt(t)).length)
     for (; n = this[l++];)
      if (i = bt(n), r = 1 === n.nodeType && " " + yt(i) + " ") {
       for (o = 0; a = e[o++];)
        for (; - 1 < r.indexOf(" " + a + " ");) r = r.replace(" " + a + " ", " ");
       i !== (s = yt(r)) && n.setAttribute("class", s)
      } return this
   },
   toggleClass: function(i, t) {
    var a = typeof i,
     o = "string" === a || Array.isArray(i);
    return "boolean" == typeof t && o ? t ? this.addClass(i) : this.removeClass(i) : y(i) ? this.each(function(e) {
     C(this).toggleClass(i.call(this, e, bt(this), t), t)
    }) : this.each(function() {
     var e, t, n, r;
     if (o)
      for (t = 0, n = C(this), r = xt(i); e = r[t++];) n.hasClass(e) ? n.removeClass(e) : n.addClass(e);
     else void 0 !== i && "boolean" !== a || ((e = bt(this)) && X.set(this, "__className__", e), this.setAttribute && this.setAttribute("class", e || !1 === i ? "" : X.get(this, "__className__") || ""))
    })
   },
   hasClass: function(e) {
    var t, n, r = 0;
    for (t = " " + e + " "; n = this[r++];)
     if (1 === n.nodeType && -1 < (" " + yt(bt(n)) + " ").indexOf(t)) return !0;
    return !1
   }
  });
  var wt = /\r/g;
  C.fn.extend({
   val: function(n) {
    var r, e, i, t = this[0];
    return arguments.length ? (i = y(n), this.each(function(e) {
     var t;
     1 === this.nodeType && (null == (t = i ? n.call(this, e, C(this).val()) : n) ? t = "" : "number" == typeof t ? t += "" : Array.isArray(t) && (t = C.map(t, function(e) {
      return null == e ? "" : e + ""
     })), (r = C.valHooks[this.type] || C.valHooks[this.nodeName.toLowerCase()]) && "set" in r && void 0 !== r.set(this, t, "value") || (this.value = t))
    })) : t ? (r = C.valHooks[t.type] || C.valHooks[t.nodeName.toLowerCase()]) && "get" in r && void 0 !== (e = r.get(t, "value")) ? e : "string" == typeof(e = t.value) ? e.replace(wt, "") : null == e ? "" : e : void 0
   }
  }), C.extend({
   valHooks: {
    option: {
     get: function(e) {
      var t = C.find.attr(e, "value");
      return null != t ? t : yt(C.text(e))
     }
    },
    select: {
     get: function(e) {
      var t, n, r, i = e.options,
       a = e.selectedIndex,
       o = "select-one" === e.type,
       s = o ? null : [],
       l = o ? a + 1 : i.length;
      for (r = a < 0 ? l : o ? a : 0; r < l; r++)
       if (((n = i[r]).selected || r === a) && !n.disabled && (!n.parentNode.disabled || !N(n.parentNode, "optgroup"))) {
        if (t = C(n).val(), o) return t;
        s.push(t)
       } return s
     },
     set: function(e, t) {
      for (var n, r, i = e.options, a = C.makeArray(t), o = i.length; o--;)((r = i[o]).selected = -1 < C.inArray(C.valHooks.option.get(r), a)) && (n = !0);
      return n || (e.selectedIndex = -1), a
     }
    }
   }
  }), C.each(["radio", "checkbox"], function() {
   C.valHooks[this] = {
    set: function(e, t) {
     if (Array.isArray(t)) return e.checked = -1 < C.inArray(C(e).val(), t)
    }
   }, v.checkOn || (C.valHooks[this].get = function(e) {
    return null === e.getAttribute("value") ? "on" : e.value
   })
  }), v.focusin = "onfocusin" in E;
  var _t = /^(?:focusinfocus|focusoutblur)$/,
   Et = function(e) {
    e.stopPropagation()
   };
  C.extend(C.event, {
   trigger: function(e, t, n, r) {
    var i, a, o, s, l, u, c, d, f = [n || k],
     p = m.call(e, "type") ? e.type : e,
     h = m.call(e, "namespace") ? e.namespace.split(".") : [];
    if (a = d = o = n = n || k, 3 !== n.nodeType && 8 !== n.nodeType && !_t.test(p + C.event.triggered) && (-1 < p.indexOf(".") && (p = (h = p.split(".")).shift(), h.sort()), l = p.indexOf(":") < 0 && "on" + p, (e = e[C.expando] ? e : new C.Event(p, "object" == typeof e && e)).isTrigger = r ? 2 : 3, e.namespace = h.join("."), e.rnamespace = e.namespace ? new RegExp("(^|\\.)" + h.join("\\.(?:.*\\.|)") + "(\\.|$)") : null, e.result = void 0, e.target || (e.target = n), t = null == t ? [e] : C.makeArray(t, [e]), c = C.event.special[p] || {}, r || !c.trigger || !1 !== c.trigger.apply(n, t))) {
     if (!r && !c.noBubble && !b(n)) {
      for (s = c.delegateType || p, _t.test(s + p) || (a = a.parentNode); a; a = a.parentNode) f.push(a), o = a;
      o === (n.ownerDocument || k) && f.push(o.defaultView || o.parentWindow || E)
     }
     for (i = 0;
      (a = f[i++]) && !e.isPropagationStopped();) d = a, e.type = 1 < i ? s : c.bindType || p, (u = (X.get(a, "events") || {})[e.type] && X.get(a, "handle")) && u.apply(a, t), (u = l && a[l]) && u.apply && G(a) && (e.result = u.apply(a, t), !1 === e.result && e.preventDefault());
     return e.type = p, r || e.isDefaultPrevented() || c._default && !1 !== c._default.apply(f.pop(), t) || !G(n) || l && y(n[p]) && !b(n) && ((o = n[l]) && (n[l] = null), C.event.triggered = p, e.isPropagationStopped() && d.addEventListener(p, Et), n[p](), e.isPropagationStopped() && d.removeEventListener(p, Et), C.event.triggered = void 0, o && (n[l] = o)), e.result
    }
   },
   simulate: function(e, t, n) {
    var r = C.extend(new C.Event, n, {
     type: e,
     isSimulated: !0
    });
    C.event.trigger(r, null, t)
   }
  }), C.fn.extend({
   trigger: function(e, t) {
    return this.each(function() {
     C.event.trigger(e, t, this)
    })
   },
   triggerHandler: function(e, t) {
    var n = this[0];
    if (n) return C.event.trigger(e, t, n, !0)
   }
  }), v.focusin || C.each({
   focus: "focusin",
   blur: "focusout"
  }, function(n, r) {
   var i = function(e) {
    C.event.simulate(r, e.target, C.event.fix(e))
   };
   C.event.special[r] = {
    setup: function() {
     var e = this.ownerDocument || this,
      t = X.access(e, r);
     t || e.addEventListener(n, i, !0), X.access(e, r, (t || 0) + 1)
    },
    teardown: function() {
     var e = this.ownerDocument || this,
      t = X.access(e, r) - 1;
     t ? X.access(e, r, t) : (e.removeEventListener(n, i, !0), X.remove(e, r))
    }
   }
  });
  var kt = E.location,
   Ct = Date.now(),
   Tt = /\?/;
  C.parseXML = function(e) {
   var t;
   if (!e || "string" != typeof e) return null;
   try {
    t = (new E.DOMParser).parseFromString(e, "text/xml")
   } catch (e) {
    t = void 0
   }
   return t && !t.getElementsByTagName("parsererror").length || C.error("Invalid XML: " + e), t
  };
  var St = /\[\]$/,
   Nt = /\r?\n/g,
   Ot = /^(?:submit|button|image|reset|file)$/i,
   At = /^(?:input|select|textarea|keygen)/i;

  function jt(n, e, r, i) {
   var t;
   if (Array.isArray(e)) C.each(e, function(e, t) {
    r || St.test(n) ? i(n, t) : jt(n + "[" + ("object" == typeof t && null != t ? e : "") + "]", t, r, i)
   });
   else if (r || "object" !== w(e)) i(n, e);
   else
    for (t in e) jt(n + "[" + t + "]", e[t], r, i)
  }
  C.param = function(e, t) {
   var n, r = [],
    i = function(e, t) {
     var n = y(t) ? t() : t;
     r[r.length] = encodeURIComponent(e) + "=" + encodeURIComponent(null == n ? "" : n)
    };
   if (null == e) return "";
   if (Array.isArray(e) || e.jquery && !C.isPlainObject(e)) C.each(e, function() {
    i(this.name, this.value)
   });
   else
    for (n in e) jt(n, e[n], t, i);
   return r.join("&")
  }, C.fn.extend({
   serialize: function() {
    return C.param(this.serializeArray())
   },
   serializeArray: function() {
    return this.map(function() {
     var e = C.prop(this, "elements");
     return e ? C.makeArray(e) : this
    }).filter(function() {
     var e = this.type;
     return this.name && !C(this).is(":disabled") && At.test(this.nodeName) && !Ot.test(e) && (this.checked || !fe.test(e))
    }).map(function(e, t) {
     var n = C(this).val();
     return null == n ? null : Array.isArray(n) ? C.map(n, function(e) {
      return {
       name: t.name,
       value: e.replace(Nt, "\r\n")
      }
     }) : {
      name: t.name,
      value: n.replace(Nt, "\r\n")
     }
    }).get()
   }
  });
  var Dt = /%20/g,
   Lt = /#.*$/,
   Rt = /([?&])_=[^&]*/,
   Pt = /^(.*?):[ \t]*([^\r\n]*)$/gm,
   Mt = /^(?:GET|HEAD)$/,
   It = /^\/\//,
   qt = {},
   Bt = {},
   Qt = "*/".concat("*"),
   Ht = k.createElement("a");

  function Ft(a) {
   return function(e, t) {
    "string" != typeof e && (t = e, e = "*");
    var n, r = 0,
     i = e.toLowerCase().match(M) || [];
    if (y(t))
     for (; n = i[r++];) "+" === n[0] ? (n = n.slice(1) || "*", (a[n] = a[n] || []).unshift(t)) : (a[n] = a[n] || []).push(t)
   }
  }

  function $t(t, i, a, o) {
   var s = {},
    l = t === Bt;

   function u(e) {
    var r;
    return s[e] = !0, C.each(t[e] || [], function(e, t) {
     var n = t(i, a, o);
     return "string" != typeof n || l || s[n] ? l ? !(r = n) : void 0 : (i.dataTypes.unshift(n), u(n), !1)
    }), r
   }
   return u(i.dataTypes[0]) || !s["*"] && u("*")
  }

  function zt(e, t) {
   var n, r, i = C.ajaxSettings.flatOptions || {};
   for (n in t) void 0 !== t[n] && ((i[n] ? e : r || (r = {}))[n] = t[n]);
   return r && C.extend(!0, e, r), e
  }
  Ht.href = kt.href, C.extend({
   active: 0,
   lastModified: {},
   etag: {},
   ajaxSettings: {
    url: kt.href,
    type: "GET",
    isLocal: /^(?:about|app|app-storage|.+-extension|file|res|widget):$/.test(kt.protocol),
    global: !0,
    processData: !0,
    async: !0,
    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    accepts: {
     "*": Qt,
     text: "text/plain",
     html: "text/html",
     xml: "application/xml, text/xml",
     json: "application/json, text/javascript"
    },
    contents: {
     xml: /\bxml\b/,
     html: /\bhtml/,
     json: /\bjson\b/
    },
    responseFields: {
     xml: "responseXML",
     text: "responseText",
     json: "responseJSON"
    },
    converters: {
     "* text": String,
     "text html": !0,
     "text json": JSON.parse,
     "text xml": C.parseXML
    },
    flatOptions: {
     url: !0,
     context: !0
    }
   },
   ajaxSetup: function(e, t) {
    return t ? zt(zt(e, C.ajaxSettings), t) : zt(C.ajaxSettings, e)
   },
   ajaxPrefilter: Ft(qt),
   ajaxTransport: Ft(Bt),
   ajax: function(e, t) {
    "object" == typeof e && (t = e, e = void 0), t = t || {};
    var c, d, f, n, p, r, h, g, i, a, m = C.ajaxSetup({}, t),
     v = m.context || m,
     y = m.context && (v.nodeType || v.jquery) ? C(v) : C.event,
     b = C.Deferred(),
     x = C.Callbacks("once memory"),
     w = m.statusCode || {},
     o = {},
     s = {},
     l = "canceled",
     _ = {
      readyState: 0,
      getResponseHeader: function(e) {
       var t;
       if (h) {
        if (!n)
         for (n = {}; t = Pt.exec(f);) n[t[1].toLowerCase() + " "] = (n[t[1].toLowerCase() + " "] || []).concat(t[2]);
        t = n[e.toLowerCase() + " "]
       }
       return null == t ? null : t.join(", ")
      },
      getAllResponseHeaders: function() {
       return h ? f : null
      },
      setRequestHeader: function(e, t) {
       return null == h && (e = s[e.toLowerCase()] = s[e.toLowerCase()] || e, o[e] = t), this
      },
      overrideMimeType: function(e) {
       return null == h && (m.mimeType = e), this
      },
      statusCode: function(e) {
       var t;
       if (e)
        if (h) _.always(e[_.status]);
        else
         for (t in e) w[t] = [w[t], e[t]];
       return this
      },
      abort: function(e) {
       var t = e || l;
       return c && c.abort(t), u(0, t), this
      }
     };
    if (b.promise(_), m.url = ((e || m.url || kt.href) + "").replace(It, kt.protocol + "//"), m.type = t.method || t.type || m.method || m.type, m.dataTypes = (m.dataType || "*").toLowerCase().match(M) || [""], null == m.crossDomain) {
     r = k.createElement("a");
     try {
      r.href = m.url, r.href = r.href, m.crossDomain = Ht.protocol + "//" + Ht.host != r.protocol + "//" + r.host
     } catch (e) {
      m.crossDomain = !0
     }
    }
    if (m.data && m.processData && "string" != typeof m.data && (m.data = C.param(m.data, m.traditional)), $t(qt, m, t, _), h) return _;
    for (i in (g = C.event && m.global) && 0 == C.active++ && C.event.trigger("ajaxStart"), m.type = m.type.toUpperCase(), m.hasContent = !Mt.test(m.type), d = m.url.replace(Lt, ""), m.hasContent ? m.data && m.processData && 0 === (m.contentType || "").indexOf("application/x-www-form-urlencoded") && (m.data = m.data.replace(Dt, "+")) : (a = m.url.slice(d.length), m.data && (m.processData || "string" == typeof m.data) && (d += (Tt.test(d) ? "&" : "?") + m.data, delete m.data), !1 === m.cache && (d = d.replace(Rt, "$1"), a = (Tt.test(d) ? "&" : "?") + "_=" + Ct++ + a), m.url = d + a), m.ifModified && (C.lastModified[d] && _.setRequestHeader("If-Modified-Since", C.lastModified[d]), C.etag[d] && _.setRequestHeader("If-None-Match", C.etag[d])), (m.data && m.hasContent && !1 !== m.contentType || t.contentType) && _.setRequestHeader("Content-Type", m.contentType), _.setRequestHeader("Accept", m.dataTypes[0] && m.accepts[m.dataTypes[0]] ? m.accepts[m.dataTypes[0]] + ("*" !== m.dataTypes[0] ? ", " + Qt + "; q=0.01" : "") : m.accepts["*"]), m.headers) _.setRequestHeader(i, m.headers[i]);
    if (m.beforeSend && (!1 === m.beforeSend.call(v, _, m) || h)) return _.abort();
    if (l = "abort", x.add(m.complete), _.done(m.success), _.fail(m.error), c = $t(Bt, m, t, _)) {
     if (_.readyState = 1, g && y.trigger("ajaxSend", [_, m]), h) return _;
     m.async && 0 < m.timeout && (p = E.setTimeout(function() {
      _.abort("timeout")
     }, m.timeout));
     try {
      h = !1, c.send(o, u)
     } catch (e) {
      if (h) throw e;
      u(-1, e)
     }
    } else u(-1, "No Transport");

    function u(e, t, n, r) {
     var i, a, o, s, l, u = t;
     h || (h = !0, p && E.clearTimeout(p), c = void 0, f = r || "", _.readyState = 0 < e ? 4 : 0, i = 200 <= e && e < 300 || 304 === e, n && (s = function(e, t, n) {
      for (var r, i, a, o, s = e.contents, l = e.dataTypes;
       "*" === l[0];) l.shift(), void 0 === r && (r = e.mimeType || t.getResponseHeader("Content-Type"));
      if (r)
       for (i in s)
        if (s[i] && s[i].test(r)) {
         l.unshift(i);
         break
        } if (l[0] in n) a = l[0];
      else {
       for (i in n) {
        if (!l[0] || e.converters[i + " " + l[0]]) {
         a = i;
         break
        }
        o || (o = i)
       }
       a = a || o
      }
      if (a) return a !== l[0] && l.unshift(a), n[a]
     }(m, _, n)), s = function(e, t, n, r) {
      var i, a, o, s, l, u = {},
       c = e.dataTypes.slice();
      if (c[1])
       for (o in e.converters) u[o.toLowerCase()] = e.converters[o];
      for (a = c.shift(); a;)
       if (e.responseFields[a] && (n[e.responseFields[a]] = t), !l && r && e.dataFilter && (t = e.dataFilter(t, e.dataType)), l = a, a = c.shift())
        if ("*" === a) a = l;
        else if ("*" !== l && l !== a) {
       if (!(o = u[l + " " + a] || u["* " + a]))
        for (i in u)
         if ((s = i.split(" "))[1] === a && (o = u[l + " " + s[0]] || u["* " + s[0]])) {
          !0 === o ? o = u[i] : !0 !== u[i] && (a = s[0], c.unshift(s[1]));
          break
         } if (!0 !== o)
        if (o && e.throws) t = o(t);
        else try {
         t = o(t)
        } catch (e) {
         return {
          state: "parsererror",
          error: o ? e : "No conversion from " + l + " to " + a
         }
        }
      }
      return {
       state: "success",
       data: t
      }
     }(m, s, _, i), i ? (m.ifModified && ((l = _.getResponseHeader("Last-Modified")) && (C.lastModified[d] = l), (l = _.getResponseHeader("etag")) && (C.etag[d] = l)), 204 === e || "HEAD" === m.type ? u = "nocontent" : 304 === e ? u = "notmodified" : (u = s.state, a = s.data, i = !(o = s.error))) : (o = u, !e && u || (u = "error", e < 0 && (e = 0))), _.status = e, _.statusText = (t || u) + "", i ? b.resolveWith(v, [a, u, _]) : b.rejectWith(v, [_, u, o]), _.statusCode(w), w = void 0, g && y.trigger(i ? "ajaxSuccess" : "ajaxError", [_, m, i ? a : o]), x.fireWith(v, [_, u]), g && (y.trigger("ajaxComplete", [_, m]), --C.active || C.event.trigger("ajaxStop")))
    }
    return _
   },
   getJSON: function(e, t, n) {
    return C.get(e, t, n, "json")
   },
   getScript: function(e, t) {
    return C.get(e, void 0, t, "script")
   }
  }), C.each(["get", "post"], function(e, i) {
   C[i] = function(e, t, n, r) {
    return y(t) && (r = r || n, n = t, t = void 0), C.ajax(C.extend({
     url: e,
     type: i,
     dataType: r,
     data: t,
     success: n
    }, C.isPlainObject(e) && e))
   }
  }), C._evalUrl = function(e, t) {
   return C.ajax({
    url: e,
    type: "GET",
    dataType: "script",
    cache: !0,
    async: !1,
    global: !1,
    converters: {
     "text script": function() {}
    },
    dataFilter: function(e) {
     C.globalEval(e, t)
    }
   })
  }, C.fn.extend({
   wrapAll: function(e) {
    var t;
    return this[0] && (y(e) && (e = e.call(this[0])), t = C(e, this[0].ownerDocument).eq(0).clone(!0), this[0].parentNode && t.insertBefore(this[0]), t.map(function() {
     for (var e = this; e.firstElementChild;) e = e.firstElementChild;
     return e
    }).append(this)), this
   },
   wrapInner: function(n) {
    return y(n) ? this.each(function(e) {
     C(this).wrapInner(n.call(this, e))
    }) : this.each(function() {
     var e = C(this),
      t = e.contents();
     t.length ? t.wrapAll(n) : e.append(n)
    })
   },
   wrap: function(t) {
    var n = y(t);
    return this.each(function(e) {
     C(this).wrapAll(n ? t.call(this, e) : t)
    })
   },
   unwrap: function(e) {
    return this.parent(e).not("body").each(function() {
     C(this).replaceWith(this.childNodes)
    }), this
   }
  }), C.expr.pseudos.hidden = function(e) {
   return !C.expr.pseudos.visible(e)
  }, C.expr.pseudos.visible = function(e) {
   return !!(e.offsetWidth || e.offsetHeight || e.getClientRects().length)
  }, C.ajaxSettings.xhr = function() {
   try {
    return new E.XMLHttpRequest
   } catch (e) {}
  };
  var Wt = {
    0: 200,
    1223: 204
   },
   Ut = C.ajaxSettings.xhr();
  v.cors = !!Ut && "withCredentials" in Ut, v.ajax = Ut = !!Ut, C.ajaxTransport(function(i) {
   var a, o;
   if (v.cors || Ut && !i.crossDomain) return {
    send: function(e, t) {
     var n, r = i.xhr();
     if (r.open(i.type, i.url, i.async, i.username, i.password), i.xhrFields)
      for (n in i.xhrFields) r[n] = i.xhrFields[n];
     for (n in i.mimeType && r.overrideMimeType && r.overrideMimeType(i.mimeType), i.crossDomain || e["X-Requested-With"] || (e["X-Requested-With"] = "XMLHttpRequest"), e) r.setRequestHeader(n, e[n]);
     a = function(e) {
      return function() {
       a && (a = o = r.onload = r.onerror = r.onabort = r.ontimeout = r.onreadystatechange = null, "abort" === e ? r.abort() : "error" === e ? "number" != typeof r.status ? t(0, "error") : t(r.status, r.statusText) : t(Wt[r.status] || r.status, r.statusText, "text" !== (r.responseType || "text") || "string" != typeof r.responseText ? {
        binary: r.response
       } : {
        text: r.responseText
       }, r.getAllResponseHeaders()))
      }
     }, r.onload = a(), o = r.onerror = r.ontimeout = a("error"), void 0 !== r.onabort ? r.onabort = o : r.onreadystatechange = function() {
      4 === r.readyState && E.setTimeout(function() {
       a && o()
      })
     }, a = a("abort");
     try {
      r.send(i.hasContent && i.data || null)
     } catch (e) {
      if (a) throw e
     }
    },
    abort: function() {
     a && a()
    }
   }
  }), C.ajaxPrefilter(function(e) {
   e.crossDomain && (e.contents.script = !1)
  }), C.ajaxSetup({
   accepts: {
    script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
   },
   contents: {
    script: /\b(?:java|ecma)script\b/
   },
   converters: {
    "text script": function(e) {
     return C.globalEval(e), e
    }
   }
  }), C.ajaxPrefilter("script", function(e) {
   void 0 === e.cache && (e.cache = !1), e.crossDomain && (e.type = "GET")
  }), C.ajaxTransport("script", function(n) {
   var r, i;
   if (n.crossDomain || n.scriptAttrs) return {
    send: function(e, t) {
     r = C("<script>").attr(n.scriptAttrs || {}).prop({
      charset: n.scriptCharset,
      src: n.url
     }).on("load error", i = function(e) {
      r.remove(), i = null, e && t("error" === e.type ? 404 : 200, e.type)
     }), k.head.appendChild(r[0])
    },
    abort: function() {
     i && i()
    }
   }
  });
  var Vt, Gt = [],
   Kt = /(=)\?(?=&|$)|\?\?/;
  C.ajaxSetup({
   jsonp: "callback",
   jsonpCallback: function() {
    var e = Gt.pop() || C.expando + "_" + Ct++;
    return this[e] = !0, e
   }
  }), C.ajaxPrefilter("json jsonp", function(e, t, n) {
   var r, i, a, o = !1 !== e.jsonp && (Kt.test(e.url) ? "url" : "string" == typeof e.data && 0 === (e.contentType || "").indexOf("application/x-www-form-urlencoded") && Kt.test(e.data) && "data");
   if (o || "jsonp" === e.dataTypes[0]) return r = e.jsonpCallback = y(e.jsonpCallback) ? e.jsonpCallback() : e.jsonpCallback, o ? e[o] = e[o].replace(Kt, "$1" + r) : !1 !== e.jsonp && (e.url += (Tt.test(e.url) ? "&" : "?") + e.jsonp + "=" + r), e.converters["script json"] = function() {
    return a || C.error(r + " was not called"), a[0]
   }, e.dataTypes[0] = "json", i = E[r], E[r] = function() {
    a = arguments
   }, n.always(function() {
    void 0 === i ? C(E).removeProp(r) : E[r] = i, e[r] && (e.jsonpCallback = t.jsonpCallback, Gt.push(r)), a && y(i) && i(a[0]), a = i = void 0
   }), "script"
  }), v.createHTMLDocument = ((Vt = k.implementation.createHTMLDocument("").body).innerHTML = "<form></form><form></form>", 2 === Vt.childNodes.length), C.parseHTML = function(e, t, n) {
   return "string" != typeof e ? [] : ("boolean" == typeof t && (n = t, t = !1), t || (v.createHTMLDocument ? ((r = (t = k.implementation.createHTMLDocument("")).createElement("base")).href = k.location.href, t.head.appendChild(r)) : t = k), a = !n && [], (i = O.exec(e)) ? [t.createElement(i[1])] : (i = we([e], t, a), a && a.length && C(a).remove(), C.merge([], i.childNodes)));
   var r, i, a
  }, C.fn.load = function(e, t, n) {
   var r, i, a, o = this,
    s = e.indexOf(" ");
   return -1 < s && (r = yt(e.slice(s)), e = e.slice(0, s)), y(t) ? (n = t, t = void 0) : t && "object" == typeof t && (i = "POST"), 0 < o.length && C.ajax({
    url: e,
    type: i || "GET",
    dataType: "html",
    data: t
   }).done(function(e) {
    a = arguments, o.html(r ? C("<div>").append(C.parseHTML(e)).find(r) : e)
   }).always(n && function(e, t) {
    o.each(function() {
     n.apply(this, a || [e.responseText, t, e])
    })
   }), this
  }, C.each(["ajaxStart", "ajaxStop", "ajaxComplete", "ajaxError", "ajaxSuccess", "ajaxSend"], function(e, t) {
   C.fn[t] = function(e) {
    return this.on(t, e)
   }
  }), C.expr.pseudos.animated = function(t) {
   return C.grep(C.timers, function(e) {
    return t === e.elem
   }).length
  }, C.offset = {
   setOffset: function(e, t, n) {
    var r, i, a, o, s, l, u = C.css(e, "position"),
     c = C(e),
     d = {};
    "static" === u && (e.style.position = "relative"), s = c.offset(), a = C.css(e, "top"), l = C.css(e, "left"), i = ("absolute" === u || "fixed" === u) && -1 < (a + l).indexOf("auto") ? (o = (r = c.position()).top, r.left) : (o = parseFloat(a) || 0, parseFloat(l) || 0), y(t) && (t = t.call(e, n, C.extend({}, s))), null != t.top && (d.top = t.top - s.top + o), null != t.left && (d.left = t.left - s.left + i), "using" in t ? t.using.call(e, d) : c.css(d)
   }
  }, C.fn.extend({
   offset: function(t) {
    if (arguments.length) return void 0 === t ? this : this.each(function(e) {
     C.offset.setOffset(this, t, e)
    });
    var e, n, r = this[0];
    return r ? r.getClientRects().length ? (e = r.getBoundingClientRect(), n = r.ownerDocument.defaultView, {
     top: e.top + n.pageYOffset,
     left: e.left + n.pageXOffset
    }) : {
     top: 0,
     left: 0
    } : void 0
   },
   position: function() {
    if (this[0]) {
     var e, t, n, r = this[0],
      i = {
       top: 0,
       left: 0
      };
     if ("fixed" === C.css(r, "position")) t = r.getBoundingClientRect();
     else {
      for (t = this.offset(), n = r.ownerDocument, e = r.offsetParent || n.documentElement; e && (e === n.body || e === n.documentElement) && "static" === C.css(e, "position");) e = e.parentNode;
      e && e !== r && 1 === e.nodeType && ((i = C(e).offset()).top += C.css(e, "borderTopWidth", !0), i.left += C.css(e, "borderLeftWidth", !0))
     }
     return {
      top: t.top - i.top - C.css(r, "marginTop", !0),
      left: t.left - i.left - C.css(r, "marginLeft", !0)
     }
    }
   },
   offsetParent: function() {
    return this.map(function() {
     for (var e = this.offsetParent; e && "static" === C.css(e, "position");) e = e.offsetParent;
     return e || ie
    })
   }
  }), C.each({
   scrollLeft: "pageXOffset",
   scrollTop: "pageYOffset"
  }, function(t, i) {
   var a = "pageYOffset" === i;
   C.fn[t] = function(e) {
    return $(this, function(e, t, n) {
     var r;
     if (b(e) ? r = e : 9 === e.nodeType && (r = e.defaultView), void 0 === n) return r ? r[i] : e[t];
     r ? r.scrollTo(a ? r.pageXOffset : n, a ? n : r.pageYOffset) : e[t] = n
    }, t, e, arguments.length)
   }
  }), C.each(["top", "left"], function(e, n) {
   C.cssHooks[n] = ze(v.pixelPosition, function(e, t) {
    if (t) return t = $e(e, n), Qe.test(t) ? C(e).position()[n] + "px" : t
   })
  }), C.each({
   Height: "height",
   Width: "width"
  }, function(o, s) {
   C.each({
    padding: "inner" + o,
    content: s,
    "": "outer" + o
   }, function(r, a) {
    C.fn[a] = function(e, t) {
     var n = arguments.length && (r || "boolean" != typeof e),
      i = r || (!0 === e || !0 === t ? "margin" : "border");
     return $(this, function(e, t, n) {
      var r;
      return b(e) ? 0 === a.indexOf("outer") ? e["inner" + o] : e.document.documentElement["client" + o] : 9 === e.nodeType ? (r = e.documentElement, Math.max(e.body["scroll" + o], r["scroll" + o], e.body["offset" + o], r["offset" + o], r["client" + o])) : void 0 === n ? C.css(e, t, i) : C.style(e, t, n, i)
     }, s, n ? e : void 0, n)
    }
   })
  }), C.each("blur focus focusin focusout resize scroll click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup contextmenu".split(" "), function(e, n) {
   C.fn[n] = function(e, t) {
    return 0 < arguments.length ? this.on(n, null, e, t) : this.trigger(n)
   }
  }), C.fn.extend({
   hover: function(e, t) {
    return this.mouseenter(e).mouseleave(t || e)
   }
  }), C.fn.extend({
   bind: function(e, t, n) {
    return this.on(e, null, t, n)
   },
   unbind: function(e, t) {
    return this.off(e, null, t)
   },
   delegate: function(e, t, n, r) {
    return this.on(t, e, n, r)
   },
   undelegate: function(e, t, n) {
    return 1 === arguments.length ? this.off(e, "**") : this.off(t, e || "**", n)
   }
  }), C.proxy = function(e, t) {
   var n, r, i;
   if ("string" == typeof t && (n = e[t], t = e, e = n), y(e)) return r = s.call(arguments, 2), (i = function() {
    return e.apply(t || this, r.concat(s.call(arguments)))
   }).guid = e.guid = e.guid || C.guid++, i
  }, C.holdReady = function(e) {
   e ? C.readyWait++ : C.ready(!0)
  }, C.isArray = Array.isArray, C.parseJSON = JSON.parse, C.nodeName = N, C.isFunction = y, C.isWindow = b, C.camelCase = V, C.type = w, C.now = Date.now, C.isNumeric = function(e) {
   var t = C.type(e);
   return ("number" === t || "string" === t) && !isNaN(e - parseFloat(e))
  }, void 0 === (en = function() {
   return C
  }.apply(Yt, [])) || (Jt.exports = en);
  var Xt = E.jQuery,
   Zt = E.$;
  return C.noConflict = function(e) {
   return E.$ === C && (E.$ = Zt), e && E.jQuery === C && (E.jQuery = Xt), C
  }, e || (E.jQuery = E.$ = C), C
 })
}, function(e, t, n) {
 ! function(e) {
  "object" == typeof window && window || "object" == typeof self && self;
  (function(i) {
   var d = [],
    u = Object.keys,
    y = {},
    s = {},
    t = /^(no-?highlight|plain|text)$/i,
    l = /\blang(?:uage)?-([\w-]+)\b/i,
    n = /((^(<[^>]+>|\t|)+|(?:\n)))/gm,
    b = "</span>",
    x = {
     classPrefix: "hljs-",
     tabReplace: null,
     useBR: !1,
     languages: void 0
    };

   function w(e) {
    return e.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
   }

   function f(e) {
    return e.nodeName.toLowerCase()
   }

   function _(e, t) {
    var n = e && e.exec(t);
    return n && 0 === n.index
   }

   function c(e) {
    return t.test(e)
   }

   function r(e) {
    var t, n = {},
     r = Array.prototype.slice.call(arguments, 1);
    for (t in e) n[t] = e[t];
    return r.forEach(function(e) {
     for (t in e) n[t] = e[t]
    }), n
   }

   function p(e) {
    var i = [];
    return function e(t, n) {
     for (var r = t.firstChild; r; r = r.nextSibling) 3 === r.nodeType ? n += r.nodeValue.length : 1 === r.nodeType && (i.push({
      event: "start",
      offset: n,
      node: r
     }), n = e(r, n), f(r).match(/br|hr|img|input/) || i.push({
      event: "stop",
      offset: n,
      node: r
     }));
     return n
    }(e, 0), i
   }

   function h(t) {
    return t.variants && !t.cached_variants && (t.cached_variants = t.variants.map(function(e) {
     return r(t, {
      variants: null
     }, e)
    })), t.cached_variants || t.endsWithParent && [r(t)] || [t]
   }

   function E(o) {
    function s(e) {
     return e && e.source || e
    }

    function l(e, t) {
     return new RegExp(s(e), "m" + (o.case_insensitive ? "i" : "") + (t ? "g" : ""))
    }! function t(n, e) {
     if (n.compiled) return;
     n.compiled = !0;
     n.keywords = n.keywords || n.beginKeywords;
     if (n.keywords) {
      var r = {},
       i = function(n, e) {
        o.case_insensitive && (e = e.toLowerCase()), e.split(" ").forEach(function(e) {
         var t = e.split("|");
         r[t[0]] = [n, t[1] ? Number(t[1]) : 1]
        })
       };
      "string" == typeof n.keywords ? i("keyword", n.keywords) : u(n.keywords).forEach(function(e) {
       i(e, n.keywords[e])
      }), n.keywords = r
     }
     n.lexemesRe = l(n.lexemes || /\w+/, !0);
     e && (n.beginKeywords && (n.begin = "\\b(" + n.beginKeywords.split(" ").join("|") + ")\\b"), n.begin || (n.begin = /\B|\b/), n.beginRe = l(n.begin), n.end || n.endsWithParent || (n.end = /\B|\b/), n.end && (n.endRe = l(n.end)), n.terminator_end = s(n.end) || "", n.endsWithParent && e.terminator_end && (n.terminator_end += (n.end ? "|" : "") + e.terminator_end));
     n.illegal && (n.illegalRe = l(n.illegal));
     null == n.relevance && (n.relevance = 1);
     n.contains || (n.contains = []);
     n.contains = Array.prototype.concat.apply([], n.contains.map(function(e) {
      return h("self" === e ? n : e)
     }));
     n.contains.forEach(function(e) {
      t(e, n)
     });
     n.starts && t(n.starts, e);
     var a = n.contains.map(function(e) {
      return e.beginKeywords ? "\\.?(" + e.begin + ")\\.?" : e.begin
     }).concat([n.terminator_end, n.illegal]).map(s).filter(Boolean);
     n.terminators = a.length ? l(a.join("|"), !0) : {
      exec: function() {
       return null
      }
     }
    }(o)
   }

   function k(e, t, s, n) {
    function l(e, t, n, r) {
     var i = r ? "" : x.classPrefix,
      a = '<span class="' + i,
      o = n ? "" : b;
     return (a += e + '">') + t + o
    }

    function u() {
     p += null != f.subLanguage ? function() {
      var e = "string" == typeof f.subLanguage;
      if (e && !y[f.subLanguage]) return w(h);
      var t = e ? k(f.subLanguage, h, !0, a[f.subLanguage]) : C(h, f.subLanguage.length ? f.subLanguage : void 0);
      0 < f.relevance && (g += t.relevance);
      e && (a[f.subLanguage] = t.top);
      return l(t.language, t.value, !1, !0)
     }() : function() {
      var e, t, n, r;
      if (!f.keywords) return w(h);
      r = "", t = 0, f.lexemesRe.lastIndex = 0, n = f.lexemesRe.exec(h);
      for (; n;) r += w(h.substring(t, n.index)), i = f, a = n, void 0, o = d.case_insensitive ? a[0].toLowerCase() : a[0], (e = i.keywords.hasOwnProperty(o) && i.keywords[o]) ? (g += e[1], r += l(e[0], w(n[0]))) : r += w(n[0]), t = f.lexemesRe.lastIndex, n = f.lexemesRe.exec(h);
      var i, a, o;
      return r + w(h.substr(t))
     }(), h = ""
    }

    function c(e) {
     p += e.className ? l(e.className, "", !0) : "", f = Object.create(e, {
      parent: {
       value: f
      }
     })
    }

    function r(e, t) {
     if (h += e, null == t) return u(), 0;
     var n = function(e, t) {
      var n, r;
      for (n = 0, r = t.contains.length; n < r; n++)
       if (_(t.contains[n].beginRe, e)) return t.contains[n]
     }(t, f);
     if (n) return n.skip ? h += t : (n.excludeBegin && (h += t), u(), n.returnBegin || n.excludeBegin || (h = t)), c(n), n.returnBegin ? 0 : t.length;
     var r, i, a = function e(t, n) {
      if (_(t.endRe, n)) {
       for (; t.endsParent && t.parent;) t = t.parent;
       return t
      }
      if (t.endsWithParent) return e(t.parent, n)
     }(f, t);
     if (a) {
      var o = f;
      for (o.skip ? h += t : (o.returnEnd || o.excludeEnd || (h += t), u(), o.excludeEnd && (h = t)); f.className && (p += b), f.skip || (g += f.relevance), (f = f.parent) !== a.parent;);
      return a.starts && c(a.starts), o.returnEnd ? 0 : t.length
     }
     if (r = t, i = f, !s && _(i.illegalRe, r)) throw new Error('Illegal lexeme "' + t + '" for mode "' + (f.className || "<unnamed>") + '"');
     return h += t, t.length || 1
    }
    var d = T(e);
    if (!d) throw new Error('Unknown language: "' + e + '"');
    E(d);
    var i, f = n || d,
     a = {},
     p = "";
    for (i = f; i !== d; i = i.parent) i.className && (p = l(i.className, "", !0) + p);
    var h = "",
     g = 0;
    try {
     for (var o, m, v = 0; f.terminators.lastIndex = v, o = f.terminators.exec(t);) m = r(t.substring(v, o.index), o[0]), v = o.index + m;
     for (r(t.substr(v)), i = f; i.parent; i = i.parent) i.className && (p += b);
     return {
      relevance: g,
      value: p,
      language: e,
      top: f
     }
    } catch (e) {
     if (e.message && -1 !== e.message.indexOf("Illegal")) return {
      relevance: 0,
      value: w(t)
     };
     throw e
    }
   }

   function C(n, e) {
    e = e || x.languages || u(y);
    var r = {
      relevance: 0,
      value: w(n)
     },
     i = r;
    return e.filter(T).forEach(function(e) {
     var t = k(e, n, !1);
     t.language = e, t.relevance > i.relevance && (i = t), t.relevance > r.relevance && (i = r, r = t)
    }), i.language && (r.second_best = i), r
   }

   function g(e) {
    return x.tabReplace || x.useBR ? e.replace(n, function(e, t) {
     return x.useBR && "\n" === e ? "<br>" : x.tabReplace ? t.replace(/\t/g, x.tabReplace) : ""
    }) : e
   }

   function a(e) {
    var t, n, r, i, a, o = function(e) {
     var t, n, r, i, a = e.className + " ";
     if (a += e.parentNode ? e.parentNode.className : "", n = l.exec(a)) return T(n[1]) ? n[1] : "no-highlight";
     for (a = a.split(/\s+/), t = 0, r = a.length; t < r; t++)
      if (c(i = a[t]) || T(i)) return i
    }(e);
    c(o) || (x.useBR ? (t = document.createElementNS("http://www.w3.org/1999/xhtml", "div")).innerHTML = e.innerHTML.replace(/\n/g, "").replace(/<br[ \/]*>/g, "\n") : t = e, a = t.textContent, r = o ? k(o, a, !0) : C(a), (n = p(t)).length && ((i = document.createElementNS("http://www.w3.org/1999/xhtml", "div")).innerHTML = r.value, r.value = function(e, t, n) {
     var r = 0,
      i = "",
      a = [];

     function o() {
      return e.length && t.length ? e[0].offset !== t[0].offset ? e[0].offset < t[0].offset ? e : t : "start" === t[0].event ? e : t : e.length ? e : t
     }

     function s(e) {
      function t(e) {
       return " " + e.nodeName + '="' + w(e.value).replace('"', "&quot;") + '"'
      }
      i += "<" + f(e) + d.map.call(e.attributes, t).join("") + ">"
     }

     function l(e) {
      i += "</" + f(e) + ">"
     }

     function u(e) {
      ("start" === e.event ? s : l)(e.node)
     }
     for (; e.length || t.length;) {
      var c = o();
      if (i += w(n.substring(r, c[0].offset)), r = c[0].offset, c === e) {
       for (a.reverse().forEach(l); u(c.splice(0, 1)[0]), (c = o()) === e && c.length && c[0].offset === r;);
       a.reverse().forEach(s)
      } else "start" === c[0].event ? a.push(c[0].node) : a.pop(), u(c.splice(0, 1)[0])
     }
     return i + w(n.substr(r))
    }(n, p(i), a)), r.value = g(r.value), e.innerHTML = r.value, e.className = function(e, t, n) {
     var r = t ? s[t] : n,
      i = [e.trim()];
     e.match(/\bhljs\b/) || i.push("hljs"); - 1 === e.indexOf(r) && i.push(r);
     return i.join(" ").trim()
    }(e.className, o, r.language), e.result = {
     language: r.language,
     re: r.relevance
    }, r.second_best && (e.second_best = {
     language: r.second_best.language,
     re: r.second_best.relevance
    }))
   }

   function o() {
    if (!o.called) {
     o.called = !0;
     var e = document.querySelectorAll("pre code");
     d.forEach.call(e, a)
    }
   }

   function T(e) {
    return e = (e || "").toLowerCase(), y[e] || y[s[e]]
   }
   i.highlight = k, i.highlightAuto = C, i.fixMarkup = g, i.highlightBlock = a, i.configure = function(e) {
    x = r(x, e)
   }, i.initHighlighting = o, i.initHighlightingOnLoad = function() {
    addEventListener("DOMContentLoaded", o, !1), addEventListener("load", o, !1)
   }, i.registerLanguage = function(t, e) {
    var n = y[t] = e(i);
    n.aliases && n.aliases.forEach(function(e) {
     s[e] = t
    })
   }, i.listLanguages = function() {
    return u(y)
   }, i.getLanguage = T, i.inherit = r, i.IDENT_RE = "[a-zA-Z]\\w*", i.UNDERSCORE_IDENT_RE = "[a-zA-Z_]\\w*", i.NUMBER_RE = "\\b\\d+(\\.\\d+)?", i.C_NUMBER_RE = "(-?)(\\b0[xX][a-fA-F0-9]+|(\\b\\d+(\\.\\d*)?|\\.\\d+)([eE][-+]?\\d+)?)", i.BINARY_NUMBER_RE = "\\b(0b[01]+)", i.RE_STARTERS_RE = "!|!=|!==|%|%=|&|&&|&=|\\*|\\*=|\\+|\\+=|,|-|-=|/=|/|:|;|<<|<<=|<=|<|===|==|=|>>>=|>>=|>=|>>>|>>|>|\\?|\\[|\\{|\\(|\\^|\\^=|\\||\\|=|\\|\\||~", i.BACKSLASH_ESCAPE = {
    begin: "\\\\[\\s\\S]",
    relevance: 0
   }, i.APOS_STRING_MODE = {
    className: "string",
    begin: "'",
    end: "'",
    illegal: "\\n",
    contains: [i.BACKSLASH_ESCAPE]
   }, i.QUOTE_STRING_MODE = {
    className: "string",
    begin: '"',
    end: '"',
    illegal: "\\n",
    contains: [i.BACKSLASH_ESCAPE]
   }, i.PHRASAL_WORDS_MODE = {
    begin: /\b(a|an|the|are|I'm|isn't|don't|doesn't|won't|but|just|should|pretty|simply|enough|gonna|going|wtf|so|such|will|you|your|they|like|more)\b/
   }, i.COMMENT = function(e, t, n) {
    var r = i.inherit({
     className: "comment",
     begin: e,
     end: t,
     contains: []
    }, n || {});
    return r.contains.push(i.PHRASAL_WORDS_MODE), r.contains.push({
     className: "doctag",
     begin: "(?:TODO|FIXME|NOTE|BUG|XXX):",
     relevance: 0
    }), r
   }, i.C_LINE_COMMENT_MODE = i.COMMENT("//", "$"), i.C_BLOCK_COMMENT_MODE = i.COMMENT("/\\*", "\\*/"), i.HASH_COMMENT_MODE = i.COMMENT("#", "$"), i.NUMBER_MODE = {
    className: "number",
    begin: i.NUMBER_RE,
    relevance: 0
   }, i.C_NUMBER_MODE = {
    className: "number",
    begin: i.C_NUMBER_RE,
    relevance: 0
   }, i.BINARY_NUMBER_MODE = {
    className: "number",
    begin: i.BINARY_NUMBER_RE,
    relevance: 0
   }, i.CSS_NUMBER_MODE = {
    className: "number",
    begin: i.NUMBER_RE + "(%|em|ex|ch|rem|vw|vh|vmin|vmax|cm|mm|in|pt|pc|px|deg|grad|rad|turn|s|ms|Hz|kHz|dpi|dpcm|dppx)?",
    relevance: 0
   }, i.REGEXP_MODE = {
    className: "regexp",
    begin: /\//,
    end: /\/[gimuy]*/,
    illegal: /\n/,
    contains: [i.BACKSLASH_ESCAPE, {
     begin: /\[/,
     end: /\]/,
     relevance: 0,
     contains: [i.BACKSLASH_ESCAPE]
    }]
   }, i.TITLE_MODE = {
    className: "title",
    begin: i.IDENT_RE,
    relevance: 0
   }, i.UNDERSCORE_TITLE_MODE = {
    className: "title",
    begin: i.UNDERSCORE_IDENT_RE,
    relevance: 0
   }, i.METHOD_GUARD = {
    begin: "\\.\\s*" + i.UNDERSCORE_IDENT_RE,
    relevance: 0
   }
  })(t)
 }()
}, function(e, t, n) {
 e.exports = n(40).default
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0, t.extend = s, t.indexOf = function(e, t) {
  for (var n = 0, r = e.length; n < r; n++)
   if (e[n] === t) return n;
  return -1
 }, t.escapeExpression = function(e) {
  if ("string" != typeof e) {
   if (e && e.toHTML) return e.toHTML();
   if (null == e) return "";
   if (!e) return e + "";
   e = "" + e
  }
  return a.test(e) ? e.replace(i, o) : e
 }, t.isEmpty = function(e) {
  return !e && 0 !== e || !(!c(e) || 0 !== e.length)
 }, t.createFrame = function(e) {
  var t = s({}, e);
  return t._parent = e, t
 }, t.blockParams = function(e, t) {
  return e.path = t, e
 }, t.appendContextPath = function(e, t) {
  return (e ? e + "." : "") + t
 };
 var r = {
   "&": "&amp;",
   "<": "&lt;",
   ">": "&gt;",
   '"': "&quot;",
   "'": "&#x27;",
   "`": "&#x60;",
   "=": "&#x3D;"
  },
  i = /[&<>"'`=]/g,
  a = /[&<>"'`=]/;

 function o(e) {
  return r[e]
 }

 function s(e) {
  for (var t = 1; t < arguments.length; t++)
   for (var n in arguments[t]) Object.prototype.hasOwnProperty.call(arguments[t], n) && (e[n] = arguments[t][n]);
  return e
 }
 var l = Object.prototype.toString;
 t.toString = l;
 var u = function(e) {
  return "function" == typeof e
 };
 u(/x/) && (t.isFunction = u = function(e) {
  return "function" == typeof e && "[object Function]" === l.call(e)
 }), t.isFunction = u;
 var c = Array.isArray || function(e) {
  return !(!e || "object" != typeof e) && "[object Array]" === l.call(e)
 };
 t.isArray = c
}, function(e, yt, t) {
 (function(e, t) {
  var n = "Expected a function",
   r = "__lodash_hash_undefined__",
   v = 1,
   x = 2,
   l = 1 / 0,
   i = 9007199254740991,
   u = 17976931348623157e292,
   c = NaN,
   y = "[object Arguments]",
   b = "[object Array]",
   w = "[object Boolean]",
   _ = "[object Date]",
   E = "[object Error]",
   a = "[object Function]",
   o = "[object GeneratorFunction]",
   k = "[object Map]",
   C = "[object Number]",
   T = "[object Object]",
   s = "[object Promise]",
   S = "[object RegExp]",
   N = "[object Set]",
   O = "[object String]",
   A = "[object Symbol]",
   d = "[object WeakMap]",
   j = "[object ArrayBuffer]",
   D = "[object DataView]",
   f = /\.|\[(?:[^[\]]*|(["'])(?:(?!\1)[^\\]|\\.)*?\1)\]/,
   p = /^\w*$/,
   h = /^\./,
   g = /[^.[\]]+|\[(?:(-?\d+(?:\.\d+)?)|(["'])((?:(?!\2)[^\\]|\\.)*?)\2)\]|(?=(?:\.|\[\])(?:\.|\[\]|$))/g,
   m = /^\s+|\s+$/g,
   L = /\\(\\)?/g,
   R = /^[-+]0x[0-9a-f]+$/i,
   P = /^0b[01]+$/i,
   M = /^\[object .+?Constructor\]$/,
   I = /^0o[0-7]+$/i,
   q = /^(?:0|[1-9]\d*)$/,
   B = {};
  B["[object Float32Array]"] = B["[object Float64Array]"] = B["[object Int8Array]"] = B["[object Int16Array]"] = B["[object Int32Array]"] = B["[object Uint8Array]"] = B["[object Uint8ClampedArray]"] = B["[object Uint16Array]"] = B["[object Uint32Array]"] = !0, B[y] = B[b] = B[j] = B[w] = B[D] = B[_] = B[E] = B[a] = B[k] = B[C] = B[T] = B[S] = B[N] = B[O] = B[d] = !1;
  var Q = parseInt,
   H = "object" == typeof e && e && e.Object === Object && e,
   F = "object" == typeof self && self && self.Object === Object && self,
   $ = H || F || Function("return this")(),
   z = "object" == typeof yt && yt && !yt.nodeType && yt,
   W = z && "object" == typeof t && t && !t.nodeType && t,
   U = W && W.exports === z && H.process,
   V = function() {
    try {
     return U && U.binding("util")
    } catch (e) {}
   }(),
   G = V && V.isTypedArray;

  function K(e, t) {
   for (var n = -1, r = e ? e.length : 0; ++n < r;)
    if (t(e[n], n, e)) return !0;
   return !1
  }

  function X(e) {
   var t = !1;
   if (null != e && "function" != typeof e.toString) try {
    t = !!(e + "")
   } catch (e) {}
   return t
  }

  function Z(e) {
   var n = -1,
    r = Array(e.size);
   return e.forEach(function(e, t) {
    r[++n] = [t, e]
   }), r
  }

  function J(e) {
   var t = -1,
    n = Array(e.size);
   return e.forEach(function(e) {
    n[++t] = e
   }), n
  }
  var Y, ee, te, ne = Array.prototype,
   re = Function.prototype,
   ie = Object.prototype,
   ae = $["__core-js_shared__"],
   oe = (Y = /[^.]+$/.exec(ae && ae.keys && ae.keys.IE_PROTO || "")) ? "Symbol(src)_1." + Y : "",
   se = re.toString,
   le = ie.hasOwnProperty,
   ue = ie.toString,
   ce = RegExp("^" + se.call(le).replace(/[\\^$.*+?()[\]{}|]/g, "\\$&").replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g, "$1.*?") + "$"),
   de = $.Symbol,
   fe = $.Uint8Array,
   pe = ie.propertyIsEnumerable,
   he = ne.splice,
   ge = (ee = Object.keys, te = Object, function(e) {
    return ee(te(e))
   }),
   me = Math.max,
   ve = Ve($, "DataView"),
   ye = Ve($, "Map"),
   be = Ve($, "Promise"),
   xe = Ve($, "Set"),
   we = Ve($, "WeakMap"),
   _e = Ve(Object, "create"),
   Ee = tt(ve),
   ke = tt(ye),
   Ce = tt(be),
   Te = tt(xe),
   Se = tt(we),
   Ne = de ? de.prototype : void 0,
   Oe = Ne ? Ne.valueOf : void 0,
   Ae = Ne ? Ne.toString : void 0;

  function je(e) {
   var t = -1,
    n = e ? e.length : 0;
   for (this.clear(); ++t < n;) {
    var r = e[t];
    this.set(r[0], r[1])
   }
  }

  function De(e) {
   var t = -1,
    n = e ? e.length : 0;
   for (this.clear(); ++t < n;) {
    var r = e[t];
    this.set(r[0], r[1])
   }
  }

  function Le(e) {
   var t = -1,
    n = e ? e.length : 0;
   for (this.clear(); ++t < n;) {
    var r = e[t];
    this.set(r[0], r[1])
   }
  }

  function Re(e) {
   var t = -1,
    n = e ? e.length : 0;
   for (this.__data__ = new Le; ++t < n;) this.add(e[t])
  }

  function Pe(e) {
   this.__data__ = new De(e)
  }

  function Me(e, t) {
   var n = st(e) || ot(e) ? function(e, t) {
     for (var n = -1, r = Array(e); ++n < e;) r[n] = t(n);
     return r
    }(e.length, String) : [],
    r = n.length,
    i = !!r;
   for (var a in e) !t && !le.call(e, a) || i && ("length" == a || Ke(a, r)) || n.push(a);
   return n
  }

  function Ie(e, t) {
   for (var n = e.length; n--;)
    if (at(e[n][0], t)) return n;
   return -1
  }

  function qe(e, t) {
   for (var n = 0, r = (t = Xe(t, e) ? [t] : ze(t)).length; null != e && n < r;) e = e[et(t[n++])];
   return n && n == r ? e : void 0
  }

  function Be(e, t) {
   return null != e && t in Object(e)
  }

  function Qe(e, t, n, r, i) {
   return e === t || (null == e || null == t || !dt(e) && !ft(t) ? e != e && t != t : function(e, t, n, r, i, a) {
    var o = st(e),
     s = st(t),
     l = b,
     u = b;
    o || (l = (l = Ge(e)) == y ? T : l);
    s || (u = (u = Ge(t)) == y ? T : u);
    var c = l == T && !X(e),
     d = u == T && !X(t),
     f = l == u;
    if (f && !c) return a || (a = new Pe), o || gt(e) ? We(e, t, n, r, i, a) : function(e, t, n, r, i, a, o) {
     switch (n) {
      case D:
       if (e.byteLength != t.byteLength || e.byteOffset != t.byteOffset) return !1;
       e = e.buffer, t = t.buffer;
      case j:
       return !(e.byteLength != t.byteLength || !r(new fe(e), new fe(t)));
      case w:
      case _:
      case C:
       return at(+e, +t);
      case E:
       return e.name == t.name && e.message == t.message;
      case S:
      case O:
       return e == t + "";
      case k:
       var s = Z;
      case N:
       var l = a & x;
       if (s || (s = J), e.size != t.size && !l) return !1;
       var u = o.get(e);
       if (u) return u == t;
       a |= v, o.set(e, t);
       var c = We(s(e), s(t), r, i, a, o);
       return o.delete(e), c;
      case A:
       if (Oe) return Oe.call(e) == Oe.call(t)
     }
     return !1
    }(e, t, l, n, r, i, a);
    if (!(i & x)) {
     var p = c && le.call(e, "__wrapped__"),
      h = d && le.call(t, "__wrapped__");
     if (p || h) {
      var g = p ? e.value() : e,
       m = h ? t.value() : t;
      return a || (a = new Pe), n(g, m, r, i, a)
     }
    }
    return !!f && (a || (a = new Pe), function(e, t, n, r, i, a) {
     var o = i & x,
      s = mt(e),
      l = s.length,
      u = mt(t).length;
     if (l != u && !o) return !1;
     for (var c = l; c--;) {
      var d = s[c];
      if (!(o ? d in t : le.call(t, d))) return !1
     }
     var f = a.get(e);
     if (f && a.get(t)) return f == t;
     var p = !0;
     a.set(e, t), a.set(t, e);
     for (var h = o; ++c < l;) {
      d = s[c];
      var g = e[d],
       m = t[d];
      if (r) var v = o ? r(m, g, d, t, e, a) : r(g, m, d, e, t, a);
      if (!(void 0 === v ? g === m || n(g, m, r, i, a) : v)) {
       p = !1;
       break
      }
      h || (h = "constructor" == d)
     }
     if (p && !h) {
      var y = e.constructor,
       b = t.constructor;
      y != b && "constructor" in e && "constructor" in t && !("function" == typeof y && y instanceof y && "function" == typeof b && b instanceof b) && (p = !1)
     }
     return a.delete(e), a.delete(t), p
    }(e, t, n, r, i, a))
   }(e, t, Qe, n, r, i))
  }

  function He(e) {
   return !(!dt(e) || (t = e, oe && oe in t)) && (ut(e) || X(e) ? ce : M).test(tt(e));
   var t
  }

  function Fe(e) {
   return "function" == typeof e ? e : null == e ? vt : "object" == typeof e ? st(e) ? function(l, u) {
    if (Xe(l) && Ze(u)) return Je(et(l), u);
    return function(e) {
     var t, n, r, i, a, o, s = (n = l, void 0 === (i = null == (t = e) ? void 0 : qe(t, n)) ? r : i);
     return void 0 === s && s === u ? (o = l, null != (a = e) && function(e, t, n) {
      t = Xe(t, e) ? [t] : ze(t);
      for (var r, i = -1, a = t.length; ++i < a;) {
       var o = et(t[i]);
       if (!(r = null != e && n(e, o))) break;
       e = e[o]
      }
      return r || !!(a = e ? e.length : 0) && ct(a) && Ke(o, a) && (st(e) || ot(e))
     }(a, o, Be)) : Qe(u, s, void 0, v | x)
    }
   }(e[0], e[1]) : function(t) {
    var n = function(e) {
     var t = mt(e),
      n = t.length;
     for (; n--;) {
      var r = t[n],
       i = e[r];
      t[n] = [r, i, Ze(i)]
     }
     return t
    }(t);
    if (1 == n.length && n[0][2]) return Je(n[0][0], n[0][1]);
    return function(e) {
     return e === t || function(e, t, n, r) {
      var i = n.length,
       a = i,
       o = !r;
      if (null == e) return !a;
      for (e = Object(e); i--;) {
       var s = n[i];
       if (o && s[2] ? s[1] !== e[s[0]] : !(s[0] in e)) return !1
      }
      for (; ++i < a;) {
       var l = (s = n[i])[0],
        u = e[l],
        c = s[1];
       if (o && s[2]) {
        if (void 0 === u && !(l in e)) return !1
       } else {
        var d = new Pe;
        if (r) var f = r(u, c, l, e, t, d);
        if (!(void 0 === f ? Qe(c, u, r, v | x, d) : f)) return !1
       }
      }
      return !0
     }(e, t, n)
    }
   }(e) : Xe(t = e) ? (r = et(t), function(e) {
    return null == e ? void 0 : e[r]
   }) : (n = t, function(e) {
    return qe(e, n)
   });
   var t, n, r
  }

  function $e(e) {
   if (n = (t = e) && t.constructor, r = "function" == typeof n && n.prototype || ie, t !== r) return ge(e);
   var t, n, r, i = [];
   for (var a in Object(e)) le.call(e, a) && "constructor" != a && i.push(a);
   return i
  }

  function ze(e) {
   return st(e) ? e : Ye(e)
  }

  function We(e, t, n, r, i, a) {
   var o = i & x,
    s = e.length,
    l = t.length;
   if (s != l && !(o && s < l)) return !1;
   var u = a.get(e);
   if (u && a.get(t)) return u == t;
   var c = -1,
    d = !0,
    f = i & v ? new Re : void 0;
   for (a.set(e, t), a.set(t, e); ++c < s;) {
    var p = e[c],
     h = t[c];
    if (r) var g = o ? r(h, p, c, t, e, a) : r(p, h, c, e, t, a);
    if (void 0 !== g) {
     if (g) continue;
     d = !1;
     break
    }
    if (f) {
     if (!K(t, function(e, t) {
       if (!f.has(t) && (p === e || n(p, e, r, i, a))) return f.add(t)
      })) {
      d = !1;
      break
     }
    } else if (p !== h && !n(p, h, r, i, a)) {
     d = !1;
     break
    }
   }
   return a.delete(e), a.delete(t), d
  }

  function Ue(e, t) {
   var n, r, i = e.__data__;
   return ("string" == (r = typeof(n = t)) || "number" == r || "symbol" == r || "boolean" == r ? "__proto__" !== n : null === n) ? i["string" == typeof t ? "string" : "hash"] : i.map
  }

  function Ve(e, t) {
   var n, r, i = (r = t, null == (n = e) ? void 0 : n[r]);
   return He(i) ? i : void 0
  }
  je.prototype.clear = function() {
   this.__data__ = _e ? _e(null) : {}
  }, je.prototype.delete = function(e) {
   return this.has(e) && delete this.__data__[e]
  }, je.prototype.get = function(e) {
   var t = this.__data__;
   if (_e) {
    var n = t[e];
    return n === r ? void 0 : n
   }
   return le.call(t, e) ? t[e] : void 0
  }, je.prototype.has = function(e) {
   var t = this.__data__;
   return _e ? void 0 !== t[e] : le.call(t, e)
  }, je.prototype.set = function(e, t) {
   return this.__data__[e] = _e && void 0 === t ? r : t, this
  }, De.prototype.clear = function() {
   this.__data__ = []
  }, De.prototype.delete = function(e) {
   var t = this.__data__,
    n = Ie(t, e);
   return !(n < 0 || (n == t.length - 1 ? t.pop() : he.call(t, n, 1), 0))
  }, De.prototype.get = function(e) {
   var t = this.__data__,
    n = Ie(t, e);
   return n < 0 ? void 0 : t[n][1]
  }, De.prototype.has = function(e) {
   return -1 < Ie(this.__data__, e)
  }, De.prototype.set = function(e, t) {
   var n = this.__data__,
    r = Ie(n, e);
   return r < 0 ? n.push([e, t]) : n[r][1] = t, this
  }, Le.prototype.clear = function() {
   this.__data__ = {
    hash: new je,
    map: new(ye || De),
    string: new je
   }
  }, Le.prototype.delete = function(e) {
   return Ue(this, e).delete(e)
  }, Le.prototype.get = function(e) {
   return Ue(this, e).get(e)
  }, Le.prototype.has = function(e) {
   return Ue(this, e).has(e)
  }, Le.prototype.set = function(e, t) {
   return Ue(this, e).set(e, t), this
  }, Re.prototype.add = Re.prototype.push = function(e) {
   return this.__data__.set(e, r), this
  }, Re.prototype.has = function(e) {
   return this.__data__.has(e)
  }, Pe.prototype.clear = function() {
   this.__data__ = new De
  }, Pe.prototype.delete = function(e) {
   return this.__data__.delete(e)
  }, Pe.prototype.get = function(e) {
   return this.__data__.get(e)
  }, Pe.prototype.has = function(e) {
   return this.__data__.has(e)
  }, Pe.prototype.set = function(e, t) {
   var n = this.__data__;
   if (n instanceof De) {
    var r = n.__data__;
    if (!ye || r.length < 199) return r.push([e, t]), this;
    n = this.__data__ = new Le(r)
   }
   return n.set(e, t), this
  };
  var Ge = function(e) {
   return ue.call(e)
  };

  function Ke(e, t) {
   return !!(t = null == t ? i : t) && ("number" == typeof e || q.test(e)) && -1 < e && e % 1 == 0 && e < t
  }

  function Xe(e, t) {
   if (st(e)) return !1;
   var n = typeof e;
   return !("number" != n && "symbol" != n && "boolean" != n && null != e && !pt(e)) || (p.test(e) || !f.test(e) || null != t && e in Object(t))
  }

  function Ze(e) {
   return e == e && !dt(e)
  }

  function Je(t, n) {
   return function(e) {
    return null != e && (e[t] === n && (void 0 !== n || t in Object(e)))
   }
  }(ve && Ge(new ve(new ArrayBuffer(1))) != D || ye && Ge(new ye) != k || be && Ge(be.resolve()) != s || xe && Ge(new xe) != N || we && Ge(new we) != d) && (Ge = function(e) {
   var t = ue.call(e),
    n = t == T ? e.constructor : void 0,
    r = n ? tt(n) : void 0;
   if (r) switch (r) {
    case Ee:
     return D;
    case ke:
     return k;
    case Ce:
     return s;
    case Te:
     return N;
    case Se:
     return d
   }
   return t
  });
  var Ye = it(function(e) {
   var t;
   e = null == (t = e) ? "" : function(e) {
    if ("string" == typeof e) return e;
    if (pt(e)) return Ae ? Ae.call(e) : "";
    var t = e + "";
    return "0" == t && 1 / e == -l ? "-0" : t
   }(t);
   var i = [];
   return h.test(e) && i.push(""), e.replace(g, function(e, t, n, r) {
    i.push(n ? r.replace(L, "$1") : t || e)
   }), i
  });

  function et(e) {
   if ("string" == typeof e || pt(e)) return e;
   var t = e + "";
   return "0" == t && 1 / e == -l ? "-0" : t
  }

  function tt(e) {
   if (null != e) {
    try {
     return se.call(e)
    } catch (e) {}
    try {
     return e + ""
    } catch (e) {}
   }
   return ""
  }
  var nt, rt = (nt = function(e, t, n) {
   var r = e ? e.length : 0;
   if (!r) return -1;
   var i, a, o, s = null == n ? 0 : (i = (o = n) ? (o = function(e) {
    if ("number" == typeof e) return e;
    if (pt(e)) return c;
    if (dt(e)) {
     var t = "function" == typeof e.valueOf ? e.valueOf() : e;
     e = dt(t) ? t + "" : t
    }
    if ("string" != typeof e) return 0 === e ? e : +e;
    e = e.replace(m, "");
    var n = P.test(e);
    return n || I.test(e) ? Q(e.slice(2), n ? 2 : 8) : R.test(e) ? c : +e
   }(o)) !== l && o !== -l ? o == o ? o : 0 : (o < 0 ? -1 : 1) * u : 0 === o ? o : 0, a = i % 1, i == i ? a ? i - a : i : 0);
   return s < 0 && (s = me(r + s, 0)),
    function(e, t, n, r) {
     for (var i = e.length, a = n + (r ? 1 : -1); r ? a-- : ++a < i;)
      if (t(e[a], a, e)) return a;
     return -1
    }(e, Fe(t), s)
  }, function(e, t, n) {
   var r = Object(e);
   if (!lt(e)) {
    var i = Fe(t);
    e = mt(e), t = function(e) {
     return i(r[e], e, r)
    }
   }
   var a = nt(e, t, n);
   return -1 < a ? r[i ? e[a] : a] : void 0
  });

  function it(i, a) {
   if ("function" != typeof i || a && "function" != typeof a) throw new TypeError(n);
   var o = function() {
    var e = arguments,
     t = a ? a.apply(this, e) : e[0],
     n = o.cache;
    if (n.has(t)) return n.get(t);
    var r = i.apply(this, e);
    return o.cache = n.set(t, r), r
   };
   return o.cache = new(it.Cache || Le), o
  }

  function at(e, t) {
   return e === t || e != e && t != t
  }

  function ot(e) {
   return ft(t = e) && lt(t) && le.call(e, "callee") && (!pe.call(e, "callee") || ue.call(e) == y);
   var t
  }
  it.Cache = Le;
  var st = Array.isArray;

  function lt(e) {
   return null != e && ct(e.length) && !ut(e)
  }

  function ut(e) {
   var t = dt(e) ? ue.call(e) : "";
   return t == a || t == o
  }

  function ct(e) {
   return "number" == typeof e && -1 < e && e % 1 == 0 && e <= i
  }

  function dt(e) {
   var t = typeof e;
   return !!e && ("object" == t || "function" == t)
  }

  function ft(e) {
   return !!e && "object" == typeof e
  }

  function pt(e) {
   return "symbol" == typeof e || ft(e) && ue.call(e) == A
  }
  var ht, gt = G ? (ht = G, function(e) {
   return ht(e)
  }) : function(e) {
   return ft(e) && ct(e.length) && !!B[ue.call(e)]
  };

  function mt(e) {
   return lt(e) ? Me(e) : $e(e)
  }

  function vt(e) {
   return e
  }
  t.exports = rt
 }).call(this, t(20), t(55)(e))
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0;
 var s = ["description", "fileName", "lineNumber", "message", "name", "number", "stack"];

 function l(e, t) {
  var n = t && t.loc,
   r = void 0,
   i = void 0;
  n && (e += " - " + (r = n.start.line) + ":" + (i = n.start.column));
  for (var a = Error.prototype.constructor.call(this, e), o = 0; o < s.length; o++) this[s[o]] = a[s[o]];
  Error.captureStackTrace && Error.captureStackTrace(this, l);
  try {
   n && (this.lineNumber = r, Object.defineProperty ? Object.defineProperty(this, "column", {
    value: i,
    enumerable: !0
   }) : this.column = i)
  } catch (e) {}
 }
 l.prototype = new Error, t.default = l, e.exports = t.default
}, function(e, t) {
 e.exports = function(e) {
  var t = {
    className: "variable",
    variants: [{
     begin: /\$[\w\d#@][\w\d_]*/
    }, {
     begin: /\$\{(.*?)}/
    }]
   },
   n = {
    className: "string",
    begin: /"/,
    end: /"/,
    contains: [e.BACKSLASH_ESCAPE, t, {
     className: "variable",
     begin: /\$\(/,
     end: /\)/,
     contains: [e.BACKSLASH_ESCAPE]
    }]
   };
  return {
   aliases: ["sh", "zsh"],
   lexemes: /-?[a-z\._]+/,
   keywords: {
    keyword: "if then else elif fi for while in do done case esac function",
    literal: "true false",
    built_in: "break cd continue eval exec exit export getopts hash pwd readonly return shift test times trap umask unset alias bind builtin caller command declare echo enable help let local logout mapfile printf read readarray source type typeset ulimit unalias set shopt autoload bg bindkey bye cap chdir clone comparguments compcall compctl compdescribe compfiles compgroups compquote comptags comptry compvalues dirs disable disown echotc echoti emulate fc fg float functions getcap getln history integer jobs kill limit log noglob popd print pushd pushln rehash sched setcap setopt stat suspend ttyctl unfunction unhash unlimit unsetopt vared wait whence where which zcompile zformat zftp zle zmodload zparseopts zprof zpty zregexparse zsocket zstyle ztcp",
    _: "-ne -eq -lt -gt -f -d -e -s -l -a"
   },
   contains: [{
    className: "meta",
    begin: /^#![^\n]+sh\s*$/,
    relevance: 10
   }, {
    className: "function",
    begin: /\w[\w\d_]*\s*\(\s*\)\s*\{/,
    returnBegin: !0,
    contains: [e.inherit(e.TITLE_MODE, {
     begin: /\w[\w\d_]*/
    })],
    relevance: 0
   }, e.HASH_COMMENT_MODE, n, {
    className: "string",
    begin: /'/,
    end: /'/
   }, t]
  }
 }
}, function(e, t) {
 e.exports = function(e) {
  var t = {
   begin: /[A-Z\_\.\-]+\s*:/,
   returnBegin: !0,
   end: ";",
   endsWithParent: !0,
   contains: [{
    className: "attribute",
    begin: /\S/,
    end: ":",
    excludeEnd: !0,
    starts: {
     endsWithParent: !0,
     excludeEnd: !0,
     contains: [{
      begin: /[\w-]+\(/,
      returnBegin: !0,
      contains: [{
       className: "built_in",
       begin: /[\w-]+/
      }, {
       begin: /\(/,
       end: /\)/,
       contains: [e.APOS_STRING_MODE, e.QUOTE_STRING_MODE]
      }]
     }, e.CSS_NUMBER_MODE, e.QUOTE_STRING_MODE, e.APOS_STRING_MODE, e.C_BLOCK_COMMENT_MODE, {
      className: "number",
      begin: "#[0-9A-Fa-f]+"
     }, {
      className: "meta",
      begin: "!important"
     }]
    }
   }]
  };
  return {
   case_insensitive: !0,
   illegal: /[=\/|'\$]/,
   contains: [e.C_BLOCK_COMMENT_MODE, {
    className: "selector-id",
    begin: /#[A-Za-z0-9_-]+/
   }, {
    className: "selector-class",
    begin: /\.[A-Za-z0-9_-]+/
   }, {
    className: "selector-attr",
    begin: /\[/,
    end: /\]/,
    illegal: "$"
   }, {
    className: "selector-pseudo",
    begin: /:(:)?[a-zA-Z0-9\_\-\+\(\)"'.]+/
   }, {
    begin: "@(font-face|page)",
    lexemes: "[a-z-]+",
    keywords: "font-face page"
   }, {
    begin: "@",
    end: "[{;]",
    illegal: /:/,
    contains: [{
     className: "keyword",
     begin: /\w+/
    }, {
     begin: /\s/,
     endsWithParent: !0,
     excludeEnd: !0,
     relevance: 0,
     contains: [e.APOS_STRING_MODE, e.QUOTE_STRING_MODE, e.CSS_NUMBER_MODE]
    }]
   }, {
    className: "selector-tag",
    begin: "[a-zA-Z-][a-zA-Z0-9_-]*",
    relevance: 0
   }, {
    begin: "{",
    end: "}",
    illegal: /\S/,
    contains: [e.C_BLOCK_COMMENT_MODE, t]
   }]
  }
 }
}, function(e, t) {
 e.exports = function(e) {
  return {
   aliases: ["patch"],
   contains: [{
    className: "meta",
    relevance: 10,
    variants: [{
     begin: /^@@ +\-\d+,\d+ +\+\d+,\d+ +@@$/
    }, {
     begin: /^\*\*\* +\d+,\d+ +\*\*\*\*$/
    }, {
     begin: /^\-\-\- +\d+,\d+ +\-\-\-\-$/
    }]
   }, {
    className: "comment",
    variants: [{
     begin: /Index: /,
     end: /$/
    }, {
     begin: /={3,}/,
     end: /$/
    }, {
     begin: /^\-{3}/,
     end: /$/
    }, {
     begin: /^\*{3} /,
     end: /$/
    }, {
     begin: /^\+{3}/,
     end: /$/
    }, {
     begin: /\*{5}/,
     end: /\*{5}$/
    }]
   }, {
    className: "addition",
    begin: "^\\+",
    end: "$"
   }, {
    className: "deletion",
    begin: "^\\-",
    end: "$"
   }, {
    className: "addition",
    begin: "^\\!",
    end: "$"
   }]
  }
 }
}, function(e, t) {
 e.exports = function(e) {
  var t = "[a-z'][a-zA-Z0-9_']*",
   n = "(" + t + ":" + t + "|" + t + ")",
   r = {
    keyword: "after and andalso|10 band begin bnot bor bsl bzr bxor case catch cond div end fun if let not of orelse|10 query receive rem try when xor",
    literal: "false true"
   },
   i = e.COMMENT("%", "$"),
   a = {
    className: "number",
    begin: "\\b(\\d+#[a-fA-F0-9]+|\\d+(\\.\\d+)?([eE][-+]?\\d+)?)",
    relevance: 0
   },
   o = {
    begin: "fun\\s+" + t + "/\\d+"
   },
   s = {
    begin: n + "\\(",
    end: "\\)",
    returnBegin: !0,
    relevance: 0,
    contains: [{
     begin: n,
     relevance: 0
    }, {
     begin: "\\(",
     end: "\\)",
     endsWithParent: !0,
     returnEnd: !0,
     relevance: 0
    }]
   },
   l = {
    begin: "{",
    end: "}",
    relevance: 0
   },
   u = {
    begin: "\\b_([A-Z][A-Za-z0-9_]*)?",
    relevance: 0
   },
   c = {
    begin: "[A-Z][a-zA-Z0-9_]*",
    relevance: 0
   },
   d = {
    begin: "#" + e.UNDERSCORE_IDENT_RE,
    relevance: 0,
    returnBegin: !0,
    contains: [{
     begin: "#" + e.UNDERSCORE_IDENT_RE,
     relevance: 0
    }, {
     begin: "{",
     end: "}",
     relevance: 0
    }]
   },
   f = {
    beginKeywords: "fun receive if try case",
    end: "end",
    keywords: r
   };
  f.contains = [i, o, e.inherit(e.APOS_STRING_MODE, {
   className: ""
  }), f, s, e.QUOTE_STRING_MODE, a, l, u, c, d];
  var p = [i, o, f, s, e.QUOTE_STRING_MODE, a, l, u, c, d];
  s.contains[1].contains = p, l.contains = p;
  var h = {
   className: "params",
   begin: "\\(",
   end: "\\)",
   contains: d.contains[1].contains = p
  };
  return {
   aliases: ["erl"],
   keywords: r,
   illegal: "(</|\\*=|\\+=|-=|/\\*|\\*/|\\(\\*|\\*\\))",
   contains: [{
    className: "function",
    begin: "^" + t + "\\s*\\(",
    end: "->",
    returnBegin: !0,
    illegal: "\\(|#|//|/\\*|\\\\|:|;",
    contains: [h, e.inherit(e.TITLE_MODE, {
     begin: t
    })],
    starts: {
     end: ";|\\.",
     keywords: r,
     contains: p
    }
   }, i, {
    begin: "^-",
    end: "\\.",
    relevance: 0,
    excludeEnd: !0,
    returnBegin: !0,
    lexemes: "-" + e.IDENT_RE,
    keywords: "-module -record -undef -export -ifdef -ifndef -author -copyright -doc -vsn -import -include -include_lib -compile -define -else -endif -file -behaviour -behavior -spec",
    contains: [h]
   }, a, e.QUOTE_STRING_MODE, d, u, c, l, {
    begin: /\.$/
   }]
  }
 }
}, function(e, t) {
 e.exports = function(e) {
  return {
   keywords: {
    built_in: "spawn spawn_link self",
    keyword: "after and andalso|10 band begin bnot bor bsl bsr bxor case catch cond div end fun if let not of or orelse|10 query receive rem try when xor"
   },
   contains: [{
    className: "meta",
    begin: "^[0-9]+> ",
    relevance: 10
   }, e.COMMENT("%", "$"), {
    className: "number",
    begin: "\\b(\\d+#[a-fA-F0-9]+|\\d+(\\.\\d+)?([eE][-+]?\\d+)?)",
    relevance: 0
   }, e.APOS_STRING_MODE, e.QUOTE_STRING_MODE, {
    begin: "\\?(::)?([A-Z]\\w*(::)?)+"
   }, {
    begin: "->"
   }, {
    begin: "ok"
   }, {
    begin: "!"
   }, {
    begin: "(\\b[a-z'][a-zA-Z0-9_']*:[a-z'][a-zA-Z0-9_']*)|(\\b[a-z'][a-zA-Z0-9_']*)",
    relevance: 0
   }, {
    begin: "[A-Z][a-zA-Z0-9_']*",
    relevance: 0
   }]
  }
 }
}, function(e, t) {
 e.exports = function(e) {
  var t = "HTTP/[0-9\\.]+";
  return {
   aliases: ["https"],
   illegal: "\\S",
   contains: [{
    begin: "^" + t,
    end: "$",
    contains: [{
     className: "number",
     begin: "\\b\\d{3}\\b"
    }]
   }, {
    begin: "^[A-Z]+ (.*?) " + t + "$",
    returnBegin: !0,
    end: "$",
    contains: [{
     className: "string",
     begin: " ",
     end: " ",
     excludeBegin: !0,
     excludeEnd: !0
    }, {
     begin: t
    }, {
     className: "keyword",
     begin: "[A-Z]+"
    }]
   }, {
    className: "attribute",
    begin: "^\\w",
    end: ": ",
    excludeEnd: !0,
    illegal: "\\n|\\s|=",
    starts: {
     end: "$",
     relevance: 0
    }
   }, {
    begin: "\\n\\n",
    starts: {
     subLanguage: [],
     endsWithParent: !0
    }
   }]
  }
 }
}, function(e, t) {
 e.exports = function(e) {
  var t = "[A-Za-z$_][0-9A-Za-z$_]*",
   n = {
    keyword: "in of if for while finally var new function do return void else break catch instanceof with throw case default try this switch continue typeof delete let yield const export super debugger as async await static import from as",
    literal: "true false null undefined NaN Infinity",
    built_in: "eval isFinite isNaN parseFloat parseInt decodeURI decodeURIComponent encodeURI encodeURIComponent escape unescape Object Function Boolean Error EvalError InternalError RangeError ReferenceError StopIteration SyntaxError TypeError URIError Number Math Date String RegExp Array Float32Array Float64Array Int16Array Int32Array Int8Array Uint16Array Uint32Array Uint8Array Uint8ClampedArray ArrayBuffer DataView JSON Intl arguments require module console window document Symbol Set Map WeakSet WeakMap Proxy Reflect Promise"
   },
   r = {
    className: "number",
    variants: [{
     begin: "\\b(0[bB][01]+)"
    }, {
     begin: "\\b(0[oO][0-7]+)"
    }, {
     begin: e.C_NUMBER_RE
    }],
    relevance: 0
   },
   i = {
    className: "subst",
    begin: "\\$\\{",
    end: "\\}",
    keywords: n,
    contains: []
   },
   a = {
    className: "string",
    begin: "`",
    end: "`",
    contains: [e.BACKSLASH_ESCAPE, i]
   };
  i.contains = [e.APOS_STRING_MODE, e.QUOTE_STRING_MODE, a, r, e.REGEXP_MODE];
  var o = i.contains.concat([e.C_BLOCK_COMMENT_MODE, e.C_LINE_COMMENT_MODE]);
  return {
   aliases: ["js", "jsx"],
   keywords: n,
   contains: [{
    className: "meta",
    relevance: 10,
    begin: /^\s*['"]use (strict|asm)['"]/
   }, {
    className: "meta",
    begin: /^#!/,
    end: /$/
   }, e.APOS_STRING_MODE, e.QUOTE_STRING_MODE, a, e.C_LINE_COMMENT_MODE, e.C_BLOCK_COMMENT_MODE, r, {
    begin: /[{,]\s*/,
    relevance: 0,
    contains: [{
     begin: t + "\\s*:",
     returnBegin: !0,
     relevance: 0,
     contains: [{
      className: "attr",
      begin: t,
      relevance: 0
     }]
    }]
   }, {
    begin: "(" + e.RE_STARTERS_RE + "|\\b(case|return|throw)\\b)\\s*",
    keywords: "return throw case",
    contains: [e.C_LINE_COMMENT_MODE, e.C_BLOCK_COMMENT_MODE, e.REGEXP_MODE, {
     className: "function",
     begin: "(\\(.*?\\)|" + t + ")\\s*=>",
     returnBegin: !0,
     end: "\\s*=>",
     contains: [{
      className: "params",
      variants: [{
       begin: t
      }, {
       begin: /\(\s*\)/
      }, {
       begin: /\(/,
       end: /\)/,
       excludeBegin: !0,
       excludeEnd: !0,
       keywords: n,
       contains: o
      }]
     }]
    }, {
     begin: /</,
     end: /(\/\w+|\w+\/)>/,
     subLanguage: "xml",
     contains: [{
      begin: /<\w+\s*\/>/,
      skip: !0
     }, {
      begin: /<\w+/,
      end: /(\/\w+|\w+\/)>/,
      skip: !0,
      contains: [{
       begin: /<\w+\s*\/>/,
       skip: !0
      }, "self"]
     }]
    }],
    relevance: 0
   }, {
    className: "function",
    beginKeywords: "function",
    end: /\{/,
    excludeEnd: !0,
    contains: [e.inherit(e.TITLE_MODE, {
     begin: t
    }), {
     className: "params",
     begin: /\(/,
     end: /\)/,
     excludeBegin: !0,
     excludeEnd: !0,
     contains: o
    }],
    illegal: /\[|%/
   }, {
    begin: /\$[(.]/
   }, e.METHOD_GUARD, {
    className: "class",
    beginKeywords: "class",
    end: /[{;=]/,
    excludeEnd: !0,
    illegal: /[:"\[\]]/,
    contains: [{
     beginKeywords: "extends"
    }, e.UNDERSCORE_TITLE_MODE]
   }, {
    beginKeywords: "constructor",
    end: /\{/,
    excludeEnd: !0
   }],
   illegal: /#(?!!)/
  }
 }
}, function(e, t) {
 e.exports = function(e) {
  var t = {
    literal: "true false null"
   },
   n = [e.QUOTE_STRING_MODE, e.C_NUMBER_MODE],
   r = {
    end: ",",
    endsWithParent: !0,
    excludeEnd: !0,
    contains: n,
    keywords: t
   },
   i = {
    begin: "{",
    end: "}",
    contains: [{
     className: "attr",
     begin: /"/,
     end: /"/,
     contains: [e.BACKSLASH_ESCAPE],
     illegal: "\\n"
    }, e.inherit(r, {
     begin: /:/
    })],
    illegal: "\\S"
   },
   a = {
    begin: "\\[",
    end: "\\]",
    contains: [e.inherit(r)],
    illegal: "\\S"
   };
  return n.splice(n.length, 0, i, a), {
   contains: n,
   keywords: t,
   illegal: "\\S"
  }
 }
}, function(e, t) {
 e.exports = function(e) {
  return {
   aliases: ["md", "mkdown", "mkd"],
   contains: [{
    className: "section",
    variants: [{
     begin: "^#{1,6}",
     end: "$"
    }, {
     begin: "^.+?\\n[=-]{2,}$"
    }]
   }, {
    begin: "<",
    end: ">",
    subLanguage: "xml",
    relevance: 0
   }, {
    className: "bullet",
    begin: "^([*+-]|(\\d+\\.))\\s+"
   }, {
    className: "strong",
    begin: "[*_]{2}.+?[*_]{2}"
   }, {
    className: "emphasis",
    variants: [{
     begin: "\\*.+?\\*"
    }, {
     begin: "_.+?_",
     relevance: 0
    }]
   }, {
    className: "quote",
    begin: "^>\\s+",
    end: "$"
   }, {
    className: "code",
    variants: [{
     begin: "^```w*s*$",
     end: "^```s*$"
    }, {
     begin: "`.+?`"
    }, {
     begin: "^( {4}|\t)",
     end: "$",
     relevance: 0
    }]
   }, {
    begin: "^[-\\*]{3,}",
    end: "$"
   }, {
    begin: "\\[.+?\\][\\(\\[].*?[\\)\\]]",
    returnBegin: !0,
    contains: [{
     className: "string",
     begin: "\\[",
     end: "\\]",
     excludeBegin: !0,
     returnEnd: !0,
     relevance: 0
    }, {
     className: "link",
     begin: "\\]\\(",
     end: "\\)",
     excludeBegin: !0,
     excludeEnd: !0
    }, {
     className: "symbol",
     begin: "\\]\\[",
     end: "\\]",
     excludeBegin: !0,
     excludeEnd: !0
    }],
    relevance: 10
   }, {
    begin: /^\[[^\n]+\]:/,
    returnBegin: !0,
    contains: [{
     className: "symbol",
     begin: /\[/,
     end: /\]/,
     excludeBegin: !0,
     excludeEnd: !0
    }, {
     className: "link",
     begin: /:\s*/,
     end: /$/,
     excludeBegin: !0
    }]
   }]
  }
 }
}, function(e, t) {
 e.exports = function(e) {
  var t = e.COMMENT("--", "$");
  return {
   case_insensitive: !0,
   illegal: /[<>{}*#]/,
   contains: [{
    beginKeywords: "begin end start commit rollback savepoint lock alter create drop rename call delete do handler insert load replace select truncate update set show pragma grant merge describe use explain help declare prepare execute deallocate release unlock purge reset change stop analyze cache flush optimize repair kill install uninstall checksum restore check backup revoke comment",
    end: /;/,
    endsWithParent: !0,
    lexemes: /[\w\.]+/,
    keywords: {
     keyword: "abort abs absolute acc acce accep accept access accessed accessible account acos action activate add addtime admin administer advanced advise aes_decrypt aes_encrypt after agent aggregate ali alia alias allocate allow alter always analyze ancillary and any anydata anydataset anyschema anytype apply archive archived archivelog are as asc ascii asin assembly assertion associate asynchronous at atan atn2 attr attri attrib attribu attribut attribute attributes audit authenticated authentication authid authors auto autoallocate autodblink autoextend automatic availability avg backup badfile basicfile before begin beginning benchmark between bfile bfile_base big bigfile bin binary_double binary_float binlog bit_and bit_count bit_length bit_or bit_xor bitmap blob_base block blocksize body both bound buffer_cache buffer_pool build bulk by byte byteordermark bytes cache caching call calling cancel capacity cascade cascaded case cast catalog category ceil ceiling chain change changed char_base char_length character_length characters characterset charindex charset charsetform charsetid check checksum checksum_agg child choose chr chunk class cleanup clear client clob clob_base clone close cluster_id cluster_probability cluster_set clustering coalesce coercibility col collate collation collect colu colum column column_value columns columns_updated comment commit compact compatibility compiled complete composite_limit compound compress compute concat concat_ws concurrent confirm conn connec connect connect_by_iscycle connect_by_isleaf connect_by_root connect_time connection consider consistent constant constraint constraints constructor container content contents context contributors controlfile conv convert convert_tz corr corr_k corr_s corresponding corruption cos cost count count_big counted covar_pop covar_samp cpu_per_call cpu_per_session crc32 create creation critical cross cube cume_dist curdate current current_date current_time current_timestamp current_user cursor curtime customdatum cycle data database databases datafile datafiles datalength date_add date_cache date_format date_sub dateadd datediff datefromparts datename datepart datetime2fromparts day day_to_second dayname dayofmonth dayofweek dayofyear days db_role_change dbtimezone ddl deallocate declare decode decompose decrement decrypt deduplicate def defa defau defaul default defaults deferred defi defin define degrees delayed delegate delete delete_all delimited demand dense_rank depth dequeue des_decrypt des_encrypt des_key_file desc descr descri describ describe descriptor deterministic diagnostics difference dimension direct_load directory disable disable_all disallow disassociate discardfile disconnect diskgroup distinct distinctrow distribute distributed div do document domain dotnet double downgrade drop dumpfile duplicate duration each edition editionable editions element ellipsis else elsif elt empty enable enable_all enclosed encode encoding encrypt end end-exec endian enforced engine engines enqueue enterprise entityescaping eomonth error errors escaped evalname evaluate event eventdata events except exception exceptions exchange exclude excluding execu execut execute exempt exists exit exp expire explain export export_set extended extent external external_1 external_2 externally extract failed failed_login_attempts failover failure far fast feature_set feature_value fetch field fields file file_name_convert filesystem_like_logging final finish first first_value fixed flash_cache flashback floor flush following follows for forall force form forma format found found_rows freelist freelists freepools fresh from from_base64 from_days ftp full function general generated get get_format get_lock getdate getutcdate global global_name globally go goto grant grants greatest group group_concat group_id grouping grouping_id groups gtid_subtract guarantee guard handler hash hashkeys having hea head headi headin heading heap help hex hierarchy high high_priority hosts hour http id ident_current ident_incr ident_seed identified identity idle_time if ifnull ignore iif ilike ilm immediate import in include including increment index indexes indexing indextype indicator indices inet6_aton inet6_ntoa inet_aton inet_ntoa infile initial initialized initially initrans inmemory inner innodb input insert install instance instantiable instr interface interleaved intersect into invalidate invisible is is_free_lock is_ipv4 is_ipv4_compat is_not is_not_null is_used_lock isdate isnull isolation iterate java join json json_exists keep keep_duplicates key keys kill language large last last_day last_insert_id last_value lax lcase lead leading least leaves left len lenght length less level levels library like like2 like4 likec limit lines link list listagg little ln load load_file lob lobs local localtime localtimestamp locate locator lock locked log log10 log2 logfile logfiles logging logical logical_reads_per_call logoff logon logs long loop low low_priority lower lpad lrtrim ltrim main make_set makedate maketime managed management manual map mapping mask master master_pos_wait match matched materialized max maxextents maximize maxinstances maxlen maxlogfiles maxloghistory maxlogmembers maxsize maxtrans md5 measures median medium member memcompress memory merge microsecond mid migration min minextents minimum mining minus minute minvalue missing mod mode model modification modify module monitoring month months mount move movement multiset mutex name name_const names nan national native natural nav nchar nclob nested never new newline next nextval no no_write_to_binlog noarchivelog noaudit nobadfile nocheck nocompress nocopy nocycle nodelay nodiscardfile noentityescaping noguarantee nokeep nologfile nomapping nomaxvalue nominimize nominvalue nomonitoring none noneditionable nonschema noorder nopr nopro noprom nopromp noprompt norely noresetlogs noreverse normal norowdependencies noschemacheck noswitch not nothing notice notrim novalidate now nowait nth_value nullif nulls num numb numbe nvarchar nvarchar2 object ocicoll ocidate ocidatetime ociduration ociinterval ociloblocator ocinumber ociref ocirefcursor ocirowid ocistring ocitype oct octet_length of off offline offset oid oidindex old on online only opaque open operations operator optimal optimize option optionally or oracle oracle_date oradata ord ordaudio orddicom orddoc order ordimage ordinality ordvideo organization orlany orlvary out outer outfile outline output over overflow overriding package pad parallel parallel_enable parameters parent parse partial partition partitions pascal passing password password_grace_time password_lock_time password_reuse_max password_reuse_time password_verify_function patch path patindex pctincrease pctthreshold pctused pctversion percent percent_rank percentile_cont percentile_disc performance period period_add period_diff permanent physical pi pipe pipelined pivot pluggable plugin policy position post_transaction pow power pragma prebuilt precedes preceding precision prediction prediction_cost prediction_details prediction_probability prediction_set prepare present preserve prior priority private private_sga privileges procedural procedure procedure_analyze processlist profiles project prompt protection public publishingservername purge quarter query quick quiesce quota quotename radians raise rand range rank raw read reads readsize rebuild record records recover recovery recursive recycle redo reduced ref reference referenced references referencing refresh regexp_like register regr_avgx regr_avgy regr_count regr_intercept regr_r2 regr_slope regr_sxx regr_sxy reject rekey relational relative relaylog release release_lock relies_on relocate rely rem remainder rename repair repeat replace replicate replication required reset resetlogs resize resource respect restore restricted result result_cache resumable resume retention return returning returns reuse reverse revoke right rlike role roles rollback rolling rollup round row row_count rowdependencies rowid rownum rows rtrim rules safe salt sample save savepoint sb1 sb2 sb4 scan schema schemacheck scn scope scroll sdo_georaster sdo_topo_geometry search sec_to_time second section securefile security seed segment select self sequence sequential serializable server servererror session session_user sessions_per_user set sets settings sha sha1 sha2 share shared shared_pool short show shrink shutdown si_averagecolor si_colorhistogram si_featurelist si_positionalcolor si_stillimage si_texture siblings sid sign sin size size_t sizes skip slave sleep smalldatetimefromparts smallfile snapshot some soname sort soundex source space sparse spfile split sql sql_big_result sql_buffer_result sql_cache sql_calc_found_rows sql_small_result sql_variant_property sqlcode sqldata sqlerror sqlname sqlstate sqrt square standalone standby start starting startup statement static statistics stats_binomial_test stats_crosstab stats_ks_test stats_mode stats_mw_test stats_one_way_anova stats_t_test_ stats_t_test_indep stats_t_test_one stats_t_test_paired stats_wsr_test status std stddev stddev_pop stddev_samp stdev stop storage store stored str str_to_date straight_join strcmp strict string struct stuff style subdate subpartition subpartitions substitutable substr substring subtime subtring_index subtype success sum suspend switch switchoffset switchover sync synchronous synonym sys sys_xmlagg sysasm sysaux sysdate sysdatetimeoffset sysdba sysoper system system_user sysutcdatetime table tables tablespace tan tdo template temporary terminated tertiary_weights test than then thread through tier ties time time_format time_zone timediff timefromparts timeout timestamp timestampadd timestampdiff timezone_abbr timezone_minute timezone_region to to_base64 to_date to_days to_seconds todatetimeoffset trace tracking transaction transactional translate translation treat trigger trigger_nestlevel triggers trim truncate try_cast try_convert try_parse type ub1 ub2 ub4 ucase unarchived unbounded uncompress under undo unhex unicode uniform uninstall union unique unix_timestamp unknown unlimited unlock unpivot unrecoverable unsafe unsigned until untrusted unusable unused update updated upgrade upped upper upsert url urowid usable usage use use_stored_outlines user user_data user_resources users using utc_date utc_timestamp uuid uuid_short validate validate_password_strength validation valist value values var var_samp varcharc vari varia variab variabl variable variables variance varp varraw varrawc varray verify version versions view virtual visible void wait wallet warning warnings week weekday weekofyear wellformed when whene whenev wheneve whenever where while whitespace with within without work wrapped xdb xml xmlagg xmlattributes xmlcast xmlcolattval xmlelement xmlexists xmlforest xmlindex xmlnamespaces xmlpi xmlquery xmlroot xmlschema xmlserialize xmltable xmltype xor year year_to_month years yearweek",
     literal: "true false null",
     built_in: "array bigint binary bit blob boolean char character date dec decimal float int int8 integer interval number numeric real record serial serial8 smallint text varchar varying void"
    },
    contains: [{
     className: "string",
     begin: "'",
     end: "'",
     contains: [e.BACKSLASH_ESCAPE, {
      begin: "''"
     }]
    }, {
     className: "string",
     begin: '"',
     end: '"',
     contains: [e.BACKSLASH_ESCAPE, {
      begin: '""'
     }]
    }, {
     className: "string",
     begin: "`",
     end: "`",
     contains: [e.BACKSLASH_ESCAPE]
    }, e.C_NUMBER_MODE, e.C_BLOCK_COMMENT_MODE, t]
   }, e.C_BLOCK_COMMENT_MODE, t]
  }
 }
}, function(e, t) {
 e.exports = function(e) {
  var t = {
   endsWithParent: !0,
   illegal: /</,
   relevance: 0,
   contains: [{
    className: "attr",
    begin: "[A-Za-z0-9\\._:-]+",
    relevance: 0
   }, {
    begin: /=\s*/,
    relevance: 0,
    contains: [{
     className: "string",
     endsParent: !0,
     variants: [{
      begin: /"/,
      end: /"/
     }, {
      begin: /'/,
      end: /'/
     }, {
      begin: /[^\s"'=<>`]+/
     }]
    }]
   }]
  };
  return {
   aliases: ["html", "xhtml", "rss", "atom", "xjb", "xsd", "xsl", "plist"],
   case_insensitive: !0,
   contains: [{
    className: "meta",
    begin: "<!DOCTYPE",
    end: ">",
    relevance: 10,
    contains: [{
     begin: "\\[",
     end: "\\]"
    }]
   }, e.COMMENT("\x3c!--", "--\x3e", {
    relevance: 10
   }), {
    begin: "<\\!\\[CDATA\\[",
    end: "\\]\\]>",
    relevance: 10
   }, {
    begin: /<\?(php)?/,
    end: /\?>/,
    subLanguage: "php",
    contains: [{
     begin: "/\\*",
     end: "\\*/",
     skip: !0
    }]
   }, {
    className: "tag",
    begin: "<style(?=\\s|>|$)",
    end: ">",
    keywords: {
     name: "style"
    },
    contains: [t],
    starts: {
     end: "</style>",
     returnEnd: !0,
     subLanguage: ["css", "xml"]
    }
   }, {
    className: "tag",
    begin: "<script(?=\\s|>|$)",
    end: ">",
    keywords: {
     name: "script"
    },
    contains: [t],
    starts: {
     end: "<\/script>",
     returnEnd: !0,
     subLanguage: ["actionscript", "javascript", "handlebars", "xml"]
    }
   }, {
    className: "meta",
    variants: [{
     begin: /<\?xml/,
     end: /\?>/,
     relevance: 10
    }, {
     begin: /<\?\w+/,
     end: /\?>/
    }]
   }, {
    className: "tag",
    begin: "</?",
    end: "/?>",
    contains: [{
     className: "name",
     begin: /[^\/><\s]+/,
     relevance: 0
    }, t]
   }]
  }
 }
}, function(e, t, n) {
 "use strict";
 n.d(t, "a", function() {
  return o
 });
 var i = "hll";

 function r(e) {
  for (var t = e.target.getAttribute("data-group-id"), n = document.querySelectorAll("[data-group-id='" + t + "']"), r = 0; r < n.length; ++r) n[r].classList.add(i)
 }

 function a(e) {
  for (var t = e.target.getAttribute("data-group-id"), n = document.querySelectorAll("[data-group-id='" + t + "']"), r = 0; r < n.length; ++r) n[r].classList.remove(i)
 }

 function o() {
  for (var e = document.querySelectorAll("[data-group-id]"), t = 0; t < e.length; t++) {
   var n = e[t];
   n.addEventListener("mouseenter", r), n.addEventListener("mouseleave", a)
  }
 }
}, function(e, t, n) {
 "use strict";
 n.r(t), t.default = function(e, t) {
  return Array.isArray(e) ? t.fn(this) : t.inverse(this)
 }
}, function(i, a, o) {
 var s, l;
 /**
  * lunr - http://lunrjs.com - A bit like Solr, but much smaller and not as bright - 2.3.5
  * Copyright (C) 2018 Oliver Nightingale
  * @license MIT
  */
 ! function() {
  var t, u, c, e, n, d, f, p, h, g, m, v, y, b, x, w, _, E, k, C, T, S, N, O, A, r, H = function(e) {
   var t = new H.Builder;
   return t.pipeline.add(H.trimmer, H.stopWordFilter, H.stemmer), t.searchPipeline.add(H.stemmer), e.call(t, t), t.build()
  };
  H.version = "2.3.5"
   /*!
    * lunr.utils
    * Copyright (C) 2018 Oliver Nightingale
    */
   , H.utils = {}, H.utils.warn = (t = this, function(e) {
    t.console && console.warn && console.warn(e)
   }), H.utils.asString = function(e) {
    return null == e ? "" : e.toString()
   }, H.utils.clone = function(e) {
    if (null == e) return e;
    for (var t = Object.create(null), n = Object.keys(e), r = 0; r < n.length; r++) {
     var i = n[r],
      a = e[i];
     if (Array.isArray(a)) t[i] = a.slice();
     else {
      if ("string" != typeof a && "number" != typeof a && "boolean" != typeof a) throw new TypeError("clone is not deep and does not support nested objects");
      t[i] = a
     }
    }
    return t
   }, H.FieldRef = function(e, t, n) {
    this.docRef = e, this.fieldName = t, this._stringValue = n
   }, H.FieldRef.joiner = "/", H.FieldRef.fromString = function(e) {
    var t = e.indexOf(H.FieldRef.joiner);
    if (-1 === t) throw "malformed field ref string";
    var n = e.slice(0, t),
     r = e.slice(t + 1);
    return new H.FieldRef(r, n, e)
   }, H.FieldRef.prototype.toString = function() {
    return null == this._stringValue && (this._stringValue = this.fieldName + H.FieldRef.joiner + this.docRef), this._stringValue
   }
   /*!
    * lunr.Set
    * Copyright (C) 2018 Oliver Nightingale
    */
   , H.Set = function(e) {
    if (this.elements = Object.create(null), e) {
     this.length = e.length;
     for (var t = 0; t < this.length; t++) this.elements[e[t]] = !0
    } else this.length = 0
   }, H.Set.complete = {
    intersect: function(e) {
     return e
    },
    union: function(e) {
     return e
    },
    contains: function() {
     return !0
    }
   }, H.Set.empty = {
    intersect: function() {
     return this
    },
    union: function(e) {
     return e
    },
    contains: function() {
     return !1
    }
   }, H.Set.prototype.contains = function(e) {
    return !!this.elements[e]
   }, H.Set.prototype.intersect = function(e) {
    var t, n, r, i = [];
    if (e === H.Set.complete) return this;
    if (e === H.Set.empty) return e;
    n = this.length < e.length ? (t = this, e) : (t = e, this), r = Object.keys(t.elements);
    for (var a = 0; a < r.length; a++) {
     var o = r[a];
     o in n.elements && i.push(o)
    }
    return new H.Set(i)
   }, H.Set.prototype.union = function(e) {
    return e === H.Set.complete ? H.Set.complete : e === H.Set.empty ? this : new H.Set(Object.keys(this.elements).concat(Object.keys(e.elements)))
   }, H.idf = function(e, t) {
    var n = 0;
    for (var r in e) "_index" != r && (n += Object.keys(e[r]).length);
    var i = (t - n + .5) / (n + .5);
    return Math.log(1 + Math.abs(i))
   }, H.Token = function(e, t) {
    this.str = e || "", this.metadata = t || {}
   }, H.Token.prototype.toString = function() {
    return this.str
   }, H.Token.prototype.update = function(e) {
    return this.str = e(this.str, this.metadata), this
   }, H.Token.prototype.clone = function(e) {
    return e = e || function(e) {
     return e
    }, new H.Token(e(this.str, this.metadata), this.metadata)
   }
   /*!
    * lunr.tokenizer
    * Copyright (C) 2018 Oliver Nightingale
    */
   , H.tokenizer = function(e, t) {
    if (null == e || null == e) return [];
    if (Array.isArray(e)) return e.map(function(e) {
     return new H.Token(H.utils.asString(e).toLowerCase(), H.utils.clone(t))
    });
    for (var n = e.toString().trim().toLowerCase(), r = n.length, i = [], a = 0, o = 0; a <= r; a++) {
     var s = a - o;
     if (n.charAt(a).match(H.tokenizer.separator) || a == r) {
      if (0 < s) {
       var l = H.utils.clone(t) || {};
       l.position = [o, s], l.index = i.length, i.push(new H.Token(n.slice(o, a), l))
      }
      o = a + 1
     }
    }
    return i
   }, H.tokenizer.separator = /[\s\-]+/
   /*!
    * lunr.Pipeline
    * Copyright (C) 2018 Oliver Nightingale
    */
   , H.Pipeline = function() {
    this._stack = []
   }, H.Pipeline.registeredFunctions = Object.create(null), H.Pipeline.registerFunction = function(e, t) {
    t in this.registeredFunctions && H.utils.warn("Overwriting existing registered function: " + t), e.label = t, H.Pipeline.registeredFunctions[e.label] = e
   }, H.Pipeline.warnIfFunctionNotRegistered = function(e) {
    e.label && e.label in this.registeredFunctions || H.utils.warn("Function is not registered with pipeline. This may cause problems when serialising the index.\n", e)
   }, H.Pipeline.load = function(e) {
    var n = new H.Pipeline;
    return e.forEach(function(e) {
     var t = H.Pipeline.registeredFunctions[e];
     if (!t) throw new Error("Cannot load unregistered function: " + e);
     n.add(t)
    }), n
   }, H.Pipeline.prototype.add = function() {
    Array.prototype.slice.call(arguments).forEach(function(e) {
     H.Pipeline.warnIfFunctionNotRegistered(e), this._stack.push(e)
    }, this)
   }, H.Pipeline.prototype.after = function(e, t) {
    H.Pipeline.warnIfFunctionNotRegistered(t);
    var n = this._stack.indexOf(e);
    if (-1 == n) throw new Error("Cannot find existingFn");
    n += 1, this._stack.splice(n, 0, t)
   }, H.Pipeline.prototype.before = function(e, t) {
    H.Pipeline.warnIfFunctionNotRegistered(t);
    var n = this._stack.indexOf(e);
    if (-1 == n) throw new Error("Cannot find existingFn");
    this._stack.splice(n, 0, t)
   }, H.Pipeline.prototype.remove = function(e) {
    var t = this._stack.indexOf(e); - 1 != t && this._stack.splice(t, 1)
   }, H.Pipeline.prototype.run = function(e) {
    for (var t = this._stack.length, n = 0; n < t; n++) {
     for (var r = this._stack[n], i = [], a = 0; a < e.length; a++) {
      var o = r(e[a], a, e);
      if (void 0 !== o && "" !== o)
       if (Array.isArray(o))
        for (var s = 0; s < o.length; s++) i.push(o[s]);
       else i.push(o)
     }
     e = i
    }
    return e
   }, H.Pipeline.prototype.runString = function(e, t) {
    var n = new H.Token(e, t);
    return this.run([n]).map(function(e) {
     return e.toString()
    })
   }, H.Pipeline.prototype.reset = function() {
    this._stack = []
   }, H.Pipeline.prototype.toJSON = function() {
    return this._stack.map(function(e) {
     return H.Pipeline.warnIfFunctionNotRegistered(e), e.label
    })
   }
   /*!
    * lunr.Vector
    * Copyright (C) 2018 Oliver Nightingale
    */
   , H.Vector = function(e) {
    this._magnitude = 0, this.elements = e || []
   }, H.Vector.prototype.positionForIndex = function(e) {
    if (0 == this.elements.length) return 0;
    for (var t = 0, n = this.elements.length / 2, r = n - t, i = Math.floor(r / 2), a = this.elements[2 * i]; 1 < r && (a < e && (t = i), e < a && (n = i), a != e);) r = n - t, i = t + Math.floor(r / 2), a = this.elements[2 * i];
    return a == e ? 2 * i : e < a ? 2 * i : a < e ? 2 * (i + 1) : void 0
   }, H.Vector.prototype.insert = function(e, t) {
    this.upsert(e, t, function() {
     throw "duplicate index"
    })
   }, H.Vector.prototype.upsert = function(e, t, n) {
    this._magnitude = 0;
    var r = this.positionForIndex(e);
    this.elements[r] == e ? this.elements[r + 1] = n(this.elements[r + 1], t) : this.elements.splice(r, 0, e, t)
   }, H.Vector.prototype.magnitude = function() {
    if (this._magnitude) return this._magnitude;
    for (var e = 0, t = this.elements.length, n = 1; n < t; n += 2) {
     var r = this.elements[n];
     e += r * r
    }
    return this._magnitude = Math.sqrt(e)
   }, H.Vector.prototype.dot = function(e) {
    for (var t = 0, n = this.elements, r = e.elements, i = n.length, a = r.length, o = 0, s = 0, l = 0, u = 0; l < i && u < a;)(o = n[l]) < (s = r[u]) ? l += 2 : s < o ? u += 2 : o == s && (t += n[l + 1] * r[u + 1], l += 2, u += 2);
    return t
   }, H.Vector.prototype.similarity = function(e) {
    return this.dot(e) / this.magnitude() || 0
   }, H.Vector.prototype.toArray = function() {
    for (var e = new Array(this.elements.length / 2), t = 1, n = 0; t < this.elements.length; t += 2, n++) e[n] = this.elements[t];
    return e
   }, H.Vector.prototype.toJSON = function() {
    return this.elements
   }
   /*!
    * lunr.stemmer
    * Copyright (C) 2018 Oliver Nightingale
    * Includes code from - http://tartarus.org/~martin/PorterStemmer/js.txt
    */
   , H.stemmer = (u = {
    ational: "ate",
    tional: "tion",
    enci: "ence",
    anci: "ance",
    izer: "ize",
    bli: "ble",
    alli: "al",
    entli: "ent",
    eli: "e",
    ousli: "ous",
    ization: "ize",
    ation: "ate",
    ator: "ate",
    alism: "al",
    iveness: "ive",
    fulness: "ful",
    ousness: "ous",
    aliti: "al",
    iviti: "ive",
    biliti: "ble",
    logi: "log"
   }, c = {
    icate: "ic",
    ative: "",
    alize: "al",
    iciti: "ic",
    ical: "ic",
    ful: "",
    ness: ""
   }, e = "[aeiouy]", n = "[^aeiou][^aeiouy]*", d = new RegExp("^([^aeiou][^aeiouy]*)?[aeiouy][aeiou]*[^aeiou][^aeiouy]*"), f = new RegExp("^([^aeiou][^aeiouy]*)?[aeiouy][aeiou]*[^aeiou][^aeiouy]*[aeiouy][aeiou]*[^aeiou][^aeiouy]*"), p = new RegExp("^([^aeiou][^aeiouy]*)?[aeiouy][aeiou]*[^aeiou][^aeiouy]*([aeiouy][aeiou]*)?$"), h = new RegExp("^([^aeiou][^aeiouy]*)?[aeiouy]"), g = /^(.+?)(ss|i)es$/, m = /^(.+?)([^s])s$/, v = /^(.+?)eed$/, y = /^(.+?)(ed|ing)$/, b = /.$/, x = /(at|bl|iz)$/, w = new RegExp("([^aeiouylsz])\\1$"), _ = new RegExp("^" + n + e + "[^aeiouwxy]$"), E = /^(.+?[^aeiou])y$/, k = /^(.+?)(ational|tional|enci|anci|izer|bli|alli|entli|eli|ousli|ization|ation|ator|alism|iveness|fulness|ousness|aliti|iviti|biliti|logi)$/, C = /^(.+?)(icate|ative|alize|iciti|ical|ful|ness)$/, T = /^(.+?)(al|ance|ence|er|ic|able|ible|ant|ement|ment|ent|ou|ism|ate|iti|ous|ive|ize)$/, S = /^(.+?)(s|t)(ion)$/, N = /^(.+?)e$/, O = /ll$/, A = new RegExp("^" + n + e + "[^aeiouwxy]$"), r = function(e) {
    var t, n, r, i, a, o, s;
    if (e.length < 3) return e;
    if ("y" == (r = e.substr(0, 1)) && (e = r.toUpperCase() + e.substr(1)), a = m, (i = g).test(e) ? e = e.replace(i, "$1$2") : a.test(e) && (e = e.replace(a, "$1$2")), a = y, (i = v).test(e)) {
     var l = i.exec(e);
     (i = d).test(l[1]) && (i = b, e = e.replace(i, ""))
    } else if (a.test(e)) {
     t = (l = a.exec(e))[1], (a = h).test(t) && (o = w, s = _, (a = x).test(e = t) ? e += "e" : o.test(e) ? (i = b, e = e.replace(i, "")) : s.test(e) && (e += "e"))
    }(i = E).test(e) && (e = (t = (l = i.exec(e))[1]) + "i");
    (i = k).test(e) && (t = (l = i.exec(e))[1], n = l[2], (i = d).test(t) && (e = t + u[n]));
    (i = C).test(e) && (t = (l = i.exec(e))[1], n = l[2], (i = d).test(t) && (e = t + c[n]));
    if (a = S, (i = T).test(e)) t = (l = i.exec(e))[1], (i = f).test(t) && (e = t);
    else if (a.test(e)) {
     t = (l = a.exec(e))[1] + l[2], (a = f).test(t) && (e = t)
    }(i = N).test(e) && (t = (l = i.exec(e))[1], a = p, o = A, ((i = f).test(t) || a.test(t) && !o.test(t)) && (e = t));
    return a = f, (i = O).test(e) && a.test(e) && (i = b, e = e.replace(i, "")), "y" == r && (e = r.toLowerCase() + e.substr(1)), e
   }, function(e) {
    return e.update(r)
   }), H.Pipeline.registerFunction(H.stemmer, "stemmer")
   /*!
    * lunr.stopWordFilter
    * Copyright (C) 2018 Oliver Nightingale
    */
   , H.generateStopWordFilter = function(e) {
    var t = e.reduce(function(e, t) {
     return e[t] = t, e
    }, {});
    return function(e) {
     if (e && t[e.toString()] !== e.toString()) return e
    }
   }, H.stopWordFilter = H.generateStopWordFilter(["a", "able", "about", "across", "after", "all", "almost", "also", "am", "among", "an", "and", "any", "are", "as", "at", "be", "because", "been", "but", "by", "can", "cannot", "could", "dear", "did", "do", "does", "either", "else", "ever", "every", "for", "from", "get", "got", "had", "has", "have", "he", "her", "hers", "him", "his", "how", "however", "i", "if", "in", "into", "is", "it", "its", "just", "least", "let", "like", "likely", "may", "me", "might", "most", "must", "my", "neither", "no", "nor", "not", "of", "off", "often", "on", "only", "or", "other", "our", "own", "rather", "said", "say", "says", "she", "should", "since", "so", "some", "than", "that", "the", "their", "them", "then", "there", "these", "they", "this", "tis", "to", "too", "twas", "us", "wants", "was", "we", "were", "what", "when", "where", "which", "while", "who", "whom", "why", "will", "with", "would", "yet", "you", "your"]), H.Pipeline.registerFunction(H.stopWordFilter, "stopWordFilter")
   /*!
    * lunr.trimmer
    * Copyright (C) 2018 Oliver Nightingale
    */
   , H.trimmer = function(e) {
    return e.update(function(e) {
     return e.replace(/^\W+/, "").replace(/\W+$/, "")
    })
   }, H.Pipeline.registerFunction(H.trimmer, "trimmer")
   /*!
    * lunr.TokenSet
    * Copyright (C) 2018 Oliver Nightingale
    */
   , H.TokenSet = function() {
    this.final = !1, this.edges = {}, this.id = H.TokenSet._nextId, H.TokenSet._nextId += 1
   }, H.TokenSet._nextId = 1, H.TokenSet.fromArray = function(e) {
    for (var t = new H.TokenSet.Builder, n = 0, r = e.length; n < r; n++) t.insert(e[n]);
    return t.finish(), t.root
   }, H.TokenSet.fromClause = function(e) {
    return "editDistance" in e ? H.TokenSet.fromFuzzyString(e.term, e.editDistance) : H.TokenSet.fromString(e.term)
   }, H.TokenSet.fromFuzzyString = function(e, t) {
    for (var n = new H.TokenSet, r = [{
      node: n,
      editsRemaining: t,
      str: e
     }]; r.length;) {
     var i, a, o, s = r.pop();
     if (0 < s.str.length)(a = s.str.charAt(0)) in s.node.edges ? i = s.node.edges[a] : (i = new H.TokenSet, s.node.edges[a] = i), 1 == s.str.length && (i.final = !0), r.push({
      node: i,
      editsRemaining: s.editsRemaining,
      str: s.str.slice(1)
     });
     if (0 < s.editsRemaining && 1 < s.str.length)(a = s.str.charAt(1)) in s.node.edges ? o = s.node.edges[a] : (o = new H.TokenSet, s.node.edges[a] = o), s.str.length <= 2 ? o.final = !0 : r.push({
      node: o,
      editsRemaining: s.editsRemaining - 1,
      str: s.str.slice(2)
     });
     if (0 < s.editsRemaining && 1 == s.str.length && (s.node.final = !0), 0 < s.editsRemaining && 1 <= s.str.length) {
      if ("*" in s.node.edges) var l = s.node.edges["*"];
      else {
       l = new H.TokenSet;
       s.node.edges["*"] = l
      }
      1 == s.str.length ? l.final = !0 : r.push({
       node: l,
       editsRemaining: s.editsRemaining - 1,
       str: s.str.slice(1)
      })
     }
     if (0 < s.editsRemaining) {
      if ("*" in s.node.edges) var u = s.node.edges["*"];
      else {
       u = new H.TokenSet;
       s.node.edges["*"] = u
      }
      0 == s.str.length ? u.final = !0 : r.push({
       node: u,
       editsRemaining: s.editsRemaining - 1,
       str: s.str
      })
     }
     if (0 < s.editsRemaining && 1 < s.str.length) {
      var c, d = s.str.charAt(0),
       f = s.str.charAt(1);
      f in s.node.edges ? c = s.node.edges[f] : (c = new H.TokenSet, s.node.edges[f] = c), 1 == s.str.length ? c.final = !0 : r.push({
       node: c,
       editsRemaining: s.editsRemaining - 1,
       str: d + s.str.slice(2)
      })
     }
    }
    return n
   }, H.TokenSet.fromString = function(e) {
    for (var t = new H.TokenSet, n = t, r = 0, i = e.length; r < i; r++) {
     var a = e[r],
      o = r == i - 1;
     if ("*" == a)(t.edges[a] = t).final = o;
     else {
      var s = new H.TokenSet;
      s.final = o, t.edges[a] = s, t = s
     }
    }
    return n
   }, H.TokenSet.prototype.toArray = function() {
    for (var e = [], t = [{
      prefix: "",
      node: this
     }]; t.length;) {
     var n = t.pop(),
      r = Object.keys(n.node.edges),
      i = r.length;
     n.node.final && (n.prefix.charAt(0), e.push(n.prefix));
     for (var a = 0; a < i; a++) {
      var o = r[a];
      t.push({
       prefix: n.prefix.concat(o),
       node: n.node.edges[o]
      })
     }
    }
    return e
   }, H.TokenSet.prototype.toString = function() {
    if (this._str) return this._str;
    for (var e = this.final ? "1" : "0", t = Object.keys(this.edges).sort(), n = t.length, r = 0; r < n; r++) {
     var i = t[r];
     e = e + i + this.edges[i].id
    }
    return e
   }, H.TokenSet.prototype.intersect = function(e) {
    for (var t = new H.TokenSet, n = void 0, r = [{
      qNode: e,
      output: t,
      node: this
     }]; r.length;) {
     n = r.pop();
     for (var i = Object.keys(n.qNode.edges), a = i.length, o = Object.keys(n.node.edges), s = o.length, l = 0; l < a; l++)
      for (var u = i[l], c = 0; c < s; c++) {
       var d = o[c];
       if (d == u || "*" == u) {
        var f = n.node.edges[d],
         p = n.qNode.edges[u],
         h = f.final && p.final,
         g = void 0;
        d in n.output.edges ? (g = n.output.edges[d]).final = g.final || h : ((g = new H.TokenSet).final = h, n.output.edges[d] = g), r.push({
         qNode: p,
         output: g,
         node: f
        })
       }
      }
    }
    return t
   }, H.TokenSet.Builder = function() {
    this.previousWord = "", this.root = new H.TokenSet, this.uncheckedNodes = [], this.minimizedNodes = {}
   }, H.TokenSet.Builder.prototype.insert = function(e) {
    var t, n = 0;
    if (e < this.previousWord) throw new Error("Out of order word insertion");
    for (var r = 0; r < e.length && r < this.previousWord.length && e[r] == this.previousWord[r]; r++) n++;
    this.minimize(n), t = 0 == this.uncheckedNodes.length ? this.root : this.uncheckedNodes[this.uncheckedNodes.length - 1].child;
    for (r = n; r < e.length; r++) {
     var i = new H.TokenSet,
      a = e[r];
     t.edges[a] = i, this.uncheckedNodes.push({
      parent: t,
      char: a,
      child: i
     }), t = i
    }
    t.final = !0, this.previousWord = e
   }, H.TokenSet.Builder.prototype.finish = function() {
    this.minimize(0)
   }, H.TokenSet.Builder.prototype.minimize = function(e) {
    for (var t = this.uncheckedNodes.length - 1; e <= t; t--) {
     var n = this.uncheckedNodes[t],
      r = n.child.toString();
     r in this.minimizedNodes ? n.parent.edges[n.char] = this.minimizedNodes[r] : (n.child._str = r, this.minimizedNodes[r] = n.child), this.uncheckedNodes.pop()
    }
   }
   /*!
    * lunr.Index
    * Copyright (C) 2018 Oliver Nightingale
    */
   , H.Index = function(e) {
    this.invertedIndex = e.invertedIndex, this.fieldVectors = e.fieldVectors, this.tokenSet = e.tokenSet, this.fields = e.fields, this.pipeline = e.pipeline
   }, H.Index.prototype.search = function(t) {
    return this.query(function(e) {
     new H.QueryParser(t, e).parse()
    })
   }, H.Index.prototype.query = function(e) {
    for (var t = new H.Query(this.fields), n = Object.create(null), r = Object.create(null), i = Object.create(null), a = Object.create(null), o = Object.create(null), s = 0; s < this.fields.length; s++) r[this.fields[s]] = new H.Vector;
    e.call(t, t);
    for (s = 0; s < t.clauses.length; s++) {
     var l = t.clauses[s],
      u = null,
      c = H.Set.complete;
     u = l.usePipeline ? this.pipeline.runString(l.term, {
      fields: l.fields
     }) : [l.term];
     for (var d = 0; d < u.length; d++) {
      var f = u[d];
      l.term = f;
      var p = H.TokenSet.fromClause(l),
       h = this.tokenSet.intersect(p).toArray();
      if (0 === h.length && l.presence === H.Query.presence.REQUIRED) {
       for (var g = 0; g < l.fields.length; g++) {
        a[j = l.fields[g]] = H.Set.empty
       }
       break
      }
      for (var m = 0; m < h.length; m++) {
       var v = h[m],
        y = this.invertedIndex[v],
        b = y._index;
       for (g = 0; g < l.fields.length; g++) {
        var x = y[j = l.fields[g]],
         w = Object.keys(x),
         _ = v + "/" + j,
         E = new H.Set(w);
        if (l.presence == H.Query.presence.REQUIRED && (c = c.union(E), void 0 === a[j] && (a[j] = H.Set.complete)), l.presence != H.Query.presence.PROHIBITED) {
         if (r[j].upsert(b, l.boost, function(e, t) {
           return e + t
          }), !i[_]) {
          for (var k = 0; k < w.length; k++) {
           var C, T = w[k],
            S = new H.FieldRef(T, j),
            N = x[T];
           void 0 === (C = n[S]) ? n[S] = new H.MatchData(v, j, N) : C.add(v, j, N)
          }
          i[_] = !0
         }
        } else void 0 === o[j] && (o[j] = H.Set.empty), o[j] = o[j].union(E)
       }
      }
     }
     if (l.presence === H.Query.presence.REQUIRED)
      for (g = 0; g < l.fields.length; g++) {
       a[j = l.fields[g]] = a[j].intersect(c)
      }
    }
    var O = H.Set.complete,
     A = H.Set.empty;
    for (s = 0; s < this.fields.length; s++) {
     var j;
     a[j = this.fields[s]] && (O = O.intersect(a[j])), o[j] && (A = A.union(o[j]))
    }
    var D = Object.keys(n),
     L = [],
     R = Object.create(null);
    if (t.isNegated()) {
     D = Object.keys(this.fieldVectors);
     for (s = 0; s < D.length; s++) {
      S = D[s];
      var P = H.FieldRef.fromString(S);
      n[S] = new H.MatchData
     }
    }
    for (s = 0; s < D.length; s++) {
     var M = (P = H.FieldRef.fromString(D[s])).docRef;
     if (O.contains(M) && !A.contains(M)) {
      var I, q = this.fieldVectors[P],
       B = r[P.fieldName].similarity(q);
      if (void 0 !== (I = R[M])) I.score += B, I.matchData.combine(n[P]);
      else {
       var Q = {
        ref: M,
        score: B,
        matchData: n[P]
       };
       R[M] = Q, L.push(Q)
      }
     }
    }
    return L.sort(function(e, t) {
     return t.score - e.score
    })
   }, H.Index.prototype.toJSON = function() {
    var e = Object.keys(this.invertedIndex).sort().map(function(e) {
      return [e, this.invertedIndex[e]]
     }, this),
     t = Object.keys(this.fieldVectors).map(function(e) {
      return [e, this.fieldVectors[e].toJSON()]
     }, this);
    return {
     version: H.version,
     fields: this.fields,
     fieldVectors: t,
     invertedIndex: e,
     pipeline: this.pipeline.toJSON()
    }
   }, H.Index.load = function(e) {
    var t = {},
     n = {},
     r = e.fieldVectors,
     i = Object.create(null),
     a = e.invertedIndex,
     o = new H.TokenSet.Builder,
     s = H.Pipeline.load(e.pipeline);
    e.version != H.version && H.utils.warn("Version mismatch when loading serialised index. Current version of lunr '" + H.version + "' does not match serialized index '" + e.version + "'");
    for (var l = 0; l < r.length; l++) {
     var u = (d = r[l])[0],
      c = d[1];
     n[u] = new H.Vector(c)
    }
    for (l = 0; l < a.length; l++) {
     var d, f = (d = a[l])[0],
      p = d[1];
     o.insert(f), i[f] = p
    }
    return o.finish(), t.fields = e.fields, t.fieldVectors = n, t.invertedIndex = i, t.tokenSet = o.root, t.pipeline = s, new H.Index(t)
   }
   /*!
    * lunr.Builder
    * Copyright (C) 2018 Oliver Nightingale
    */
   , H.Builder = function() {
    this._ref = "id", this._fields = Object.create(null), this._documents = Object.create(null), this.invertedIndex = Object.create(null), this.fieldTermFrequencies = {}, this.fieldLengths = {}, this.tokenizer = H.tokenizer, this.pipeline = new H.Pipeline, this.searchPipeline = new H.Pipeline, this.documentCount = 0, this._b = .75, this._k1 = 1.2, this.termIndex = 0, this.metadataWhitelist = []
   }, H.Builder.prototype.ref = function(e) {
    this._ref = e
   }, H.Builder.prototype.field = function(e, t) {
    if (/\//.test(e)) throw new RangeError("Field '" + e + "' contains illegal character '/'");
    this._fields[e] = t || {}
   }, H.Builder.prototype.b = function(e) {
    this._b = e < 0 ? 0 : 1 < e ? 1 : e
   }, H.Builder.prototype.k1 = function(e) {
    this._k1 = e
   }, H.Builder.prototype.add = function(e, t) {
    var n = e[this._ref],
     r = Object.keys(this._fields);
    this._documents[n] = t || {}, this.documentCount += 1;
    for (var i = 0; i < r.length; i++) {
     var a = r[i],
      o = this._fields[a].extractor,
      s = o ? o(e) : e[a],
      l = this.tokenizer(s, {
       fields: [a]
      }),
      u = this.pipeline.run(l),
      c = new H.FieldRef(n, a),
      d = Object.create(null);
     this.fieldTermFrequencies[c] = d, this.fieldLengths[c] = 0, this.fieldLengths[c] += u.length;
     for (var f = 0; f < u.length; f++) {
      var p = u[f];
      if (null == d[p] && (d[p] = 0), d[p] += 1, null == this.invertedIndex[p]) {
       var h = Object.create(null);
       h._index = this.termIndex, this.termIndex += 1;
       for (var g = 0; g < r.length; g++) h[r[g]] = Object.create(null);
       this.invertedIndex[p] = h
      }
      null == this.invertedIndex[p][a][n] && (this.invertedIndex[p][a][n] = Object.create(null));
      for (var m = 0; m < this.metadataWhitelist.length; m++) {
       var v = this.metadataWhitelist[m],
        y = p.metadata[v];
       null == this.invertedIndex[p][a][n][v] && (this.invertedIndex[p][a][n][v] = []), this.invertedIndex[p][a][n][v].push(y)
      }
     }
    }
   }, H.Builder.prototype.calculateAverageFieldLengths = function() {
    for (var e = Object.keys(this.fieldLengths), t = e.length, n = {}, r = {}, i = 0; i < t; i++) {
     var a = H.FieldRef.fromString(e[i]),
      o = a.fieldName;
     r[o] || (r[o] = 0), r[o] += 1, n[o] || (n[o] = 0), n[o] += this.fieldLengths[a]
    }
    var s = Object.keys(this._fields);
    for (i = 0; i < s.length; i++) {
     var l = s[i];
     n[l] = n[l] / r[l]
    }
    this.averageFieldLength = n
   }, H.Builder.prototype.createFieldVectors = function() {
    for (var e = {}, t = Object.keys(this.fieldTermFrequencies), n = t.length, r = Object.create(null), i = 0; i < n; i++) {
     for (var a = H.FieldRef.fromString(t[i]), o = a.fieldName, s = this.fieldLengths[a], l = new H.Vector, u = this.fieldTermFrequencies[a], c = Object.keys(u), d = c.length, f = this._fields[o].boost || 1, p = this._documents[a.docRef].boost || 1, h = 0; h < d; h++) {
      var g, m, v, y = c[h],
       b = u[y],
       x = this.invertedIndex[y]._index;
      void 0 === r[y] ? (g = H.idf(this.invertedIndex[y], this.documentCount), r[y] = g) : g = r[y], m = g * ((this._k1 + 1) * b) / (this._k1 * (1 - this._b + this._b * (s / this.averageFieldLength[o])) + b), m *= f, m *= p, v = Math.round(1e3 * m) / 1e3, l.insert(x, v)
     }
     e[a] = l
    }
    this.fieldVectors = e
   }, H.Builder.prototype.createTokenSet = function() {
    this.tokenSet = H.TokenSet.fromArray(Object.keys(this.invertedIndex).sort())
   }, H.Builder.prototype.build = function() {
    return this.calculateAverageFieldLengths(), this.createFieldVectors(), this.createTokenSet(), new H.Index({
     invertedIndex: this.invertedIndex,
     fieldVectors: this.fieldVectors,
     tokenSet: this.tokenSet,
     fields: Object.keys(this._fields),
     pipeline: this.searchPipeline
    })
   }, H.Builder.prototype.use = function(e) {
    var t = Array.prototype.slice.call(arguments, 1);
    t.unshift(this), e.apply(this, t)
   }, H.MatchData = function(e, t, n) {
    for (var r = Object.create(null), i = Object.keys(n || {}), a = 0; a < i.length; a++) {
     var o = i[a];
     r[o] = n[o].slice()
    }
    this.metadata = Object.create(null), void 0 !== e && (this.metadata[e] = Object.create(null), this.metadata[e][t] = r)
   }, H.MatchData.prototype.combine = function(e) {
    for (var t = Object.keys(e.metadata), n = 0; n < t.length; n++) {
     var r = t[n],
      i = Object.keys(e.metadata[r]);
     null == this.metadata[r] && (this.metadata[r] = Object.create(null));
     for (var a = 0; a < i.length; a++) {
      var o = i[a],
       s = Object.keys(e.metadata[r][o]);
      null == this.metadata[r][o] && (this.metadata[r][o] = Object.create(null));
      for (var l = 0; l < s.length; l++) {
       var u = s[l];
       null == this.metadata[r][o][u] ? this.metadata[r][o][u] = e.metadata[r][o][u] : this.metadata[r][o][u] = this.metadata[r][o][u].concat(e.metadata[r][o][u])
      }
     }
    }
   }, H.MatchData.prototype.add = function(e, t, n) {
    if (!(e in this.metadata)) return this.metadata[e] = Object.create(null), void(this.metadata[e][t] = n);
    if (t in this.metadata[e])
     for (var r = Object.keys(n), i = 0; i < r.length; i++) {
      var a = r[i];
      a in this.metadata[e][t] ? this.metadata[e][t][a] = this.metadata[e][t][a].concat(n[a]) : this.metadata[e][t][a] = n[a]
     } else this.metadata[e][t] = n
   }, H.Query = function(e) {
    this.clauses = [], this.allFields = e
   }, H.Query.wildcard = new String("*"), H.Query.wildcard.NONE = 0, H.Query.wildcard.LEADING = 1, H.Query.wildcard.TRAILING = 2, H.Query.presence = {
    OPTIONAL: 1,
    REQUIRED: 2,
    PROHIBITED: 3
   }, H.Query.prototype.clause = function(e) {
    return "fields" in e || (e.fields = this.allFields), "boost" in e || (e.boost = 1), "usePipeline" in e || (e.usePipeline = !0), "wildcard" in e || (e.wildcard = H.Query.wildcard.NONE), e.wildcard & H.Query.wildcard.LEADING && e.term.charAt(0) != H.Query.wildcard && (e.term = "*" + e.term), e.wildcard & H.Query.wildcard.TRAILING && e.term.slice(-1) != H.Query.wildcard && (e.term = e.term + "*"), "presence" in e || (e.presence = H.Query.presence.OPTIONAL), this.clauses.push(e), this
   }, H.Query.prototype.isNegated = function() {
    for (var e = 0; e < this.clauses.length; e++)
     if (this.clauses[e].presence != H.Query.presence.PROHIBITED) return !1;
    return !0
   }, H.Query.prototype.term = function(e, t) {
    if (Array.isArray(e)) return e.forEach(function(e) {
     this.term(e, H.utils.clone(t))
    }, this), this;
    var n = t || {};
    return n.term = e.toString(), this.clause(n), this
   }, H.QueryParseError = function(e, t, n) {
    this.name = "QueryParseError", this.message = e, this.start = t, this.end = n
   }, H.QueryParseError.prototype = new Error, H.QueryLexer = function(e) {
    this.lexemes = [], this.str = e, this.length = e.length, this.pos = 0, this.start = 0, this.escapeCharPositions = []
   }, H.QueryLexer.prototype.run = function() {
    for (var e = H.QueryLexer.lexText; e;) e = e(this)
   }, H.QueryLexer.prototype.sliceString = function() {
    for (var e = [], t = this.start, n = this.pos, r = 0; r < this.escapeCharPositions.length; r++) n = this.escapeCharPositions[r], e.push(this.str.slice(t, n)), t = n + 1;
    return e.push(this.str.slice(t, this.pos)), this.escapeCharPositions.length = 0, e.join("")
   }, H.QueryLexer.prototype.emit = function(e) {
    this.lexemes.push({
     type: e,
     str: this.sliceString(),
     start: this.start,
     end: this.pos
    }), this.start = this.pos
   }, H.QueryLexer.prototype.escapeCharacter = function() {
    this.escapeCharPositions.push(this.pos - 1), this.pos += 1
   }, H.QueryLexer.prototype.next = function() {
    if (this.pos >= this.length) return H.QueryLexer.EOS;
    var e = this.str.charAt(this.pos);
    return this.pos += 1, e
   }, H.QueryLexer.prototype.width = function() {
    return this.pos - this.start
   }, H.QueryLexer.prototype.ignore = function() {
    this.start == this.pos && (this.pos += 1), this.start = this.pos
   }, H.QueryLexer.prototype.backup = function() {
    this.pos -= 1
   }, H.QueryLexer.prototype.acceptDigitRun = function() {
    for (var e, t; 47 < (t = (e = this.next()).charCodeAt(0)) && t < 58;);
    e != H.QueryLexer.EOS && this.backup()
   }, H.QueryLexer.prototype.more = function() {
    return this.pos < this.length
   }, H.QueryLexer.EOS = "EOS", H.QueryLexer.FIELD = "FIELD", H.QueryLexer.TERM = "TERM", H.QueryLexer.EDIT_DISTANCE = "EDIT_DISTANCE", H.QueryLexer.BOOST = "BOOST", H.QueryLexer.PRESENCE = "PRESENCE", H.QueryLexer.lexField = function(e) {
    return e.backup(), e.emit(H.QueryLexer.FIELD), e.ignore(), H.QueryLexer.lexText
   }, H.QueryLexer.lexTerm = function(e) {
    if (1 < e.width() && (e.backup(), e.emit(H.QueryLexer.TERM)), e.ignore(), e.more()) return H.QueryLexer.lexText
   }, H.QueryLexer.lexEditDistance = function(e) {
    return e.ignore(), e.acceptDigitRun(), e.emit(H.QueryLexer.EDIT_DISTANCE), H.QueryLexer.lexText
   }, H.QueryLexer.lexBoost = function(e) {
    return e.ignore(), e.acceptDigitRun(), e.emit(H.QueryLexer.BOOST), H.QueryLexer.lexText
   }, H.QueryLexer.lexEOS = function(e) {
    0 < e.width() && e.emit(H.QueryLexer.TERM)
   }, H.QueryLexer.termSeparator = H.tokenizer.separator, H.QueryLexer.lexText = function(e) {
    for (;;) {
     var t = e.next();
     if (t == H.QueryLexer.EOS) return H.QueryLexer.lexEOS;
     if (92 != t.charCodeAt(0)) {
      if (":" == t) return H.QueryLexer.lexField;
      if ("~" == t) return e.backup(), 0 < e.width() && e.emit(H.QueryLexer.TERM), H.QueryLexer.lexEditDistance;
      if ("^" == t) return e.backup(), 0 < e.width() && e.emit(H.QueryLexer.TERM), H.QueryLexer.lexBoost;
      if ("+" == t && 1 === e.width()) return e.emit(H.QueryLexer.PRESENCE), H.QueryLexer.lexText;
      if ("-" == t && 1 === e.width()) return e.emit(H.QueryLexer.PRESENCE), H.QueryLexer.lexText;
      if (t.match(H.QueryLexer.termSeparator)) return H.QueryLexer.lexTerm
     } else e.escapeCharacter()
    }
   }, H.QueryParser = function(e, t) {
    this.lexer = new H.QueryLexer(e), this.query = t, this.currentClause = {}, this.lexemeIdx = 0
   }, H.QueryParser.prototype.parse = function() {
    this.lexer.run(), this.lexemes = this.lexer.lexemes;
    for (var e = H.QueryParser.parseClause; e;) e = e(this);
    return this.query
   }, H.QueryParser.prototype.peekLexeme = function() {
    return this.lexemes[this.lexemeIdx]
   }, H.QueryParser.prototype.consumeLexeme = function() {
    var e = this.peekLexeme();
    return this.lexemeIdx += 1, e
   }, H.QueryParser.prototype.nextClause = function() {
    var e = this.currentClause;
    this.query.clause(e), this.currentClause = {}
   }, H.QueryParser.parseClause = function(e) {
    var t = e.peekLexeme();
    if (null != t) switch (t.type) {
     case H.QueryLexer.PRESENCE:
      return H.QueryParser.parsePresence;
     case H.QueryLexer.FIELD:
      return H.QueryParser.parseField;
     case H.QueryLexer.TERM:
      return H.QueryParser.parseTerm;
     default:
      var n = "expected either a field or a term, found " + t.type;
      throw 1 <= t.str.length && (n += " with value '" + t.str + "'"), new H.QueryParseError(n, t.start, t.end)
    }
   }, H.QueryParser.parsePresence = function(e) {
    var t = e.consumeLexeme();
    if (null != t) {
     switch (t.str) {
      case "-":
       e.currentClause.presence = H.Query.presence.PROHIBITED;
       break;
      case "+":
       e.currentClause.presence = H.Query.presence.REQUIRED;
       break;
      default:
       var n = "unrecognised presence operator'" + t.str + "'";
       throw new H.QueryParseError(n, t.start, t.end)
     }
     var r = e.peekLexeme();
     if (null == r) {
      n = "expecting term or field, found nothing";
      throw new H.QueryParseError(n, t.start, t.end)
     }
     switch (r.type) {
      case H.QueryLexer.FIELD:
       return H.QueryParser.parseField;
      case H.QueryLexer.TERM:
       return H.QueryParser.parseTerm;
      default:
       n = "expecting term or field, found '" + r.type + "'";
       throw new H.QueryParseError(n, r.start, r.end)
     }
    }
   }, H.QueryParser.parseField = function(e) {
    var t = e.consumeLexeme();
    if (null != t) {
     if (-1 == e.query.allFields.indexOf(t.str)) {
      var n = e.query.allFields.map(function(e) {
        return "'" + e + "'"
       }).join(", "),
       r = "unrecognised field '" + t.str + "', possible fields: " + n;
      throw new H.QueryParseError(r, t.start, t.end)
     }
     e.currentClause.fields = [t.str];
     var i = e.peekLexeme();
     if (null == i) {
      r = "expecting term, found nothing";
      throw new H.QueryParseError(r, t.start, t.end)
     }
     switch (i.type) {
      case H.QueryLexer.TERM:
       return H.QueryParser.parseTerm;
      default:
       r = "expecting term, found '" + i.type + "'";
       throw new H.QueryParseError(r, i.start, i.end)
     }
    }
   }, H.QueryParser.parseTerm = function(e) {
    var t = e.consumeLexeme();
    if (null != t) {
     e.currentClause.term = t.str.toLowerCase(), -1 != t.str.indexOf("*") && (e.currentClause.usePipeline = !1);
     var n = e.peekLexeme();
     if (null != n) switch (n.type) {
      case H.QueryLexer.TERM:
       return e.nextClause(), H.QueryParser.parseTerm;
      case H.QueryLexer.FIELD:
       return e.nextClause(), H.QueryParser.parseField;
      case H.QueryLexer.EDIT_DISTANCE:
       return H.QueryParser.parseEditDistance;
      case H.QueryLexer.BOOST:
       return H.QueryParser.parseBoost;
      case H.QueryLexer.PRESENCE:
       return e.nextClause(), H.QueryParser.parsePresence;
      default:
       var r = "Unexpected lexeme type '" + n.type + "'";
       throw new H.QueryParseError(r, n.start, n.end)
     } else e.nextClause()
    }
   }, H.QueryParser.parseEditDistance = function(e) {
    var t = e.consumeLexeme();
    if (null != t) {
     var n = parseInt(t.str, 10);
     if (isNaN(n)) {
      var r = "edit distance must be numeric";
      throw new H.QueryParseError(r, t.start, t.end)
     }
     e.currentClause.editDistance = n;
     var i = e.peekLexeme();
     if (null != i) switch (i.type) {
      case H.QueryLexer.TERM:
       return e.nextClause(), H.QueryParser.parseTerm;
      case H.QueryLexer.FIELD:
       return e.nextClause(), H.QueryParser.parseField;
      case H.QueryLexer.EDIT_DISTANCE:
       return H.QueryParser.parseEditDistance;
      case H.QueryLexer.BOOST:
       return H.QueryParser.parseBoost;
      case H.QueryLexer.PRESENCE:
       return e.nextClause(), H.QueryParser.parsePresence;
      default:
       r = "Unexpected lexeme type '" + i.type + "'";
       throw new H.QueryParseError(r, i.start, i.end)
     } else e.nextClause()
    }
   }, H.QueryParser.parseBoost = function(e) {
    var t = e.consumeLexeme();
    if (null != t) {
     var n = parseInt(t.str, 10);
     if (isNaN(n)) {
      var r = "boost must be numeric";
      throw new H.QueryParseError(r, t.start, t.end)
     }
     e.currentClause.boost = n;
     var i = e.peekLexeme();
     if (null != i) switch (i.type) {
      case H.QueryLexer.TERM:
       return e.nextClause(), H.QueryParser.parseTerm;
      case H.QueryLexer.FIELD:
       return e.nextClause(), H.QueryParser.parseField;
      case H.QueryLexer.EDIT_DISTANCE:
       return H.QueryParser.parseEditDistance;
      case H.QueryLexer.BOOST:
       return H.QueryParser.parseBoost;
      case H.QueryLexer.PRESENCE:
       return e.nextClause(), H.QueryParser.parsePresence;
      default:
       r = "Unexpected lexeme type '" + i.type + "'";
       throw new H.QueryParseError(r, i.start, i.end)
     } else e.nextClause()
    }
   }, void 0 === (l = "function" == typeof(s = function() {
    return H
   }) ? s.call(a, o, a, i) : s) || (i.exports = l)
 }()
}, function(X3, Y3) {
 var Z3;
 Z3 = function() {
  return this
 }();
 try {
  Z3 = Z3 || Function("return this")() || eval("this")
 } catch (e) {
  "object" == typeof window && (Z3 = window)
 }
 X3.exports = Z3
}, function(e, t, n) {
 "use strict";
 n.r(t), t.default = function(e, t) {
  var n = window.location.pathname.split("/");
  return (e += ".html") === n[n.length - 1] ? t.fn(this) : t.inverse(this)
 }
}, function(e, t, n) {
 "use strict";
 n.r(t), t.default = function(e, t) {
  return Array.isArray(e) && 0 < e.length ? t.fn(this) : t.inverse(this)
 }
}, function(e, t, n) {
 "use strict";
 n.r(t), t.default = function(e, t, n) {
  var r = t || "";
  if (e.group !== r) return delete e.nestedContext, e.group = r, n.fn(this)
 }
}, function(e, t, n) {
 "use strict";
 n.r(t), t.default = function(e, t, n) {
  if (t.nested_context && t.nested_context !== e.nestedContext) {
   if (e.nestedContext = t.nested_context, e.lastModuleSeenInGroup !== t.nested_context) return n.fn(this)
  } else e.lastModuleSeenInGroup = t.title
 }
}, function(e, t, n) {
 "use strict";
 n.r(t), t.default = function(e, t) {
  if (e.nodeGroups) return t.fn(this)
 }
}, function(e, t, n) {
 "use strict";

 function r(e) {
  return e && e.__esModule ? e : {
   default: e
  }
 }
 t.__esModule = !0, t.HandlebarsEnvironment = c;
 var i = n(3),
  a = r(n(5)),
  o = n(41),
  s = n(49),
  l = r(n(51));
 t.VERSION = "4.1.2";
 t.COMPILER_REVISION = 7;
 t.REVISION_CHANGES = {
  1: "<= 1.0.rc.2",
  2: "== 1.0.0-rc.3",
  3: "== 1.0.0-rc.4",
  4: "== 1.x.x",
  5: "== 2.0.0-alpha.x",
  6: ">= 2.0.0-beta.1",
  7: ">= 4.0.0"
 };
 var u = "[object Object]";

 function c(e, t, n) {
  this.helpers = e || {}, this.partials = t || {}, this.decorators = n || {}, o.registerDefaultHelpers(this), s.registerDefaultDecorators(this)
 }
 c.prototype = {
  constructor: c,
  logger: l.default,
  log: l.default.log,
  registerHelper: function(e, t) {
   if (i.toString.call(e) === u) {
    if (t) throw new a.default("Arg not supported with multiple helpers");
    i.extend(this.helpers, e)
   } else this.helpers[e] = t
  },
  unregisterHelper: function(e) {
   delete this.helpers[e]
  },
  registerPartial: function(e, t) {
   if (i.toString.call(e) === u) i.extend(this.partials, e);
   else {
    if (void 0 === t) throw new a.default('Attempting to register a partial called "' + e + '" as undefined');
    this.partials[e] = t
   }
  },
  unregisterPartial: function(e) {
   delete this.partials[e]
  },
  registerDecorator: function(e, t) {
   if (i.toString.call(e) === u) {
    if (t) throw new a.default("Arg not supported with multiple decorators");
    i.extend(this.decorators, e)
   } else this.decorators[e] = t
  },
  unregisterDecorator: function(e) {
   delete this.decorators[e]
  }
 };
 var d = l.default.log;
 t.log = d, t.createFrame = i.createFrame, t.logger = l.default
}, function(e, t, n) {
 var r = n(2);
 e.exports = (r.default || r).template({
  1: function(e, t, n, r, i) {
   var a, o, s = null != t ? t : e.nullContext || {},
    l = n.helperMissing,
    u = "function",
    c = e.escapeExpression;
   return '    <a href="' + c(typeof(o = null != (o = n.link || (null != t ? t.link : t)) ? o : l) === u ? o.call(s, {
    name: "link",
    hash: {},
    data: i
   }) : o) + '" class="autocomplete-suggestion" data-index="' + c(typeof(o = null != (o = n.index || i && i.index) ? o : l) === u ? o.call(s, {
    name: "index",
    hash: {},
    data: i
   }) : o) + '" tabindex="-1">\n      <div class="title">\n        ' + (null != (a = typeof(o = null != (o = n.title || (null != t ? t.title : t)) ? o : l) === u ? o.call(s, {
    name: "title",
    hash: {},
    data: i
   }) : o) ? a : "") + "\n" + (null != (a = n.if.call(s, null != t ? t.label : t, {
    name: "if",
    hash: {},
    fn: e.program(2, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : "") + "      </div>\n\n" + (null != (a = n.if.call(s, null != t ? t.description : t, {
    name: "if",
    hash: {},
    fn: e.program(4, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : "") + "    </a>\n"
  },
  2: function(e, t, n, r, i) {
   var a;
   return '          <span class="label">(' + e.escapeExpression("function" == typeof(a = null != (a = n.label || (null != t ? t.label : t)) ? a : n.helperMissing) ? a.call(null != t ? t : e.nullContext || {}, {
    name: "label",
    hash: {},
    data: i
   }) : a) + ")</span>\n"
  },
  4: function(e, t, n, r, i) {
   var a, o;
   return '        <div class="description">\n          ' + (null != (a = "function" == typeof(o = null != (o = n.description || (null != t ? t.description : t)) ? o : n.helperMissing) ? o.call(null != t ? t : e.nullContext || {}, {
    name: "description",
    hash: {},
    data: i
   }) : o) ? a : "") + "\n        </div>\n"
  },
  compiler: [7, ">= 4.0.0"],
  main: function(e, t, n, r, i) {
   var a, o, s = null != t ? t : e.nullContext || {},
    l = n.helperMissing,
    u = "function",
    c = e.escapeExpression;
   return '<div class="autocomplete-suggestions">\n  <a class="autocomplete-suggestion" href="search.html?q=' + c(typeof(o = null != (o = n.term || (null != t ? t.term : t)) ? o : l) === u ? o.call(s, {
    name: "term",
    hash: {},
    data: i
   }) : o) + '" data-index="-1" tabindex="-1">\n    <div class="title">"<em>' + c(typeof(o = null != (o = n.term || (null != t ? t.term : t)) ? o : l) === u ? o.call(s, {
    name: "term",
    hash: {},
    data: i
   }) : o) + '</em>"</div>\n    <div class="description">Search the documentation</div>\n  </a>\n' + (null != (a = n.each.call(s, null != t ? t.results : t, {
    name: "each",
    hash: {},
    fn: e.program(1, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : "") + "</div>\n"
  },
  useData: !0
 })
}, function(e, t, o) {
 var n = o(2);

 function s(e) {
  return e && (e.__esModule ? e.default : e)
 }
 e.exports = (n.default || n).template({
  1: function(e, t, n, r, i) {
   var a;
   return null != (a = n.each.call(null != t ? t : e.nullContext || {}, null != t ? t.results : t, {
    name: "each",
    hash: {},
    fn: e.program(2, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : ""
  },
  2: function(e, t, n, r, i) {
   var a, o = e.lambda,
    s = e.escapeExpression;
   return '    <div class="result">\n      <h2 class="result-id">\n        <a href="' + s(o(null != t ? t.ref : t, t)) + '">' + s(o(null != t ? t.title : t, t)) + " <small>(" + s(o(null != t ? t.type : t, t)) + ")</small></a>\n      </h2>\n" + (null != (a = n.each.call(null != t ? t : e.nullContext || {}, null != t ? t.excerpts : t, {
    name: "each",
    hash: {},
    fn: e.program(3, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : "") + "    </div>\n"
  },
  3: function(e, t, n, r, i) {
   var a;
   return '          <p class="result-elem">' + (null != (a = e.lambda(t, t)) ? a : "") + "</p>\n"
  },
  5: function(e, t, n, r, i) {
   var a;
   return (null != (a = s(o(18)).call(null != t ? t : e.nullContext || {}, null != t ? t.results : t, {
    name: "isArray",
    hash: {},
    fn: e.program(6, i, 0),
    inverse: e.program(8, i, 0),
    data: i
   })) ? a : "") + "\n  <p>The search functionality is full-text based. Here are some tips:</p>\n\n  <ul>\n    <li>Multiple words (such as <code>foo bar</code>) are searched as <code>OR</code></li>\n    <li>Use <code>*</code> anywhere (such as <code>fo*</code>) as wildcard</li>\n    <li>Use <code>+</code> before a word (such as <code>+foo</code>) to make its presence required</li>\n    <li>Use <code>-</code> before a word (such as <code>-foo</code>) to make its absence required</li>\n    <li>Use <code>WORD^NUMBER</code> (such as <code>foo^2</code>) to boost the given word</li>\n    <li>Use <code>WORD~NUMBER</code> (such as <code>foo~2</code>) to do a search with edit distance on word</li>\n  </ul>\n\n  <p>To quickly go to a module, type, or function, use the autocompletion feature in the sidebar search.</p>\n"
  },
  6: function(e, t, n, r, i) {
   return "    <p>Sorry, we couldn't find anything for <em>" + e.escapeExpression(e.lambda(null != t ? t.value : t, t)) + "</em>.</p>\n"
  },
  8: function(e, t, n, r, i) {
   return "    <p>Invalid search: " + e.escapeExpression(e.lambda(null != t ? t.errorMessage : t, t)) + ".</p>\n"
  },
  compiler: [7, ">= 4.0.0"],
  main: function(e, t, n, r, i) {
   var a;
   return "<h1>Search results for <em>" + e.escapeExpression(e.lambda(null != t ? t.value : t, t)) + "</em></h1>\n\n" + (null != (a = s(o(22)).call(null != t ? t : e.nullContext || {}, null != t ? t.results : t, {
    name: "isNonEmptyArray",
    hash: {},
    fn: e.program(1, i, 0),
    inverse: e.program(5, i, 0),
    data: i
   })) ? a : "")
  },
  useData: !0
 })
}, function(e, t, d) {
 var n = d(2);

 function f(e) {
  return e && (e.__esModule ? e.default : e)
 }
 e.exports = (n.default || n).template({
  1: function(e, t, n, r, i, a, o) {
   var s, l = null != t ? t : e.nullContext || {},
    u = e.lambda,
    c = e.escapeExpression;
   return (null != (s = f(d(23)).call(l, o[1], null != (s = a[0][0]) ? s.group : s, {
    name: "groupChanged",
    hash: {},
    fn: e.program(2, i, 0, a, o),
    inverse: e.noop,
    data: i,
    blockParams: a
   })) ? s : "") + "\n" + (null != (s = f(d(24)).call(l, o[1], a[0][0], {
    name: "nestingChanged",
    hash: {},
    fn: e.program(4, i, 0, a, o),
    inverse: e.noop,
    data: i,
    blockParams: a
   })) ? s : "") + '\n    <li class="' + (null != (s = f(d(21)).call(l, null != (s = a[0][0]) ? s.id : s, {
    name: "isLocal",
    hash: {},
    fn: e.program(6, i, 0, a, o),
    inverse: e.noop,
    data: i,
    blockParams: a
   })) ? s : "") + " " + (null != (s = n.if.call(l, null != (s = a[0][0]) ? s.nested_title : s, {
    name: "if",
    hash: {},
    fn: e.program(8, i, 0, a, o),
    inverse: e.noop,
    data: i,
    blockParams: a
   })) ? s : "") + '">\n      <a href="' + c(u(null != (s = a[0][0]) ? s.id : s, t)) + '.html" class="expand">\n' + (null != (s = n.if.call(l, null != (s = a[0][0]) ? s.nested_title : s, {
    name: "if",
    hash: {},
    fn: e.program(10, i, 0, a, o),
    inverse: e.program(12, i, 0, a, o),
    data: i,
    blockParams: a
   })) ? s : "") + '\n        <span class="icon-goto" title="Go to ' + c(u(null != (s = a[0][0]) ? s.title : s, t)) + '"></span>\n      </a>\n\n      <ul>\n        <li>\n          <a href="' + c(u(null != (s = a[0][0]) ? s.id : s, t)) + '.html#content">Top</a>\n        </li>\n\n' + (null != (s = f(d(18)).call(l, null != (s = a[0][0]) ? s.headers : s, {
    name: "isArray",
    hash: {},
    fn: e.program(14, i, 0, a, o),
    inverse: e.program(17, i, 0, a, o),
    data: i,
    blockParams: a
   })) ? s : "") + "        </ul>\n    </li>\n"
  },
  2: function(e, t, n, r, i, a) {
   var o;
   return '      <li class="group">' + e.escapeExpression(e.lambda(null != (o = a[1][0]) ? o.group : o, t)) + "</li>\n"
  },
  4: function(e, t, n, r, i, a) {
   var o;
   return '      <li class="nesting-context" aria-hidden="true">' + e.escapeExpression(e.lambda(null != (o = a[1][0]) ? o.nested_context : o, t)) + "</li>\n"
  },
  6: function(e, t, n, r, i) {
   return "current-page open"
  },
  8: function(e, t, n, r, i) {
   return "nested"
  },
  10: function(e, t, n, r, i, a) {
   var o;
   return "          " + e.escapeExpression(e.lambda(null != (o = a[1][0]) ? o.nested_title : o, t)) + "\n"
  },
  12: function(e, t, n, r, i, a) {
   var o;
   return "          " + e.escapeExpression(e.lambda(null != (o = a[1][0]) ? o.title : o, t)) + "\n"
  },
  14: function(e, t, n, r, i, a) {
   var o;
   return null != (o = n.each.call(null != t ? t : e.nullContext || {}, null != (o = a[1][0]) ? o.headers : o, {
    name: "each",
    hash: {},
    fn: e.program(15, i, 0, a),
    inverse: e.noop,
    data: i,
    blockParams: a
   })) ? o : ""
  },
  15: function(e, t, n, r, i, a) {
   var o, s = e.lambda;
   return '            <li>\n              <a href="' + e.escapeExpression(s(null != (o = a[2][0]) ? o.id : o, t)) + ".html#" + (null != (o = s(null != t ? t.anchor : t, t)) ? o : "") + '">' + (null != (o = s(null != t ? t.id : t, t)) ? o : "") + "</a>\n            </li>\n"
  },
  17: function(e, t, n, r, i, a) {
   var o, s = null != t ? t : e.nullContext || {};
   return (null != (o = f(d(25)).call(s, a[1][0], {
    name: "showSummary",
    hash: {},
    fn: e.program(18, i, 0, a),
    inverse: e.noop,
    data: i,
    blockParams: a
   })) ? o : "") + (null != (o = n.each.call(s, null != (o = a[1][0]) ? o.nodeGroups : o, {
    name: "each",
    hash: {},
    fn: e.program(20, i, 1, a),
    inverse: e.noop,
    data: i,
    blockParams: a
   })) ? o : "")
  },
  18: function(e, t, n, r, i, a) {
   var o;
   return '            <li>\n              <a href="' + e.escapeExpression(e.lambda(null != (o = a[2][0]) ? o.id : o, t)) + '.html#summary">Summary</a>\n            </li>\n'
  },
  20: function(e, t, n, r, i, a) {
   var o, s = e.lambda,
    l = e.escapeExpression;
   return '            <li class="docs">\n              <a href="' + l(s(null != (o = a[2][0]) ? o.id : o, t)) + ".html#" + l(s(null != (o = a[0][0]) ? o.key : o, t)) + '" class="expand">\n                ' + l(s(null != (o = a[0][0]) ? o.name : o, t)) + '\n                <span class="icon-goto" title="Go to ' + l(s(null != (o = a[0][0]) ? o.name : o, t)) + '"></span>\n              </a>\n              <ul class="' + l(s(null != (o = a[0][0]) ? o.key : o, t)) + '-list deflist">\n' + (null != (o = n.each.call(null != t ? t : e.nullContext || {}, null != (o = a[0][0]) ? o.nodes : o, {
    name: "each",
    hash: {},
    fn: e.program(21, i, 0, a),
    inverse: e.noop,
    data: i,
    blockParams: a
   })) ? o : "") + "              </ul>\n            </li>\n"
  },
  21: function(e, t, n, r, i, a) {
   var o, s = e.lambda,
    l = e.escapeExpression;
   return '                  <li>\n                    <a href="' + l(s(null != (o = a[3][0]) ? o.id : o, t)) + ".html#" + l(s(null != t ? t.anchor : t, t)) + '">' + (null != (o = s(null != t ? t.id : t, t)) ? o : "") + "</a>\n                  </li>\n"
  },
  compiler: [7, ">= 4.0.0"],
  main: function(e, t, n, r, i, a, o) {
   var s;
   return '<ul id="full-list">\n' + (null != (s = n.each.call(null != t ? t : e.nullContext || {}, null != t ? t.nodes : t, {
    name: "each",
    hash: {},
    fn: e.program(1, i, 2, a, o),
    inverse: e.noop,
    data: i,
    blockParams: a
   })) ? s : "") + "</ul>\n"
  },
  useData: !0,
  useDepths: !0,
  useBlockParams: !0
 })
}, function(i, e, t) {
 (function(e) {
  var y = "Expected a function",
   a = NaN,
   o = "[object Symbol]",
   s = /^\s+|\s+$/g,
   l = /^[-+]0x[0-9a-f]+$/i,
   u = /^0b[01]+$/i,
   c = /^0o[0-7]+$/i,
   d = parseInt,
   t = "object" == typeof e && e && e.Object === Object && e,
   n = "object" == typeof self && self && self.Object === Object && self,
   r = t || n || Function("return this")(),
   f = Object.prototype.toString,
   b = Math.max,
   x = Math.min,
   w = function() {
    return r.Date.now()
   };

  function p(r, i, e) {
   var a, o, s, l, u, c, d = 0,
    f = !1,
    p = !1,
    t = !0;
   if ("function" != typeof r) throw new TypeError(y);

   function h(e) {
    var t = a,
     n = o;
    return a = o = void 0, d = e, l = r.apply(n, t)
   }

   function g(e) {
    var t = e - c;
    return void 0 === c || i <= t || t < 0 || p && s <= e - d
   }

   function m() {
    var e, t, n = w();
    if (g(n)) return v(n);
    u = setTimeout(m, (t = i - ((e = n) - c), p ? x(t, s - (e - d)) : t))
   }

   function v(e) {
    return u = void 0, t && a ? h(e) : (a = o = void 0, l)
   }

   function n() {
    var e, t = w(),
     n = g(t);
    if (a = arguments, o = this, c = t, n) {
     if (void 0 === u) return d = e = c, u = setTimeout(m, i), f ? h(e) : l;
     if (p) return u = setTimeout(m, i), h(c)
    }
    return void 0 === u && (u = setTimeout(m, i)), l
   }
   return i = E(i) || 0, _(e) && (f = !!e.leading, s = (p = "maxWait" in e) ? b(E(e.maxWait) || 0, i) : s, t = "trailing" in e ? !!e.trailing : t), n.cancel = function() {
    void 0 !== u && clearTimeout(u), a = c = o = u = void(d = 0)
   }, n.flush = function() {
    return void 0 === u ? l : v(w())
   }, n
  }

  function _(e) {
   var t = typeof e;
   return !!e && ("object" == t || "function" == t)
  }

  function E(e) {
   if ("number" == typeof e) return e;
   if ("symbol" == typeof(t = e) || (n = t) && "object" == typeof n && f.call(t) == o) return a;
   var t, n;
   if (_(e)) {
    var r = "function" == typeof e.valueOf ? e.valueOf() : e;
    e = _(r) ? r + "" : r
   }
   if ("string" != typeof e) return 0 === e ? e : +e;
   e = e.replace(s, "");
   var i = u.test(e);
   return i || c.test(e) ? d(e.slice(2), i ? 2 : 8) : l.test(e) ? a : +e
  }
  i.exports = function(e, t, n) {
   var r = !0,
    i = !0;
   if ("function" != typeof e) throw new TypeError(y);
   return _(n) && (r = "leading" in n ? !!n.leading : r, i = "trailing" in n ? !!n.trailing : i), p(e, t, {
    leading: r,
    maxWait: t,
    trailing: i
   })
  }
 }).call(this, t(20))
}, function(e, t, n) {
 var r = n(2);
 e.exports = (r.default || r).template({
  1: function(e, t, n, r, i) {
   var a, o, s = null != t ? t : e.nullContext || {},
    l = n.helperMissing,
    u = e.escapeExpression;
   return '      <option value="' + u("function" == typeof(o = null != (o = n.url || (null != t ? t.url : t)) ? o : l) ? o.call(s, {
    name: "url",
    hash: {},
    data: i
   }) : o) + '"' + (null != (a = n.if.call(s, null != t ? t.isCurrentVersion : t, {
    name: "if",
    hash: {},
    fn: e.program(2, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : "") + ">\n        " + u("function" == typeof(o = null != (o = n.version || (null != t ? t.version : t)) ? o : l) ? o.call(s, {
    name: "version",
    hash: {},
    data: i
   }) : o) + "\n      </option>\n"
  },
  2: function(e, t, n, r, i) {
   return " selected disabled"
  },
  compiler: [7, ">= 4.0.0"],
  main: function(e, t, n, r, i) {
   var a;
   return '<form autocomplete="off">\n  <select class="sidebar-projectVersionsDropdown" dir="rtl">\n' + (null != (a = n.each.call(null != t ? t : e.nullContext || {}, null != t ? t.nodes : t, {
    name: "each",
    hash: {},
    fn: e.program(1, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : "") + "  </select>\n</form>"
  },
  useData: !0
 })
}, function(e, t, n) {
 var r = n(2);
 e.exports = (r.default || r).template({
  compiler: [7, ">= 4.0.0"],
  main: function(e, t, n, r, i) {
   return '<div id="quick-switch-modal-wrapper">\n  <div id="quick-switch-modal" class="modal" tabindex="-1">\n    <div class="modal-contents">\n      <div class="modal-header">\n        <div class="modal-title">Go to a HexDocs package</div>\n        <div class="modal-close">Ã—</div>\n      </div>\n      <div class="modal-body">\n        <div class="quick-switch-wrapper">\n          <span class="icon-search" aria-hidden="true"></span>\n          <input type="text" id="quick-switch-input" class="search-input" placeholder="Jump to..." autocomplete="off">\n          <div id="quick-switch-results"></div>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>\n'
  },
  useData: !0
 })
}, function(e, t, n) {
 var r = n(2);
 e.exports = (r.default || r).template({
  1: function(e, t, n, r, i) {
   var a, o = null != t ? t : e.nullContext || {},
    s = n.helperMissing,
    l = e.escapeExpression;
   return '  <div class="quick-switch-result" data-index="' + l("function" == typeof(a = null != (a = n.index || i && i.index) ? a : s) ? a.call(o, {
    name: "index",
    hash: {},
    data: i
   }) : a) + '">\n    ' + l("function" == typeof(a = null != (a = n.name || (null != t ? t.name : t)) ? a : s) ? a.call(o, {
    name: "name",
    hash: {},
    data: i
   }) : a) + "\n  </div>\n"
  },
  compiler: [7, ">= 4.0.0"],
  main: function(e, t, n, r, i) {
   var a;
   return null != (a = n.each.call(null != t ? t : e.nullContext || {}, null != t ? t.results : t, {
    name: "each",
    hash: {},
    fn: e.program(1, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : ""
  },
  useData: !0
 })
}, function(e, t, n) {
 var r = n(2);
 e.exports = (r.default || r).template({
  1: function(e, t, n, r, i) {
   var a;
   return null != (a = n.if.call(null != t ? t : e.nullContext || {}, null != t ? t.description : t, {
    name: "if",
    hash: {},
    fn: e.program(2, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : ""
  },
  2: function(e, t, n, r, i) {
   var a;
   return '            <dl class="shortcut-row">\n              <dt class="shortcut-keys">\n' + (null != (a = n.if.call(null != t ? t : e.nullContext || {}, null != t ? t.displayAs : t, {
    name: "if",
    hash: {},
    fn: e.program(3, i, 0),
    inverse: e.program(5, i, 0),
    data: i
   })) ? a : "") + '              </dt>\n              <dd class="shortcut-description">\n                ' + e.escapeExpression(e.lambda(null != t ? t.description : t, t)) + "\n              </dd>\n            </dl>\n"
  },
  3: function(e, t, n, r, i) {
   var a;
   return "                  " + (null != (a = e.lambda(null != t ? t.displayAs : t, t)) ? a : "") + "\n"
  },
  5: function(e, t, n, r, i) {
   return "                  <kbd>" + e.escapeExpression(e.lambda(null != t ? t.name : t, t)) + "</kbd>\n"
  },
  compiler: [7, ">= 4.0.0"],
  main: function(e, t, n, r, i) {
   var a;
   return '<div id="keyboard-shortcuts-modal-wrapper">\n  <div id="keyboard-shortcuts-modal" class="modal" tabindex="-1">\n    <div class="modal-contents">\n      <div class="modal-header">\n        <div class="modal-title">Keyboard Shortcuts</div>\n        <div class="modal-close">Ã—</div>\n      </div>\n      <div class="modal-body">\n' + (null != (a = n.each.call(null != t ? t : e.nullContext || {}, null != t ? t.shortcuts : t, {
    name: "each",
    hash: {},
    fn: e.program(1, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : "") + "      </div>\n    </div>\n  </div>\n</div>\n"
  },
  useData: !0
 })
}, function(e, t, n) {
 var r = n(2);
 e.exports = (r.default || r).template({
  1: function(e, t, n, r, i) {
   var a;
   return '  <section class="docstring docstring-type">\n    ' + e.escapeExpression(e.lambda(null != (a = null != t ? t.hint : t) ? a.description : a, t)) + "\n  </section>\n"
  },
  3: function(e, t, n, r, i) {
   var a, o = e.lambda,
    s = e.escapeExpression,
    l = null != t ? t : e.nullContext || {};
   return '  <div class="detail-header">\n    <h1 class="signature">\n      ' + s(o(null != (a = null != t ? t.hint : t) ? a.title : a, t)) + '\n      <div class="version-info">' + s(o(null != (a = null != t ? t.hint : t) ? a.version : a, t)) + "</div>\n    </h1>\n" + (null != (a = n.unless.call(l, null != t ? t.isModule : t, {
    name: "unless",
    hash: {},
    fn: e.program(4, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : "") + "  </div>\n" + (null != (a = n.if.call(l, null != (a = null != t ? t.hint : t) ? a.description : a, {
    name: "if",
    hash: {},
    fn: e.program(6, i, 0),
    inverse: e.noop,
    data: i
   })) ? a : "")
  },
  4: function(e, t, n, r, i) {
   var a;
   return '      <div class="specs">' + e.escapeExpression(e.lambda(null != (a = null != t ? t.hint : t) ? a.signatureSpecs : a, t)) + "</div>\n"
  },
  6: function(e, t, n, r, i) {
   var a;
   return '    <section class="docstring">\n      ' + e.escapeExpression(e.lambda(null != (a = null != t ? t.hint : t) ? a.description : a, t)) + "\n    </section>\n"
  },
  compiler: [7, ">= 4.0.0"],
  main: function(e, t, n, r, i) {
   var a;
   return null != (a = n.if.call(null != t ? t : e.nullContext || {}, null != t ? t.isType : t, {
    name: "if",
    hash: {},
    fn: e.program(1, i, 0),
    inverse: e.program(3, i, 0),
    data: i
   })) ? a : ""
  },
  useData: !0
 })
}, function(e, t, n) {
 var r = n(2);
 e.exports = (r.default || r).template({
  compiler: [7, ">= 4.0.0"],
  main: function(e, t, n, r, i) {
   return '<div id="tooltip">\n  <div class="tooltip-body"></div>\n  <iframe class="tooltip-iframe"></iframe>\n</div>\n'
  },
  useData: !0
 })
}, , , , function(e, t, n) {
 "use strict";

 function r(e) {
  return e && e.__esModule ? e : {
   default: e
  }
 }

 function i(e) {
  if (e && e.__esModule) return e;
  var t = {};
  if (null != e)
   for (var n in e) Object.prototype.hasOwnProperty.call(e, n) && (t[n] = e[n]);
  return t.default = e, t
 }
 t.__esModule = !0;
 var a = i(n(26)),
  o = r(n(52)),
  s = r(n(5)),
  l = i(n(3)),
  u = i(n(53)),
  c = r(n(54));

 function d() {
  var t = new a.HandlebarsEnvironment;
  return l.extend(t, a), t.SafeString = o.default, t.Exception = s.default, t.Utils = l, t.escapeExpression = l.escapeExpression, t.VM = u, t.template = function(e) {
   return u.template(e, t)
  }, t
 }
 var f = d();
 f.create = d, c.default(f), f.default = f, t.default = f, e.exports = t.default
}, function(e, t, n) {
 "use strict";

 function r(e) {
  return e && e.__esModule ? e : {
   default: e
  }
 }
 t.__esModule = !0, t.registerDefaultHelpers = function(e) {
  i.default(e), a.default(e), o.default(e), s.default(e), l.default(e), u.default(e), c.default(e)
 };
 var i = r(n(42)),
  a = r(n(43)),
  o = r(n(44)),
  s = r(n(45)),
  l = r(n(46)),
  u = r(n(47)),
  c = r(n(48))
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0;
 var o = n(3);
 t.default = function(a) {
  a.registerHelper("blockHelperMissing", function(e, t) {
   var n = t.inverse,
    r = t.fn;
   if (!0 === e) return r(this);
   if (!1 === e || null == e) return n(this);
   if (o.isArray(e)) return 0 < e.length ? (t.ids && (t.ids = [t.name]), a.helpers.each(e, t)) : n(this);
   if (t.data && t.ids) {
    var i = o.createFrame(t.data);
    i.contextPath = o.appendContextPath(t.data.contextPath, t.name), t = {
     data: i
    }
   }
   return r(e, t)
  })
 }, e.exports = t.default
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0;
 var r, f = n(3),
  i = n(5),
  p = (r = i) && r.__esModule ? r : {
   default: r
  };
 t.default = function(e) {
  e.registerHelper("each", function(r, e) {
   if (!e) throw new p.default("Must pass iterator to #each");
   var i = e.fn,
    t = e.inverse,
    n = 0,
    a = "",
    o = void 0,
    s = void 0;

   function l(e, t, n) {
    o && (o.key = e, o.index = t, o.first = 0 === t, o.last = !!n, s && (o.contextPath = s + e)), a += i(r[e], {
     data: o,
     blockParams: f.blockParams([r[e], e], [s + e, null])
    })
   }
   if (e.data && e.ids && (s = f.appendContextPath(e.data.contextPath, e.ids[0]) + "."), f.isFunction(r) && (r = r.call(this)), e.data && (o = f.createFrame(e.data)), r && "object" == typeof r)
    if (f.isArray(r))
     for (var u = r.length; n < u; n++) n in r && l(n, n, n === r.length - 1);
    else {
     var c = void 0;
     for (var d in r) r.hasOwnProperty(d) && (void 0 !== c && l(c, n - 1), c = d, n++);
     void 0 !== c && l(c, n - 1, !0)
    } return 0 === n && (a = t(this)), a
  })
 }, e.exports = t.default
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0;
 var r, i = n(5),
  a = (r = i) && r.__esModule ? r : {
   default: r
  };
 t.default = function(e) {
  e.registerHelper("helperMissing", function() {
   if (1 !== arguments.length) throw new a.default('Missing helper: "' + arguments[arguments.length - 1].name + '"')
  })
 }, e.exports = t.default
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0;
 var r = n(3);
 t.default = function(n) {
  n.registerHelper("if", function(e, t) {
   return r.isFunction(e) && (e = e.call(this)), !t.hash.includeZero && !e || r.isEmpty(e) ? t.inverse(this) : t.fn(this)
  }), n.registerHelper("unless", function(e, t) {
   return n.helpers.if.call(this, e, {
    fn: t.inverse,
    inverse: t.fn,
    hash: t.hash
   })
  })
 }, e.exports = t.default
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0, t.default = function(i) {
  i.registerHelper("log", function() {
   for (var e = [void 0], t = arguments[arguments.length - 1], n = 0; n < arguments.length - 1; n++) e.push(arguments[n]);
   var r = 1;
   null != t.hash.level ? r = t.hash.level : t.data && null != t.data.level && (r = t.data.level), e[0] = r, i.log.apply(i, e)
  })
 }, e.exports = t.default
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0, t.default = function(e) {
  e.registerHelper("lookup", function(e, t) {
   return e ? "constructor" !== t || e.propertyIsEnumerable(t) ? e[t] : void 0 : e
  })
 }, e.exports = t.default
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0;
 var i = n(3);
 t.default = function(e) {
  e.registerHelper("with", function(e, t) {
   i.isFunction(e) && (e = e.call(this));
   var n = t.fn;
   if (i.isEmpty(e)) return t.inverse(this);
   var r = t.data;
   return t.data && t.ids && ((r = i.createFrame(t.data)).contextPath = i.appendContextPath(t.data.contextPath, t.ids[0])), n(e, {
    data: r,
    blockParams: i.blockParams([e], [r && r.contextPath])
   })
  })
 }, e.exports = t.default
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0, t.registerDefaultDecorators = function(e) {
  a.default(e)
 };
 var r, i = n(50),
  a = (r = i) && r.__esModule ? r : {
   default: r
  }
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0;
 var s = n(3);
 t.default = function(e) {
  e.registerDecorator("inline", function(i, a, o, e) {
   var t = i;
   return a.partials || (a.partials = {}, t = function(e, t) {
    var n = o.partials;
    o.partials = s.extend({}, n, a.partials);
    var r = i(e, t);
    return o.partials = n, r
   }), a.partials[e.args[0]] = e.fn, t
  })
 }, e.exports = t.default
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0;
 var r = n(3),
  a = {
   methodMap: ["debug", "info", "warn", "error"],
   level: "info",
   lookupLevel: function(e) {
    if ("string" == typeof e) {
     var t = r.indexOf(a.methodMap, e.toLowerCase());
     e = 0 <= t ? t : parseInt(e, 10)
    }
    return e
   },
   log: function(e) {
    if (e = a.lookupLevel(e), "undefined" != typeof console && a.lookupLevel(a.level) <= e) {
     var t = a.methodMap[e];
     console[t] || (t = "log");
     for (var n = arguments.length, r = Array(1 < n ? n - 1 : 0), i = 1; i < n; i++) r[i - 1] = arguments[i];
     console[t].apply(console, r)
    }
   }
  };
 t.default = a, e.exports = t.default
}, function(e, t, n) {
 "use strict";

 function r(e) {
  this.string = e
 }
 t.__esModule = !0, r.prototype.toString = r.prototype.toHTML = function() {
  return "" + this.string
 }, t.default = r, e.exports = t.default
}, function(e, t, n) {
 "use strict";
 t.__esModule = !0, t.checkRevision = function(e) {
  var t = e && e[0] || 1,
   n = f.COMPILER_REVISION;
  if (t !== n) {
   if (t < n) {
    var r = f.REVISION_CHANGES[n],
     i = f.REVISION_CHANGES[t];
    throw new d.default("Template was precompiled with an older version of Handlebars than the current runtime. Please update your precompiler to a newer version (" + r + ") or downgrade your runtime to an older version (" + i + ").")
   }
   throw new d.default("Template was precompiled with a newer version of Handlebars than the current runtime. Please update your runtime to a newer version (" + e[1] + ").")
  }
 }, t.template = function(s, l) {
  if (!l) throw new d.default("No environment passed to template");
  if (!s || !s.main) throw new d.default("Unknown template object: " + typeof s);
  s.main.decorator = s.main_d, l.VM.checkRevision(s.compiler);
  var o = {
   strict: function(e, t) {
    if (!(t in e)) throw new d.default('"' + t + '" not defined in ' + e);
    return e[t]
   },
   lookup: function(e, t) {
    for (var n = e.length, r = 0; r < n; r++)
     if (e[r] && null != e[r][t]) return e[r][t]
   },
   lambda: function(e, t) {
    return "function" == typeof e ? e.call(t) : e
   },
   escapeExpression: c.escapeExpression,
   invokePartial: function(e, t, n) {
    n.hash && (t = c.extend({}, t, n.hash), n.ids && (n.ids[0] = !0));
    e = l.VM.resolvePartial.call(this, e, t, n);
    var r = l.VM.invokePartial.call(this, e, t, n);
    null == r && l.compile && (n.partials[n.name] = l.compile(e, s.compilerOptions, l), r = n.partials[n.name](t, n)); {
     if (null == r) throw new d.default("The partial " + n.name + " could not be compiled when running in runtime-only mode");
     if (n.indent) {
      for (var i = r.split("\n"), a = 0, o = i.length; a < o && (i[a] || a + 1 !== o); a++) i[a] = n.indent + i[a];
      r = i.join("\n")
     }
     return r
    }
   },
   fn: function(e) {
    var t = s[e];
    return t.decorator = s[e + "_d"], t
   },
   programs: [],
   program: function(e, t, n, r, i) {
    var a = this.programs[e],
     o = this.fn(e);
    return t || i || r || n ? a = p(this, e, o, t, n, r, i) : a || (a = this.programs[e] = p(this, e, o)), a
   },
   data: function(e, t) {
    for (; e && t--;) e = e._parent;
    return e
   },
   merge: function(e, t) {
    var n = e || t;
    return e && t && e !== t && (n = c.extend({}, t, e)), n
   },
   nullContext: Object.seal({}),
   noop: l.VM.noop,
   compilerInfo: s.compiler
  };

  function u(e) {
   var t = arguments.length <= 1 || void 0 === arguments[1] ? {} : arguments[1],
    n = t.data;
   u._setup(t), !t.partial && s.useData && (n = function(e, t) {
    t && "root" in t || ((t = t ? f.createFrame(t) : {}).root = e);
    return t
   }(e, n));
   var r = void 0,
    i = s.useBlockParams ? [] : void 0;

   function a(e) {
    return "" + s.main(o, e, o.helpers, o.partials, n, i, r)
   }
   return s.useDepths && (r = t.depths ? e != t.depths[0] ? [e].concat(t.depths) : t.depths : [e]), (a = h(s.main, a, o, t.depths || [], n, i))(e, t)
  }
  return u.isTop = !0, u._setup = function(e) {
   e.partial ? (o.helpers = e.helpers, o.partials = e.partials, o.decorators = e.decorators) : (o.helpers = o.merge(e.helpers, l.helpers), s.usePartial && (o.partials = o.merge(e.partials, l.partials)), (s.usePartial || s.useDecorators) && (o.decorators = o.merge(e.decorators, l.decorators)))
  }, u._child = function(e, t, n, r) {
   if (s.useBlockParams && !n) throw new d.default("must pass block params");
   if (s.useDepths && !r) throw new d.default("must pass parent depths");
   return p(o, e, s[e], t, 0, n, r)
  }, u
 }, t.wrapProgram = p, t.resolvePartial = function(e, t, n) {
  e ? e.call || n.name || (n.name = e, e = n.partials[e]) : e = "@partial-block" === n.name ? n.data["partial-block"] : n.partials[n.name];
  return e
 }, t.invokePartial = function(e, t, r) {
  var i = r.data && r.data["partial-block"];
  r.partial = !0, r.ids && (r.data.contextPath = r.ids[0] || r.data.contextPath);
  var a = void 0;
  r.fn && r.fn !== o && function() {
   r.data = f.createFrame(r.data);
   var n = r.fn;
   a = r.data["partial-block"] = function(e) {
    var t = arguments.length <= 1 || void 0 === arguments[1] ? {} : arguments[1];
    return t.data = f.createFrame(t.data), t.data["partial-block"] = i, n(e, t)
   }, n.partials && (r.partials = c.extend({}, r.partials, n.partials))
  }();
  void 0 === e && a && (e = a); {
   if (void 0 === e) throw new d.default("The partial " + r.name + " could not be found");
   if (e instanceof Function) return e(t, r)
  }
 }, t.noop = o;
 var r, c = function(e) {
   if (e && e.__esModule) return e;
   var t = {};
   if (null != e)
    for (var n in e) Object.prototype.hasOwnProperty.call(e, n) && (t[n] = e[n]);
   return t.default = e, t
  }(n(3)),
  i = n(5),
  d = (r = i) && r.__esModule ? r : {
   default: r
  },
  f = n(26);

 function p(r, e, i, a, t, o, s) {
  function n(e) {
   var t = arguments.length <= 1 || void 0 === arguments[1] ? {} : arguments[1],
    n = s;
   return !s || e == s[0] || e === r.nullContext && null === s[0] || (n = [e].concat(s)), i(r, e, r.helpers, r.partials, t.data || a, o && [t.blockParams].concat(o), n)
  }
  return (n = h(i, n, r, s, a, o)).program = e, n.depth = s ? s.length : 0, n.blockParams = t || 0, n
 }

 function o() {
  return ""
 }

 function h(e, t, n, r, i, a) {
  if (e.decorator) {
   var o = {};
   t = e.decorator(t, o, n, r && r[0], i, a, r), c.extend(t, o)
  }
  return t
 }
}, function(e, t, n) {
 "use strict";
 (function(r) {
  t.__esModule = !0, t.default = function(e) {
   var t = void 0 !== r ? r : window,
    n = t.Handlebars;
   e.noConflict = function() {
    return t.Handlebars === e && (t.Handlebars = n), e
   }
  }, e.exports = t.default
 }).call(this, n(20))
}, function(e, t) {
 e.exports = function(e) {
  return e.webpackPolyfill || (e.deprecate = function() {}, e.paths = [], e.children || (e.children = []), Object.defineProperty(e, "loaded", {
   enumerable: !0,
   get: function() {
    return e.l
   }
  }), Object.defineProperty(e, "id", {
   enumerable: !0,
   get: function() {
    return e.i
   }
  }), e.webpackPolyfill = 1), e
 }
}, , , function(e, t, n) {
 "use strict";
 n.r(t);
 var r = n(0),
  p = n.n(r),
  i = n(2),
  a = n.n(i),
  o = n(1),
  s = n.n(o),
  l = n(6),
  u = n.n(l),
  c = n(7),
  d = n.n(c),
  f = n(8),
  h = n.n(f),
  g = n(9),
  m = n.n(g),
  v = n(10),
  y = n.n(v),
  b = n(11),
  x = n.n(b),
  w = n(12),
  _ = n.n(w),
  E = n(13),
  k = n.n(E),
  C = n(14),
  T = n.n(C),
  S = n(15),
  N = n.n(S),
  O = n(16),
  A = n.n(O),
  j = n(18),
  D = n(21),
  L = n(22),
  R = n(23),
  P = n(24),
  M = n(25),
  I = n(27),
  q = n.n(I),
  B = n(4),
  Q = n.n(B);

 function H(e) {
  return e.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&")
 }

 function F() {
  return p()("body").data("type")
 }

 function $(e) {
  return function(e) {
   if (Array.isArray(e)) {
    for (var t = 0, n = new Array(e.length); t < e.length; t++) n[t] = e[t];
    return n
   }
  }(e) || function(e) {
   if (Symbol.iterator in Object(e) || "[object Arguments]" === Object.prototype.toString.call(e)) return Array.from(e)
  }(e) || function() {
   throw new TypeError("Invalid attempt to spread non-iterable instance")
  }()
 }
 var z = 5,
  W = {
   Module: 3,
   Child: 2,
   Exception: 1,
   "Mix Task": 0
  },
  U = {
   callbacks: "callback",
   types: "type"
  };

 function V(e) {
  var t = 1 < arguments.length && void 0 !== arguments[1] ? arguments[1] : null,
   n = "Child" === e.category,
   r = n ? e.anchor : "",
   i = n ? "Child" : e.category,
   a = n ? t : null,
   o = e.label || null;
  return {
   link: r ? "".concat(t, ".html#").concat(r) : "".concat(t, ".html"),
   title: e.match,
   description: a,
   label: o,
   matchQuality: e.matchQuality,
   category: i
  }
 }

 function G() {
  var e = 0 < arguments.length && void 0 !== arguments[0] ? arguments[0] : "";
  if (0 === e.trim().length) return [];
  var t = sidebarNodes,
   n = K(t.modules, e, "Module"),
   r = K(t.tasks, e, "Mix Task"),
   i = $(n).concat($(r));
  return (i = i.sort(function(e, t) {
   var n = Z(e),
    r = Z(t);
   return r - n
  }).sort(function(e, t) {
   var n = e.matchQuality || 0,
    r = t.matchQuality || 0;
   return r - n
  })).slice(0, z)
 }

 function K(e, h, c) {
  var d = new RegExp(H(h), "i");
  return e.reduce(function(o, s) {
   var l = s.title,
    e = l && l.match(d);
   if (e) {
    var t = V({
     id: s.id,
     match: X(e),
     category: c,
     matchQuality: J(e),
     group: s.group
    }, s.id);
    o.push(t)
   }
   if (s.nodeGroups) {
    var n = !0,
     r = !1,
     i = void 0;
    try {
     for (var p, a = function() {
       var e, u, c, d, f, t = p.value,
        n = t.key,
        r = t.nodes,
        i = (e = r, u = l, c = h, d = n, f = new RegExp(H(c), "i"), (e || []).reduce(function(e, t) {
         if (e[d + t.id]) return e;
         var n = "".concat(u, ".").concat(t.id),
          r = !(u + ".").match(f) && n.match(f),
          i = t.id && t.id.match(f),
          a = JSON.parse(JSON.stringify(t));
         if (i) a.match = X(i), a.matchQuality = J(i);
         else {
          if (!r) return e;
          var o = c.split(".").pop(),
           s = new RegExp(H(o), "i"),
           l = t.id.match(s);
          a.matchQuality = J(l), a.match = X(l)
         }
         return e[d + a.id] = a, e
        }, {}));
       if (0 < Object.keys(i).length) {
        var a = Object.values(i);
        a = a.map(function(e) {
         return e.category = "Child", e.label = U[n], V(e, s.id)
        }), o = o.concat(a)
       }
      }, u = s.nodeGroups[Symbol.iterator](); !(n = (p = u.next()).done); n = !0) a()
    } catch (e) {
     r = !0, i = e
    } finally {
     try {
      n || null == u.return || u.return()
     } finally {
      if (r) throw i
     }
    }
   }
   return o
  }, []).filter(function(e) {
   return !!e
  })
 }

 function X(e) {
  return e.input.replace(e, "<em>".concat(e[0], "</em>"))
 }

 function Z(e) {
  return "Exceptions" === e.group ? W.Exception : W[e.category] || -1
 }

 function J(e) {
  if (!e) return 0;
  var t = e.input.length;
  return t ? e.length / t : 0
 }
 var Y = p()(".autocomplete");

 function ee() {
  Y.hide()
 }

 function te(e) {
  var t, n, r;
  e ? (Y.show(), n = G(t = e), r = q()({
   empty: 0 === n.length,
   results: n,
   term: t
  }), Y.html(r)) : ee()
 }

 function ne(e) {
  var t = p()(".autocomplete-suggestion.selected"),
   n = -1;
  t.length && (n = parseInt(t.attr("data-index")) + e);
  var r = p()('.autocomplete-suggestion[data-index="'.concat(n, '"]'));
  r.length || (r = n < 0 ? p()(".autocomplete-suggestion:last") : p()(".autocomplete-suggestion:first")), p()(".autocomplete-suggestion").each(function() {
   p()(this).toggleClass("selected", p()(this).is(r))
  })
 }
 var re = n(19),
  ie = n.n(re),
  ae = n(28),
  oe = n.n(ae),
  se = p()("#search"),
  le = p()(".sidebar-search input");

 function ue(e) {
  var r = searchNodes,
   i = [];
  return e.forEach(function(t) {
   var e = r.find(function(e) {
    return e.ref === t.ref
   });
   if (e) {
    var n = t.matchData.metadata;
    e.metadata = n, e.excerpts = function(i, t) {
     var e = Object.keys(t),
      a = [];
     e.forEach(function(e) {
      "doc" in t[e] && t[e].doc.position.forEach(function(e) {
       var t = 0 < e[0] - 80 ? e[0] - 80 : 0,
        n = e[0] + e[1] + 80 > i.doc.length ? i.doc.length : e[0] + e[1] + 80,
        r = (0 < t ? "..." : "") + i.doc.slice(t, e[0]) + "<em>" + i.doc.slice(e[0], e[0] + e[1]) + "</em> " + i.doc.slice(e[0] + e[1], n) + (n < i.doc.length ? "..." : "");
       a.push(r)
      })
     }), 0 === a.length && a.push(i.doc.slice(0, 160) + (160 < i.doc.length ? "..." : ""));
     return a.slice(0, 1)
    }(e, n), i.push(e)
   }
  }), i
 }

 function ce(e) {
  if ("" !== e.replace(/\s/, "")) {
   le.val(e);
   var t, n, r = function() {
    var t = document.head.querySelector("meta[name=project][content]").content,
     e = sessionStorage.getItem(t);
    try {
     if (null == e) throw "create and save";
     return ie.a.Index.load(JSON.parse(e))
    } catch (e) {
     var n = ie()(function() {
       this.ref("ref"), this.field("title", {
        boost: 3,
        extractor: de
       }), this.field("doc"), this.metadataWhitelist = ["position"], this.pipeline.remove(ie.a.stopWordFilter), searchNodes.forEach(function(e) {
        this.add(e)
       }, this)
      }),
      r = JSON.stringify(n);
     try {
      sessionStorage.setItem(t, r)
     } catch (e) {}
     return n
    }
   }();
   try {
    t = ue(r.search(e.replace(":", "")))
   } catch (e) {
    n = e.message
   }
   var i = oe()({
    value: e,
    results: t,
    errorMessage: n
   });
   se.html(i)
  } else se.html("<h1>Search</h1>")
 }

 function de(e) {
  var t = e.title,
   n = e.type;
  if ("function" === n || "callback" === n || "type" === n) {
   var r = t.replace(/\/\d+/, ""),
    i = r.replace(".", " "),
    a = t.split(".");
   t = t + " " + r + " " + i + " " + a[a.length - 1]
  }
  return t
 }
 var fe = n(29),
  pe = n.n(fe),
  he = ["#extras-list", "#modules-list", "#tasks-list", "#search-list"],
  ge = p()(".sidebar-listNav"),
  me = p()(".content"),
  ve = p()(".content-inner"),
  ye = p()("body"),
  be = p()("form.sidebar-search");

 function xe() {
  var e = p()("#full-list"),
   t = p()("#full-list li.current-page");
  0 < t.length && e.scrollTop(t.offset().top - e.offset().top - 40)
 }

 function we(e, t) {
  var n, r = F(),
   i = e[t = t || r] || [];
  p()("#full-list").replaceWith(pe()({
   nodes: i,
   group: ""
  })), n = ["#", t, "-list"].join(""), he.forEach(function(e) {
   e === n ? p()(e).parent().addClass("selected") : p()(e).parent().removeClass("selected")
  }), p()("#full-list li a").on("click", function(e) {
   var t = p()(e.target);
   !(t.is("a") ? t : t.closest("a")).hasClass("expand") || t.is("span") || e.shiftKey ? (p()("#full-list li.current-page li.current-hash").removeClass("current-hash"), p()(e.target).closest("li").addClass("current-hash")) : (e.preventDefault(), p()(e.target).closest("li").toggleClass("open"))
  })
 }

 function _e(t) {
  return function(e) {
   e.preventDefault(), we(sidebarNodes, t), xe()
  }
 }

 function Ee() {
  ge.on("click", "#extras-list", _e("extras")), ge.on("click", "#modules-list", _e("modules")), ge.on("click", "#exceptions-list", _e("exceptions")), ge.on("click", "#tasks-list", _e("tasks")), p()(".sidebar-search").on("click", ".search-close-button", function(e) {
   Ce(), e.preventDefault()
  }), p()(".sidebar-search input").on("keydown", function(e) {
   var t, n, r, i, a, o = event.metaKey || event.ctrlKey,
    s = 0 === (t = p()(".autocomplete-suggestion.selected")).length ? null : "-1" === t.attr("data-index") ? null : t;
   if (27 === e.keyCode) p()(this).val("").blur();
   else if (13 === e.keyCode)
    if (s) {
     var l = s.attr("href");
     n = p()(this), r = l, i = o ? "_blank" : "_self", a = n.val(), n.removeAttr("name").val(""), be.attr("action", r).attr("target", i).submit().attr("action", "search.html"), n.val(a).attr("name", "q"), e.preventDefault()
    } else o && (be.attr("target", "_blank").submit().removeAttr(""), e.preventDefault());
   else 38 === e.keyCode ? (ne(-1), e.preventDefault()) : 40 === e.keyCode ? (ne(1), e.preventDefault()) : o || te(p()(this).val())
  }), p()(".sidebar-search input").on("keyup", function(e) {
   if (event.metaKey || event.ctrlKey) return null;
   38 !== e.keyCode && 40 !== e.keyCode && te(p()(this).val())
  }), p()(".sidebar-search input").on("focus", function(e) {
   ye.addClass("search-focused"), te(p()(this).val())
  }), p()(".sidebar-search input").on("blur", function(e) {
   var t = p()(e.relatedTarget);
   if (t.hasClass("autocomplete-suggestion")) return null;
   t.hasClass("search-close-button") && Ce(), ye.removeClass("search-focused"), ee()
  });
  var e, t, n, r, i = window.location.pathname;
  "search.html" === i.substr(i.lastIndexOf("/") + 1) && ce((e = "q", t = window.location.href, n = e.replace(/[\[\]]/g, "\\$&"), (r = new RegExp("[?&]" + n + "(=([^&#]*)|&|#|$)").exec(t)) && r[2] ? decodeURIComponent(r[2].replace(/\+/g, " ")) : ""))
 }

 function ke() {
  var e = window.location.hash.replace(/^#/, "") || "content",
   t = function(e, n) {
    if (e) {
     var t = !0,
      r = !1,
      i = void 0;
     try {
      for (var a, o = e[Symbol.iterator](); !(t = (a = o.next()).done); t = !0) {
       var s = a.value,
        l = Q()(s.nodeGroups, function(e) {
         var t = e.nodes;
         return Q()(t, function(e) {
          return e.anchor === n
         })
        });
       if (l) return l.key
      }
     } catch (e) {
      r = !0, i = e
     } finally {
      try {
       t || null == o.return || o.return()
      } finally {
       if (r) throw i
      }
     }
    }
   }(sidebarNodes[F()] || [], e);
  p()('#full-list li.current-page a.expand[href$="#'.concat(t, '"]')).closest("li").addClass("open"), p()('#full-list li.current-page a[href$="#'.concat(e, '"]')).closest("li").addClass("current-hash")
 }

 function Ce() {
  p()(".sidebar-search input").val(""), p()(".sidebar-search input").blur()
 }

 function Te() {
  we(sidebarNodes), Ee(), xe(), ke(), me.find("a").has("code").addClass("no-underline"), me.find("a").has("img").addClass("no-underline"), ve.attr("tabindex", -1).focus()
 }
 var Se, Ne = n(30),
  Oe = n.n(Ne),
  Ae = p()("body"),
  je = p()("#search-list"),
  De = 768,
  Le = 300,
  Re = "sidebar-opened",
  Pe = "sidebar-opening",
  Me = "sidebar-closed",
  Ie = "sidebar-closing",
  qe = [Re, Pe, Me, Ie].join(" ");

 function Be() {
  Ae.addClass(Pe).removeClass(Me).removeClass(Ie), Se = setTimeout(function() {
   return Ae.addClass(Re).removeClass(Pe)
  }, Le)
 }

 function Qe() {
  var e = Ae.attr("class") || "";
  clearTimeout(Se), e.includes(Me) || e.includes(Ie) ? Be() : (Ae.addClass(Ie).removeClass(Re).removeClass(Pe), Se = setTimeout(function() {
   return Ae.addClass(Me).removeClass(Ie)
  }, Le))
 }

 function He() {
  Ae.removeClass(qe), Ae.addClass(window.innerWidth > De ? Re : Me)
 }
 var Fe = n(31),
  $e = n.n(Fe),
  ze = p()(".sidebar-projectVersion"),
  We = ze.text().trim();

 function Ue(e) {
  return e.isCurrentVersion = e.version === We, e
 }

 function Ve() {
  if ("undefined" != typeof versionNodes) {
   Q()(versionNodes, function(e) {
    return e.version === We
   }) || versionNodes.unshift({
    version: We,
    url: "#"
   });
   var e = p()(".sidebar-projectVersion").width() + 10,
    t = $e()({
     nodes: versionNodes.map(Ue)
    });
   ze.text(""), ze.append(t), p()(".sidebar-projectVersionsDropdown").width(e).change(function() {
    window.location.href = p()(this).val()
   })
  }
 }
 var Ge = p()("body"),
  Ke = "night-mode";

 function Xe() {
  Ge.addClass(Ke);
  try {
   localStorage.setItem(Ke, !0)
  } catch (e) {}
 }

 function Ze() {
  Ge.hasClass(Ke) ? function() {
   Ge.removeClass(Ke);
   try {
    localStorage.removeItem(Ke)
   } catch (e) {}
  }() : Xe()
 }

 function Je() {
  ! function() {
   try {
    var e = localStorage.getItem(Ke);
    null != e ? !0 === e && Xe() : matchMedia("(prefers-color-scheme: dark)").matches && Ge.addClass(Ke)
   } catch (e) {}
  }(), Ge.on("click", ".night-mode-toggle", function() {
   Ze()
  })
 }
 var Ye = n(17),
  et = n(32),
  tt = n.n(et),
  nt = n(33),
  rt = n.n(nt),
  it = "https://hexdocs.pm/%%",
  at = "https://hex.pm/api/packages?search=name:%%*",
  ot = "#quick-switch-modal",
  st = "#quick-switch-input",
  lt = "#quick-switch-results",
  ut = ".quick-switch-result",
  ct = 300,
  dt = 9,
  ft = [13, 27, 37, 38, 39, 40],
  pt = ["elixir", "eex", "ex_unit", "hex", "iex", "logger", "mix"].map(function(e) {
   return {
    name: e
   }
  }),
  ht = null,
  gt = [],
  mt = -1;

 function vt(e) {
  p()(ot).show(), p()(st).focus(), event.preventDefault()
 }

 function yt() {
  ht = null, gt = [], mt = -1, p()(st).blur(), p()(lt).html(""), p()(st).val("").removeClass("completed"), p()(ot).hide()
 }

 function bt(e) {
  window.location = it.replace("%%", e)
 }

 function xt(e) {
  clearTimeout(ht), ht = setTimeout(function() {
   var a;
   a = e, p.a.get(at.replace("%%", a), function(e) {
    if (Array.isArray(e)) {
     r = a, i = e, gt = pt.concat(i).filter(function(e) {
      return -1 !== e.name.indexOf(r)
     }).filter(function(e) {
      return void 0 === e.releases || !0 === e.releases[0].has_docs
     }).slice(0, dt), mt = -1;
     var t = rt()({
       results: gt
      }),
      n = p()(st).val();
     n && 3 <= n.length && (p()(lt).html(t), p()(ut).click(function() {
      var e = gt[p()(this).attr("data-index")];
      bt(e.name)
     }))
    }
    var r, i
   })
  }, ct)
 }

 function wt(e, t) {
  var n, r, i, a, o = p()(".quick-switch-result.selected");
  0 !== o.length ? "up" === t ? (a = (i = o).prev(), i.removeClass("selected"), 0 !== a.length ? (a.addClass("selected"), mt -= 1) : (p()(ut).last().addClass("selected"), mt = dt)) : (r = (n = o).next(), n.removeClass("selected"), 0 !== r.length ? (r.addClass("selected"), mt += 1) : _t()) : _t(), e.preventDefault()
 }

 function _t() {
  p()(ut).first().addClass("selected"), mt = 0
 }

 function Et() {
  var e = tt()();
  p()("body").append(e), p()(".display-quick-switch").click(vt), p()(ot).on("keydown", function(e) {
   27 === e.keyCode && yt()
  }), p()(ot).on("click", ".modal-close", function() {
   yt()
  }), p()(st).on("keydown", function(e) {
   var t, n = p()(st).val();
   13 === e.keyCode && (t = n, bt(-1 === mt ? t : gt[mt].name)), 37 !== e.keyCode && 39 !== e.keyCode || (p()(".quick-switch-result.selected").removeClass("selected"), mt = -1), 38 === e.keyCode && wt(e, "up"), 40 === e.keyCode && wt(e, "down")
  }), p()(st).on("keyup", function(e) {
   var t = p()(st).val() || "";
   8 === e.keyCode && t.length < 3 && p()(lt).html(""), -1 === ft.indexOf(e.keyCode) && 3 <= t.length && xt(t)
  })
 }
 var kt = n(34),
  Ct = n.n(kt),
  Tt = "#keyboard-shortcuts-modal",
  St = ["input", "textarea"],
  Nt = [{
   name: "c",
   keyCode: 67,
   description: "Toggle sidebar",
   action: Qe
  }, {
   name: "n",
   keyCode: 78,
   description: "Toggle night mode",
   action: Ze
  }, {
   name: "s",
   keyCode: 83,
   description: "Focus search bar",
   displayAs: "<kbd>/</kbd> or <kbd>s</kdb>",
   action: Dt
  }, {
   name: "/",
   keyCode: 191,
   action: Dt
  }, {
   name: "g",
   keyCode: 71,
   description: "Go to a HexDocs package",
   displayAs: "<kbd>g</kdb>",
   action: vt
  }, {
   name: "?",
   keyCode: 191,
   requiresShiftKey: !0,
   displayAs: "<kbd>?</kbd>",
   description: "Bring up this help dialog",
   action: function() {
    p()(Tt).is(":visible") ? At() : jt()
   }
  }],
  Ot = null;

 function At() {
  p()(Tt).hide()
 }

 function jt() {
  p()(Tt).show().focus()
 }

 function Dt() {
  Be(), At(), je.focus(), event.preventDefault()
 }

 function Lt() {
  var e = Ct()({
   shortcuts: Nt
  });
  p()("body").append(e), p()(Tt).on("keydown", function(e) {
   27 === e.keyCode && At()
  }), p()(Tt).on("click", ".modal-close", function() {
   At()
  }), p()("footer").on("click", ".display-shortcuts-help", function() {
   jt()
  }), p()(document).on("keydown", function(e) {
   ! function(e) {
    var t = e.target.tagName.toLowerCase(),
     n = e.keyCode,
     r = e.shiftKey;
    if (!Ot && !(0 <= St.indexOf(t) || e.ctrlKey || e.metaKey || e.altKey)) {
     var i = Q()(Nt, function(e) {
      var t = !!e.requiresShiftKey;
      return e.keyCode === n && t === r
     });
     i && (Ot = i).action(e)
    }
   }(e)
  }), p()(document).on("keyup", function(e) {
   Ot = null
  })
 }
 var Rt = n(35),
  Pt = n.n(Rt),
  Mt = n(36),
  It = n.n(Mt),
  qt = "#tooltip",
  Bt = "#tooltip .tooltip-iframe",
  Qt = "body .content-inner",
  Ht = 10,
  Ft = 5 * Ht,
  $t = {
   height: 450,
   width: 768
  },
  zt = 100,
  Wt = [{
   description: "Basic type",
   href: "typespecs.html#basic-types"
  }, {
   description: "Literal",
   href: "typespecs.html#literals"
  }, {
   description: "Built-in type",
   href: "typespecs.html#built-in-types"
  }],
  Ut = ".tooltips-toggle",
  Vt = "tooltipsDisabled",
  Gt = "#content",
  Kt = "allow-scripts allow-same-origin",
  Xt = null,
  Zt = null,
  Jt = null,
  Yt = null,
  en = null,
  tn = null;

 function nn() {
  try {
   return !!localStorage.getItem(Vt)
  } catch (e) {}
  return !1
 }

 function rn() {
  nn() ? function() {
   try {
    localStorage.removeItem(Vt)
   } catch (e) {}
   an()
  }() : function() {
   try {
    localStorage.setItem(Vt, !0)
   } catch (e) {}
   an()
  }()
 }

 function an() {
  p()(Ut).attr("data-is-disabled", nn().toString())
 }

 function on(e) {
  var t;
  (t = e.data.href, Jt === t || dn(t, Jt)) && (!0 === e.data.ready && cn(e.data.hint))
 }

 function sn() {
  nn() || window.innerWidth < $t.width || window.innerHeight < $t.height || ("A" !== (Zt = p()(this)).prop("tagName") && (Zt = p()(this).parent()), tn = setTimeout(function() {
   en && clearTimeout(en), Xt.removeClass("tooltip-visible"), Xt.removeClass("tooltip-shown"),
    function() {
     if (un(), !Zt) return;
     var e = Zt.attr("href");
     if (!e) return;
     "#" === e.charAt(0) && (e = "".concat(window.location.pathname).concat(e));
     if (t = e, t = t.replace(Gt, ""), dn(window.location.pathname, t)) return;
     var t;
     var n = (r = e, Q()(Wt, function(e) {
      return 0 <= r.indexOf(e.href)
     }));
     var r;
     if (n) cn({
      kind: "type",
      description: n.description
     });
     else {
      var i = e.replace(".html", ".html?hint=true");
      Jt = i;
      var a = p()(Bt).detach();
      a.attr("src", i), a.attr("sandbox", Kt), Xt.append(a)
     }
    }()
  }, zt))
 }

 function ln() {
  nn() || (Yt && clearTimeout(Yt), tn && clearTimeout(tn), Zt = null, Xt.removeClass("tooltip-shown"), en = setTimeout(function() {
   Xt.removeClass("tooltip-visible")
  }, 300))
 }

 function un() {
  if (Zt) {
   var e, t, n, r, i, a = p()(qt),
    o = Zt[0].getBoundingClientRect(),
    s = p()(Qt)[0].getBoundingClientRect(),
    l = a[0].getBoundingClientRect().width,
    u = (t = s, {
     top: (e = o).top - t.top,
     bottom: e.bottom - t.top,
     left: e.left - t.left,
     right: e.right - t.left,
     x: e.x - t.x,
     y: e.y - t.y,
     width: e.width,
     height: e.height
    }),
    c = (n = u, i = s, {
     left: (r = o).x,
     right: i.width - r.x + r.width,
     top: n.y - window.scrollY,
     bottom: window.innerHeight - (n.y - window.scrollY) + n.height
    });
   if (c.left + l + Ht < window.innerWidth) a.css("left", u.left), a.css("right", "auto");
   else {
    var d = u.right - l;
    d < Ht && (d = Ht), a.css("left", d), a.css("right", "auto")
   }
   var f = a[0].getBoundingClientRect().height;
   f + Ft < c.bottom ? a.css("top", u.bottom + Ht) : a.css("top", u.top - f - Ht)
  }
 }

 function cn(e) {
  var t = Pt()({
   isModule: "module" === e.kind,
   isType: "type" === e.kind,
   hint: e
  });
  Xt.find(".tooltip-body").html(t), Xt.addClass("tooltip-visible"), un(), Yt = setTimeout(function() {
   Xt.addClass("tooltip-shown")
  }, 10)
 }

 function dn(e, t) {
  return e.substring(e.length - t.length, e.length) === t
 }
 var fn = ".content-inner",
  pn = 'meta[name="project"]',
  hn = {
   hint: {},
   ready: !1,
   href: ""
  };

 function gn() {
  var e = new URLSearchParams(window.location.search),
   t = window.location.hash,
   n = p()(fn),
   r = null;
  if (e.has("hint")) {
   var i, a, o, s, l, u, c, d = function(e) {
    if (!e) return null;
    if (!(e = e.substr(1))) return null;
    if (e = decodeURI(e), !(e = p.a.escapeSelector(e))) return null;
    var t = p()("#".concat(e, ".detail"));
    return 0 < t.length ? t : p()(".detail > span#".concat(e)).parent()
   }(t);
   if (d && 0 < d.length ? (o = (a = d).find(".specs").text(), s = a.find("h1").text(), l = a.find(".docstring > p:first").text(), r = {
     kind: "function",
     title: s.trim(),
     signatureSpecs: o.trim(),
     description: l.trim()
    }) : 0 < p()(fn).find("#moduledoc").length && ((i = n).find("h1:first > *").remove(), r = {
     kind: "module",
     title: i.find("h1:first").text().trim(),
     description: i.find("#moduledoc p:first").text().trim()
    }), r) r.version = p()(pn).attr("content"), u = r, c = window.location.href, window.self !== window.parent && (hn.hint = u, hn.ready = !0, hn.href = c, window.parent.postMessage(hn, "*"))
  }
 }
 window.$ = p.a, p()(function() {
  a.a.registerHelper("isArray", j.default), a.a.registerHelper("isLocal", D.default), a.a.registerHelper("isNonEmptyArray", L.default), a.a.registerHelper("groupChanged", R.default), a.a.registerHelper("nestingChanged", P.default), a.a.registerHelper("showSummary", M.default), s.a.configure({
    tabReplace: "    ",
    languages: []
   }), s.a.registerLanguage("bash", u.a), s.a.registerLanguage("css", d.a), s.a.registerLanguage("diff", h.a), s.a.registerLanguage("erlang", m.a), s.a.registerLanguage("erlang-repl", y.a), s.a.registerLanguage("http", x.a), s.a.registerLanguage("javascript", _.a), s.a.registerLanguage("json", k.a), s.a.registerLanguage("markdown", T.a), s.a.registerLanguage("sql", N.a), s.a.registerLanguage("xml", A.a), Je(),
   function() {
    He();
    var e = window.innerWidth;
    p()(window).resize(Oe()(function() {
     e !== window.innerWidth && (e = window.innerWidth, He())
    }, 100)), p()(".sidebar-toggle").click(function() {
     Qe()
    })
   }(), Ve(), Te(), Object(Ye.a)(), Lt(), Et(), window.addEventListener("message", on, !1), p()(Qt).append(It()()), Xt = p()(qt), p()(".content a, .detail-header .specs a").hover(sn, ln), p()("footer").on("click", Ut, function() {
    rn()
   }), an(), p()(document).ready(function() {
    gn()
   }), s.a.initHighlighting()
 })
}]);