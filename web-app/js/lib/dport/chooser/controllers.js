(function() {
    var datasetFilterApp,
        __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

    datasetFilterApp = angular.module("ChooserApp", []);

    datasetFilterApp.directive("columnChooser", function() {
        return {
            restrict: "E",
            scope: false,
            templateUrl: "column-chooser-directive",
            link: function(scope, element, attrs) {
                return scope.refreshMarksGrid = function() {};
            }
        };
    });

    datasetFilterApp.controller("ChooserController", [
        "$scope", "$http", function($scope, $http) {
            var e, fullTextRegexTokens;
            $scope.tree = [];
            $scope.treeLoading = true;
            $scope.$ = $;
            $scope.view = {};
            $scope.view.showAdvancedSelector = true;
            $scope.search = {};
            $scope.search.currentQuery = {
                version:'',
                ancestry:'',
                phenotypes:'',
                technology:''
            };
            $scope.selectedSets = [];
            fullTextRegexTokens = [];

            $scope.init = function(metadataUrl,
                                   selections) {
                $scope.metadataUrl = metadataUrl;
                $scope.setSelections(angular.fromJson(selections));
                var datasets = $scope.getDatasetsFromQuery($scope.search.currentQuery);
            };

            $scope.setSelections = function(selections) {
                $scope.datasetVersion = selections.datasetVersion;
                $scope.search.currentQuery.version = selections.datasetVersion;
                $scope.search.currentQuery.ancestry = selections.ancestry;
                $scope.search.currentQuery.phenotypes = selections.phenotypes;
                $scope.search.currentQuery.technology = selections.technology;
                $scope.selectedSets = selections.selectedSets;
            };

            $scope.setColumnFilter = function($columns,$filters) {
                applyDatasetsFilter($columns,$filters);
            };

            $scope.humanReadableDatasetName = function(id,unfriendlyName) {
                var name;
                var datasetMap = {
                    'ExSeq_17k_mdv2':'17K exome sequence analysis',
                    'ExSeq_17k_aa_mdv2':'17K exome sequence analysis: African-Americans',
                    'ExSeq_17k_aa_genes_mdv2':'17K exome sequence analysis: African-Americans, T2D-GENES cohorts',
                    'ExSeq_17k_aa_genes_aj_mdv2':'17K exome sequence analysis: African-Americans, Jackson Heart Study cohort',
                    'ExSeq_17k_aa_genes_aw_mdv2':'17K exome sequence analysis: African-Americans, Wake Forest Study cohort',
                    'ExSeq_17k_ea_genes_mdv2':'17K exome sequence analysis: East Asians',
                    'ExSeq_17k_ea_genes_ek_mdv2':'17K exome sequence analysis: East Asians, Korea Association Research Project (KARE) and Korean National Institute of Health (KNIH) cohort',
                    'ExSeq_17k_ea_genes_es_mdv2':'17K exome sequence analysis: East Asians, Singapore Diabetes Cohort Study and Singapore Prospective Study Program cohort',
                    'ExSeq_17k_eu_mdv2':'17K exome sequence analysis: Europeans',
                    'ExSeq_17k_eu_genes_mdv2':'17K exome sequence analysis: Europeans, T2D-GENES cohorts',
                    'ExSeq_17k_eu_genes_ua_mdv2':'17K exome sequence analysis: Europeans, Longevity Genes in Founder Populations (Ashkenazi) cohort',
                    'ExSeq_17k_eu_genes_um_mdv2':'17K exome sequence analysis: Europeans, Metabolic Syndrome in Men (METSIM) Study cohort',
                    'ExSeq_17k_eu_go_mdv2':'17K exome sequence analysis: Europeans, GoT2D cohorts',
                    'ExSeq_17k_hs_mdv2':'17K exome sequence analysis: Latinos',
                    'ExSeq_17k_hs_genes_mdv2':'17K exome sequence analysis: Latinos, T2D-GENES cohorts',
                    'ExSeq_17k_hs_genes_ha_mdv2':'17K exome sequence analysis: Latinos, San Antonio cohort',
                    'ExSeq_17k_hs_genes_hs_mdv2':'17K exome sequence analysis: Latinos, Starr County cohort',
                    'ExSeq_17k_hs_sigma_mdv2':'17K exome sequence analysis: Latinos, SIGMA cohorts',
                    'ExSeq_17k_hs_sigma_mec_mdv2':'17K exome sequence analysis: Multiethnic Cohort (MEC)',
                    'ExSeq_17k_hs_sigma_mexb1_mdv2':'17K exome sequence analysis: UNAM/INCMNSZ Diabetes Study (UIDS) cohort',
                    'ExSeq_17k_hs_sigma_mexb2_mdv2':'17K exome sequence analysis: Diabetes in Mexico Study (DMS) cohort',
                    'ExSeq_17k_hs_sigma_mexb3_mdv2':'17K exome sequence analysis: Mexico City Diabetes Study (MCDS) cohort',
                    'ExSeq_17k_sa_genes_mdv2':'17K exome sequence analysis: South Asians',
                    'ExSeq_17k_sa_genes_sl_mdv2':'17K exome sequence analysis: South Asians, LOLIPOP cohort',
                    'ExSeq_17k_sa_genes_ss_mdv2':'17K exome sequence analysis: South Asians, Singapore Indian Eye Study cohort',
                    'ExSeq_13k_mdv1':'13K exome sequence analysis',
                    'ExSeq_13k_aa_genes_mdv2':'13K exome sequence analysis: African-Americans',
                    'ExSeq_13k_ea_genes_mdv2':'13K exome sequence analysis: East Asians',
                    'ExSeq_13k_eu_genes_mdv2':'13K exome sequence analysis: Europeans, T2D-GENES cohorts',
                    'ExSeq_13k_hs_genes_mdv2':'13K exome sequence analysis: Latinos',
                    'ExSeq_13k_sa_genes_mdv2':'13K exome sequence analysis: South Asians',
                    'ExChip_82k_mdv2':'exome chip analysis'
                };
                if (datasetMap[id] != null) {
                    name = datasetMap[id];
                }
                else {
                    name = unfriendlyName;
                }
                return name;
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
                excludedAttributes = ["name", "sample_groups", "id", "level", "$$hashKey", "selected", "properties","ancestry"];
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
                $scope.search.currentQuery = {
                    version:'',
                    ancestry:'',
                    phenotypes:'',
                    technology:''
                };
                $scope.search.currentQuery.version = $scope.datasetVersion;
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

            // mark the dataset as selected if item.id was passed into ng-init
            $scope.selectDatasetIfChosenInPreviousSession = function(item) {
                $scope.selectedSets.forEach(function (selectedSet) {
                    if (item.id === selectedSet) {
                        item.selected = true;
                    }
                });
            };

            $scope.initializeData = function() {
                var item, _i, _len, _ref;
                $scope.getLevels($scope.tree);
                _ref = $scope.flattenTree($scope.tree);
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                    item = _ref[_i];
                    $scope.assignAncestries(item);
                    $scope.selectDatasetIfChosenInPreviousSession(item);
                }
                $scope.propagateAttributes($scope.tree);
                return $scope.view.filters = $scope.getAllFilters($scope.tree);
            };

            $scope.loadMetadata = function() {
                $http.get($scope.metadataUrl)
                    .success(function (data, status, headers, config) {
                        try {
                            $scope.treeLoading = false;
                            $scope.tree = angular.fromJson(data[0].experiments);
                            $scope.initializeData();
                            if ($scope.tree.length == 0) {
                                alert('No data returned from metadata query.  Please report the problem and try again later.');
                            }
                        }
                        catch(err) {
                            console.error(err);
                            alert('Unable to query metadata. Please report the problem and try again later.');

                        }
                    })
                    .error(function (data, status, headers, config) {
                        $scope.treeLoading = false;
                        if (status != 0) {
                            alert('Unable to query metadata due to ' + status + '. Please report the problem and try again later.');
                        }
                    });
            }
        }
    ]);

}).call(this);
