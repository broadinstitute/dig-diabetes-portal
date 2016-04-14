<div id="collapseHowCommonIsVariant" class="accordion-body collapse">
    <div class="accordion-inner">

        <script>
            var mpgSoftware = mpgSoftware || {};

            mpgSoftware.howCommonIsVariant = (function () {
                // this is to reduce server calls and make the display faster
                // keys are the possible values for the showAll argument
                // there is no timeout because people shouldn't be hanging around the page
                // for that long
                var cache = {};
                var loadHowCommonIsVariant = function (showAll) {
                    var howCommonIsThisVariantAcrossEthnicities = mpgSoftware.variantInfo.retrieveHowCommonIsThisVariantAcrossEthnicities();
                    // check the cache--if we've already done this lookup, use the stored data,
                    // otherwise make the call to the server
                    if(cache[showAll]) {
                        var mafInfo = cache[showAll];
                        howCommonIsThisVariantAcrossEthnicities(mafInfo);
                        if ((typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation() !== 'undefined') &&
                                (typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().launch !== 'undefined')) {
                            mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().launch();
                        }
                        return;
                    }
                    $.ajax({
                        cache: false,
                        type: "get",
                        url: "${createLink(controller:'variantInfo',action: 'howCommonIsVariant')}",
                        data: {variantId: '<%=variantToSearch%>', showAll: showAll},
                        async: true
                    }).done(function (data, textStatus, jqXHR) {
                        var mafInfo = [];
                        _.forEach(data.variantInfo.results, function(result) {
                            // make objects with just the level and count fields, then filter
                            // out anything that's not MAF information
                            var theseValues = _.chain(data.variantInfo.results[0].pVals).map(function(item) {
                                return {level: item.level, count: item.count};
                            }).filter(function(o) {
                                var fieldDescription = o.level.split('^');
                                return ((fieldDescription.length > 3) && (fieldDescription[0] === 'MAF'));
                            }).value();
                            mafInfo = mafInfo.concat(theseValues);
                        });

                        cache[showAll] = mafInfo;

                        howCommonIsThisVariantAcrossEthnicities(mafInfo);

                        if ((typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation() !== 'undefined') &&
                                (typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().launch !== 'undefined')) {
                            mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().launch();
                        }
                    }).fail(function (jqXHR, textStatus, exception) {
                        loading.hide();
                        core.errorReporter(jqXHR, exception);
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
                    loadHowCommonIsVariant: loadHowCommonIsVariant,
                    loadSummaryAncestryData: loadSummaryAncestryData,
                    loadAllAncestryData: loadAllAncestryData
                }
            }());

            $('#collapseHowCommonIsVariant').on('show.bs.collapse', function (e) {
                mpgSoftware.howCommonIsVariant.loadHowCommonIsVariant(0);
            });

            $('#collapseHowCommonIsVariant').on('hide.bs.collapse', function (e) {
                if ((typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation() !== 'undefined') &&
                        (typeof mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().launch !== 'undefined')) {
                    mpgSoftware.variantInfo.retrieveDelayedHowCommonIsPresentation().removeBarchart();
                }
            });

        </script>




        <br/>

        <g:if test="${show_exseq}">

            <div id="howCommonIsExists" style="display: block">

                <p>
            <g:message code="variant.alleleFrequency.subtitle" default="Relative allele frequencies"/>
            <button id="summaryAncestryData" type="button" class="btn  btn-md btn-primary" disabled
                    onclick="mpgSoftware.howCommonIsVariant.loadSummaryAncestryData()">Largest sample only</button>
            <button id="allAncestryData" type="button" class="btn  btn-md btn-primary"
                    onclick="mpgSoftware.howCommonIsVariant.loadAllAncestryData()">Show all cohorts</button>
            </p>


            <p>

            <div id="howCommonIsChart"></div>
            </p>
        </div>

         <div id="howCommonIsNoExists" style="display: none">

            <p>
                     <h4><g:message code="variant.insufficientdata"
                                default="Insufficient data to draw conclusion"/> <g:helpText
                title="insufficient.variant.data.help.header" placement="bottom"
                body="insufficient.variant.data.help.text"/></h4>
        </p>

    </div>

        </g:if>

    </div>
</div>



