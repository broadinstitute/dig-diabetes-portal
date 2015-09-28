<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="variantWF"/>

    <r:layoutResources/>
</head>

<body>
<style>
.panel.inputGoesHere {
    border: 2px solid #052090;
    -moz-border-radius: 10px;
    -webkit-border-radius: 10px;
    -khtml-border-radius: 10px;
    border-radius: 10px;
    box-shadow: 8px 8px 5px #888888;
}
.bluebox.inputGoesHere {
    border: 3px solid #052090;
    -moz-border-radius: 10px;
    -webkit-border-radius: 10px;
    -khtml-border-radius: 10px;
    border-radius: 10px;

}
</style>
<script>
    $(document).ready(function (){
        mpgSoftware.variantWF.initializePage();
        $('#region_gene_input').typeahead({
            source: function (query, process) {
                $.get('<g:createLink controller="gene" action="index"/>', {query: query}, function (data) {
                    process(data);
                })
            }
        });
    });

    applyDatasetsFilter = function(columns) {
        console.log(columns);
    };

    showDatasetModal = function() {
        var modal = '#columnChooserModal';
        $(modal).modal('show');
        angular.element(modal).scope().loadMetadata();
    };

    %{--$.get('<g:createLink controller="gene" action="geneOnlyTypeAhead"/>', {query: query}, function (data) {--}%



</script>


<div id="main">

    <div class="container" >

        <div class="variantWF-container" >
            <div class="variant-view" >

                <div class="row clearfix">
                    <div class="col-md-12">
                        <h4>Find genetic variants of interest</h4>
                        <g:render template="variantWFSpec" />
                    </div>
                </div>


           </div>

        </div>
    </div>

</div>
<div style = "display: none">
    <div id="hiddenFields">
         <g:renderHiddenFields filterSet='${encodedFilterSets}'/>
    </div>
</div>
<script>
    $( document ).ready( function(){
        $('.panel-collapse.in')
                .collapse('hide');
    });
</script>

</body>
</html>

