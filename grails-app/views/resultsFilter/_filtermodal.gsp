<!DOCTYPE html>
<html lang="en"
      ng-app="ChooserApp"
      ng-controller="ChooserController"
      ng-init="init('${createLink(controller:'ResultsFilter', action:'metadata')}','mdv2')">

<body>

<script src="https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.3.15/angular.js"></script>
<script src="https://code.jquery.com/jquery-2.1.3.min.js"></script>
<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
<link href="//fonts.googleapis.com/css?family=Lato:300,400,700,900,300italic,400italic,700italic,900italic" rel="stylesheet" type="text/css"/>
<link type="text/css" rel="stylesheet" href="${resource(dir: 'css', file: 'dport/chooser/custom.css')}" />

<g:javascript src="lib/dport/chooser/controllers.js"></g:javascript>
<g:javascript src="lib/dport/chooser/t.js"></g:javascript>

<script id='column-chooser-directive' type='text/ng-template'>
<div class='column-chooser-container container-fluid modal-dialog'>
    <div class='modal-content'>
        <div class='modal-header'>
            <button aria-hidden='true' class='close' data-dismiss='modal' type='button'>&times;</button>
            <h4 class='modal-title'><g:message code='filterModal.title.customize'/></h4>
        </div>
        <div class='modal-body'>
            <div class='row'>
                <div class='col-md-12'>
                    <!-- %h2 Choose custom columns to display in results table -->
                    <p><g:message code='filterModal.message.results'/>.</p>
                </div>
            </div>
            <div ng-show="tree.length == 0" class="row">
                <div id="spinner" style="background-color: #003300" class="text-center">
                    <img id="img-spinner" src="${resource(dir: 'images', file: 'ajaxLoadingAnimation.gif')}" alt="Loading"/>
                </div>
            </div>
            <div ng-show="tree.length > 0">
            <!-- This is a chunk that just creates filters based upon an enumeration of the possible filters -->
            <div class='dynamicfilters form-group'>
                <div class='row'>
                    <h4 class='col-xs-6'>1. <g:message code='filterModal.step.select_datasets_category'/></h4>
                        <div class='iconbutton pull-right'
                             data='Reset'
                             ng-click='resetFilters()'>
                            <div class='glyphicon glyphicon-refresh'></div>
                            <g:message code='filterModal.shared.actions.reset'/>
                        </div>
                </div>
                <div class='row' ng-repeat='(filter_name, filter_values) in view.filters'>
                    <div ng-if="filter_name != 'version'">
                        <div class='col-md-4'><g:message code='filterModal.shared.phrases.by'/> {{filter_name}}:</div>
                        <div class='col-md-8'>
                            <select class='form-control'
                                    ng-change='view.filters = refineFilters(search.currentQuery)'
                                    ng-init="search.currentQuery[filter_name] = ''"
                                    ng-model='search.currentQuery[filter_name]'
                                    ng-options="k for k in [''].concat(filter_values)"></select>

                        </div>
                    </div>

                </div>

                <div class='row flex-container'>
                    <div class='col-xs-8'>
                        <h4>2. <g:message code='filterModal.step.select_datasets_single'/> ({{getDatasetsFromQuery(search.currentQuery).length}} <g:message code='filterModal.shared.phrases.found'/>)</h4>
                    </div>
                    <div class='col-xs-6'>
                        <div class='flex-container pull-right'>
                            <div class='iconbutton' data='Select Matches' ng-click='selectTextMatches(getDatasetsFromQuery(search.currentQuery))'>
                                <div class='glyphicon glyphicon-ok'></div>
                                <g:message code='filterModal.shared.phrases.all'/>
                            </div>
                            <div class='iconbutton' data='Deselect Matches' ng-click='toggleItems(getDatasetsFromQuery(search.currentQuery), false)'>
                                <div class='glyphicon glyphicon-unchecked'></div>
                                <g:message code='filterModal.shared.phrases.none'/>
                            </div>
                        </div>
                    </div>
                </div>
                <div class='row clearfix'>
                    <div class='datasets scrollable col-md-12'>
                        <div class='group flex-container horizontal flex-wrap'>
                            <!-- .flex{:"ng-repeat" => "category in getNodesAtLevel(2, getDatasetsFromQuery(search.currentQuery))"} -->
                            <div class='flex'>
                                <span ng-class='{highlighted: checkAttribute(sampleGroup, view.highlight), selected:sampleGroup.selected, match:(search.queryDatasetText &amp;&amp; checkSearchTextMatch(sampleGroup)), nomatch:(search.queryDatasetText &amp;&amp; !checkSearchTextMatch(sampleGroup))}'
                                      ng-repeat='sampleGroup in getDatasetsFromQuery(search.currentQuery) | filter:checkSearchTextMatch'>
                                    <p class='level{{sampleGroup.level}}' ng-init='view = {}'>
                                        <input ng-model='sampleGroup.selected' type='checkbox'>
                                        <span ng-click='toggleItem(sampleGroup)'>{{sampleGroup.name}} ({{sampleGroup.version}}) - {{sampleGroup.ancestry}} / {{sampleGroup.technology}}</span>
                                        <!-- %span.glyphicon.glyphicon-list-alt{:"ng-click" => "view.showProperties = !view.showProperties", :"ng-if" => "sampleGroup.properties.length > 0"} -->
                                    </p>

                                </span>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class='row'>
                <div class='col-xs-12'>
                    <h4>3. <g:message code='filterModal.step.confirm_selection'/></h4>
                </div>
                <div class='col-xs-12'>
                    <div>
                        <div class='row'>
                            <div class='col-xs-8'>
                                <p>{{getSelectedSets(tree).length}} <g:message code='filterModal.message.addt_results'/>:</p>
                            </div>
                            <div class='col-xs-4'>
                                <div class='iconbutton pull-right' data='Clear All Selections' ng-click='toggleItems(flattenTree(tree))' style="padding-right: 10px;">
                                    <div class='glyphicon glyphicon-trash'></div>
                                    <g:message code='filterModal.shared.actions.remove'/>
                                </div>
                            </div>
                        </div>
                        <div class='row'>
                            <div class='set-wrapper flex-container flex-wrap horizontal col-xs-12'>
                                <div class='tag-wrapper' ng-repeat='set in getSelectedSets(tree)'>
                                    <span class='small'>
                                        {{set.name}}
                                        <div class='glyphicon glyphicon-remove' ng-click='toggleItem(set)'></div>
                                        <!-- %span{:"ng-click" => "toggleItem(set)"} &times; -->
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
        <div class='modal-footer'>
            <div class='row'>
                <div class='col-xs-12'>
                    <button class='btn btn-primary btn-lg pull-right' data-dismiss='modal'
                            ng-click="setColumnFilter(getSelectedSetNames(tree))"><g:message code='filterModal.shared.actions.update'/></button>
                    <button class='btn btn-lg pull-right' data-dismiss='modal' ng-click='view.showAdvancedSelector = false'><g:message code='filterModal.shared.actions.cancel'/></button>
                </div>
            </div>
        </div>
    </div>
</div>
</script>

<div class="modal fade" id="columnChooserModal">
    <link type="text/css" href="${resource(dir: 'css', file: 'dport/chooser/custom.css')}" />
    <column-chooser></column-chooser>
</div>

</body>
</html>
