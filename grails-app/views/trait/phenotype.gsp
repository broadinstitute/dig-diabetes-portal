<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,phenotype,traitInfo, datatables"/>
    <r:layoutResources/>
    <%@ page import="org.broadinstitute.mpg.RestServerService" %>
</head>

<body>
<script>
    var mpgSoftware = mpgSoftware || {};

    mpgSoftware.regionalTraitAnalysis = (function () {

        var fillRegionalTraitAnalysis = function (phenotype,sampleGroup) {

            var loading = $('#spinner').show();
            $('[data-toggle="popover"]').popover();
            $.ajax({
                cache: false,
                type: "post",
                url: "${createLink(controller:'trait',action: 'phenotypeAjax')}",
                data: { trait: '<%=phenotypeKey%>',
                        significance: '<%=requestedSignificance%>',
                        sampleGroup: sampleGroup  },
                async: true,
                success: function (data) {
                    try{
                        mpgSoftware.manhattanplotTableHeader.refreshManhattanplotTableView(data);
                    }
                    catch (e){console.log("YYY",e)}


                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };
        return {fillRegionalTraitAnalysis: fillRegionalTraitAnalysis}
    }());


    $( document ).ready(function() {
        mpgSoftware.regionalTraitAnalysis.fillRegionalTraitAnalysis('<%=phenotypeKey%>','');
    });

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

