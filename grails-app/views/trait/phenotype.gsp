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

                    var collector = [];
                    var effectType = 'beta';
                    if ((typeof data !== 'undefined') &&
                            (data)) {
                        if ((data.variant) &&
                                (data.variant.results)) {//assume we have data and process it

                            for (var i = 0; i < data.variant.results.length; i++) {
                                var d = {};
                                for (var j = 0; j < data.variant.results[i].pVals.length; j++) {
                                    var key = data.variant.results[i].pVals[j].level;
                                    var value = data.variant.results[i].pVals[j].count;
                                    var splitKey = key.split('^');
                                    if (splitKey.length>3) {
                                        if (splitKey[2]=='P_VALUE') {
                                            d['P_VALUE'] = value;
                                        } else if (splitKey[2]=='ODDS_RATIO') {
                                            d[key] = value;
                                            effectType = 'odds ratio'
                                        } else if ((splitKey[2]=='BETA')||(splitKey[2]=='MAF')) {
                                            d[key] = value;
                                        }
                                    } else if (key==='POS') {
                                        d[key] = parseInt(value);
                                    } else {
                                        d[key] = value;
                                    }

                                }
                                collector.push(d);
                            }


                        }
                    }
                    if ((data.variant) &&
                            (data.variant.dataset))  {
//                        $('#traitTableDescription').text(data.variant.dataset);
                        $('#manhattanSampleGroupChooser').val(data.variant.dataset);
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
                                        .significanceThreshold(- Math.log10(parseFloat('<%=requestedSignificance%>')))
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
                                effectType,
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

