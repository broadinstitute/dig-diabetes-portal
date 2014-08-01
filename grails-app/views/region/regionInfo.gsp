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
    var regionSpec = "<%=regionSpecification%>";
    $.ajax({
        cache:false,
        type:"get",
        url:"../regionAjax/"+regionSpec,
        async:true,
        success: function (data) {
            fillTheFields(data) ;
            console.log(' fields have been filled')
        }
    });
    function fillTheFields (data)  {
//        var cariantRec = {
//            _13k_T2D_HET_CARRIERS : 1,
//            _13k_T2D_HOM_CARRIERS : 2,
//            IN_EXSEQ : 3,
//            _13k_T2D_SA_MAF : 4,
//            MOST_DEL_SCORE : 5,
//            CLOSEST_GENE : 6,
//            CHROM : 7,
//            Consequence : 8,
//            ID : 9,
//            _13k_T2D_MINA : 10,
//            _13k_T2D_HS_MAF : 11,
//            DBSNP_ID : 12,
//            _13k_T2D_EA_MAF : 13,
//            _13k_T2D_AA_MAF : 14,
//            POS : 15,
//            _13k_T2D_TRANSCRIPT_ANNOT : 16,
//            IN_GWAS : 17,
//            GWAS_T2D_PVALUE: 18,
//            EXCHP_T2D_P_value: 19,
//            _13k_T2D_P_EMMAX_FE_IV: 20
//        }
//        variant =  data['variant'];
//        variantTitle =  UTILS.get_variant_title(variant);
//        $('#variantTitle').append(variantTitle);
        $('#variantTableBody').append(UTILS.fillCollectedVariantsTable(data, ${show_gene}, ${show_sigma}, ${show_exseq}, ${show_exchp} ));
console.log('fillThe Region Fields');
    }
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >


                <h1>
                    <span id="variantTitle"></span>
                    <a class="page-nav-link" href="#associations">Associations</a>
                    <a class="page-nav-link" href="#populations">Populations</a>
                    <a class="page-nav-link" href="#biology">Biology</a>
                </h1>

                <g:render template="geneSummaryForRegion" />

                <g:render template="collectedVariantsForRegion" />



            </div>

        </div>
    </div>

</div>

</body>
</html>

