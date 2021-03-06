/* globals Cookies */

var ukti = window.ukti || {};

ukti.ToggleFieldEdit = (function(Cookies) {
    'use strict';
    var baseEl,
        labelEl,
        buttonEl,
        textEl,
        fieldElWrapper,
        fieldEl,
        hiddenClass = 'js-hidden';

    var cacheElements = function (el) {
      baseEl = el;
      labelEl = baseEl.querySelector( '.form-label' );
      buttonEl = baseEl.querySelector( '.js-toggle-field-edit-button' );
      textEl = baseEl.querySelector( '.js-toggle-field-edit-text' );
      fieldElWrapper = baseEl.querySelector( '.js-toggle-field-edit-field' );
      fieldEl = baseEl.querySelector( 'textarea' );
    };

    var handleToggle = function (event) {
      event.preventDefault();
      textEl.classList.toggle(hiddenClass);
      fieldElWrapper.classList.toggle(hiddenClass);
    };

    var handleChange = function (event) {
      var fieldValue = event.target.value;
      Cookies.set('last_enquiry_response_signature', fieldValue);
      updateText();
    };

    var setup = function () {
      var text = Cookies.get('last_enquiry_response_signature');
      if (text && !ukti.Utilities.isValueEmpty(text)) {
        hasSignatureValue();
      } else {
        noSignatureValue();
      }
    };

    var hasSignatureValue = function () {
      fieldElWrapper.classList.add(hiddenClass);
      updateText();
      updateField();
    };

    var noSignatureValue = function () {
      textEl.classList.add(hiddenClass);
      buttonEl.classList.add(hiddenClass);
      fieldEl.value = '[full name],</br>[role],</br>[organisation name],</br>[city & country],</br>[phone number],</br>[email]';
    };

    var updateText = function () {
      var text = Cookies.get('last_enquiry_response_signature');
      textEl.querySelector( '.white-space-pre' ).innerHTML = text;
    };

    var updateField = function () {
      var text = Cookies.get('last_enquiry_response_signature');
      fieldEl.value = text;
    };

    var attachBehaviour = function() {
      buttonEl.addEventListener('click', handleToggle, false);
      fieldEl.addEventListener('change', handleChange, false);
    };

    var init = function (el) {
      cacheElements(el);
      setup();
      attachBehaviour();
    };

    return {
      init: init
    };

})(Cookies);