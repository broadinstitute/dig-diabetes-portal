<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>
    <%@ page import="dport.RestServerService" %>
    <%
        RestServerService   restServerService = grailsApplication.classLoader.loadClass('dport.RestServerService').newInstance()
    %>
</head>

<body>
<script>
    var variant;
    function fillTheFields (data) {
        var cariantRec = {
            _13k_T2D_HET_CARRIERS: 1,
            _13k_T2D_HOM_CARRIERS: 2,
            IN_EXSEQ: 3,
            _13k_T2D_SA_MAF: 4,
            MOST_DEL_SCORE: 5,
            CLOSEST_GENE: 6,
            CHROM: 7,
            Consequence: 8,
            ID: 9,
            _13k_T2D_MINA: 10,
            _13k_T2D_HS_MAF: 11,
            DBSNP_ID: 12,
            _13k_T2D_EA_MAF: 13,
            _13k_T2D_AA_MAF: 14,
            POS: 15,
            _13k_T2D_TRANSCRIPT_ANNOT: 16,
            IN_GWAS: 17,
            GWAS_T2D_PVALUE: 18,
            EXCHP_T2D_P_value: 19,
            _13k_T2D_P_EMMAX_FE_IV: 20
        }
        variant = data['variant'];
        variantTitle = UTILS.get_variant_title(variant);
    };
    function gatherFieldsAndPostResults(){
        var varsToSend = {};
        varsToSend["datatype"]  = $("input:radio[name='datatype']:checked").val();
        varsToSend["significance"]  = $("input:radio[name='significance']:checked").val();
        var customSignificance = UTILS.extractValFromTextboxes(['custom_significance_input']);
        var restrictToRegion = UTILS.extractValFromTextboxes(['region_gene_input','region_chrom_input','region_start_input','region_stop_input']);
        var alleleFrequencies = UTILS.extractAlleleFrequencyRanges($('.form-control'));
        var caseControlRequests = UTILS.extractValFromCheckboxes(['id_onlyseen_t2dcases','id_onlyseen_t2dcontrols']);
        var missensePredictions = [];
        varsToSend["predictedEffects"]  = $("input:radio[name='predictedEffects']:checked").val();
        if (varsToSend["predictedEffects"]==='missense'){
            missensePredictions = UTILS.extractValsFromCombobox(['polyphenSelect','siftSelect','condelSelect']);
        }
        varsToSend = UTILS.concatMap(varsToSend,customSignificance) ;
        varsToSend = UTILS.concatMap(varsToSend,caseControlRequests) ;
        varsToSend = UTILS.concatMap(varsToSend,alleleFrequencies) ;
        varsToSend = UTILS.concatMap(varsToSend,restrictToRegion) ;
        varsToSend = UTILS.concatMap(varsToSend,missensePredictions) ;
        UTILS.postQuery('../variantSearch/variantSearchRequest',varsToSend);
    }
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >

                <g:render template="variantSearchDataTypes" />
                <g:render template="variantSearchAssociationThreshold" />
                <g:render template="variantSearchSigmaOddsRatios" />
                <g:render template="variantSearchRestrictToRegion" />
                <g:render template="variantSearchRestrictToEthnicity" />
                <g:render template="variantSearchCaseControlRestriction" />
                <g:render template="variantSearchEffectsOnProteins" />


                <div class="big-button-container">
                     <button class="btn btn-lg btn-primary" onclick="gatherFieldsAndPostResults()">Go</button>
                    %{--<form id="dummy-form" action="/variantsearch/results" method="get">--}%
                        %{--<a id="variant-search-go" class="btn btn-lg btn-primary">Go</a>--}%
                    %{--</form>--}%
                </div>

            </div>

        </div>
    </div>

</div>

</body>
</html>

