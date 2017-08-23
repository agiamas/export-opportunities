var ukti = window.ukti || {};

ukti.Utilities = (function($) {
  'use strict';

  var closestByClass = function (el, className) {
		while (el.className && el.className.indexOf(className) < 0) {
			el = el.parentNode;
			if (!el) {
				return null;
			}
		}
		return el;
  };

	var isValueEmpty = function (value) {
		return (/^ *$/.test(value));
	};

  return {
    closestByClass: closestByClass,
    isValueEmpty: isValueEmpty
  };

})();

