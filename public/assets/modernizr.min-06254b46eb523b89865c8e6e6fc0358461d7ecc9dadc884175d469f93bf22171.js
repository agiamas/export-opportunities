/*! modernizr 3.3.1 (Custom Build) | MIT *
 * http://modernizr.com/download/?-flexbox-input-matchmedia-picture-placeholder-srcset-svg-mq-setclasses-shiv !*/

!function(a, b, c) {
    function d(a, b) {
        return typeof a === b;
    }
    function e() {
        var a, b, c, e, f, g, h;
        for (var i in t) if (t.hasOwnProperty(i)) {
            if (a = [], b = t[i], b.name && (a.push(b.name.toLowerCase()), b.options && b.options.aliases && b.options.aliases.length)) for (c = 0; c < b.options.aliases.length; c++) a.push(b.options.aliases[c].toLowerCase());
            for (e = d(b.fn, "function") ? b.fn() : b.fn, f = 0; f < a.length; f++) g = a[f], 
            h = g.split("."), 1 === h.length ? v[h[0]] = e : (!v[h[0]] || v[h[0]] instanceof Boolean || (v[h[0]] = new Boolean(v[h[0]])), 
            v[h[0]][h[1]] = e), s.push((e ? "" : "no-") + h.join("-"));
        }
    }
    function f(a) {
        var b = w.className, c = v._config.classPrefix || "";
        if (x && (b = b.baseVal), v._config.enableJSClass) {
            var d = new RegExp("(^|\\s)" + c + "no-js(\\s|$)");
            b = b.replace(d, "$1" + c + "js$2");
        }
        v._config.enableClasses && (b += " " + c + a.join(" " + c), x ? w.className.baseVal = b : w.className = b);
    }
    function g() {
        return "function" != typeof b.createElement ? b.createElement(arguments[0]) : x ? b.createElementNS.call(b, "http://www.w3.org/2000/svg", arguments[0]) : b.createElement.apply(b, arguments);
    }
    function h() {
        var a = b.body;
        return a || (a = g(x ? "svg" : "body"), a.fake = !0), a;
    }
    function i(a, c, d, e) {
        var f, i, j, k, l = "modernizr", m = g("div"), n = h();
        if (parseInt(d, 10)) for (;d--; ) j = g("div"), j.id = e ? e[d] : l + (d + 1), m.appendChild(j);
        return f = g("style"), f.type = "text/css", f.id = "s" + l, (n.fake ? n : m).appendChild(f), 
        n.appendChild(m), f.styleSheet ? f.styleSheet.cssText = a : f.appendChild(b.createTextNode(a)), 
        m.id = l, n.fake && (n.style.background = "", n.style.overflow = "hidden", k = w.style.overflow, 
        w.style.overflow = "hidden", w.appendChild(n)), i = c(m, a), n.fake ? (n.parentNode.removeChild(n), 
        w.style.overflow = k, w.offsetHeight) : m.parentNode.removeChild(m), !!i;
    }
    function j(a) {
        return a.replace(/([a-z])-([a-z])/g, function(a, b, c) {
            return b + c.toUpperCase();
        }).replace(/^-/, "");
    }
    function k(a, b) {
        return !!~("" + a).indexOf(b);
    }
    function l(a, b) {
        return function() {
            return a.apply(b, arguments);
        };
    }
    function m(a, b, c) {
        var e;
        for (var f in a) if (a[f] in b) return c === !1 ? a[f] : (e = b[a[f]], d(e, "function") ? l(e, c || b) : e);
        return !1;
    }
    function n(a) {
        return a.replace(/([A-Z])/g, function(a, b) {
            return "-" + b.toLowerCase();
        }).replace(/^ms-/, "-ms-");
    }
    function o(b, d) {
        var e = b.length;
        if ("CSS" in a && "supports" in a.CSS) {
            for (;e--; ) if (a.CSS.supports(n(b[e]), d)) return !0;
            return !1;
        }
        if ("CSSSupportsRule" in a) {
            for (var f = []; e--; ) f.push("(" + n(b[e]) + ":" + d + ")");
            return f = f.join(" or "), i("@supports (" + f + ") { #modernizr { position: absolute; } }", function(a) {
                return "absolute" == getComputedStyle(a, null).position;
            });
        }
        return c;
    }
    function p(a, b, e, f) {
        function h() {
            l && (delete H.style, delete H.modElem);
        }
        if (f = d(f, "undefined") ? !1 : f, !d(e, "undefined")) {
            var i = o(a, e);
            if (!d(i, "undefined")) return i;
        }
        for (var l, m, n, p, q, r = [ "modernizr", "tspan" ]; !H.style; ) l = !0, H.modElem = g(r.shift()), 
        H.style = H.modElem.style;
        for (n = a.length, m = 0; n > m; m++) if (p = a[m], q = H.style[p], k(p, "-") && (p = j(p)), 
        H.style[p] !== c) {
            if (f || d(e, "undefined")) return h(), "pfx" == b ? p : !0;
            try {
                H.style[p] = e;
            } catch (s) {}
            if (H.style[p] != q) return h(), "pfx" == b ? p : !0;
        }
        return h(), !1;
    }
    function q(a, b, c, e, f) {
        var g = a.charAt(0).toUpperCase() + a.slice(1), h = (a + " " + D.join(g + " ") + g).split(" ");
        return d(b, "string") || d(b, "undefined") ? p(h, b, e, f) : (h = (a + " " + F.join(g + " ") + g).split(" "), 
        m(h, b, c));
    }
    function r(a, b, d) {
        return q(a, c, c, b, d);
    }
    var s = [], t = [], u = {
        _version: "3.3.1",
        _config: {
            classPrefix: "",
            enableClasses: !0,
            enableJSClass: !0,
            usePrefixes: !0
        },
        _q: [],
        on: function(a, b) {
            var c = this;
            setTimeout(function() {
                b(c[a]);
            }, 0);
        },
        addTest: function(a, b, c) {
            t.push({
                name: a,
                fn: b,
                options: c
            });
        },
        addAsyncTest: function(a) {
            t.push({
                name: null,
                fn: a
            });
        }
    }, v = function() {};
    v.prototype = u, v = new v(), v.addTest("svg", !!b.createElementNS && !!b.createElementNS("http://www.w3.org/2000/svg", "svg").createSVGRect), 
    v.addTest("picture", "HTMLPictureElement" in a);
    var w = b.documentElement, x = "svg" === w.nodeName.toLowerCase();
    x || !function(a, b) {
        function c(a, b) {
            var c = a.createElement("p"), d = a.getElementsByTagName("head")[0] || a.documentElement;
            return c.innerHTML = "x<style>" + b + "</style>", d.insertBefore(c.lastChild, d.firstChild);
        }
        function d() {
            var a = t.elements;
            return "string" == typeof a ? a.split(" ") : a;
        }
        function e(a, b) {
            var c = t.elements;
            "string" != typeof c && (c = c.join(" ")), "string" != typeof a && (a = a.join(" ")), 
            t.elements = c + " " + a, j(b);
        }
        function f(a) {
            var b = s[a[q]];
            return b || (b = {}, r++, a[q] = r, s[r] = b), b;
        }
        function g(a, c, d) {
            if (c || (c = b), l) return c.createElement(a);
            d || (d = f(c));
            var e;
            return e = d.cache[a] ? d.cache[a].cloneNode() : p.test(a) ? (d.cache[a] = d.createElem(a)).cloneNode() : d.createElem(a), 
            !e.canHaveChildren || o.test(a) || e.tagUrn ? e : d.frag.appendChild(e);
        }
        function h(a, c) {
            if (a || (a = b), l) return a.createDocumentFragment();
            c = c || f(a);
            for (var e = c.frag.cloneNode(), g = 0, h = d(), i = h.length; i > g; g++) e.createElement(h[g]);
            return e;
        }
        function i(a, b) {
            b.cache || (b.cache = {}, b.createElem = a.createElement, b.createFrag = a.createDocumentFragment, 
            b.frag = b.createFrag()), a.createElement = function(c) {
                return t.shivMethods ? g(c, a, b) : b.createElem(c);
            }, a.createDocumentFragment = Function("h,f", "return function(){var n=f.cloneNode(),c=n.createElement;h.shivMethods&&(" + d().join().replace(/[\w\-:]+/g, function(a) {
                return b.createElem(a), b.frag.createElement(a), 'c("' + a + '")';
            }) + ");return n}")(t, b.frag);
        }
        function j(a) {
            a || (a = b);
            var d = f(a);
            return !t.shivCSS || k || d.hasCSS || (d.hasCSS = !!c(a, "article,aside,dialog,figcaption,figure,footer,header,hgroup,main,nav,section{display:block}mark{background:#FF0;color:#000}template{display:none}")), 
            l || i(a, d), a;
        }
        var k, l, m = "3.7.3", n = a.html5 || {}, o = /^<|^(?:button|map|select|textarea|object|iframe|option|optgroup)$/i, p = /^(?:a|b|code|div|fieldset|h1|h2|h3|h4|h5|h6|i|label|li|ol|p|q|span|strong|style|table|tbody|td|th|tr|ul)$/i, q = "_html5shiv", r = 0, s = {};
        !function() {
            try {
                var a = b.createElement("a");
                a.innerHTML = "<xyz></xyz>", k = "hidden" in a, l = 1 == a.childNodes.length || function() {
                    b.createElement("a");
                    var a = b.createDocumentFragment();
                    return "undefined" == typeof a.cloneNode || "undefined" == typeof a.createDocumentFragment || "undefined" == typeof a.createElement;
                }();
            } catch (c) {
                k = !0, l = !0;
            }
        }();
        var t = {
            elements: n.elements || "abbr article aside audio bdi canvas data datalist details dialog figcaption figure footer header hgroup main mark meter nav output picture progress section summary template time video",
            version: m,
            shivCSS: n.shivCSS !== !1,
            supportsUnknownElements: l,
            shivMethods: n.shivMethods !== !1,
            type: "default",
            shivDocument: j,
            createElement: g,
            createDocumentFragment: h,
            addElements: e
        };
        a.html5 = t, j(b), "object" == typeof module && module.exports && (module.exports = t);
    }("undefined" != typeof a ? a : this, b), v.addTest("placeholder", "placeholder" in g("input") && "placeholder" in g("textarea")), 
    v.addTest("srcset", "srcset" in g("img"));
    var y = g("input"), z = "autocomplete autofocus list placeholder max min multiple pattern required step".split(" "), A = {};
    v.input = function(b) {
        for (var c = 0, d = b.length; d > c; c++) A[b[c]] = !!(b[c] in y);
        return A.list && (A.list = !(!g("datalist") || !a.HTMLDataListElement)), A;
    }(z);
    var B = function() {
        var b = a.matchMedia || a.msMatchMedia;
        return b ? function(a) {
            var c = b(a);
            return c && c.matches || !1;
        } : function(b) {
            var c = !1;
            return i("@media " + b + " { #modernizr { position: absolute; } }", function(b) {
                c = "absolute" == (a.getComputedStyle ? a.getComputedStyle(b, null) : b.currentStyle).position;
            }), c;
        };
    }();
    u.mq = B;
    var C = "Moz O ms Webkit", D = u._config.usePrefixes ? C.split(" ") : [];
    u._cssomPrefixes = D;
    var E = function(b) {
        var d, e = prefixes.length, f = a.CSSRule;
        if ("undefined" == typeof f) return c;
        if (!b) return !1;
        if (b = b.replace(/^@/, ""), d = b.replace(/-/g, "_").toUpperCase() + "_RULE", d in f) return "@" + b;
        for (var g = 0; e > g; g++) {
            var h = prefixes[g], i = h.toUpperCase() + "_" + d;
            if (i in f) return "@-" + h.toLowerCase() + "-" + b;
        }
        return !1;
    };
    u.atRule = E;
    var F = u._config.usePrefixes ? C.toLowerCase().split(" ") : [];
    u._domPrefixes = F;
    var G = {
        elem: g("modernizr")
    };
    v._q.push(function() {
        delete G.elem;
    });
    var H = {
        style: G.elem.style
    };
    v._q.unshift(function() {
        delete H.style;
    }), u.testAllProps = q, u.testAllProps = r, v.addTest("flexbox", r("flexBasis", "1px", !0));
    var I = u.prefixed = function(a, b, c) {
        return 0 === a.indexOf("@") ? E(a) : (-1 != a.indexOf("-") && (a = j(a)), b ? q(a, b, c) : q(a, "pfx"));
    };
    v.addTest("matchmedia", !!I("matchMedia", a)), e(), f(s), delete u.addTest, delete u.addAsyncTest;
    for (var J = 0; J < v._q.length; J++) v._q[J]();
    a.Modernizr = v;
}(window, document);
//# sourceMappingURL=modernizr.min.js.map
;
