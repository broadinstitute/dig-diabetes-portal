<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="tableViewer"/>
    <r:require modules="variantWF"/>
    <r:layoutResources/>
    <style>
    .propertyAdder{
        margin: 0 0 0 15px;
    }
    .propertyHolder {
        position: absolute;
        background-color: white;
        height:150px;
        width:150px;
        overflow-y: auto;
    }
    </style>

</head>

<body>


<script>
var lookAtProperties = function (here){
    if ($('#propertyWindow').is(":visible")){
        $('#propertyWindow').remove ();
    } else {
        $(here).append("<div id='propertyWindow' class ='propertyHolder' onclick='stopLookingAtProperties()'> hello</div>");
    }
};
var stopLookingAtProperties = function (){
    $('#propertyWindow').hide()
};
    var  proteinEffectList =  new UTILS.proteinEffectListConstructor (decodeURIComponent("${proteinEffectsList}")) ;
    var loading = $('#spinner').show();
    loading.show();
    $.ajax({
        type:'POST',
        cache:false,
        data:{'keys':"<%=filter%>"},
        url:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsAjax" />',
        async:true,
        success:function(data,textStatus){
            var variantTableContext = {
                tooManyResults:'<g:message code="variantTable.searchResults.tooManyResults" default="too many results, sharpen your search" />'
            };
            if (${newApi}){
	          dynamicFillTheFields(data) ;
            } else {
                variantProcessing.fillTheVariantTable(data,
                        ${show_gene},
                        ${show_sigma},
                        ${show_exseq},
                        ${show_exchp},
                        '<g:createLink controller="variantInfo" action="variantInfo"  />',
                        '<g:createLink controller="gene" action="geneInfo"  />',
                        ${dataSetDetermination},
                        {variantTableContext:variantTableContext});
            }

            loading.hide();
        },
        error:function(XMLHttpRequest,textStatus,errorThrown){
            loading.hide();
            errorReporter(XMLHttpRequest, exception) ;
        }
    });


    var uri_dec = decodeURIComponent("<%=filter%>");
    var encodedParameters = decodeURIComponent("<%=encodedParameters%>");


    var  proteinEffectList =  new UTILS.proteinEffectListConstructor (decodeURIComponent("${proteinEffectsList}")) ;

    function fillTheFields (data)  {
        variantProcessing.oldIterativeVariantTableFiller(data,'#variantTable',
                ${show_gene},
                ${show_sigma},
                ${show_exseq},
                ${show_exchp},
                '<g:createLink controller="variantInfo" action="variantInfo" />',
                '<g:createLink controller="gene" action="geneInfo" />',
                proteinEffectList,{},${newApi});

    }

    var contentExists = function (field){
        return ((typeof field !== 'undefined') && (field !== null) );
    };
    var noop = function (field){return field;};
    var lineBreakSubstitution = function (field){
        return (contentExists(field))?field.replace(/[;,]/g,'<br/>'):'';
    };


    function dynamicFillTheFields (data)  {

        var sortCol = 0
        var totCol = 0
        for (var pheno in data.columns.dproperty) {
            var pheno_width = 0

            for (var dataset in data.columns.dproperty[pheno]) {
                var dataset_width = 0
                var datasetDisp = mpgSoftware.trans.translator(dataset)
                for (var i = 0; i < data.columns.dproperty[pheno][dataset].length; i++) {
                    var column = data.columns.dproperty[pheno][dataset][i]
                    var columnDisp = mpgSoftware.trans.translator(column)
                    pheno_width++
                    dataset_width++
                    $('#variantTableHeaderRow3').append("<th class=\"datatype-header\">" + columnDisp + "</th>")
                }
                if (dataset_width > 0) {
                    $('#variantTableHeaderRow2').append("<th colspan=" + dataset_width + " class=\"datatype-header\">" + datasetDisp +
                            "<span class='glyphicon glyphicon-plus filterEditor filterActivator' aria-hidden='true' onclick='lookAtProperties(this)'></span>"+
                    "</th>")
                }
            }
            if (pheno_width > 0) {
                $('#variantTableHeaderRow').append("<th colspan=" + pheno_width + " class=\"datatype-header\"></th>")
            }
            totCol += pheno_width
        }

        for (var pheno in data.columns.pproperty) {
            var pheno_width = 0
            var phenoDisp = mpgSoftware.trans.translator(pheno)
            for (var dataset in data.columns.pproperty[pheno]) {
                var dataset_width = 0
                var datasetDisp = mpgSoftware.trans.translator(dataset)
                for (var i = 0; i < data.columns.pproperty[pheno][dataset].length; i++) {
                    var column = data.columns.pproperty[pheno][dataset][i]
                    var columnDisp = mpgSoftware.trans.translator(column)
                    pheno_width++
                    dataset_width++
                    //HACK HACK HACK HACK HACK
                    if (column.substring(0,2) == "P_") {
                        sortCol = totCol + pheno_width - 1
                    }
                    $('#variantTableHeaderRow3').append("<th class=\"datatype-header\">" + columnDisp + "</th>")
                }
//                if (dataset_width > 0) {
//                    $('#variantTableHeaderRow2').append("<th colspan=" + dataset_width + " class=\"datatype-header\">" + datasetDisp +
//                            "<button type='button' class='btn btn-default dropdown-toggle' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>"+
//                    "<span class='caret'></span>" +
//                    "<span class='sr-only'>Toggle Dropdown</span>" +
//                    "</button>" +
//                    "<ul class='dropdown-menu'>" +
//                            "<li>one</li>" +
//                    "<li>two</li>" +
//                    "</ul>"+
//                            "</th>")
//                }
                if (dataset_width > 0) {
                    $('#variantTableHeaderRow2').append("<th colspan=" + dataset_width + " class=\"datatype-header\">" + datasetDisp +
                            "<span class='glyphicon glyphicon-plus filterEditor propertyAdder' aria-hidden='true' onclick='lookAtProperties(this)'></span>"+
                            "</th>")
                }
//                if (dataset_width > 0) {
//                    $('#variantTableHeaderRow2').append("<th colspan=" + dataset_width + " class=\"datatype-header\">" + datasetDisp +
//                            "<span class='glyphicon glyphicon-plus filterEditor propertyAdder' aria-hidden='true' onclick='mpgSoftware.variantWF.editThisClause(this)'></span>"+
//                            "<span style='padding:2px 0 0 6px' class='glyphicon glyphicon-question-sign pop-auto'  data-toggle='popover' animation='true' "+
//                            " data-container='body'  title='' code='title' data-html='true' data-content='This annotation indicates' code='stuff'/></span>"+
//                            "<a href='#' data-toggle='tooltip' title='Hooray!'><div style='background-color: #fff'>Hover over me</div></a>"+
//                            "</th>")
//                }
//                if (dataset_width > 0) {
//                    $('#variantTableHeaderRow2').append("<th colspan=" + dataset_width + " class=\"datatype-header\">" + datasetDisp +
//                            "<span style='padding:2px 0 0 6px' class='glyphicon glyphicon-question-sign pop-top'  data-toggle='popover' animation='true'  data-container='body'  data-placement='top' title='' data-html='true' data-content='This annotad chain' data-original-title='protein change'></span>"+
//                            "</th>")
//                }
            }
            if (pheno_width > 0) {
                $('#variantTableHeaderRow').append("<th colspan=" + pheno_width + " class=\"datatype-header\">" + phenoDisp + "</th>")
            }
            totCol += pheno_width
        }

        variantProcessing.iterativeVariantTableFiller(data,totCol,sortCol,'#variantTable',
                '<g:createLink controller="variantInfo" action="variantInfo" />',
                '<g:createLink controller="gene" action="geneInfo" />',
                proteinEffectList,{},${newApi});

    }


