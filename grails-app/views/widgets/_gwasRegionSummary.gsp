<!-- inputs needed
    phenotypeList: a list of the 24 phenotypes shown in the display
    regionSpecification: the chromosome and start/end position of the region to show (ex: chr9:21940000-22190000)
    openOnLoad: if accordion closed at start
-->
<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle  collapsed" data-toggle="collapse" href="#collapseGwasSummary">
            <h2><strong><g:message code="widgets.gene.gwas.summary.title" default="GWAS Results Summary"/></strong></h2>
        </a>
    </div>


    <div id="collapseGwasSummary" class="accordion-body collapse">
        <div class="accordion-inner" id="traitAssociationInner">


<script>
    var loading = $('#spinner').show();
    $.ajax({
        cache: false,
        type: "get",
        url: "../../trait/traitVariantCrossAjax/" + "${regionSpecification}",
        async: true,
        success: function (data) {
            fillTraitVariantCross(data);
            loading.hide();
        },
        error: function (jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception);
        }
    });
    var phenotypeMap = new UTILS.phenotypeListConstructor(decodeURIComponent("${phenotypeList}"));
    function fillTraitVariantCross(data) {
        var margin = { top: 175, right: 100, bottom: 25, left: 10 },
                width = 1080 - margin.left - margin.right,
                height = 1050 - margin.top - margin.bottom;


        var crossMap = baget.crossMap()
                .width(width)
                .height(height)
                .margin(margin)
                .variantLinkUrl('<g:createLink controller="variantInfo" action="variantInfo" />')
                .phenotypeArray(phenotypeMap.phenotypeArray);

        crossMap.dataHanger("#vis", data)
                .render();
    }

</script>

<style>
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
    stroke-width: 2;
}

.assoc-up:hover {
    stroke-width: 2;
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
    fill: none;
    stroke: black;
}

.legend {
    border: 1px solid black;
}

.legendTitle {
    font-family: 'Lato';
    font-weight: 400;
    font-size: 12pt;
    font-style: italic;
    text-anchor: middle;
}

rect.legendHolder {
    fill: white;
    stroke: black;
    opacity: 0.8;
}

.legendStylingCat {
    font-size: 8pt;
    font-weight: bold;
    font-style: normal;
    fill: black;
}

.legendStylingCat2 {
    font-size: 8pt;
    font-weight: bold;
    font-style: normal;
    fill: black;
}

.legendStylingSig {
    font-size: 8pt;
    font-weight: bold;
    font-style: normal;
    fill: black;
}

.legendStylingSig2 {
    font-size: 8pt;
    font-weight: bold;
    font-style: normal;
    fill: black;
}

.legendStyling {
    font-size: 9pt;
}

.legendStyling0 {

    display: none;
}

.legendStyling1 {
    font-size: 8pt;
    fill: #6fb7f7;
}

.legendStyling2 {
    font-size: 8pt;
    fill: red;
}
</style>

<div class="variant-info-container">
    <div class="variant-info-view">

        <h2>Region: <strong><%=regionSpecification%></strong></h2>

        <div class="separator"></div>

        <p>
            The table below shows all GWAS variants in this region available in this portal.
            Rows represent each of the <a class="boldlink"
                                          href="${createLink(controller: 'informational', action: 'hgat')}">25 traits</a> that were studied in meta-analyses included in this portal.
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
    </div>
</div>

<g:if test="${openOnLoad}">
    <script>
        $('#collapseGwasSummary').collapse({hide: false})
    </script>
</g:if>
