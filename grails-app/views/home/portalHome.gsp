<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>
<body>
 <script>
     $(function() {

         $('#gene-input').typeahead(
                  {
                     source: function(query, process) {
                         $.get('../gene', {query: query}, function(data) {
                             process(data);
                         })
                     }
                 }
         );

         $('#gene-go').on('click', function() {
             var gene_symbol = $('#gene-input').val();
             window.location.href = '/gene/' + gene_symbol;
         });

         $('#variant-go').on('click', function() {
             var variant_id = $('#variant-input').val();
             window.location.href = '/variant/' + variant_id;
         });

         $('#region-go').on('click', function() {
             var region_str = $('#region-input').val();
             window.location.href = '/region/' + region_str;
         });

         $('#trait-go').on('click', function() {
             var trait_val = $('#trait-input option:selected').val();
             var significance = 0;
             if ($('#id_significance_genomewide').prop('checked')) {
                 significance = 5e-8;
             } else {
                 significance = $('#custom_significance_input').val();
             }
             if (trait_val == "" || significance == 0) {
                 alert('Please choose a trait and enter a valid significance!')
             }
             window.location.href = '/trait-search?trait=' + trait_val + '&significance=' + significance;
         });

     });
 </script>
<div id="main">
    <div class="container">
        <p>
            This prototype portal contains results from genetic association studies of type 2 diabetes.
            Datatsets include exome sequencing results contributed by <a class="boldlink" href="../informational/t2dgenes">T2D-GENES</a> and <a class="boldlink" href="../informational/got2d">GoT2D</a> (n&asymp;13,000);
        exome chip results contributed by <a class="boldlink" href="../informational/got2d">GoT2D</a> (n&asymp;82,000); and GWAS results contributed by <a class="boldlink" href="http://diagram-consortium.org/about.html">DIAGRAM</a> (n&asymp;69,000).
        The portal also contains  results from large GWAS meta-analyses of <a class="boldlink" href="../informational/hgat">24 other traits</a>.
        </p>
        <p>
            To use these results to investigate a biological hypothesis or assess a potential drug target,
            choose a starting point below.
        </p>

        <div class="row">
            <div class="col-sm-5">
                <div class="main-searchbox">
                    <h2>Start with a gene</h2>
                    <div class="input-group input-group-lg">
                        <input type="text" class="form-control" id="gene-input">
                        <span class="input-group-btn">
                            <button id="gene-go" class="btn btn-primary btn-lg" type="button">Go!</button>
                        </span>
                    </div>
                    <div class="helptext">enter <a class="boldlink" href="http://www.genenames.org" target="_blank">HGNC</a> gene symbol</div>
                </div>
                <div class="main-searchbox">
                    <h2>Start with a variant</h2>
                    <div class="input-group input-group-lg">
                        <input type="text" class="form-control" id="variant-input">
                        <span class="input-group-btn">
                            <button id="variant-go" class="btn btn-primary btn-lg" type="button">Go!</button>
                        </span>
                    </div>
                    <div class="helptext">enter rsID (e.g., rs13266634)</div>
                </div>
                <div class="main-searchbox">
                    <h2>Start with a genomic region</h2>
                    <div class="input-group input-group-lg">
                        <input type="text" class="form-control" id="region-input">
                        <span class="input-group-btn">
                            <button id="region-go" class="btn btn-primary btn-lg" type="button">Go!</button>
                        </span>
                    </div>
                    <div class="helptext">enter coordinates (e.g., chr9:21,940,000-22,190,000)</div>
                </div>
            </div>

            <div class="col-sm-5 col-sm-offset-1">
                <div class="row">
                    <div class="col-sm-9">
                        <h2>
                            Find variants associated with type 2 diabetes <br/>
                            <small>(from exome and exome chip data)</small>
                        </h2>
                    </div>
                    <div class="col-sm-3" style="padding-top: 40px; text-align: right;">
                        <a href="/variantsearch" class="btn btn-primary btn-lg">Go!</a>
                    </div>
                </div>
                <h2>
                    Find variants associated with type 2 diabetes and related traits <br/>
                    <small>(from large GWAS meta-analyses)</small>
                </h2>
                <div class="input-group input-group-lg">
                    <select name="" id="trait-input" class="form-control" style="width:95%;">
                        <option value="">-- Select A Trait --</option>
                        <optgroup label="Cardiometabolic">
                            {% for phenotype in gwas_phenotypes %}
                            {% if phenotype.category == 'cardiometabolic' %}
                            <option value="{{ phenotype.db_key }}">{{ phenotype.name }}</option>
                            {% endif %}
                            {% endfor %}
                        </optgroup>
                        <optgroup label="Other">
                            {% for phenotype in gwas_phenotypes %}
                            {% if phenotype.category == 'other' %}
                            <option value="{{ phenotype.db_key }}">{{ phenotype.name }}</option>
                            {% endif %}
                            {% endfor %}
                        </optgroup>
                    </select>
                </div>
                <h4>Set association threshold</h4>
                <div class="row">
                    <div class="col-sm-9">
                        <div class="radio">
                            <label>
                                <input id="id_significance_genomewide" type="radio" name="significance" value="genomewide" checked />
                                genome-wide significance  |  &le; 5 x 10<sup>-8</sup>
                            </label>
                        </div>
                        <div class="radio">
                            <label for="id_significance_custom">
                                <input id="id_significance_custom" type="radio" name="significance" value="custom" />
                                custom
                            </label>
                            <input type="text" id="custom_significance_input"/>
                            or stronger
                        </div>
                    </div>
                    <div class="col-sm-3" style="padding-top: 10px; text-align: right;">
                        <span class="input-group-btn">
                            <button id="trait-go" class="btn btn-primary btn-lg" type="button">Go!</button>
                        </span>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

</body>
</html>
