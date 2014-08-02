<h4>Set allele frequencies (use only if searching exome sequence data)</h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="frequencies-form">
        <g:if test="${show_sigma}">
            <div class="checkbox">
                        <div class="row">
                            <div class="col-xs-4">
                                <label>
                                    <strong>Allele frequency:</strong>
                                </label>
                            </div>
                            <div class="col-xs-2" style="text-align: right">from</div>
                            <div class="col-xs-2">
                                <input type="text" class="form-control" id="ethnicity_af_sigma" />
                            </div>
                            <div class="col-xs-1" style="text-align: right">
                                to
                            </div>
                            <div class="col-xs-2">
                                <input type="text" class="form-control" id="ethnicity_af_sigma"/>
                            </div>
                        </div>
                    </div>
       </g:if>
       <g:if test="${show_exseq}">
           <g:alleleFrequencyRange></g:alleleFrequencyRange>
            %{--<% _.each(ethnicities, function(e) { %>--}%
            %{--<div class="checkbox">--}%
                %{--<div class="row">--}%
                    %{--<div class="col-xs-5">--}%
                        %{--<label>--}%
                            %{--in <strong><%= e.name %></strong>:--}%
                        %{--</label>--}%
                    %{--</div>--}%
                    %{--<div class="col-xs-2">--}%
                        %{--<input type="text" class="form-control" id="ethnicity_af_<%= e.key %>-min" />--}%
                    %{--</div>--}%
                    %{--<div class="col-xs-1">--}%
                        %{--to--}%
                    %{--</div>--}%
                    %{--<div class="col-xs-2">--}%
                        %{--<input type="text" class="form-control" id="ethnicity_af_<%= e.key %>-max"/>--}%
                    %{--</div>--}%
                %{--</div>--}%
            %{--</div>--}%
            %{--<% }); %>--}%
        </g:if>
        </div>
    </div>
    <div class="col-md-6">
      <g:if test="${show_exseq}">
        <p>
            Allele frequencies can vary widely by population, and some variants may influence disease risk in one population but not another.
            For instance, <a href="http://www.ncbi.nlm.nih.gov/pubmed/24390345">a set of five variants</a>
            in the gene <em>SLC16A11</em> is common in people of Native American ancestry and increases T2D risk in that population;
        however, the variants are low-frequency or rare in other ancestry groups,
        and appear to play little to no role in T2D in Europeans.
        Thus, <em>SLC16A11</em> was not implicated in early GWAS of type 2 diabetes, which focused on people of European ancestry.
        </p>
      </g:if>
      <g:if test="${show_sigma}">
        <p>
            Allele frequencies are derived from both exome sequencing and exome chip datasets.
            If a variant is in exome chip, its frequency from that study is used, since the sample size of exome chip studies is much larger.
            If a variant is in exome sequencing but not exome chip (as is the case with most rare variants), its frequency from exome chip.
            You can see whether a variant is from exome sequencing or exome chip from the <em>SIGMA source</em> column in the variant table.
        Finally, note that if a variant is not seen in either exome sequencing or exome chip data, it is assigned an allele frequency of 0.0.
        There is currently no way to identify whether a variant was genotyped and not seen, or was not in a part of the genome included in these studies.
        </p>
      </g:if>
    </div>
</div>

