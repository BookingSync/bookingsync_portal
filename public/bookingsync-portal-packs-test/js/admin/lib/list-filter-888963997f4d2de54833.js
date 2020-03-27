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
/******/ 	return __webpack_require__(__webpack_require__.s = "./app/javascript/packs/admin/lib/list-filter.js.coffee");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./app/javascript/packs/admin/lib/list-filter.js.coffee":
/*!**************************************************************!*\
  !*** ./app/javascript/packs/admin/lib/list-filter.js.coffee ***!
  \**************************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

this.ListFilter = (function() {
  function ListFilter(header, list, listElement, listFilterable, inputId, formTemplate) {
    this.listElement = listElement;
    this.listFilterable = listFilterable;
    this.inputId = inputId;
    this.header = $(header);
    this.list = $(list);
    this.form = $(formTemplate);
    this.insertForm();
    this.observeInputChanges();
  }

  ListFilter.prototype.insertForm = function() {
    this.form.appendTo(this.header);
    return this.input = $("#" + this.inputId);
  };

  ListFilter.prototype.observeInputChanges = function() {
    return this.input.change((function(_this) {
      return function() {
        var filter;
        filter = $(event.target).val();
        _this.hideElements(_this.listFilterable + ":not(:Contains(" + filter + "))");
        _this.showElements(_this.listFilterable + ":Contains(" + filter + ")");
        return false;
      };
    })(this)).keyup((function(_this) {
      return function() {
        return _this.input.change();
      };
    })(this));
  };

  ListFilter.prototype.showElements = function(elements) {
    return this.list.find(elements).parents(this.listElement).show();
  };

  ListFilter.prototype.hideElements = function(elements) {
    return this.list.find(elements).parents(this.listElement).hide();
  };

  return ListFilter;

})();


/***/ })

/******/ });
//# sourceMappingURL=list-filter-888963997f4d2de54833.js.map