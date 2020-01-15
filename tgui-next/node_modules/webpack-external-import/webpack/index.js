"use strict";

function _slicedToArray(arr, i) { return _arrayWithHoles(arr) || _iterableToArrayLimit(arr, i) || _nonIterableRest(); }

function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance"); }

function _iterableToArrayLimit(arr, i) { if (!(Symbol.iterator in Object(arr) || Object.prototype.toString.call(arr) === "[object Arguments]")) { return; } var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"] != null) _i["return"](); } finally { if (_d) throw _e; } } return _arr; }

function _arrayWithHoles(arr) { if (Array.isArray(arr)) return arr; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(source, true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(source).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance"); }

function _iterableToArray(iter) { if (Symbol.iterator in Object(iter) || Object.prototype.toString.call(iter) === "[object Arguments]") return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = new Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } }

function _typeof(obj) { if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") { _typeof = function _typeof(obj) { return typeof obj; }; } else { _typeof = function _typeof(obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; } return _typeof(obj); }

var path = require('path');

var fse = require('fs-extra');

var createHash = require('webpack/lib/util/createHash');

var fs = require('fs');

function mergeDeep() {
  var isObject = function isObject(obj) {
    return obj && _typeof(obj) === 'object';
  };

  for (var _len = arguments.length, objects = new Array(_len), _key = 0; _key < _len; _key++) {
    objects[_key] = arguments[_key];
  }

  return objects.reduce(function (prev, obj) {
    Object.keys(obj).forEach(function (key) {
      var pVal = prev[key];
      var oVal = obj[key];

      if (Array.isArray(pVal) && Array.isArray(oVal)) {
        prev[key] = pVal.concat.apply(pVal, _toConsumableArray(oVal));
      } else if (isObject(pVal) && isObject(oVal)) {
        prev[key] = mergeDeep(pVal, oVal);
      } else {
        prev[key] = oVal;
      }
    });
    return prev;
  }, {});
}

var removeNull = function removeNull() {
  var nullCount = 0;
  var length = this.length;

  for (var i = 0, len = this.length; i < len; i++) {
    if (!this[i]) {
      nullCount++;
    }
  } // no item is null


  if (!nullCount) {
    return this;
  } // all items are null


  if (nullCount == length) {
    this.length = 0;
    return this;
  } // mix of null // non-null


  var idest = 0;
  var isrc = length - 1;
  length -= nullCount;

  while (true) {
    while (!this[isrc]) {
      isrc--;
      nullCount--;
    } // find a non null (source) slot on the right


    if (!nullCount) {
      break;
    } // break if found all null


    while (this[idest]) {
      idest++;
    } // find one null slot on the left (destination)
    // perform copy


    this[idest] = this[isrc];

    if (! --nullCount) {
      break;
    }

    idest++;
    isrc--;
  }

  this.length = length;
  return this;
};

Object.defineProperty(Array.prototype, 'removeNull', {
  value: removeNull,
  writable: true,
  configurable: true
});

function hasExternalizedModule(module) {
  var _module$originalSourc, _module$originalSourc2, _module$originalSourc3;

  var moduleSource = (module === null || module === void 0 ? void 0 : (_module$originalSourc = module.originalSource) === null || _module$originalSourc === void 0 ? void 0 : (_module$originalSourc2 = _module$originalSourc.call(module)) === null || _module$originalSourc2 === void 0 ? void 0 : (_module$originalSourc3 = _module$originalSourc2.source) === null || _module$originalSourc3 === void 0 ? void 0 : _module$originalSourc3.call(_module$originalSourc2)) || '';

  if ((moduleSource === null || moduleSource === void 0 ? void 0 : moduleSource.indexOf('externalize')) > -1 || false) {
    return moduleSource;
  }

  return false;
}

var interleaveConfig = function interleaveConfig(_test) {
  return {
    test: function test(module) {
      if (module.resource) {
        return module.resource.includes(_test) && !!hasExternalizedModule(module);
      }
    },
    name: function name(module, chunks, cacheGroupKey) {
      // dont chunk unless we are sure you can
      var moduleSource = hasExternalizedModule(module);

      if (moduleSource) {
        return moduleSource.match(/\/\*\s*externalize\s*:\s*(\S+)\s*\*\//)[1];
      } // returning a chunk name causes problems with mini-css popping chunks off
      // return 'main';

    },
    enforce: true // might need for next.js
    // reuseExistingChunk: false,

  };
};

function performInterleave() {}

var emitCountMap = new Map();

var URLImportPlugin =
/*#__PURE__*/
function () {
  function URLImportPlugin(opts) {
    _classCallCheck(this, URLImportPlugin);

    var debug = (typeof v8debug === "undefined" ? "undefined" : _typeof(v8debug)) === 'object' || /--debug|--inspect/.test(process.execArgv.join(' '));

    if (!opts.manifestName) {
      throw new Error('URLImportPlugin: You MUST specify a manifestName in your options. Something unique. Like {manifestName: my-special-build}');
    }

    this.opts = _objectSpread({
      publicPath: null,
      debug: debug || false,
      testPath: 'src',
      basePath: '',
      manifestName: 'unknown-project',
      fileName: 'importManifest.js',
      transformExtensions: /^(gz|map)$/i,
      writeToFileEmit: false,
      seed: null,
      filter: null,
      map: null,
      generate: null,
      hashDigest: 'base64',
      hashDigestLength: 10,
      context: null,
      sort: null,
      hashFunction: 'md4',
      serialize: function serialize(manifest) {
        return "if(!window.entryManifest) {window.entryManifest = {}}; window.entryManifest[\"".concat(opts.manifestName, "\"] = ").concat(JSON.stringify(manifest, null, 2));
      }
    }, opts || {});
  }

  _createClass(URLImportPlugin, [{
    key: "getFileType",
    value: function getFileType(str) {
      str = str.replace(/\?.*/, '');
      var split = str.split('.');
      var ext = split.pop();

      if (this.opts.transformExtensions.test(ext)) {
        ext = "".concat(split.pop(), ".").concat(ext);
      }

      return ext;
    }
  }, {
    key: "apply",
    value: function apply(compiler) {
      var _options$optimization,
          _options$optimization2,
          _options$optimization3,
          _this = this;

      if (this.opts.debug) {
        console.group('Webpack Plugin Debugging: webpack-external-import');
        console.info('To disable this, set plugin options {debug:false}');
      }

      var options = compiler === null || compiler === void 0 ? void 0 : compiler.options;
      var chunkSplitting = (options === null || options === void 0 ? void 0 : (_options$optimization = options.optimization) === null || _options$optimization === void 0 ? void 0 : (_options$optimization2 = _options$optimization.splitChunks) === null || _options$optimization2 === void 0 ? void 0 : _options$optimization2.cacheGroups) || {};
      chunkSplitting.interleave = interleaveConfig(this.opts.testPath); // dont rename exports when hoisting and tree shaking

      Object.assign(options.optimization, {
        providedExports: false
      });

      if (this.opts.debug) {
        console.groupCollapsed('interleaveConfig');
        console.log(chunkSplitting.interleave);
        console.groupEnd();
        console.groupCollapsed('New webpack optimization config');
      }

      mergeDeep(options, {
        optimization: {
          runtimeChunk: 'multiple',
          namedModules: true,
          splitChunks: {
            chunks: 'all',
            cacheGroups: chunkSplitting
          }
        }
      });
      Object.assign(options.optimization, {
        minimizer: this.opts.debug ? [] : options.optimization.minimizer,
        splitChunks: ((_options$optimization3 = options.optimization) === null || _options$optimization3 === void 0 ? void 0 : _options$optimization3.splitChunks) || {}
      }); // forcefully mutate it

      Object.assign(options.optimization.splitChunks, {
        chunks: 'all',
        cacheGroups: chunkSplitting,
        namedModules: true
      });

      if (this.opts.debug) {
        console.log(options);
        console.groupEnd();
      }

      compiler.hooks.thisCompilation.tap('URLImportPlugin', function (compilation) {// TODO: throw warning when changing module ID type
        // if (options.ignoreOrder) {
        //   compilation.warnings.push(
        //     new Error(
        //       `chunk ${chunk.name || chunk.id} [${pluginName}]\n`
        //           + 'Conflicting order between:\n'
        //           + ` * ${fallbackModule.readableIdentifier(
        //             requestShortener,
        //           )}\n`
        //           + `${bestMatchDeps
        //             .map(m => ` * ${m.readableIdentifier(requestShortener)}`)
        //             .join('\n')}`,
        //     ),
        //   );
        // }
      });
      var moduleAssets = {};
      var externalModules = {};
      var outputFolder = compiler.options.output.path;
      var outputFile = path.resolve(outputFolder, this.opts.fileName);
      var outputName = path.relative(outputFolder, outputFile);

      var moduleAsset = function moduleAsset(_ref, file) {
        var userRequest = _ref.userRequest;

        if (userRequest) {
          moduleAssets[file] = path.join(path.dirname(file), path.basename(userRequest));
        }
      };

      var emit = function emit(compilation, compileCallback) {
        var emitCount = emitCountMap.get(outputFile) - 1;
        emitCountMap.set(outputFile, emitCount);
        var seed = _this.opts.seed || {};
        var publicPath = _this.opts.publicPath != null ? _this.opts.publicPath : compilation.options.output.publicPath;
        var stats = compilation.getStats().toJson();

        if (_this.opts.debug) {
          console.groupCollapsed('Initial webpack stats');
          console.log(stats);
          console.groupEnd();
          console.group('Files');
        }

        var files = compilation.chunks.reduce(function (files, chunk) {
          return chunk.files.reduce(function (files, path) {
            var _dependencyChains$chu5, _dependencyChains$chu6, _dependencyChains$chu7, _dependencyChains$chu8;

            var name = chunk.name ? chunk.name : null;
            var dependencyChains = {};

            if (name) {
              name = "".concat(name, ".").concat(_this.getFileType(path));
            } else {
              // For nameless chunks, just map the files directly.
              name = path;
            }

            if (externalModules[chunk.id] || externalModules[chunk.name]) {
              if (_this.opts.debug) {
                console.groupCollapsed(chunk.id, chunk.name);
              } // TODO: swap forEachModle out with const of
              // for(const module of chunk.modulesIterable){


              chunk.forEachModule(function (module) {
                if (module.dependencies) {
                  if (_this.opts.debug) {
                    console.log(module);
                    console.group('Dependencies');
                  }

                  module.dependencies.forEach(function (dependency) {
                    var _dependency$getRefere, _dependency$getRefere2;

                    if (_this.opts.debug && (dependency.request || dependency.userRequest)) {
                      console.groupCollapsed('Dependency', dependency.userRequest, "(".concat(dependency.request, ")"));
                      console.log(dependency);
                    }

                    var dependencyModuleSet = (_dependency$getRefere = dependency.getReference) === null || _dependency$getRefere === void 0 ? void 0 : (_dependency$getRefere2 = _dependency$getRefere.call(dependency)) === null || _dependency$getRefere2 === void 0 ? void 0 : _dependency$getRefere2.module;
                    if (!dependencyModuleSet) return null;

                    if (_this.opts.debug) {
                      console.groupCollapsed('Dependency Reference');
                      console.log(dependencyModuleSet);
                      console.groupEnd();
                    }

                    if (!dependencyChains[chunk.id]) {
                      Object.assign(dependencyChains, _defineProperty({}, chunk.id, []));
                    }

                    var dependencyChainMap = dependencyChains[chunk.id][dependency.sourceOrder] = {};
                    Object.assign(dependencyChainMap, {
                      order: dependency.sourceOrder,
                      name: dependencyModuleSet.rawRequest,
                      id: dependencyModuleSet.id,
                      sourceFiles: []
                    });
                    var _iteratorNormalCompletion = true;
                    var _didIteratorError = false;
                    var _iteratorError = undefined;

                    try {
                      for (var _iterator = dependencyModuleSet.chunksIterable[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
                        var _module = _step.value;

                        if (_this.opts.debug) {
                          console.groupCollapsed('Dependency Reference Iterable', dependency.request);
                          console.groupEnd();
                        }

                        if (_module && _module.files) {
                          if (dependencyChains[chunk.id]) {
                            var _dependencyChainMap$s, _dependencyChainMap$s2;

                            dependencyChainMap.sourceFiles = (dependencyChainMap === null || dependencyChainMap === void 0 ? void 0 : (_dependencyChainMap$s = dependencyChainMap.sourceFiles) === null || _dependencyChainMap$s === void 0 ? void 0 : (_dependencyChainMap$s2 = _dependencyChainMap$s.concat) === null || _dependencyChainMap$s2 === void 0 ? void 0 : _dependencyChainMap$s2.call(_dependencyChainMap$s, _module.files)) || null;
                          } else {// Object.assign(dependencyChains, { [chunk.id]: module.files });
                          }
                        }
                      }
                    } catch (err) {
                      _didIteratorError = true;
                      _iteratorError = err;
                    } finally {
                      try {
                        if (!_iteratorNormalCompletion && _iterator["return"] != null) {
                          _iterator["return"]();
                        }
                      } finally {
                        if (_didIteratorError) {
                          throw _iteratorError;
                        }
                      }
                    }

                    if (_this.opts.debug) {
                      console.groupEnd();
                    }
                  });

                  if (_this.opts.debug) {
                    console.groupEnd();
                  }
                }
              });

              if (_this.opts.debug && !dependencyChains[chunk.id]) {
                console.groupEnd();
              }
            }

            var currentDependencyChain = [];

            if (dependencyChains[chunk.id]) {
              if (_this.opts.debug) {
                var _dependencyChains$chu, _dependencyChains$chu2, _dependencyChains$chu3, _dependencyChains$chu4;

                console.group('Computed Dependency Chain For:', chunk.id);
                currentDependencyChain = (dependencyChains === null || dependencyChains === void 0 ? void 0 : (_dependencyChains$chu = dependencyChains[chunk.id]) === null || _dependencyChains$chu === void 0 ? void 0 : (_dependencyChains$chu2 = _dependencyChains$chu.removeNull) === null || _dependencyChains$chu2 === void 0 ? void 0 : (_dependencyChains$chu3 = (_dependencyChains$chu4 = _dependencyChains$chu2.call(_dependencyChains$chu)).reverse) === null || _dependencyChains$chu3 === void 0 ? void 0 : _dependencyChains$chu3.call(_dependencyChains$chu4)) || [];
                console.log(currentDependencyChain);
                console.groupEnd();
                console.groupEnd();
              }
            } // Webpack 4: .isOnlyInitial()
            // Webpack 3: .isInitial()
            // Webpack 1/2: .initial
            // const modules = chunk.modulesIterable;
            // let i = 0;
            // while (i < modules.length) {
            //   getMeta(modules[i]);
            //   i++;
            // }


            return files.concat({
              path: path,
              chunk: chunk,
              name: name,
              dependencies: dependencyChains === null || dependencyChains === void 0 ? void 0 : (_dependencyChains$chu5 = dependencyChains[chunk.id]) === null || _dependencyChains$chu5 === void 0 ? void 0 : (_dependencyChains$chu6 = _dependencyChains$chu5.removeNull) === null || _dependencyChains$chu6 === void 0 ? void 0 : (_dependencyChains$chu7 = (_dependencyChains$chu8 = _dependencyChains$chu6.call(_dependencyChains$chu5)).reverse) === null || _dependencyChains$chu7 === void 0 ? void 0 : _dependencyChains$chu7.call(_dependencyChains$chu8),
              isInitial: chunk.isOnlyInitial ? chunk.isOnlyInitial() : chunk.isInitial ? chunk.isInitial() : chunk.initial,
              isChunk: true,
              isAsset: false,
              isModuleAsset: false
            });
          }, files);
        }, []); // module assets don't show up in assetsByChunkName.
        // we're getting them this way;

        files = stats.assets.reduce(function (files, asset) {
          var name = moduleAssets[asset.name];

          if (name) {
            return files.concat({
              path: asset.name,
              name: name,
              isInitial: false,
              isChunk: false,
              isAsset: true,
              isModuleAsset: true
            });
          }

          var isEntryAsset = asset.chunks.length > 0;

          if (isEntryAsset) {
            return files;
          }

          return files.concat({
            path: asset.name,
            name: asset.name,
            isInitial: false,
            isChunk: false,
            isAsset: true,
            isModuleAsset: false
          });
        }, files);
        files = files.filter(function (file) {
          // Don't add hot updates to manifest
          var isUpdateChunk = file.path.includes('hot-update'); // Don't add manifest from another instance

          var isManifest = emitCountMap.get(path.join(outputFolder, file.name)) !== undefined;
          return !isUpdateChunk && !isManifest;
        });

        if (_this.opts.debug) {
          console.log('Unprocessed Files:', files);
        } // Append optional basepath onto all references.
        // This allows output path to be reflected in the manifest.


        if (_this.opts.basePath) {
          files = files.map(function (file) {
            file.name = _this.opts.basePath + file.name;
            return file;
          });
        }

        if (publicPath) {
          // Similar to basePath but only affects the value (similar to how
          // output.publicPath turns require('foo/bar') into '/public/foo/bar', see
          // https://github.com/webpack/docs/wiki/configuration#outputpublicpath
          files = files.map(function (file) {
            file.path = publicPath + file.path;
            return file;
          });
        }

        files = files.map(function (file) {
          file.name = file.name.replace(/\\/g, '/');
          file.path = file.path.replace(/\\/g, '/');
          return file;
        });

        if (_this.opts.filter) {
          files = files.filter(_this.opts.filter);
        }

        if (_this.opts.map) {
          files = files.map(_this.opts.map);
        }

        if (_this.opts.sort) {
          files = files.sort(_this.opts.sort);
        }

        if (_this.opts.debug) {
          console.log('Processed Files:', files);
          console.groupEnd();
          console.groupEnd();
        }

        var manifest;

        if (_this.opts.generate) {
          manifest = _this.opts.generate(seed, files);
        } else {
          manifest = files.reduce(function (manifest, file) {
            manifest[file.name] = {
              path: file.path,
              dependencies: (file === null || file === void 0 ? void 0 : file.dependencies) || null,
              isInitial: (file === null || file === void 0 ? void 0 : file.isInitial) || null
            };
            return manifest;
          }, seed);
        }

        if (_this.opts.debug) {
          console.log('Manifest:', manifest);
        }

        var isLastEmit = emitCount === 0;

        if (isLastEmit) {
          var cleanedManifest = Object.entries(manifest).reduce(function (acc, _ref2) {
            var _asset$path;

            var _ref3 = _slicedToArray(_ref2, 2),
                key = _ref3[0],
                asset = _ref3[1];

            if (!(asset === null || asset === void 0 ? void 0 : (_asset$path = asset.path) === null || _asset$path === void 0 ? void 0 : _asset$path.includes('.map'))) {
              return Object.assign(acc, _defineProperty({}, key, asset));
            }

            return acc;
          }, {});

          var output = _this.opts.serialize(cleanedManifest);

          if (_this.opts.debug) {
            console.log('Output:', output);
          }

          compilation.assets[outputName] = {
            source: function source() {
              return output;
            },
            size: function size() {
              return output.length;
            }
          };

          if (_this.opts.writeToFileEmit) {
            fse.outputFileSync(outputFile, output);
          }
        }

        if (compiler.hooks) {
          compiler.hooks.webpackURLImportPluginAfterEmit.call(manifest);
        } else {
          compilation.applyPluginsAsync('webpack-manifest-plugin-after-emit', manifest, compileCallback);
        }
      };

      function beforeRun(compiler, callback) {
        var emitCount = emitCountMap.get(outputFile) || 0;
        emitCountMap.set(outputFile, emitCount + 1);

        if (callback) {
          callback();
        }
      }

      if (compiler.hooks) {
        var _require = require('tapable'),
            SyncWaterfallHook = _require.SyncWaterfallHook;

        var pluginOptions = {
          name: 'URLImportPlugin',
          stage: Infinity
        };
        compiler.hooks.webpackURLImportPluginAfterEmit = new SyncWaterfallHook(['manifest']);
        compiler.hooks.compilation.tap('URLImportPlugin', function (compilation) {
          var usedIds = new Set();
          compilation.hooks.beforeModuleIds.tap('URLImportPlugin', function (modules) {
            var _iteratorNormalCompletion2 = true;
            var _didIteratorError2 = false;
            var _iteratorError2 = undefined;

            try {
              for (var _iterator2 = modules[Symbol.iterator](), _step2; !(_iteratorNormalCompletion2 = (_step2 = _iterator2.next()).done); _iteratorNormalCompletion2 = true) {
                var _module2$originalSour, _module2$originalSour2, _module2$originalSour3;

                var _module2 = _step2.value;

                if (_module2.id === null && _module2.resource) {
                  var hash = createHash(_this.opts.hashFunction);
                  var resourcePath = _module2.resource;

                  if (resourcePath.indexOf('?') > -1) {
                    resourcePath = resourcePath.split('?')[0];
                  }

                  try {
                    hash.update(fs.readFileSync(resourcePath));
                  } catch (ex) {
                    console.error('failed on', _module2.context, _module2.resource);
                    throw ex;
                  }

                  var hashId = hash.digest(_this.opts.hashDigest);
                  var len = _this.opts.hashDigestLength;

                  while (usedIds.has(hashId.substr(0, len))) {
                    len++;
                  }

                  _module2.id = hashId.substr(0, len);
                  usedIds.add(_module2.id);
                }

                var moduleSource = (_module2 === null || _module2 === void 0 ? void 0 : (_module2$originalSour = _module2.originalSource) === null || _module2$originalSour === void 0 ? void 0 : (_module2$originalSour2 = (_module2$originalSour3 = _module2$originalSour.call(_module2)).source) === null || _module2$originalSour2 === void 0 ? void 0 : _module2$originalSour2.call(_module2$originalSour3)) || '';

                if ((moduleSource === null || moduleSource === void 0 ? void 0 : moduleSource.indexOf('externalize')) > -1 || false) {
                  var _module2$buildMeta;

                  _module2.buildMeta = mergeDeep(_module2.buildMeta, {
                    isExternalized: true
                  }); // add exports back to usedExports, prevents tree shaking on module

                  Object.assign(_module2, {
                    usedExports: (_module2 === null || _module2 === void 0 ? void 0 : (_module2$buildMeta = _module2.buildMeta) === null || _module2$buildMeta === void 0 ? void 0 : _module2$buildMeta.providedExports) || true
                  });

                  try {
                    // look at refactoring this to use buildMeta not mutate id
                    _module2.id = moduleSource.match(/\/\*\s*externalize\s*:\s*(\S+)\s*\*\//)[1];
                    externalModules[_module2.id] = {};
                  } catch (error) {
                    throw new Error('external-import', error.message);
                  }
                }
              }
            } catch (err) {
              _didIteratorError2 = true;
              _iteratorError2 = err;
            } finally {
              try {
                if (!_iteratorNormalCompletion2 && _iterator2["return"] != null) {
                  _iterator2["return"]();
                }
              } finally {
                if (_didIteratorError2) {
                  throw _iteratorError2;
                }
              }
            }
          });
        });
        compiler.hooks.compilation.tap(pluginOptions, function (_ref4) {
          var hooks = _ref4.hooks;
          hooks.moduleAsset.tap(pluginOptions, moduleAsset);
        });
        compiler.hooks.emit.tap(pluginOptions, emit);
        compiler.hooks.run.tap(pluginOptions, beforeRun);
        compiler.hooks.watchRun.tap(pluginOptions, beforeRun);
      } else {
        compiler.plugin('compilation', function (compilation) {
          compilation.plugin('module-asset', moduleAsset);
        });
        compiler.plugin('emit', emit);
        compiler.plugin('before-run', beforeRun);
        compiler.plugin('watch-run', beforeRun);
      }
    }
  }]);

  return URLImportPlugin;
}();

module.exports = URLImportPlugin;