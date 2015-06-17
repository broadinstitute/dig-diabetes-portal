<div id="effectOfVariantOnProtein"></div>



<script>
    var mpgSoftware = mpgSoftware || {};

    mpgSoftware.proteinEffect  = (function() {
        var loadProteinEffect = function () {
            $.ajax({
                cache: false,
                type: "get",
                url: "${createLink(controller:'variant',action: 'proteinEffect')}",
                data: {variantId: '<%=variantToSearch%>'},
                async: true,
                success: function (data) {
                    var impactOnProtein = {
                        chooseOneTranscript:'<g:message code="variant.impactOnProtein.chooseOneTranscript" default="choose one transcript" />',
                        subtitle1:'<g:message code="variant.impactOnProtein.subtitle1" default="what effect does" />',
                        subtitle2:'<g:message code="variant.impactOnProtein.subtitle2" default="have on the encoded protein" />'
                    };
                    var variant = data.variantInfo;
                    var remappedFields = mpgSoftware.variantInfo.retrieveFieldsByName(variant.variants[0],["TRANSCRIPT_ANNOT","MOST_DEL_SCORE","VAR_ID","DBSNP_ID"]);
                    var variantProteinInfo = {};
                    variantProteinInfo._13k_T2D_TRANSCRIPT_ANNOT = remappedFields["TRANSCRIPT_ANNOT"];
                    variantProteinInfo.MOST_DEL_SCORE = remappedFields["MOST_DEL_SCORE"];
//                    variantProteinInfo._13k_T2D_TRANSCRIPT_ANNOT = variant.variants[0][1]["TRANSCRIPT_ANNOT"];
//                    variantProteinInfo.MOST_DEL_SCORE = variant.variants[0][0]["MOST_DEL_SCORE"];

                    var varId = remappedFields["VAR_ID"];
                    var dbsnp_id = remappedFields["DBSNP_ID"];
                    var describeThisSnp = varId;
                    if ((dbsnp_id) && (dbsnp_id !== '') && (dbsnp_id !==  null )){
                        describeThisSnp = dbsnp_id ;
                    }
                    var describeImpactOfVariantOnProtein = mpgSoftware.variantInfo.retrieveDescribeImpactOfVariantOnProtein();
                    describeImpactOfVariantOnProtein(variantProteinInfo, describeThisSnp, impactOnProtein);
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });

        };
        return {loadProteinEffect:loadProteinEffect}
    }());
    mpgSoftware.proteinEffect.loadProteinEffect();
</script>









<div id="variationInfoEncodedProtein" style="display:block;">

    <div class="panel-group" id="accordion">
        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        <g:helpText title="variant.impactOnProtein.codonChangeQ.help.header"  qplacer="2px 6px 0 0" placement="bottom" body="variant.impactOnProtein.codonChangeQ.help.text"/>
                        <g:message code="variant.impactOnProtein.codonChange" default="codon change"/><span id="annotationCodon"></span>
                    </p>
                </h4>
            </div>
        </div>

        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        <g:helpText title="variant.impactOnProtein.proteinChangeQ.help.header"  qplacer="2px 6px 0 0" placement="bottom" body="variant.impactOnProtein.proteinChangeQ.help.text"/>
                        <g:message code="variant.impactOnProtein.proteinChange" default="Protein change:"/> <span id="annotationProteinChange"></span>
                    </p>
                </h4>
            </div>
        </div>

        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        <g:helpText title="variant.impactOnProtein.ensembleSoAnnotationsQ.help.header"  qplacer="2px 6px 0 0" placement="bottom" body="variant.impactOnProtein.ensembleSoAnnotationsQ.help.text"/>
                        <g:message code="variant.impactOnProtein.ensembleSoAnnotations" default="Ensembl SO annotations:"/><span id="ensembleSoAnnotation"></span>
                    </p>
                </h4>
            </div>
        </div>

        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        <g:helpText title="variant.impactOnProtein.variantTruncateProteinQ.help.header"  qplacer="2px 6px 0 0" placement="bottom" body="variant.impactOnProtein.variantTruncateProteinQ.help.text"/>
                        <g:message code="variant.impactOnProtein.variantTruncateProtein" default="Does this variant truncate the protein?"/> <strong><span id="variantTruncateProtein"></span>
                    </strong>
                        <a data-toggle="collapse" data-parent="#accordion"
                           href="#collapseTwo" style="text-decoration: underline; color: #428bca;"><g:message code="generalString.learnMore" default="Learn more"/></a>
                    </p>
                </h4>
            </div>

            <div id="collapseTwo" class="panel-collapse collapse">
                <div class="panel-body transcript-annotation">
                    <div class="term-description-expansion">
                        <g:message code="variant.impactOnProtein.variantTruncateProtein.helpText" default="help text"/>
                    </div>
                </div>
            </div>
        </div>

        <p style="margin: 4px 0"></p>

        <div id="mostDeleteScoreEquals2">

            <div class="">
                <div class="">
                    <h4 class="panel-title">

                        <p>
                            <g:helpText title="variant.impactOnProtein.polyphenPredictionQ.help.header"  qplacer="2px 6px 0 0" placement="bottom" body="variant.impactOnProtein.polyphenPredictionQ.help.text"/>
                            <a href="http://genetics.bwh.harvard.edu/pph2/dokuwiki/about"
                               style="text-decoration: underline; color: #428bca;"><g:message code="variant.impactOnProtein.polyphenPrediction" default="PolyPhen-2 prediction"/>
                            <span id="polyPhenPrediction"></span>
                            <a data-toggle="collapse" data-parent="#accordion" href="#polyphenDetails"
                               style="text-decoration: underline; color: #428bca;"><g:message code="generalString.learnMore" default="Learn more"/></a>
                        </p>

                    </h4>
                </div>

                <div id="polyphenDetails" class="panel-collapse collapse">
                    <div class="panel-body transcript-annotation">
                        <g:message code="variant.impactOnProtein.polyphenPrediction.helpText" default="help text"/>
                    </div>
                </div>

            </div>

            <div class="">
                <div class="">
                    <h4 class="panel-title">
                        <p>
                            <g:helpText title="variant.impactOnProtein.siftPredictionQ.help.header"  qplacer="2px 6px 0 0" placement="bottom" body="variant.impactOnProtein.siftPredictionQ.help.text"/>
                            <a href="http://sift.jcvi.org/"
                               style="text-decoration: underline; color: #428bca;"><g:message code="variant.impactOnProtein.siftPrediction" default="PolyPhen-2 prediction"/>
                            <span id="siftPrediction"></span>
                            <a data-toggle="collapse" data-parent="#accordion" href="#siftDetails"
                               style="text-decoration: underline; color: #428bca;"><g:message code="generalString.learnMore" default="Learn more"/></a>
                        </p>
                    </h4>
                </div>

                <div id="siftDetails" class="panel-collapse collapse">
                    <div class="panel-body transcript-annotation">
                        <g:message code="variant.impactOnProtein.siftPrediction.helpText" default="help text"/>
                    </div>
                </div>

            </div>

            <div class="">
                <div class="">
                    <h4 class="panel-title">
                        <p>
                            <g:helpText title="variant.impactOnProtein.condelPredictionQ.help.header"  qplacer="2px 6px 0 0" placement="bottom" body="variant.impactOnProtein.condelPredictionQ.help.text"/>
                            <a href="http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3071923/"
                               style="text-decoration: underline; color: #428bca;"><g:message code="variant.impactOnProtein.condelPrediction" default="Condel prediction"/>
                            <span id="condelPrediction"></span>
                            <a data-toggle="collapse" data-parent="#accordion" href="#condelDetails"
                               style="text-decoration:  underline; color: #428bca;"><g:message code="generalString.learnMore" default="Learn more"/></a>
                        </p>
                    </h4>
                </div>

                <div id="condelDetails" class="panel-collapse collapse">
                    <div class="panel-body transcript-annotation">
                        <g:message code="variant.impactOnProtein.condelPrediction.helpText" default="help text"/>
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>

<span id="puntOnNoncodingVariant">

    <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/></h4>
</span>

