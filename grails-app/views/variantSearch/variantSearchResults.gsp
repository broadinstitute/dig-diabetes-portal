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
    span.singprop{
        white-space:nowrap;
    }
    div.propertyHolder {
        position: absolute;
        background-color: white;
        height:160px;
        width:290px;
        border: 2px solid green;
        margin: 5px;
        padding: 10px;
        text-align: left;
    }
    div.propertySubHolder{
        position: relative;
        margin: 3px;
        height:100px;
        width:270px;
        overflow-y: auto;
        overflow-x: hidden;
        background-color: #eee;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        -khtml-border-radius: 5px;
        border-radius: 5px;

    }
    div.propertyHolder .propertyHolderChk {
        color:black;
        margin: 5px 0 5px 0;
    }
    .chkBoxText{
        color:black;
        margin: 5px 0 5px 0;
        padding: 0 0 0 10px;
        white-space:normal;
    }
    .propBox {
        color:white;
        margin: 5px 0 5px 0;
        position: absolute;
        bottom: 0;
    }

</style>

</head>

<body>


<script>
    var getPropData = function (){
        var varsToSend = {};
        var savedValuesList = [];
        var savedValue = {};
        var totalFilterCount = UTILS.extractValFromTextboxes(['totalFilterCount']);
        if (typeof totalFilterCount['totalFilterCount'] !== 'undefined') {
            var valueCount = parseInt(totalFilterCount['totalFilterCount']);
            if (valueCount>0){
                for ( var i = 0 ; i < valueCount ; i++ ){
                    savedValuesList.push ('savedValue'+i);
                }
                savedValue = UTILS.extractValFromTextboxes(savedValuesList);
            }
        }
        varsToSend = UTILS.concatMap(varsToSend,savedValue) ;
        return varsToSend;
    };
    var skipBubbleUp = false;
    var radbut = function(t,e,f){
        console.log('t='+t+', this='+this);
        t.checked=false;
    } ;
    var closer = function(that){
        $(that).parent().parent().hide();
        skipBubbleUp = true;
    } ;
