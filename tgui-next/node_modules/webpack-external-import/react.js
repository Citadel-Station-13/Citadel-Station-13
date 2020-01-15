"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _react = _interopRequireWildcard(require("react"));

var _propTypes = _interopRequireDefault(require("prop-types"));

require("./polyfill");

var _this = void 0;

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; if (obj != null) { var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance"); }

function _iterableToArrayLimit(arr, i) { if (!(Symbol.iterator in Object(arr) || Object.prototype.toString.call(arr) === "[object Arguments]")) { return; } var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function _objectWithoutProperties(source, excluded) { if (source == null) return {}; var target = _objectWithoutPropertiesLoose(source, excluded); var key, i; if (Object.getOwnPropertySymbols) { var sourceSymbolKeys = Object.getOwnPropertySymbols(source); for (i = 0; i < sourceSymbolKeys.length; i++) { key = sourceSymbolKeys[i]; if (excluded.indexOf(key) >= 0) continue; if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue; target[key] = source[key]; } } return target; }

function _objectWithoutPropertiesLoose(source, excluded) { if (source == null) return {}; var target = {}; var sourceKeys = Object.keys(source); var key, i; for (i = 0; i < sourceKeys.length; i++) { key = sourceKeys[i]; if (excluded.indexOf(key) >= 0) continue; target[key] = source[key]; } return target; }

var ExternalComponent = function ExternalComponent(props) {
  var src = props.src,
      module = props.module,
      exportName = props["export"],
      cors = props.cors,
      rest = _objectWithoutProperties(props, ["src", "module", "export", "cors"]);

  var Component = null;

  var _useState = (0, _react.useState)(false),
      _useState2 = _slicedToArray(_useState, 2),
      loaded = _useState2[0],
      setLoaded = _useState2[1];

  var importPromise = (0, _react.useCallback)(function () {
    var isPromise = src instanceof Promise;
    if (!src) return Promise.reject();

    if (_this.props.cors) {
      if (isPromise) {
        return src.then(function (src) {
          return require('./corsImport')["default"](src);
        });
      }

      return require('./corsImport')["default"](src);
    }

    if (isPromise) {
      return src.then(function (src) {
        return new Promise(function (resolve) {
          resolve(new Function("return import(\"".concat(src, "\")"))());
        });
      });
    }

    return new Promise(function (resolve) {
      resolve(new Function("return import(\"".concat(src, "\")"))());
    });
  }, [src, cors]);
  (0, _react.useEffect)(function () {
    require('./polyfill');

    if (!src) {
      throw new Error("dynamic-import: no url ".concat(JSON.stringify(props, null, 2)));
    }

    importPromise(src).then(function () {
      // patch into loadable
      if (window.__LOADABLE_LOADED_CHUNKS__) {
        window.webpackJsonp.forEach(function (item) {
          window.__LOADABLE_LOADED_CHUNKS__.push(item);
        });
      }

      var requiredComponent = __webpack_require__(module);

      Component = requiredComponent["default"] ? requiredComponent["default"] : requiredComponent[exportName];
      setLoaded(true);
    })["catch"](function (e) {
      throw new Error("dynamic-import: ".concat(e.message));
    });
  }, []);
  if (!loaded) return null;
  return _react["default"].createElement(Component, rest);
};

ExternalComponent.propTypes = {
  src: _propTypes["default"].oneOfType([_propTypes["default"].func, _propTypes["default"].object, _propTypes["default"].string]).isRequired,
  module: _propTypes["default"].string.isRequired,
  cors: _propTypes["default"].bool,
  "export": _propTypes["default"].string
};
var _default = ExternalComponent;
exports["default"] = _default;