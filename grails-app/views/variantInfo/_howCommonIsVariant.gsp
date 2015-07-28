<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle  collapsed" data-toggle="collapse"
           data-parent="#accordionVariant"
           href="#collapseHowCommonIsVariant">
            <h2><strong><g:message code="variant.howCommonIsVariant.title" default="How common is variant"/>
            </strong></h2>
        </a>
    </div>

    <div id="collapseHowCommonIsVariant" class="accordion-body collapse">
        <div class="accordion-inner">


            <script>
    var mpgSoftware = mpgSoftware || {};

    mpgSoftware.howCommonIsVariant  = (function() {
        var loadHowCommonIsVariant = function () {
            $.ajax({
                cache: false,
                type: "get",
                url: "${createLink(controller:'variantInfo',action: 'howCommonIsVariant')}",
                data: {variantId: '<%=variantToSearch%>'},
                async: true,
                success: function (data) {
                    var alleleFrequencyStrings = {
                        africanAmerican:'<g:message code="variant.alleleFrequency.africanAmerican" default="africanAmerican" />',
                        africanAmericanQ:'<g:helpText title="variant.alleleFrequency.africanAmericanQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.africanAmericanQ.help.text"/>',
                        hispanic:'<g:message code="variant.alleleFrequency.hispanic" default="hispanic" />',
                        hispanicQ:'<g:helpText title="variant.alleleFrequency.hispanicQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.hispanicQ.help.text"/>',
                        eastAsian:'<g:message code="variant.alleleFrequency.eastAsian" default="eastAsian" />',
                        eastAsianQ:'<g:helpText title="variant.alleleFrequency.eastAsianQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.eastAsianQ.help.text"/>',
                        southAsian:'<g:message code="variant.alleleFrequency.southAsian" default="southAsian" />',
                        southAsianQ:'<g:helpText title="variant.alleleFrequency.southAsianQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.southAsianQ.help.text"/>',
                        european:'<g:message code="variant.alleleFrequency.european" default="european" />',
                        europeanQ:'<g:helpText title="variant.alleleFrequency.europeanQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.europeanQ.help.text"/>',
                        exomeSequence:'<g:message code="variant.alleleFrequency.exomeSequence" default="exomeSequence" />',
                        exomeSequenceQ:'<g:helpText title="variant.alleleFrequency.exomeSequenceQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.exomeSequenceQ.help.text"/>',
                        exomeChip:'<g:message code="variant.alleleFrequency.exomeChip" default="exomeChip" />',
                        exomeChipQ:'<g:helpText title="variant.alleleFrequency.exomeChipQ.help.header"  qplacer="2px 6px 0 0" placement="right" body="variant.alleleFrequency.exomeChipQ.help.text"/>'
                    };
                    var collector = {}
                    for (var i = 0; i < data.variantInfo.results.length; i++) {
                        var d = [];
                        for (var j = 0; j < data.variantInfo.results[i].pVals.length; j++) {
                            var contents = {};
                            contents["level"] = data.variantInfo.results[i].pVals[j].level;
                            contents["count"] = data.variantInfo.results[i].pVals[j].count;
                            d.push(contents);
                        }
                        collector["d" + i] = d;
                    }
                    var howCommonIsThisVariantAcrossEthnicities = mpgSoftware.variantInfo.retrieveHowCommonIsThisVariantAcrossEthnicities();
//                    var rv = howCommonIsThisVariantAcrossEthnicities(UTILS.convertStringToNumber(collector["d0"][0].count[0]),
//                            UTILS.convertStringToNumber(collector["d0"][1].count[0]),
//                            UTILS.convertStringToNumber(collector["d0"][2].count[0]),
//                            UTILS.convertStringToNumber(collector["d0"][3].count[0]),
//                            UTILS.convertStringToNumber(collector["d0"][4].count[0]),
//                            UTILS.convertStringToNumber(collector["d0"][5].count[0]),
//                            alleleFrequencyStrings);
                    var rv = howCommonIsThisVariantAcrossEthnicities([collector["d0"][0].count[0],
                            collector["d0"][1].count[0],
                            collector["d0"][2].count[0],
                            collector["d0"][3].count[0],
                            collector["d0"][4].count[0],
                            collector["d0"][5].count[0]],
                            alleleFrequencyStrings);

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
        return {loadHowCommonIsVariant:loadHowCommonIsVariant}
    }());

    $('#collapseHowCommonIsVariant').on('show.bs.collapse', function (e) {
            mpgSoftware.howCommonIsVariant.loadHowCommonIsVariant();
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
</div>


