<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="variantWF"/>
    <r:require modules="tableViewer"/>
    <r:layoutResources/>
</head>

<body>
<style>
.panel.inputGoesHere {
    border: 2px solid #052090;
}
.bluebox.inputGoesHere {
    border: 2px solid #052090;
}
</style>
<script>
    $(document).ready(function (){
        mpgSoftware.variantWF.initializePage();
    });

    // todo arz remove me example callback from angular to set the columns
    applyDatasetsFilter = function(columns) {
        console.log(columns);
    };

    showDatasetModal = function() {
        var modal = '#columnChooserModal';
        angular.element(modal).scope().setSelections({
            datasetVersion:'mdv2',
            selectedSets: ['ExSeq_17k_aa_genes_aj_mdv2','ExSeq_17k_eu_genes_um_mdv2']
        });
        /*
         angular.element(modal).scope().setSelections({
             datasetVersion:'mdv2',
             selectedSets: ['ExSeq_17k_hs_genes_mdv2'],
             ancestry:'Hispanic',
             phenotypes:'T2D',
             technology:'ExSeq'
         });
         */
        // todo arz pass in tree structure from getMetadata
        $(modal).modal('show');
        angular.element(modal).scope().loadMetadata();
    }

</script>


<div id="main">

    <div class="container" >

        <div class="variantWF-container" >
            <div class="variant-view" >

                <div class="row clearfix">
                    <div class="col-md-12">
                        <h4>Find genetic variants of interest</h4>
                        <g:render template="variantWFSpec" />
                        <!-- todo arz remove me, this is just an example -->
                        <div>
                            <g:render template="/resultsFilter/filtermodal"></g:render>
                            <a onclick="showDatasetModal()">Refine Query</a>
                        </div>
                    </div>
                    %{--<div  class="col-md-7">--}%

                        %{--<g:render template="variantWFDescr" />--}%

                    %{--</div>--}%
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

