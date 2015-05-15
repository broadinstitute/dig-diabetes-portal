(function() {
    var testApp,
        __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

    testApp = angular.module("ChooserApp", []);

    testApp.factory("TimeFunctions", function() {
        return {
            HHMMSStoSeconds: function(HHMMSS) {
                var c, multiples, seconds, splits, _i, _len;
                if (HHMMSS == null) {
                    return false;
                }
                seconds = 0;
                splits = HHMMSS.split(":").reverse();
                multiples = [3600, 60, 1];
                for (_i = 0, _len = splits.length; _i < _len; _i++) {
                    c = splits[_i];
                    seconds += parseFloat(c) * multiples.pop();
                }
                return seconds;
            },
            lpad: function(value, totalLength) {
                value = value.toString();
                while (value.length < totalLength) {
                    value = '0' + value;
                }
                return value;
            },
            secondsToHHMMSS: function(i) {
                var h, m, s;
                h = i / 3600;
                m = (i % 3600) / 60;
                s = i % 60;
                return {
                    "hours": h,
                    "minutes": m,
                    "seconds": s,
                    "formatted": this.lpad(Math.floor(h), 1) + ":" + this.lpad(Math.floor(m), 2) + ":" + this.lpad(Math.floor(s), 2)
                };
            }
        };
    });

    testApp.directive("columnChooser", function() {
        return {
            restrict: "E",
            scope: false,
            templateUrl: "column-chooser-directive",
            link: function(scope, element, attrs) {
                return scope.refreshMarksGrid = function() {};
            }
        };
    });

    testApp.controller("ChooserController", [
        "$scope", "TimeFunctions", "$http", function($scope, TimeFunctions, $http) {
            var e, fullTextRegexTokens;
            $scope.tree = [];
            $scope.$ = $;
            $scope.view = {};
            $scope.view.showAdvancedSelector = true;
            $scope.search = {};
            $scope.search.currentQuery = {};
            fullTextRegexTokens = [];

            $scope.setColumnFilter = function($columns) {
                applyDatasetsFilter($columns);
            };

            $scope.getDatasetsFromQuery = function(query) {
                var array, dataset, e, element, elementsToRemove, index, k, newarray, removed_elements, v, value, _i, _j, _len, _len1;
                array = [];
                array = $scope.flattenTree($scope.tree);
                newarray = $scope.flattenTree($scope.tree);
                elementsToRemove = [];
                if (!$.isEmptyObject(query)) {
                    for (k in query) {
                        v = query[k];
                        if (!(v !== '')) {
                            continue;
                        }
                        index = 0;
                        for (_i = 0, _len = array.length; _i < _len; _i++) {
                            dataset = array[_i];
                            try {
                                if ((dataset[k] == null) || ($.isArray(dataset[k]) && __indexOf.call(dataset[k].concat((function() {
                                        var _j, _len1, _ref, _results;
                                        _ref = dataset[k];
                                        _results = [];
                                        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
                                            value = _ref[_j];
                                            if (value.name != null) {
                                                _results.push(value.name);
                                            }
                                        }
                                        return _results;
                                    })()), v) < 0) || (!$.isArray(dataset[k]) && v !== dataset[k])) {
                                    if (__indexOf.call(elementsToRemove, index) < 0) {
                                        elementsToRemove.push(index);
                                    }
                                } else {
                                    angular.noop();
                                }
                            } catch (_error) {
                                e = _error;
                                console.log("error " + (angular.toJson(e)) + " at " + index + " for " + k + " and value " + v);
                                if (__indexOf.call(elementsToRemove, index) < 0) {
                                    elementsToRemove.push(index);
                                }
                            }
                            index++;
                        }
                    }
                    removed_elements = 0;
                    elementsToRemove.sort(function(a, b) {
                        return a - b;
                    });
                    for (_j = 0, _len1 = elementsToRemove.length; _j < _len1; _j++) {
                        element = elementsToRemove[_j];
                        newarray.splice(element - removed_elements, 1);
                        removed_elements++;
                    }
                }
                return newarray;
            };
            $scope.toggleItems = function(items, setvalue) {
                var item, _i, _len;
                for (_i = 0, _len = items.length; _i < _len; _i++) {
                    item = items[_i];
                    item.selected = setvalue;
                }
            };
            $scope.toggleItem = function(item) {
                item.selected = (item.selected == null) || item.selected === false ? true : false;
            };

            $scope.getAllFilters = function(collection, known_filters) {
                var callback, filters;
                filters = {};
                callback = function(node, parent, ctrl) {
                    var k, v, v_v, value, _i, _len;
                    for (k in node) {
                        v = node[k];
                        if (!(k !== "sample_groups" && k !== "name" && k !== "id" && k !== "level" && k !== "selected" && k !== "properties")) {
                            continue;
                        }
                        if (!$.isArray(v)) {
                            v = [v];
                        }
                        for (_i = 0, _len = v.length; _i < _len; _i++) {
                            v_v = v[_i];
                            if (filters[k] == null) {
                                filters[k] = [];
                            }
                            value = angular.isObject(v_v) ? v_v.name : v_v;
                            if (__indexOf.call(filters[k], value) < 0) {
                                filters[k].push(value);
                            }
                        }
                    }
                };
                t.dfs(collection, {
                    "childrenName": "sample_groups"
                }, callback);
                return filters;
            };
            $scope.refineFilters = function(query) {
                var collection, new_filters;
                collection = $scope.getDatasetsFromQuery(query);
                new_filters = $scope.getAllFilters(collection);
                return new_filters;
            };
            $scope.assignAncestries = function(item) {
                var ancestries, ancestry, k, v, _i, _len, _results;
                ancestries = [
                    {
                        "_ea_": "East Asian"
                    }, {
                        "_sa_": "South Asian"
                    }, {
                        "_eu_": "European"
                    }, {
                        "_aa_": "African American"
                    }, {
                        "_hs_": "Hispanic"
                    }
                ];
                _results = [];
                for (_i = 0, _len = ancestries.length; _i < _len; _i++) {
                    ancestry = ancestries[_i];
                    _results.push((function() {
                        var _results1;
                        _results1 = [];
                        for (k in ancestry) {
                            v = ancestry[k];
                            if ((item.id != null) && item.id.indexOf(k) > -1) {
                                _results1.push(item.ancestry = v);
                            } else {
                                _results1.push(void 0);
                            }
                        }
                        return _results1;
                    })());
                }
                return _results;
            };
            $scope.propagateAttributes = function(tree) {
                var excludedAttributes, item, recursive, _i, _len;
                excludedAttributes = ["name", "sample_groups", "id", "level", "$$hashKey", "selected", "properties"];
                recursive = function(object, parent) {
                    var e, item, parent_k, parent_v, value, _i, _j, _len, _len1, _ref;
                    for (parent_k in parent) {
                        parent_v = parent[parent_k];
                        if (__indexOf.call(excludedAttributes, parent_k) < 0) {
                            if (object[parent_k] == null) {
                                object[parent_k] = parent_v;
                            } else {
                                if ($.isArray(object[parent_k]) === false) {
                                    object[parent_k] = [object[parent_k]];
                                }
                                if ($.isArray(parent_v) === false) {
                                    parent_v = [parent_v];
                                }
                                for (_i = 0, _len = parent_v.length; _i < _len; _i++) {
                                    value = parent_v[_i];
                                    try {
                                        if (__indexOf.call(object[parent_k], value) < 0) {
                                            if ($.isPlainObject(object[parent_k])) {
                                                object[parent_k] = object[parent_k].name.concat([value]);
                                            }
                                            else {
                                                object[parent_k] = object[parent_k].concat([value]);
                                            }
                                        }
                                    } catch (_error) {
                                        e = _error;
                                        console.log("propagation error in " + object.name + " " + parent_k + ": " + e.message + " for " + (angular.toJson(object[parent_k])));
                                    }
                                    if (object[parent_k].length === 1) {
                                        object[parent_k] = object[parent_k][0];
                                    }
                                }
                            }
                        }
                    }
                    if ((object.sample_groups != null) && object.sample_groups.length > 0) {
                        _ref = object.sample_groups;
                        for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
                            item = _ref[_j];
                            recursive(item, object);
                        }
                    } else {
                        return;
                    }
                };
                if ($.isArray(tree)) {
                    for (_i = 0, _len = tree.length; _i < _len; _i++) {
                        item = tree[_i];
                        recursive(item, null);
                    }
                } else if ($.isPlainObject(tree)) {
                    recursive(tree);
                }
                return tree;
            };
            $scope.flattenTree = function(tree) {
                var array, callback;
                callback = function(node, parent, control) {
                    array.push(node);
                };
                array = [];
                t.dfs(tree, {
                    "childrenName": "sample_groups"
                }, callback);
                return array;
            };
            $scope.getNodesAtLevel = function(level, collection) {
                var array, item, recursive, _i, _len;
                array = [];
                recursive = function(level, collection) {
                    var item, _i, _len, _ref;
                    if ((collection.level != null) && collection.level === level) {
                        array.push(collection);
                    }
                    if (collection.sample_groups != null) {
                        _ref = collection.sample_groups;
                        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                            item = _ref[_i];
                            recursive(level, item);
                        }
                    }
                };
                if ($.isArray(collection)) {
                    for (_i = 0, _len = collection.length; _i < _len; _i++) {
                        item = collection[_i];
                        recursive(level, item);
                    }
                } else if ($.isPlainObject(collection)) {
                    recursive(level, collection);
                }
                return array;
            };
            $scope.getLevels = function(collection) {
                var i, level, recursive, _i, _len;
                level = 1;
                recursive = function(item) {
                    var i, l, _i, _len, _ref;
                    if (item.level == null) {
                        item.level = level;
                    }
                    if (item.sample_groups != null) {
                        level++;
                        l = level;
                        _ref = item.sample_groups;
                        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                            i = _ref[_i];
                            level = l;
                            recursive(i);
                        }
                    }
                };
                if ($.isArray(collection)) {
                    for (_i = 0, _len = collection.length; _i < _len; _i++) {
                        i = collection[_i];
                        level = 1;
                        recursive(i);
                    }
                } else if ($.isPlainObject(collection)) {
                    recursive(collection);
                }
            };

            $scope.checkFilterMatch = function(item, filterObject) {
                var doesItMatch, e, k, v;
                doesItMatch = true;
                for (k in filterObject) {
                    v = filterObject[k];
                    if ((v != null) === true) {
                        try {
                            if (item.attributes[k] === v && doesItMatch === true) {
                                doesItMatch = true;
                            } else {
                                doesItMatch = false;
                            }
                        } catch (_error) {
                            e = _error;
                            console.log("filter error on " + item + " " + k);
                            doesItMatch = false;
                        }
                    }
                }
                return doesItMatch;
            };

            $scope.checkAttribute = function(item, attributeObject) {
                var k, v;
                for (k in attributeObject) {
                    v = attributeObject[k];
                    if ((item.attributes[k] != null) && item.attributes[k] && item.attributes[k] === v) {
                        return true;
                    }
                }
                return false;
            };
            $scope.checkIfSelectable = function(item) {
                return true;
            };
            $scope.updateSearchText = function() {
                var fullTextTokens, token, _i, _len;
                fullTextTokens = $scope.search.queryDatasetText != null ? $scope.search.queryDatasetText.match(/\w+|".*?"/g) : [];
                fullTextTokens = fullTextTokens != null ? fullTextTokens : [];
                fullTextRegexTokens = [];
                for (_i = 0, _len = fullTextTokens.length; _i < _len; _i++) {
                    token = fullTextTokens[_i];
                    fullTextRegexTokens.push(new RegExp('\\b' + token.replace(/"/gi, ""), 'i'));
                }
                return fullTextRegexTokens;
            };
            $scope.checkSearchTextMatch = function(item) {
                var doesItMatch, e, excludedAttributes, k, token, v, _i, _len;
                doesItMatch = false;
                if (fullTextRegexTokens.length === 0) {
                    doesItMatch = true;
                }
                excludedAttributes = ["sample_groups", "id", "level", "$$hashKey", "selected", "properties"];
                for (_i = 0, _len = fullTextRegexTokens.length; _i < _len; _i++) {
                    token = fullTextRegexTokens[_i];
                    try {
                        for (k in item) {
                            v = item[k];
                            if (__indexOf.call(excludedAttributes, k) < 0) {
                                if (token.test(v)) {
                                    doesItMatch = true;
                                }
                            }
                        }
                    } catch (_error) {
                        e = _error;
                        continue;
                    }
                }
                return doesItMatch;
            };
            $scope.selectMatches = function(tree, setvalue, attribute, value) {
                var criteria, flat, input, k, v, _i, _len, _results;
                criteria = {};
                criteria[attribute] = value;
                $scope.getLevels(tree);
                $scope.propagateAttributes(tree);
                flat = $scope.flattenTree(tree);
                _results = [];
                for (_i = 0, _len = flat.length; _i < _len; _i++) {
                    input = flat[_i];
                    _results.push((function() {
                        var _results1;
                        _results1 = [];
                        for (k in criteria) {
                            v = criteria[k];
                            if ((!$.isArray(input[k]) && input[k] === v) || ($.isArray(input[k]) && __indexOf.call(input[k], v) >= 0)) {
                                _results1.push(input.selected = setvalue);
                            } else {
                                _results1.push(void 0);
                            }
                        }
                        return _results1;
                    })());
                }
                return _results;
            };

            $scope.resetFilters = function() {
                $scope.search.currentQuery = {};
                $scope.view.filters = $scope.refineFilters($scope.search.currentQuery);
                $scope.queryDatasetText = null;
            };

            $scope.getSelectedSetNames = function(tree) {
                var selectedSets = $scope.getSelectedSets(tree);
                var setNames = [];
                for (var i = 0; i < selectedSets.length; i++) {
                    setNames.push(selectedSets[i].name);
                }
                return setNames;
            };

            $scope.getSelectedSets = function(tree) {
                var set;
                return (function() {
                    var _i, _len, _ref, _results;
                    _ref = $scope.flattenTree(tree);
                    _results = [];
                    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                        set = _ref[_i];
                        if (set.selected === true) {
                            _results.push(set);
                        }
                    }
                    return _results;
                })();
            };
            $scope.selectTextMatches = function(items) {
                var item;
                if (fullTextRegexTokens.length > 0) {
                    $scope.toggleItems((function() {
                        var _i, _len, _results;
                        _results = [];
                        for (_i = 0, _len = items.length; _i < _len; _i++) {
                            item = items[_i];
                            if ($scope.checkSearchTextMatch(item) === true) {
                                _results.push(item);
                            }
                        }
                        return _results;
                    })(), true);
                } else {
                    $scope.toggleItems(items, true);
                }
            };

            $scope.initializeData = function() {
                var item, _i, _len, _ref;
                $scope.getLevels($scope.tree);
                _ref = $scope.flattenTree($scope.tree);
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                    item = _ref[_i];
                    $scope.assignAncestries(item);
                }
                $scope.propagateAttributes($scope.tree);
                return $scope.view.filters = $scope.getAllFilters($scope.tree);
            };
            // todo fix url
            $http.get('/dig-diabetes-portal/resultsFilter/metadata')
                .success(function(data, status, headers, config) {
                    $scope.tree = angular.fromJson(data[0].experiments);
                    $scope.initializeData();
                })
                .error(function(data, status, headers, config) {
                    alert('Unable to query metadata due to ' + status + '. Please report the problem and try again later.');
                });
        }
    ]);

}).call(this);
