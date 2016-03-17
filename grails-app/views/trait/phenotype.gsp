<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,phenotype,traitInfo"/>
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
                url: "./phenotypeAjax",
                data: { trait: '<%=phenotypeKey%>',
                        significance: '<%=requestedSignificance%>',
                        sampleGroup: sampleGroup  },
                async: true,
                success: function (data) {

                    if ((typeof data !== 'undefined') &&
                            (data)) {
                        if ((data.variant) &&
                                (data.variant.results)) {//assume we have data and process it
                            var collector = [];
                            for (var i = 0; i < data.variant.results.length; i++) {
                                var d = {};
                                for (var j = 0; j < data.variant.results[i].pVals.length; j++) {
                                    var key = data.variant.results[i].pVals[j].level;
                                    var value = data.variant.results[i].pVals[j].count;
                                    d[key] = value;
                                }
                                collector.push(d);
                            }


                        }
                    }


                        var margin = {top: 0, right: 20, bottom: 0, left: 70},
                                width = 1050 - margin.left - margin.right,
                                height = 600 - margin.top - margin.bottom;

                        var manhattan = baget.manhattan()
                                        .width(width)
                                        .height(height)
                                        .dataHanger("#manhattanPlot1", collector)
                                        .crossChromosomePlot(true)
    //                    .overrideYMinimum (0)
    //                    .overrideYMaximum (10)
    //                .overrideXMinimum (0)
    //                .overrideXMaximum (1000000000)
                                        .dotRadius(3)
                                    //.blockColoringThreshold(0.5)
                                        .significanceThreshold(7.3)
                                        .xAxisAccessor(function (d) {
                                            return d.POS
                                        })
                                        .yAxisAccessor(function (d) {
                                            if (d.P_VALUE > 0) {
                                                return (0 - Math.log10(d.P_VALUE));
                                            } else {
                                                return 0
                                            }
                                        })
                                        .nameAccessor(function (d) {
                                            return d.DBSNP_ID
                                        })
                                        .chromosomeAccessor(function (d) {
                                            return d.CHROM
                                        })
                                        .includeXChromosome(true)
                                        .includeYChromosome(false)
                                        .dotClickLink('<g:createLink controller="variantInfo" action="variantInfo" />')
                                ;

                        d3.select("#manhattanPlot1").call(manhattan.render);

                        mpgSoftware.phenotype.iterativeTableFiller(collector,
                                ${show_gwas},
                                ${show_exchp},
                                ${show_exseq},
                                "${locale}",
                                '<g:message code="table.buttons.copyText" default="Copy" />',
                                '<g:message code="table.buttons.printText" default="Print me!" />');
                        loading.hide();
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

