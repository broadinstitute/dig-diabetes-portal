<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>
    <%@ page import="dport.RestServerService" %>
</head>

<body>
<script>
    var variant;
    var loading = $('#spinner').show();
    $.ajax({
        cache:false,
        type:"post",
        url:"./phenotypeAjax",
        data:{trait:'<%=phenotypeKey%>',significance:'<%=requestedSignificance%>'},
        async:true,
        success: function (data) {
           // fillTheTraitFields(data) ;
            iterativeTableFiller(data);
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception) ;
        }
    });



    function iterativeTableFiller (data)  {
        var variant =  data['variant'];
        var effectTypeTitle =  UTILS.determineEffectsTypeHeader(variant);
        var effectTypeString =  UTILS.determineEffectsTypeString(effectTypeTitle);
        $('#effectTypeHeader').append(effectTypeTitle);
        $('#phenotypeTraits').dataTable({
            iDisplayLength: 25,
            bFilter: false,
            aaSorting: [[ 2, "asc" ]],
            aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 2, 3, 4 ] } ]
        });
        var dataLength = variant.length;
        var effectsField = UTILS.determineEffectsTypeString (effectTypeString);
        for ( var i = 0 ; i < dataLength ; i++ ){
            var array = UTILS.convertLineForPhenotypicTraitTable(variant[i],effectsField,${show_gene}, ${show_sigma}, ${show_exseq}, ${show_exchp});
            $('#phenotypeTraits').dataTable().fnAddData( array, (i==25));
        }
    }





    function fillTheTraitFields (data)  {
        var variant =  data['variant'];
        var effectTypeTitle =  UTILS.determineEffectsTypeHeader(variant);
        $('#effectTypeHeader').append(effectTypeTitle);
        $('#traitTableBody').append(UTILS.fillPhenotypicTraitTable(variant, ${show_gene}, ${show_sigma}, ${show_exseq}, ${show_exchp} ));
        $('#phenotypeTraits').dataTable({
            iDisplayLength: 20,
            bFilter: false,
            aaSorting: [[ 2, "asc" ]],
            aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 2, 3, 4 ] } ]
        });
        console.log('fill The phenotypeTraits table');


    }
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >

                <g:render template="traitTableHeader" />

            </div>

        </div>
    </div>

</div>

</body>
</html>

