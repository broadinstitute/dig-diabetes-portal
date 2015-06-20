<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core, crossMap"/>
    <r:layoutResources/>
</head>

<body>
<script>
    var loading = $('#spinner').show();
    $.ajax({
        cache:false,
        type:"get",
        url:"../traitVariantCrossAjax/"+"${regionSpecification}",
        async:true,
        success: function (data) {
            fillTraitVariantCross(data) ;
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception) ;
        }
    });
    var  phenotypeMap =  new UTILS.phenotypeListConstructor (decodeURIComponent("${phenotypeList}")) ;
    function fillTraitVariantCross (data)  {
        var margin = { top: 175, right: 100, bottom: 25, left: 10 },
                width = 1080 - margin.left - margin.right,
                height = 1050 - margin.top - margin.bottom;


        var crossMap = baget.crossMap()
                .width(width)
                .height (height)
                .margin (margin)
                .variantLinkUrl ('<g:createLink controller="variantInfo" action="variantInfo" />')
                .phenotypeArray (phenotypeMap.phenotypeArray);

        crossMap.dataHanger("#vis",data)
                .render();
    }

</script>

<style>
/*.variantlabel {*/
    /*font-weight: bold;*/
    /*cursor: pointer;*/
    /*text-decoration: underline;*/
    /*color: #588fd3;*/
    /*fill: #588fd3;*/
/*}*/
/*.variantlabel .text-highlight {*/
    /*font-weight: bold;*/
    /*cursor: pointer;*/
    /*text-decoration: underline;*/
    /*color: #588fd3;*/
    /*fill: #588fd3;*/
/*}*/
.assoc-up {
    fill: #0f0;
    color: #6fb7f7;
    stroke: #6fb7f7;
}

.assoc-down {
    fill: red;
    color: red;
    stroke: red;
}
.assoc-down:hover {
    stroke-width:2;
}
.assoc-up:hover {
    stroke-width:2;
}
.bg {
    fill: green;
    fill-opacity: 0.0;
    opacity: 0.0;
    pointer-events: none;
    color: white;
    stroke: white;
}
.traitChosen {
font-weight: bold;
}
line.chosen {
    fill: green;
    color: green;
    stroke: green;
}

.assoc-none {
    fill: white;
}

.axis {
    stroke-width: 1px;
    fill:none;
    stroke: black;
}
.legend{
    border: 1px solid black;
}
.legendTitle{
    font-family: 'Lato';
    font-weight: 400;
    font-size: 12pt;
    font-style: italic;
    text-anchor: middle;
}
rect.legendHolder  {
    fill:white;
    stroke:black;
    opacity:0.8;
}
.legendStylingCat {
    font-size: 8pt;
    font-weight: bold;
    font-style: normal;
    fill:black;
}
.legendStylingCat2 {
    font-size: 8pt;
    font-weight: bold;
    font-style: normal;
    fill:black;
}
.legendStylingSig {
    font-size: 8pt;
    font-weight: bold;
    font-style: normal;
    fill:black;
}
.legendStylingSig2 {
    font-size: 8pt;
    font-weight: bold;
    font-style: normal;
    fill:black;
}
.legendStyling {
    font-size: 9pt;
}
.legendStyling0 {

    display: none;
}
.legendStyling1 {
    font-size: 8pt;
    fill:#6fb7f7;
}
.legendStyling2 {
    font-size: 8pt;
    fill: red;
}
</style>

<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >


                <h1>GWAS Results Summary</h1>
                <h2>Region: <strong><%=regionSpecification%></strong></h2>

                <div class="separator"></div>

                <p>
                    The table below shows all GWAS variants in this region available in this portal.
                    Rows represent each of the <a class="boldlink" href="${createLink(controller:'informational', action:'hgat')}">25 traits</a> that were studied in meta-analyses included in this portal.
                </p>

                <p>
                    Hover over a variant to see the additional details of that association.
                </p>


                <div class="row">
                    <div class="col-md-3">

                             <strong><span id="displayCountOfIdentifiedTraits"></span></strong>

                    </div>


                </div>

                <div class="vis-container">

                    <div id="vis"></div>

                    <div id="tooltip" class="hidden">
                        <p><span id="value"></span></p>
                    </div>
                </div>

        </div>
    </div>

</div>

</body>
</html>
