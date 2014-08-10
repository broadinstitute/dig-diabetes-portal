<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>
</head>

<body>
<script>
    $.ajax({
        cache:false,
        type:"get",
        url:"../traitVariantCrossAjax/"+"${regionSpecification}",
        async:true,
        success: function (data) {
            fillTraitVariantCross(data) ;
            console.log(' fields have been filled')
        }
    });
    function fillTraitVariantCross (data)  {
        console.log('fill The traitVariantCross');
    }
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >


                <h1>GWAS Results Summary</h1>
                <h2>Region: <strong><%=regionSpecification%></strong></h2>

                <div class="separator"></div>

                <p>
                    The table below shows all GWAS variants in this region available in this portal.
                    Columns represent each of the <a class="boldlink" href="/about/hgat">25 traits</a> that were studied in meta-analyses included in this portal.
                Rows represent variants, in genomic order.
                All variants are shown, regardless of association.
                </p>

                <p>
                    Hover over a circle to see the details of that association.
                    Some cells won't have circles because no data is available,
                    because they were not genotyped as part of the study and could not be adequately imputed.
                </p>

                <p>
                    This portal contains studies that use different measures of effect on phenotype (odds ratio, beta, z-score), and currently displays only the statistics reported in the original papers.
                </p>

                <div class="row">
                    <div class="col-md-3">
                        <p>
                            Total variants: <strong><span id="displayCountOfIdentifiedTraits"></span></strong>
                        </p>
                    </div>


                </div>

        </div>
    </div>

</div>

</body>
</html>
>