var rememberProperty = function(phenotype,dataSet,propertyList, addIt){
    var mapOfExistingProperties = {};
    var numberOfFields = 0;
    for ( var i = 0 ; i < 200 ; i++ ){
        var savedField = $('#savedValue'+i);
        if (savedField.length > 0){
            mapOfExistingProperties[savedField.val()]=savedField.attr('id');
            numberOfFields++;
        }
    }
    var hiddenFields = $('#hiddenFields');
     if ((hiddenFields.size()>0) && (propertyList) && (propertyList.length>0)){
         for ( var i = 0 ; i < propertyList.length ; i++ ){
             var totalFilterCount = parseInt($('#totalFilterCount').val());
             var codedValue = 'propId^'+phenotype +'^'+dataSet +'^'+ propertyList[i];
             if (addIt){// add the field of it doesn't exist already
                 if (!mapOfExistingProperties[codedValue]) {
                     hiddenFields.append('<input type="hidden" class="form-control" name="savedValue'+(totalFilterCount +1)+'" id="savedValue'+(totalFilterCount +1)+'" value="'+codedValue+'" style="height:0px">');
                 }
                 $('#totalFilterCount').val(totalFilterCount +1);
             } else { // remove it
                 var existingField = mapOfExistingProperties[codedValue];
                 $('#'+existingField).remove();
                 $('#totalFilterCount').val(totalFilterCount -1);
             }
         }
     }

}
    var lookAtProperties = function (here,phenotype,dataSet,propertyList,currentPropertyList){
    if (skipBubbleUp){
        skipBubbleUp = false;
        return;
    }
    var propId = "propId^"+phenotype+"^"+dataSet;
    var propDivName = "propId_"+phenotype+"_"+dataSet;
    if ($('#'+propDivName).is(":visible")){
//        console.log("div click 3");
//        $('#'+propDivName).hide();
    } else {
        if ($('#'+propDivName).size()===0){//we haven't made this window before
            var expandedProperties = "";
            for ( var i = 0 ; i < propertyList.length ; i++ ){
                var propertyAlreadyExists = "";
                if (currentPropertyList.indexOf(propertyList[i])>-1){
                    propertyAlreadyExists = " checked";
                }
                expandedProperties += ('<span class="singprop"><input  class="propertyHolderChk" type="checkbox" name="'+propId+'" value="'+propertyList[i]+
                        '" '+propertyAlreadyExists+'><label class="chkBoxText">'+mpgSoftware.trans.translator(propertyList[i])+'</label></input><br/></span>');
            }
            $(here).append("<div id='"+propDivName+"' class ='propertyHolder'>"+//<form action=\"./relaunchAVariantSearch\">"+
                    "<a style='float:right' onclick='closer(this)'>X</a>"+
                    "<div class='propertySubHolder'>"+
                    "<input type=\"hidden\"  name=\"encodedParameters\" value=\"<%=encodedParameters%>\">"+
                    "<input type=\"hidden\"  name=\"filters\" value=\"<%=filter%>\">"+
                    expandedProperties+
                    "</div>"+
//                    "<input type=\"submit\" class=\"propBox btn btn-xs btn-primary center-block\" value=\"Display properties\">"+
                    "<button onclick=\"$('#relauncher').click()\" class=\"propBox btn btn-xs btn-primary center-block\">Launch refined search</button>"+
                 //   "</form>"+
                    "</div>");
            $('#'+propDivName).change(function(event) {
                event.stopPropagation();
                event.stopImmediatePropagation() ;
                event.preventDefault()  ;
                console.log("div click 1");
            });

            $("input[type=checkbox]").change(function(event) {
                $('#'+propDivName).show();
                event.stopPropagation();
                event.stopImmediatePropagation() ;
                event.preventDefault()  ;
                console.log("div click 2");
                var fieldName = $(this).attr('name');
                var dividedFields = fieldName.split('^');
                var property = $(this).val();
                rememberProperty(dividedFields[1],dividedFields[2],[property], $(this)[0].checked);
            });
        } else {
            $('#'+propDivName).show();
        }
    }
};
    var  proteinEffectList =  new UTILS.proteinEffectListConstructor (decodeURIComponent("${proteinEffectsList}")) ;
