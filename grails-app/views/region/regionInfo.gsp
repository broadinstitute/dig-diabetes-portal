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
            errorReporter(jqXHR, exception) ;
        }
    });
    function fillTheFields (data)  {
        $('#variantTableBody').append(UTILS.fillCollectedVariantsTable(data, ${show_gene}, ${show_sigma}, ${show_exseq}, ${show_exchp} ));

        $('#variantTable').dataTable({
            iDisplayLength: 20,
            bFilter: false,
            aaSorting: [[ 1, "asc" ]],
            aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 5, 6, 8, 10, 11, 12, 13 ] } ]
        });
        console.log('fillThe Region Fields');
    }
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >


                <h1>
                    <span id="variantTitle"></span>
                    <a class="page-nav-link" href="#associations">Associations</a>
                    <a class="page-nav-link" href="#populations">Populations</a>
                    <a class="page-nav-link" href="#biology">Biology</a>
                </h1>

                <g:render template="geneSummaryForRegion" />

                <g:render template="collectedVariantsForRegion" />



            </div>

        </div>
    </div>

</div>

</body>
</html>

