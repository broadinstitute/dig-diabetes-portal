
<a name="biology"></a>

<div id="effectOfVariantOnProtein"></div>


%{--Note:  there is this goofy switch  if (annotation.MOST_DEL_SCORE < 4).  Do I need to deal with this?   --}%

<div id="variationInfoEncodedProtein" class="transcript-annotation"  style="display:block;">
    <p>Codon change: <span id="annotationCodon"></span> </p>
    %{--<%=annotation.Codons%>--}%
    <p>Protein change: <span id="annotationProteinChange"></span></p>
    %{--<%=annotation.Protein_change%>--}%
    <p>
        Ensembl SO annotations:  <span id="ensembleSoAnnotation"></span>

            %{--var consequence = _.find(so_consequences, function(c) { return c.key == annotation.Consequence });--}%
            %{--if (consequence) {--}%
                %{--print('<strong>' + consequence.name + '</strong> (' + consequence.description + ')');--}%
            %{--} else {--}%
                %{--print(annotation.Consequence);--}%
            %{--}--}%

    </p>

    <p>
        Does this variant truncate the protein?  <strong><span id="variantTruncateProtein"></span></strong>
        %{--<strong><% if (annotation.MOST_DEL_SCORE == 1) {--}%
            %{--print('yes');--}%
        %{--} else {--}%
            %{--print('no');--}%
        %{--} %></strong>--}%
    </p>

    <p class="term-description">
        Protein-truncating variants prematurely halt the translation of nucleic acids, resulting
        in an abnormally short protein. If this protein cannot play its normal biological role, the
        variant is considered a "loss-of-function" (LoF) variant. Large deletions of DNA, variants
        that disrupt splice sites (thereby preventing introns from being removed from mRNA),
        and frameshifts (insertions or deletions that render mRNA unable to read codons in the
        proper sets of three) may also cause a loss of function. However, it is not always easy to
        predict the effects of variants on protein structure, and the results of algorithms that do
        so should be treated with care.
    </p>

    <p class="term-description">
        Specific LoF variants tend to be rare in the population at large. However, the average
        individual carries about 100 LoF variants genome-wide. Some LoF variants cause
        disease, others have no phenotypic effect, and still others are protective, such as LoF
        variants in the gene <em>SLC30A8</em> that protect against diabetes. Protective LoF variants in
    humans can serve as models for drugs intended to prevent disease by deactivating
    targets.
    </p>

    %{--<% Another goofy switch -- do I need to deal with this one too?  if (annotation.MOST_DEL_SCORE == 2) { %>--}%
    <div id="mostDeleteScoreEquals2">
    <p><a href="http://genetics.bwh.harvard.edu/pph2/dokuwiki/about">PolyPhen-2</a> prediction and score:
    %{--<strong><%=annotation.PolyPhen_PRED%></strong>, <strong><%=annotation.PolyPhen_SCORE%>--}%
    <span id="polyPhenPrediction"></span> </p>
    %{--<strong><%=annotation.PolyPhen_PRED%></strong>, <strong><%=annotation.PolyPhen_SCORE%>--}%
%{--</strong></p>--}%

    <p><a href="http://sift.jcvi.org/">SIFT</a> prediction and score:
    %{--<strong><%=annotation.SIFT_PRED%></strong>, <strong><%=annotation.SIFT_SCORE%></strong>--}%
        <span id="siftPrediction"></span> </p>

    <p><a href="http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3071923/">Condel</a> prediction and score:
        %{--<strong><%=annotation.Condel_PRED%></strong>, <strong><%=annotation.Condel_SCORE%></strong></p>--}%
        <span id="condelPrediction"></span> </p>

    <p class="term-description">
        The algorithms above take different information into account to predict the effects of SNPs on protein structure.
        <strong>PolyPhen-2</strong> predictions are based on whether a variant appears in a region that is highly conserved across species
    (and thus may serve critical biological functions), and whether the variant is in a location likely to affect the protein's 3D structure.
        <strong>SIFT</strong> also relies on sequence conservation across species to predict whether a protein will tolerate any given single amino acid substitution
    at any given position in its sequence. <strong>Condel</strong> combines the weighted averages for several such algorithms
    (including but not limited to PolyPhen-2 and SIFT) for a consensus prediction.
    </p>
    </div>
</div>
<p>To learn what these predictions and scores mean, <a href="">click here</a>.</p>
</div>
<span id="puntOnNoncodingVariant">
    <h2><strong>What is the biological impact of <%=title%>?</strong></h2>
    <p>This variant is non-coding. Annotation coming soon.</p>
</span>





%{--<% _.each(variant._13k_T2D_TRANSCRIPT_ANNOT, function(annotation, transcript_id) { if (annotation.MOST_DEL_SCORE == 4) return; %>--}%
%{--<div class="transcript-annotation" data-transcript_id="<%= transcript_id %>" style="display:none;">--}%
%{--<p>Codon change: <%= annotation.Codons %></p>--}%
%{--<p>Protein change: <%= annotation.Protein_change %></p>--}%
%{--<p>--}%
%{--Ensembl SO annotations: <%--}%
%{--var consequence = _.find(so_consequences, function(c) { return c.key == annotation.Consequence });--}%
%{--if (consequence) {--}%
%{--print('<strong>' + consequence.name + '</strong> (' + consequence.description + ')');--}%
%{--} else {--}%
%{--print(annotation.Consequence);--}%
%{--}--}%
%{--%>--}%
%{--</p>--}%
%{--<p>--}%
%{--Does this variant truncate the protein?--}%
%{--<strong><% if (annotation.MOST_DEL_SCORE == 1) { print('yes'); } else { print('no'); } %></strong>--}%
%{--</p>--}%
%{--<p class="term-description">--}%
%{--Protein-truncating variants prematurely halt the translation of nucleic acids, resulting--}%
%{--in an abnormally short protein. If this protein cannot play its normal biological role, the--}%
%{--variant is considered a "loss-of-function" (LoF) variant. Large deletions of DNA, variants--}%
%{--that disrupt splice sites (thereby preventing introns from being removed from mRNA),--}%
%{--and frameshifts (insertions or deletions that render mRNA unable to read codons in the--}%
%{--proper sets of three) may also cause a loss of function. However, it is not always easy to--}%
%{--predict the effects of variants on protein structure, and the results of algorithms that do--}%
%{--so should be treated with care.--}%
%{--</p>--}%
%{--<p class="term-description">--}%
%{--Specific LoF variants tend to be rare in the population at large. However, the average--}%
%{--individual carries about 100 LoF variants genome-wide. Some LoF variants cause--}%
%{--disease, others have no phenotypic effect, and still others are protective, such as LoF--}%
%{--variants in the gene <em>SLC30A8</em> that protect against diabetes. Protective LoF variants in--}%
%{--humans can serve as models for drugs intended to prevent disease by deactivating--}%
%{--targets.--}%
%{--</p>--}%
%{--<% if (annotation.MOST_DEL_SCORE == 2) { %>--}%
%{--<p><a href="http://genetics.bwh.harvard.edu/pph2/dokuwiki/about">PolyPhen-2</a> prediction and score: <strong><%= annotation.PolyPhen_PRED %></strong>, <strong><%= annotation.PolyPhen_SCORE %></strong></p>--}%
%{--<p><a href="http://sift.jcvi.org/">SIFT</a> prediction and score: <strong><%= annotation.SIFT_PRED %></strong>, <strong><%= annotation.SIFT_SCORE %></strong></p>--}%
%{--<p><a href="http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3071923/">Condel</a> prediction and score: <strong><%= annotation.Condel_PRED %></strong>, <strong><%= annotation.Condel_SCORE %></strong></p>--}%
%{--<p class="term-description">--}%
%{--The algorithms above take different information into account to predict the effects of SNPs on protein structure.--}%
%{--<strong>PolyPhen-2</strong> predictions are based on whether a variant appears in a region that is highly conserved across species--}%
%{--(and thus may serve critical biological functions), and whether the variant is in a location likely to affect the protein's 3D structure.--}%
%{--<strong>SIFT</strong> also relies on sequence conservation across species to predict whether a protein will tolerate any given single amino acid substitution--}%
%{--at any given position in its sequence. <strong>Condel</strong> combines the weighted averages for several such algorithms--}%
%{--(including but not limited to PolyPhen-2 and SIFT) for a consensus prediction.--}%
%{--</p>--}%
%{--<% } %>--}%
%{--</div>--}%
%{--<% }); %>--}%

%{--<p>To learn what these predictions and scores mean, <a href="">click here</a>.</p>--}%
%{--<% } else { %>--}%
%{--<h2><strong>What is the biological impact of <%= UTILS.get_variant_title(variant) %>?</strong></h2>--}%
%{--<p>This variant is non-coding. Annotation coming soon.</p>--}%
%{--<% } %>--}%