var loadVariantTableViaAjax = function(filterDefinitions,additionalProperties){
    var loading = $('#spinner').show();
    loading.show();
    $.ajax({
        type:'POST',
        cache:false,
        data:{'keys':filterDefinitions,
              'properties':additionalProperties},
        url:'<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsAjax" />',
        async:true,
        success:function(data,textStatus){
            var variantTableContext = {
                tooManyResults:'<g:message code="variantTable.searchResults.tooManyResults" default="too many results, sharpen your search" />'
            };
            dynamicFillTheFields(data) ;

            loading.hide();
        },
        error:function(XMLHttpRequest,textStatus,errorThrown){
            loading.hide();
            errorReporter(XMLHttpRequest, exception) ;
        }
    });
}
loadVariantTableViaAjax("<%=filter%>","<%=additionalProperties%>");

    var uri_dec = decodeURIComponent("<%=filter%>");
    var encodedParameters = decodeURIComponent("<%=encodedParameters%>");


    var  proteinEffectList =  new UTILS.proteinEffectListConstructor (decodeURIComponent("${proteinEffectsList}")) ;
    function buildPropertyInteractor(data,phenotype,dataSet,existingCols){
        var returnValue="";
        // get our property list
        var propertyList = [];
        if ((typeof data !== 'undefined') &&
             (data) && (data.metadata)) {
            if ((dataSet == 'common') && (data.metadata[phenotype])) {
                propertyList = Object.keys(data.metadata[phenotype]);
            } else if (phenotype == 'common') {
                propertyList = data.propertiesPerSampleGroup.dataset[dataSet];
            } else if ((data.metadata[phenotype][dataSet]) && ((data.metadata[phenotype][dataSet]).length > 0)) {
                propertyList = data.metadata[phenotype][dataSet];
            } else {// error
                propertyList = [];
            }
            returnValue = "<span class='glyphicon glyphicon-plus filterEditor propertyAdder' aria-hidden='true' onclick='lookAtProperties(this,\""+phenotype+"\",\""+dataSet+"\",[\""+
                    propertyList.join('\",\"')+"\"],[\""+ existingCols.join('\",\"')+"\"])'></span>";
            }
        return returnValue;
    }
    function buildCPropertyInteractor(propertyList,existingCols){
        var returnValue="";
        // get our property list
        if (typeof propertyList !== 'undefined') {
            returnValue = "<span style='float:right' class='glyphicon glyphicon-plus filterEditor propertyAdder' aria-hidden='true' onclick='lookAtProperties(this,\"common\",\"common\",[\""+
                    propertyList.join('\",\"')+"\"],[\""+ existingCols.join('\",\"')+"\"])'></span>";
        }
        return returnValue;
    }

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

        // common props section
        var sortCol = 0;
        var totCol = 0;
        $('#variantTableHeaderRow2').children().first().append(buildCPropertyInteractor(data.cProperties.dataset,data.columns.cproperty));
        var commonWidth = 0;
        for (var common in data.columns.cproperty) {
            var colName = data.columns.cproperty[common];
            $('#variantTableHeaderRow3').append("<th class=\"datatype-header\">" + mpgSoftware.trans.translator(colName) + "</th>")
            commonWidth++;
         }
        rememberProperty('common','common',data.columns.cproperty, true);
        $('#variantTableHeaderRow').children().first().attr('colspan',commonWidth) ;
        $('#variantTableHeaderRow2').children().first().attr('colspan',commonWidth) ;

        totCol += commonWidth;


        // dataset specific props
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
                    rememberProperty('common',dataset,data.columns.dproperty[pheno][dataset], true);
                    $('#variantTableHeaderRow2').append("<th colspan=" + dataset_width + " class=\"datatype-header\">" + datasetDisp +
                            buildPropertyInteractor(data,'common',dataset,data.columns.dproperty[pheno][dataset])+
                    "</th>")
                }
            }
            if (pheno_width > 0) {
                $('#variantTableHeaderRow').append("<th colspan=" + pheno_width + " class=\"datatype-header\"></th>")
            }
            totCol += pheno_width
        }

        // pheno specific props
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
                if (dataset_width > 0) {
                    rememberProperty(pheno,dataset,data.columns.pproperty[pheno][dataset], true);
                    $('#variantTableHeaderRow2').append("<th colspan=" + dataset_width + " class=\"datatype-header\">" + datasetDisp +
                            buildPropertyInteractor(data,pheno,dataset,data.columns.pproperty[pheno][dataset])+
                            "</th>")
                }
            }
            if (pheno_width > 0) {
                $('#variantTableHeaderRow').append("<th colspan=" + pheno_width + " class=\"datatype-header\">" + phenoDisp +
                        buildPropertyInteractor(data,pheno,'common',Object.keys(data.columns.pproperty[pheno]))+
                        "</th>")
            }
            totCol += pheno_width
        }

        variantProcessing.iterativeVariantTableFiller(data,totCol,sortCol,'#variantTable',
                '<g:createLink controller="variantInfo" action="variantInfo" />',
                '<g:createLink controller="gene" action="geneInfo" />',
                proteinEffectList,{},${newApi});

    }





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
<div style="display: hidden">
    <form action="./relaunchAVariantSearch">
        <input type="hidden"  name="encodedParameters" value="<%=encodedParameters%>">
        <input type="hidden"  name="filters" value="<%=filter%>">
    <div id="hiddenFields">
        <input type="hidden" class="form-control" name="totalFilterCount" id="totalFilterCount" value="0" style="height:0px">
    </div>
    <input id='relauncher' type="submit" class="propBox btn btn-xs btn-primary center-block" value="1" style="height:0px">
    </form>
</div>
<script>
    $(document).ready(function(){
        $('[data-toggle="tooltip"]').tooltip();
    });
</script>

</body>
</html>
