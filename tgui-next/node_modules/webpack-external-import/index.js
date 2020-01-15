"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
Object.defineProperty(exports, "corsImport", {
  enumerable: true,
  get: function get() {
    return _corsImport["default"];
  }
});
Object.defineProperty(exports, "ExternalComponent", {
  enumerable: true,
  get: function get() {
    return _react["default"];
  }
});
exports.importDependenciesOf = exports.importWithDependencies = exports.getChunkDependencies = exports.getChunkPath = void 0;

var _corsImport = _interopRequireDefault(require("./corsImport"));

var _react = _interopRequireDefault(require("./react"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

var getChunkPath = function getChunkPath(basePath, nameSpace, module) {
  var _window, _window2, _window3, _window4, _window5, _window6;

  if (!window.entryManifest) return;
  if (!nameSpace) return;
  if (!window.entryManifest[nameSpace]) return;
  var pathString = [];

  if (((_window = window) === null || _window === void 0 ? void 0 : _window.entryManifest[nameSpace]) && ((_window2 = window) === null || _window2 === void 0 ? void 0 : _window2.entryManifest[nameSpace][module]) && ((_window3 = window) === null || _window3 === void 0 ? void 0 : _window3.entryManifest[nameSpace][module].path)) {
    pathString = [basePath, window.entryManifest[nameSpace][module].path];
  } else if (((_window4 = window) === null || _window4 === void 0 ? void 0 : _window4.entryManifest[nameSpace]) && ((_window5 = window) === null || _window5 === void 0 ? void 0 : _window5.entryManifest[nameSpace]["".concat(module, ".js")]) && ((_window6 = window) === null || _window6 === void 0 ? void 0 : _window6.entryManifest[nameSpace]["".concat(module, ".js")].path)) {
    pathString = [basePath, window.entryManifest[nameSpace]["".concat(module, ".js")].path];
  }

  return pathString.join('');
};

exports.getChunkPath = getChunkPath;

var getChunkDependencies = function getChunkDependencies(basePath, nameSpace, module) {
  var _window7, _window8, _window9, _window10, _window11, _window12;

  if (!window.entryManifest) return;
  if (!nameSpace) return;
  if (!window.entryManifest[nameSpace]) return;
  var dependencyPaths = [];

  if (((_window7 = window) === null || _window7 === void 0 ? void 0 : _window7.entryManifest[nameSpace]) && ((_window8 = window) === null || _window8 === void 0 ? void 0 : _window8.entryManifest[nameSpace][module]) && ((_window9 = window) === null || _window9 === void 0 ? void 0 : _window9.entryManifest[nameSpace][module].dependencies)) {
    window.entryManifest[nameSpace][module].dependencies.forEach(function (file) {
      if (!__webpack_modules__[file.id]) {
        file.sourceFiles.forEach(function (chunkFile) {
          return dependencyPaths.push(basePath + chunkFile);
        });
      }
    });
  } else if (((_window10 = window) === null || _window10 === void 0 ? void 0 : _window10.entryManifest[nameSpace]) && ((_window11 = window) === null || _window11 === void 0 ? void 0 : _window11.entryManifest[nameSpace]["".concat(module, ".js")]) && ((_window12 = window) === null || _window12 === void 0 ? void 0 : _window12.entryManifest[nameSpace]["".concat(module, ".js")].dependencies)) {
    window.entryManifest[nameSpace]["".concat(module, ".js")].dependencies.forEach(function (file) {
      if (!__webpack_modules__[file.id]) {
        file.sourceFiles.forEach(function (chunkFile) {
          return dependencyPaths.push(basePath + chunkFile);
        });
      }
    });
  }

  return Array.from(new Set(dependencyPaths));
};

exports.getChunkDependencies = getChunkDependencies;

function getInSequence(array, asyncFunc) {
  return array.reduce(function (previous, current) {
    return previous.then(function (accumulator) {
      return asyncFunc(current).then(function (result) {
        return accumulator.concat(result);
      });
    });
  }, Promise.resolve([]));
}

var importWithDependencies = function importWithDependencies(basePath, nameSpace, module) {
  if (!window.entryManifest) return;
  if (!nameSpace) return;
  if (!window.entryManifest[nameSpace]) return;
  return getInSequence(getChunkDependencies(basePath, nameSpace, module), _corsImport["default"]).then(function () {
    return (0, _corsImport["default"])(getChunkPath(basePath, nameSpace, module));
  }); // window.entryManifest[nameSpace][module]
  // console.log('import with deps:')
};

exports.importWithDependencies = importWithDependencies;

var importDependenciesOf = function importDependenciesOf(basePath, nameSpace, module) {
  if (!window.entryManifest) return;
  if (!nameSpace) return;
  if (!window.entryManifest[nameSpace]) return;
  return getInSequence(getChunkDependencies(basePath, nameSpace, module), _corsImport["default"]).then(function () {
    return getChunkPath(basePath, nameSpace, module);
  }); // window.entryManifest[nameSpace][module]
  // console.log('import with deps:')
};

exports.importDependenciesOf = importDependenciesOf;