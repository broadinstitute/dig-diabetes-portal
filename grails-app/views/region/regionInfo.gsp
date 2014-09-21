<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>
</head>

<body>
<script>
    var regionSpec = "<%=regionSpecification%>";
    jQuery.fn.dataTableExt.oSort['allnumeric-asc']  = function(a,b) {
        var x = parseFloat(a);
        var y = parseFloat(b);
        if (!x) { x = 1; }
        if (!y) { y = 1; }
        return ((x < y) ? -1 : ((x > y) ?  1 : 0));
    };

    jQuery.fn.dataTableExt.oSort['allnumeric-desc']  = function(a,b) {
        var x = parseFloat(a);
        var y = parseFloat(b);
        if (!x) { x = 1; }
        if (!y) { y = 1; }
        return ((x < y) ? 1 : ((x > y) ?  -1 : 0));
    };
    var loading = $('#spinner').show();
    $.ajax({
        cache:false,
        type:"get",
        url:"../regionAjax/"+regionSpec,
        async:true,
        success: function (data) {
            fillTheFields(data) ;
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception) ;
        }
    });
    var  proteinEffectList =  new UTILS.proteinEffectListConstructor (decodeURIComponent("${proteinEffectsList}")) ;
    function fillTheFields (data)  {
        $('#variantTableBody').append(UTILS.fillCollectedVariantsTable(data,
                ${show_gene},
                ${show_sigma},
                ${show_exseq},
                ${show_exchp},
                '<g:createLink controller="variant" action="variantInfo" />',
                '<g:createLink controller="gene" action="geneInfo" />'));

        $('#variantTable').dataTable({
            iDisplayLength: 20,
            bFilter: false,
            aaSorting: [[ 5, "asc" ]],
            aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 5, 6, 8, 10, 11, 12, 13 ] } ]
        });
        console.log('fillThe Region Fields');
    }
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >

                <g:render template="geneSummaryForRegion" />

                <g:render template="collectedVariantsForRegion" />

            </div>

        </div>
    </div>

</div>

</body>
</html>

