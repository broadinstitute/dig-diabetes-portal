<!DOCTYPE html>
<html lang="en" ng-app="ChooserApp" ng-controller="ChooserController">

<body>

<script id='column-chooser-directive' type='text/ng-template'>
<div class='column-chooser-container container-fluid'>
    <div class='column-chooser inline panel'>
        <div class='row'>
            <div class='iconbutton' data-dismiss='modal' ng-click='view.showAdvancedSelector = false'>
                <div class='glyphicon glyphicon-remove pull-right'></div>
            </div>
        </div>
        <div class='row'>
            <div class='col-md-12'>
                <h2>Choose custom columns to display in results table</h2>
                <p>Your results include variants from the datasets you selected above. The table of these variants will automatically show results (e.g., p-value, effect size) from your selected datasets and, for comparison, the largest dataset for your data type that is available through this portal. If variants in your table were genotyped in other studies, you can view results from those studies as well by adding a column for each study using these tools.</p>
            </div>
        </div>
        <!-- This is a chunk that just creates filters based upon an enumeration of the possible filters -->
        <div class='dynamicfilters form-group'>
            <div class='row'>
                <h4 class='col-xs-6'>1. Select datasets by category</h4>
                <div class='col-xs-6'>
                    <div class='iconbutton pull-right' data='Reset' ng-click='resetFilters()'>
                        <div class='glyphicon glyphicon-refresh'></div>
                        Reset
                    </div>
                </div>
            </div>
            <div class='row' ng-repeat='(filter_name, filter_values) in view.filters'>
                <div class='col-md-4'>By {{filter_name}}:</div>
                <div class='col-md-8'>
                    <select class='form-control' ng-change='view.filters = refineFilters(search.currentQuery)' ng-init="search.currentQuery[filter_name] = ''" ng-model='search.currentQuery[filter_name]' ng-options="k for k in [''].concat(filter_values)"></select>
                    <!-- .col-xs-2.control-group{:"ng-repeat" => "option in [''].concat(filter_values)"} -->
                    <!-- %input{:"type" => "radio", :"ng-model" => "search.currentQuery[filter_name]", :"ng-value" => "option"} -->
                    <!-- %label {{option}} -->
                </div>
            </div>
            <!-- .row -->
            <!-- .col-xs-2 -->
            <!-- Free text filter: -->
            <!-- .col-xs-6.search-input.form-group -->
            <!-- %input{:"type" => "text", :"ng-model" => "search.queryDatasetText", :"ng-change" => "updateSearchText()"} -->
            <!-- %span.glyphicon.glyphicon-remove{:"ng-if" => "search.queryDatasetText", :"ng-click" => "search.queryDatasetText = null; updateSearchText()"} -->
            <div class='row flex-container'>
                <div class='col-xs-8'>
                    <h4>2. Select individual datasets ({{getDatasetsFromQuery(search.currentQuery).length}} found)</h4>
                </div>
                <div class='col-xs-6'>
                    <div class='flex-container pull-right'>
                        <div class='iconbutton' data='Select Matches' ng-click='selectTextMatches(getDatasetsFromQuery(search.currentQuery))'>
                            <div class='glyphicon glyphicon-ok'></div>
                            All
                        </div>
                        <div class='iconbutton' data='Deselect Matches' ng-click='toggleItems(getDatasetsFromQuery(search.currentQuery), false)'>
                            <div class='glyphicon glyphicon-unchecked'></div>
                            None
                        </div>
                    </div>
                </div>
            </div>
            <div class='row clearfix'>
                <div class='datasets scrollable col-md-12'>
                    <div class='group flex-container horizontal flex-wrap'>
                        <!-- .flex{:"ng-repeat" => "category in getNodesAtLevel(2, getDatasetsFromQuery(search.currentQuery))"} -->
                        <div class='flex'>
                            <span ng-class='{highlighted: checkAttribute(sampleGroup, view.highlight), selected:sampleGroup.selected, match:(search.queryDatasetText &amp;&amp; checkSearchTextMatch(sampleGroup)), nomatch:(search.queryDatasetText &amp;&amp; !checkSearchTextMatch(sampleGroup))}' ng-click='toggleItem(sampleGroup)' ng-repeat='sampleGroup in getDatasetsFromQuery(search.currentQuery)|filter:checkSearchTextMatch'>
                                <p class='level{{sampleGroup.level}}'>
                                    <input ng-click='$event.stopPropagation();' ng-model='sampleGroup.selected' type='checkbox'>
                                    {{sampleGroup.name}} ({{sampleGroup.version}}) - {{sampleGroup.ancestry}} / {{sampleGroup.technology}}
                                </p>
                            </span>
                            <!-- %p.level2{:"ng-repeat" => "subitem in getNodesAtLevel(3, item) track by $index"} -->
                            <!-- {{subitem.name}} -->
                            <!-- %p.level3{:"ng-repeat" => "subitem in getNodesAtLevel(4, item) track by $index"} -->
                            <!-- {{subitem.name}} -->
                        </div>
                    </div>
                    <!-- .fade_bottom -->
                </div>
            </div>
        </div>
        <div class='row'>
            <div class='col-xs-12'>
                <h4>3. Confirm selected columns and update results table</h4>
            </div>
            <div class='col-xs-12'>
                <div>
                    <div class='row'>
                        <div class='col-xs-8'>
                            <p>{{getSelectedSets(tree).length}} datasets selected for additional result columns:</p>
                        </div>
                        <div class='col-xs-4'>
                            <div class='iconbutton pull-right' data='Clear All Selections' ng-click='toggleItems(flattenTree(tree))'>
                                <div class='glyphicon glyphicon-trash'></div>
                                Remove all datasets
                            </div>
                        </div>
                    </div>
                    <div class='row'>
                        <div class='set-wrapper flex-container flex-wrap horizontal col-xs-12'>
                            <div class='tag-wrapper' ng-repeat='set in getSelectedSets(tree)'>
                                <span class='small'>
                                    {{set.name}}
                                    <div class='glyphicon glyphicon-remove' ng-click='toggleItem(set)'></div>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class='row'>
            <div class='col-xs-12'>
                <button class='btn btn-primary btn-lg pull-right'>Update Results</button>
                <button class='btn btn-lg pull-right' data-dismiss='modal' ng-click='view.showAdvancedSelector = false'>Cancel</button>
            </div>
        </div>
    </div>
</div>
</script>



<div class="modal fade" id="columnChooserModal" tabindex="-1">
    <column-chooser></column-chooser>
</div>
<div class="row">
    <div class="col-md-12">
        <button backdrop="true" class="btn btn-lg" data-target="#columnChooserModal" data-toggle="modal" keyboard="true" type="button">Customize table...</button>
    </div>
</div>

</body>
</html>
