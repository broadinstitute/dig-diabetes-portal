<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
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
            fillTheTraitFields(data) ;
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            errorReporter(jqXHR, exception) ;
        }
    });



    function fillTheTraitFields (data)  {
        var variant =  data['variant'];
        var effectTypeTitle =  UTILS.determineEffectsTypeHeader(variant);
        $('#effectTypeHeader').append(effectTypeTitle);
        $('#traitTableBody').append(UTILS.fillPhenotypicTraitTable(variant, ${show_gene}, ${show_sigma}, ${show_exseq}, ${show_exchp} ));
        $('#phenotypeTraits').dataTable({
            iDisplayLength: 20,
            bFilter: false,
            aaSorting: [[ 1, "asc" ]],
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

