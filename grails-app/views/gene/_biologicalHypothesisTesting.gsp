
<g:if test="${show_exseq}">





<script>
    var mpgSoftware = mpgSoftware || {};

    mpgSoftware.biologicalHypothesis = (function () {
        var loadBiologicalHypothesis = function () {
            var loading = $('#spinner').show();
            $.ajax({
                cache: false,
                type: "post",
                url: "../geneInfoAjax",
                data: {geneName: '<%=geneName%>'},
                async: true,
                success: function (data) {
                    var biologicalHypothesisTesting = {
                        question1explanation:'<g:message code="gene.biologicalhypothesis.question1.explanation" default="explanation" args="[geneName]"/>',
                        question1insufficient:'<g:message code="gene.biologicalhypothesis.question1.insufficientdata" default="insufficient data"/>',
                        question1nominal:'<g:message code="gene.biologicalhypothesis.question1.nominaldifference" default="nominal difference"/>',
                        question1significant:'<g:message code="gene.biologicalhypothesis.question1.significantdifference" default="significant difference"/>',
                        question1significantQ:'<g:helpText title="gene.biologicalhypothesis.question1.significance.help.header" qplacer="2px 0 0 6px" placement="right" body="gene.biologicalhypothesis.question1.significance.help.text"/>'
                    };
                    if ((typeof data !== 'undefined')  &&
                            (typeof data['geneInfo'] !== 'undefined')){
                        mpgSoftware.geneInfo.fillBiologicalHypothesisTesting(data['geneInfo'],
                                ${show_gwas},
                                ${show_exchp},
                                ${show_exseq},
                                '<g:createLink controller="variantSearch" action="gene" />',
                                biologicalHypothesisTesting);
                        mpgSoftware.geneInfo.retrieveDelayedBiologicalHypothesisOneDataPresenter().launch();
                    }
                    $('[data-toggle="popover"]').popover({
                        animation: true,
                        html: true,
                        template: '<div class="popover" role="tooltip"><div class="arrow"></div><h5 class="popover-title"></h5><div class="popover-content"></div></div>'
                    });
                    $(".pop-top").popover({placement : 'top'});
                    $(".pop-right").popover({placement : 'right'});
                    $(".pop-bottom").popover({placement : 'bottom'});
                    $(".pop-left").popover({ placement : 'left'});
                    $(".pop-auto").popover({ placement : 'auto'});
                    loading.hide();
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });

        };
        return {loadBiologicalHypothesis: loadBiologicalHypothesis}
    }());

    $('#accordion2').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseThree") {
            mpgSoftware.biologicalHypothesis.loadBiologicalHypothesis();
        }
    });
    $('#accordion2').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseThree") {
            if ((typeof mpgSoftware.geneInfo.retrieveDelayedBiologicalHypothesisOneDataPresenter() !== 'undefined') &&
                    (typeof mpgSoftware.geneInfo.retrieveDelayedBiologicalHypothesisOneDataPresenter().launch !== 'undefined')) {
                mpgSoftware.geneInfo.retrieveDelayedBiologicalHypothesisOneDataPresenter().removeBarchart();
            }
        }
    });

</script>






<a name="biology"></a>

    <div class="translational-research-box">
        <p style="font-weight: 600"><g:message code="gene.biologicalhypothesis.question1" default="question 1" />
        <g:helpText title="gene.biologicalhypothesis.title.help.header" placement="left"
                    body="gene.biologicalhypothesis.title.help.text"/>
        </p>
    </div>
    <p></p>
    <p class="standardFont"  id="possibleCarrierVariantsLink">
    </p>
    <div class="row clearfix">
         <div class="col-md-10">
            <div class="barchartFormatter">
                <div id="chart">

                </div>
            </div>
         </div>
         <div  class="col-md-2">
                <div class="significanceDescriptorFormatter" id="significanceDescriptorFormatter">

                </div>
         </div>
    </div>

</g:if>
