/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/bookingsync-portal-packs-test/";
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/admin/application.coffee");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/admin/application.coffee":
/*!*******************************************************!*\
  !*** ./app/javascript/packs/admin/application.coffee ***!
  \*******************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

window.extractIdFromDomId = function(attribute) {
  if (attribute) {
    return attribute.split("_").pop();
  }
};

$.fn.extend({
  draggableRental: function() {
    var settings;
    settings = {
      revert: "invalid",
      zIndex: 50,
      revertDuration: 100,
      cursor: "move",
      containment: '.rentals-container',
      appendTo: '.rentals-container',
      helper: "clone",
      scroll: false,
      start: function(e, ui) {
        return $(ui.helper).addClass("ui-draggable-helper");
      }
    };
    return this.each(function() {
      return $(this).draggable(settings);
    });
  },
  droppableRemoteRental: function() {
    var settings;
    settings = {
      accept: ".bookingsync-rental",
      activeClass: "dropzone-active",
      hoverClass: "dropzone-hover",
      greedy: true,
      tolerance: "pointer",
      drop: function(event, ui) {
        var connect_url, postData, remoteAccountId, remoteRentalDropZone, remoteRentalId, rentalId;
        remoteRentalDropZone = $(this);
        rentalId = extractIdFromDomId($(ui.draggable).attr("id"));
        remoteRentalId = extractIdFromDomId(remoteRentalDropZone.attr("id"));
        remoteAccountId = remoteRentalDropZone.data("remote-account-id");
        if (remoteRentalId) {
          postData = {
            "rental_id": rentalId,
            "remote_rental_id": remoteRentalId
          };
        } else {
          postData = {
            "rental_id": rentalId,
            "remote_account_id": remoteAccountId
          };
          remoteRentalDropZone.clone().insertBefore(remoteRentalDropZone).addClass('new_rental_placeholder');
        }
        $(ui.draggable).remove();
        connect_url = $('.remote-rentals-list.rentals-list').data('connect-url');
        return $.ajax({
          url: connect_url,
          type: "POST",
          data: postData,
          dataType: 'script',
          beforeSend: function() {
            return $(this).addClass('loading');
          },
          success: function() {
            return $(this).removeClass('loading');
          }
        });
      }
    };
    return this.each(function() {
      return $(this).droppable(settings);
    });
  }
});


/***/ })

/******/ });
//# sourceMappingURL=application-93d480d788622d4fd6d0.js.map