//needed or not? From the results page...
    %{--var regionSpec = "<%=regionSpecification%>";--}%
    %{--jQuery.fn.dataTableExt.oSort['allnumeric-asc']  = function(a,b) {--}%
        %{--var x = parseFloat(a);--}%
        %{--var y = parseFloat(b);--}%
        %{--if (!x) { x = 1; }--}%
        %{--if (!y) { y = 1; }--}%
        %{--return ((x < y) ? -1 : ((x > y) ?  1 : 0));--}%
    %{--};--}%

    %{--jQuery.fn.dataTableExt.oSort['allnumeric-desc']  = function(a,b) {--}%
        %{--var x = parseFloat(a);--}%
        %{--var y = parseFloat(b);--}%
        %{--if (!x) { x = 1; }--}%
        %{--if (!y) { y = 1; }--}%
        %{--return ((x < y) ? 1 : ((x > y) ?  -1 : 0));--}%
    %{--};--}%
//    var loading = $('#spinner').show();
//    $.ajax({
//        cache:false,
//        type:"get",
//        url:"../regionAjax/"+regionSpec,
//        async:true,
//        success: function (data) {
//            fillTheFields(data) ;
//            loading.hide();
//        },
//        error: function(jqXHR, exception) {
//            loading.hide();
//            core.errorReporter(jqXHR, exception) ;
//        }
//    });
    %{--var  proteinEffectList =  new UTILS.proteinEffectListConstructor (decodeURIComponent("${proteinEffectsList}")) ;--}%
    %{--function fillTheFields (data)  {--}%
        %{--variantProcessing.iterativeVariantTableFiller(data,'#variantTable',--}%
                %{--${show_gene},--}%
                %{--${show_sigma},--}%
                %{--${show_exseq},--}%
                %{--${show_exchp},--}%
                %{--'<g:createLink controller="variant" action="variantInfo" />',--}%
                %{--'<g:createLink controller="gene" action="geneInfo" />',--}%
                %{--proteinEffectList,{},(${newApi}));--}%

    %{--}--}%






</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >



                <h1><g:message code="variantTable.searchResults.title" default="Variant Search Results" /></h1>
                <div class="separator"></div>

                <h3><g:message code="variantTable.searchResults.meetFollowingCriteria1" default="Showing" /> <span id="numberOfVariantsDisplayed"></span>
                    <g:message code="variantTable.searchResults.meetFollowingCriteria2" default="variants that meet the following criteria:" /></h3>
                <script>
                    if (uri_dec)     {
                        $('#tempfilter').append(uri_dec.split('+').join());
                    }
                </script>
                <ul>
                 <g:each in="${filterDescriptions}" >
                     <li>${it}</li>
                 </g:each>
                 </ul>

                <div id="warnIfMoreThan1000Results"></div>

                <p><a href="<g:createLink controller='variantSearch' action='variantSearchWF' params='[encParams:"${encodedParameters}"]'/>" class='boldlink'>
                    <g:message code="variantTable.searchResults.clickToRefine" default="Click here to refine your results" /></a></p>


                <g:if test="${regionSearch}">
                    <g:render template="geneSummaryForRegion" />
                </g:if>

                <g:render template="../region/newCollectedVariantsForRegion" />



            </div>

        </div>
    </div>

</div>

<script>
    $(document).ready(function(){
        $('[data-toggle="tooltip"]').tooltip();
    });
</script>

</body>
</html>
