<div id="effectOfVariantOnProtein"></div>


<div id="variationInfoEncodedProtein" style="display:block;">

    <div class="panel-group" id="accordion">
        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        Codon change: <span id="annotationCodon"></span>
                    </p>
                </h4>
            </div>
        </div>

        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        Protein change: <span id="annotationProteinChange"></span>
                    </p>
                </h4>
            </div>
        </div>

        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        Ensembl SO annotations:  <span id="ensembleSoAnnotation"></span>
                    </p>
                </h4>
            </div>
        </div>

        <div class="">
            <div class="">
                <h4 class="panel-title">
                    <p>
                        Does this variant truncate the protein? <strong><span id="variantTruncateProtein"></span>
                    </strong>
                        <a data-toggle="collapse" data-parent="#accordion"
                           href="#collapseTwo" style="text-decoration: underline; color: #428bca;">Learn more</a>
                    </p>
                </h4>
            </div>

            <div id="collapseTwo" class="panel-collapse collapse">
                <div class="panel-body transcript-annotation">
                    <div class="term-description-expansion">
                        <p>
                            Protein-truncating variants prematurely halt the translation of nucleic acids, resulting
                            in an abnormally short protein. If this protein cannot play its normal biological role, the
                            variant is considered a "loss-of-function" (LoF) variant. Large deletions of DNA, variants
                            that disrupt splice sites (thereby preventing introns from being removed from mRNA),
                            and frameshifts (insertions or deletions that render mRNA unable to read codons in the
                            proper sets of three) may also cause a loss of function. However, it is not always easy to
                            predict the effects of variants on protein structure, and the results of algorithms that do
                            so should be treated with care.
                        </p>

                        <p>
                            Specific LoF variants tend to be rare in the population at large. However, the average
                            individual carries about 100 LoF variants genome-wide. Some LoF variants cause
                            disease, others have no phenotypic effect, and still others are protective, such as LoF
                            variants in the gene <em>SLC30A8</em> that protect against diabetes. Protective LoF variants in
                        humans can serve as models for drugs intended to prevent disease by deactivating
                        targets.
                        </p>
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
                               style="text-decoration: underline; color: #428bca;">PolyPhen-2</a> prediction and score:
                            <span id="polyPhenPrediction"></span>
                            <a data-toggle="collapse" data-parent="#accordion" href="#polyphenDetails"
                               style="text-decoration: underline; color: #428bca;">Learn more</a>
                        </p>

                    </h4>
                </div>

                <div id="polyphenDetails" class="panel-collapse collapse">
                    <div class="panel-body transcript-annotation">
                        <p class="term-description-expansion">
                            <strong>PolyPhen-2 predicts a variant's effects on protein structure and function based on whether the variant appears in a region that is highly conserved across
                            species (and thus may serve critical biological functions), and whether the variant is in a location likely to affect the protein's 3D structure.</strong>
                            For comparison, this portal provides results from two other algorithms that also predict the effects of a variant on protein structure. SIFT relies on
                            sequence conservation across species to predict whether a protein will tolerate any given single amino acid substitution at any given position in its sequence.
                            Condel combines the weighted averages for several such algorithms (including but not limited to PolyPhen-2 and SIFT) for a consensus prediction.
                        </p>

                        <p class="term-description-expansion">
                            <strong>WARNING: PolyPhen-2, SIFT, and Condel may disagree with each other, and in some cases,
                                <a href="http://hmg.oxfordjournals.org/content/early/2014/06/12/hmg.ddu269.long"
                                   style="text-decoration:  underline; color: #428bca;">their predictive accuracy is low.</a>
                            </strong>
                        </p>
                    </div>
                </div>

            </div>

            <div class="">
                <div class="">
                    <h4 class="panel-title">
                        <p>
                            <a href="http://sift.jcvi.org/"
                               style="text-decoration: underline; color: #428bca;">SIFT</a> prediction and score:
                            <span id="siftPrediction"></span>
                            <a data-toggle="collapse" data-parent="#accordion" href="#siftDetails"
                               style="text-decoration: underline; color: #428bca;">Learn more</a>
                        </p>
                    </h4>
                </div>

                <div id="siftDetails" class="panel-collapse collapse">
                    <div class="panel-body transcript-annotation">
                        <p class="term-description-expansion">
                            <strong>SIFT relies on sequence conservation across species to predict whether a protein's function will be affected by any given single amino acid substitution at any
                            given position in its sequence.</strong> For comparison, this portal provides results from two other algorithms that predict a variant's effects on protein structure and
                        function. PolyPhen-2 predictions are based on whether a variant appears in a region that is highly conserved across species (and thus may serve critical biological functions),
                        and whether the variant is in a location likely to affect the protein's 3D structure. Condel combines the weighted averages for several such algorithms (including but not
                        limited to PolyPhen-2 and SIFT) for a consensus prediction.
                        </p>

                        <p class="term-description-expansion">
                            <strong>WARNING: PolyPhen-2, SIFT, and Condel may disagree with each other, and in some cases,
                                <a href="http://hmg.oxfordjournals.org/content/early/2014/06/12/hmg.ddu269.long"
                                   style="text-decoration:  underline; color: #428bca;">their predictive accuracy is low.</a>
                            </strong>
                        </p>
                    </div>
                </div>

            </div>

            <div class="">
                <div class="">
                    <h4 class="panel-title">
                        <p>
                            <a href="http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3071923/"
                               style="text-decoration: underline; color: #428bca;">Condel</a> prediction and score:<span
                                id="condelPrediction"></span>
                            <a data-toggle="collapse" data-parent="#accordion" href="#condelDetails"
                               style="text-decoration:  underline; color: #428bca;">Learn more</a>
                        </p>
                    </h4>
                </div>

                <div id="condelDetails" class="panel-collapse collapse">
                    <div class="panel-body transcript-annotation">
                        <p class="term-description-expansion">
                            <strong>Condel predicts a variant's effects on protein structure and function by combining the weighted averages for several algorithms (including
                            but not limited to PolyPhen-2 and SIFT) for a consensus prediction.</strong>  For comparison, this portal provides results from PolyPhen-2 and SIFT
                        alone. PolyPhen-2 predictions are based on whether a variant appears in a region that is highly conserved across species (and thus may serve
                        critical biological functions), and whether the variant is in a location likely to affect the protein's 3D structure. SIFT also relies on sequence
                        conservation across species to predict whether a protein will tolerate any given single amino acid substitution at any given position in its sequence.
                        </p>

                        <p class="term-description-expansion">
                            <strong>WARNING: PolyPhen-2, SIFT, and Condel may disagree with each other, and in some cases,
                                <a href="http://hmg.oxfordjournals.org/content/early/2014/06/12/hmg.ddu269.long"
                                   style="text-decoration:  underline; color: #428bca;">their predictive accuracy is low.</a>
                            </strong>
                        </p>
                    </div>
                </div>
            </div>
        </div>

    </div>

</div>

<span id="puntOnNoncodingVariant">

    <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/></h4>
</span>

