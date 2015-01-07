<div id="effectOfVariantOnProtein"></div>


<div id="variationInfoEncodedProtein" style="display:block;">

    <div class="panel-group" id="accordion">
        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        <g:message code="variant.impactOnProtein.codonChange" default="codon change"/><span id="annotationCodon"></span>
                    </p>
                </h4>
            </div>
        </div>

        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        <g:message code="variant.impactOnProtein.proteinChange" default="Protein change:"/> <span id="annotationProteinChange"></span>
                    </p>
                </h4>
            </div>
        </div>

        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        <g:message code="variant.impactOnProtein.ensembleSoAnnotations" default="Ensembl SO annotations:"/><span id="ensembleSoAnnotation"></span>
                    </p>
                </h4>
            </div>
        </div>

        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
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

