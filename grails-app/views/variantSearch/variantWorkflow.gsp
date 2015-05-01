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
<script>
    $(document).ready(function (){
        mpgSoftware.variantWF.initializePage();
    });

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

