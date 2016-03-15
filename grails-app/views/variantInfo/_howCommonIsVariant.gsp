
    <div id="collapseHowCommonIsVariant" class="accordion-body collapse">
        <div class="accordion-inner">


            <script>
    var mpgSoftware = mpgSoftware || {};

    mpgSoftware.howCommonIsVariant  = (function() {
        var loadHowCommonIsVariant = function (showAll) {
            $.ajax({
                cache: false,
                type: "get",
                url: "${createLink(controller:'variantInfo',action: 'howCommonIsVariant')}",
                data: {variantId: '<%=variantToSearch%>', showAll: showAll},
                async: true,
                success: function (data) {
                    var collector = {}
                    var mafInfo = [];
                    for (var i = 0; i < data.variantInfo.results.length; i++) {
                        for (var j = 0; j < data.variantInfo.results[i].pVals.length; j++) {
                            var contents = {};
                            contents["level"] = data.variantInfo.results[i].pVals[j].level;
                            contents["count"] = data.variantInfo.results[i].pVals[j].count;
                            var fieldDescription = contents["level"].split('^');
                            if ((fieldDescription.length>3) &&
                                (fieldDescription[0]  === 'MAF')) {
                                mafInfo.push(contents);
                            }
                        }
                    }

                    var howCommonIsThisVariantAcrossEthnicities = mpgSoftware.variantInfo.retrieveHowCommonIsThisVariantAcrossEthnicities();
                    var rv = howCommonIsThisVariantAcrossEthnicities(mafInfo);

                    if ((typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation()  !== 'undefined') &&
                            (typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().launch !== 'undefined')) {
                        mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().launch();
                    }
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });

        };
        var loadSummaryAncestryData = function () {
            $("#summaryAncestryData").prop('disabled', true);
            $("#allAncestryData").prop('disabled', false);
            $("#howCommonIsChart").empty();
            mpgSoftware.howCommonIsVariant.loadHowCommonIsVariant(0);
        };
        var loadAllAncestryData = function () {
            $("#summaryAncestryData").prop('disabled', false);
            $("#allAncestryData").prop('disabled', true);
            $("#howCommonIsChart").empty();
            mpgSoftware.howCommonIsVariant.loadHowCommonIsVariant(1);
        };
        return {
            loadHowCommonIsVariant:loadHowCommonIsVariant,
            loadSummaryAncestryData:loadSummaryAncestryData,
            loadAllAncestryData:loadAllAncestryData
        }
    }());

    $('#collapseHowCommonIsVariant').on('show.bs.collapse', function (e) {
            mpgSoftware.howCommonIsVariant.loadHowCommonIsVariant(0);
    });

    $('#collapseHowCommonIsVariant').on('hide.bs.collapse', function (e) {
            if ((typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation()  !== 'undefined') &&
                    (typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().launch !== 'undefined')) {
                mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().removeBarchart();
            }
    });

</script>




<br/>

<g:if test="${show_exseq}">

    <div id="howCommonIsExists" style="display: block">

        <p>
            <g:message code="variant.alleleFrequency.subtitle" default="Relative allele frequencies" />
            <button id="summaryAncestryData" type="button" class="btn  btn-md btn-primary" disabled onclick="mpgSoftware.howCommonIsVariant.loadSummaryAncestryData()">Largest sample only</button>
            <button id="allAncestryData" type="button" class="btn  btn-md btn-primary" onclick="mpgSoftware.howCommonIsVariant.loadAllAncestryData()">Show all cohorts</button>
        </p>


        <p>
            <div id="howCommonIsChart"></div>
        </p>
    </div>

     <div id="howCommonIsNoExists" style="display: none">

        <p>
                 <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/> <g:helpText title="insufficient.variant.data.help.header" placement="bottom"
                                                                                                                             body="insufficient.variant.data.help.text"/></h4>
        </p>

    </div>


</g:if>

        </div>
    </div>



