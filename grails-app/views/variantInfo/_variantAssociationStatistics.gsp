
<style>
    h1,h2,h3,h4,label{
        font-weight: 300;
    }
</style>

<div class="row clearfix">
 <div class="col-md-12">
     <g:message code="variant.info.associations.description" />
 </div>
</div>

<script>
    var variant;
    var fillVariantStatistics = function (phenotype,datasetDescription){
        var rememberPhenotype = phenotype;
        var summaryAndAssociationHeadliner = function (sortedDatasetList, phenotype){
            if (sortedDatasetList.length>0){ // we have something to write
                if ($('#variantPValue').text().length>0){ // if we have already written something then clear it up
                    $('#variantPValue').text('');
                    $('#variantInfoGeneratingDataSet').text('');
                    $('#associationPhenotype').text('');
                }
                var chosenDataSet = sortedDatasetList[0];
                $('#variantPValue').append(chosenDataSet['p_value'].toPrecision(4));
                $('#associationPhenotype').append(phenotype);
                $('#variantInfoGeneratingDataSet').append(mpgSoftware.trans.translator(chosenDataSet['dataset']));

            } else {
                $('#describeBestAssociation').hide();
                $('#noAssociationWithPhenotype').append(mpgSoftware.trans.translator(phenotype));
                $('#describeNoAssociation').show();
            }
        };
        // we use the common properties for other touchups around the page
        var insertTitlesAndMore = function(collector,variantAssociationStrings){
            var gene = '';
            if (collector['common']['GENE']!==null) {
                gene =  collector['common']['GENE'];
            }
            var closestGene = collector['common']['CLOSEST_GENE'];
            var mostdelscore= UTILS.convertStringToNumber(collector['common']['MOST_DEL_SCORE']);
            var varId = collector['common']['VAR_ID'];
            var dbsnpId = collector['common']['DBSNP_ID'];
            if ($('#variantTitle').html().length==0){ // initialize page.  do only once.  TODO: move somewhere else
                mpgSoftware.variantInfo.setTitlesAndTheLikeFromData(varId,dbsnpId,mostdelscore,gene,closestGene,  '<%=variantToSearch%>',
                        "<g:createLink controller='trait' action='traitInfo' />",variantAssociationStrings);
            }
        };
        $.ajax({
            cache: false,
            type: "get",
            url: "${createLink(controller:'variantInfo',action: 'variantDescriptiveStatistics')}",
            data: {variantId: '<%=variantToSearch%>',
                   phenotype: phenotype,
                   datasets: JSON.stringify(datasetDescription)},
            async: true,
            success: function (data) {
                var variantAssociationStrings = {
                    genomeSignificance:'<g:message code="variant.variantAssociations.significance.genomeSignificance" default="GWAS significance" />',
                    locusSignificance:'<g:message code="variant.variantAssociations.significance.locusSignificance" default="locus wide significance" />',
                    nominalSignificance:'<g:message code="variant.variantAssociations.significance.nominalSignificance" default="nominal significance" />',
                    nonSignificance:'<g:message code="variant.variantAssociations.significance.nonSignificance" default="no significance" />',
                    variantPValues:'<g:message code="variant.variantAssociations.variantPValues" default="click here to see a table of P values" />',
                    sourceDiagram:'<g:message code="variant.variantAssociations.source.diagram" default="diagram GWAS" />',
                    sourceDiagramQ:'<g:helpText title="variant.variantAssociations.source.diagramQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.diagramQ.help.text"/>',
                    sourceExomeChip:'<g:message code="variant.variantAssociations.source.exomeChip" default="Exome chip" />',
                    sourceExomeChipQ:'<g:helpText title="variant.variantAssociations.source.exomeChipQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.exomeChipQ.help.text"/>',
                    sourceExomeSequence:'<g:message code="variant.variantAssociations.source.exomeSequence" default="Exome sequence" />',
                    sourceExomeSequenceQ:'<g:helpText title="variant.variantAssociations.source.exomeSequenceQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.exomeSequenceQ.help.text"/>',
                    sourceSigma:'<g:message code="variant.variantAssociations.source.sigma" default="Sigma" />',
                    sourceSigmaQ:'<g:helpText title="variant.variantAssociations.source.sigmaQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.source.sigmaQ.help.text"/>',
                    associationPValueQ:'<g:helpText title="variant.variantAssociations.pValue.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.pValue.help.text"/>',
                    associationOddsRatioQ:'<g:helpText title="variant.variantAssociations.oddsRatio.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.oddsRatio.help.text"/>'
                };
                var collector = {}
                if ((typeof data !== 'undefined')&&
                        (typeof data.variantInfo !== 'undefined')&&
                        (typeof data.variantInfo.results !== 'undefined')&&
                        (typeof data.variantInfo.results[0].pVals !== 'undefined')){
                    for (var j = 0 ; j < data.variantInfo.results[0].pVals.length ; j++ ){
                        if (typeof collector[data.variantInfo.results[0].pVals[j].dataset]=== 'undefined'){
                            collector[data.variantInfo.results[0].pVals[j].dataset] = {};
                        }
                        if (data.variantInfo.results[0].pVals[j].dataset === 'common'){
                            (collector[data.variantInfo.results[0].pVals[j].dataset])[data.variantInfo.results[0].pVals[j].level] = data.variantInfo.results[0].pVals[j].count;
                        } else {
                            (collector[data.variantInfo.results[0].pVals[j].dataset])[data.variantInfo.results[0].pVals[j].meaning] = data.variantInfo.results[0].pVals[j].count[0];
                        }
                    }
                }

                insertTitlesAndMore(collector,variantAssociationStrings);
                // order the data that we are going to put into boxes for the variant info page
                var datasetList = [];
                for (var dataSetKey in collector) {
                    if ((dataSetKey!=='common')&&
                            (collector.hasOwnProperty(dataSetKey))) {
                        var dsObject = collector[dataSetKey];
                        if (dsObject["p_value"]!==null){ // if there are no associations then we're done with this data set
                            var tempObject = {};
                            tempObject['dataset'] = dataSetKey;
                            for (var dsElement in dsObject) {
                                if (dsObject.hasOwnProperty(dsElement)){
                                    tempObject[dsElement] =  dsObject [dsElement] ;
                                }
                            }
                            datasetList.push(tempObject);
                        }
                    }
                }
                var sortedDatasetList = [];
                if (datasetList.length>0){
                    sortedDatasetList = datasetList.sort(function(a,b){
                        return (a.p_value - b.p_value);
                    })
                }
                if ((sortedDatasetList.length>1)&&
                        (sortedDatasetList[0].p_value <.05)) {
                    var formSelector = "#holdAssociationStatisticsBoxes";
                    var titleSelector = formSelector + "_title";
                    $(titleSelector).text(mpgSoftware.trans.translator(rememberPhenotype));
                    '_title'
                    var variantAssociationStatistics = mpgSoftware.variantInfo.variantAssociations;
                    variantAssociationStatistics(
                            collector['common'], // object
                            sortedDatasetList, // array
                            "<%=variantToSearch%>",
                            "<g:createLink controller='trait' action='traitInfo' />",
                            variantAssociationStrings,
                            formSelector);
                    $(formSelector).lightSlider({
                        //loop:true,
                        keyPress: true
                    });
                }
                summaryAndAssociationHeadliner(sortedDatasetList, rememberPhenotype);

                $('[data-toggle="popover"]').popover();

            },
           error: function (jqXHR, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);
            }
        });

    };
    var gatherVariantStatistics = function (phenotype,datasetDescription,selectorForStatisticsBoxes){
        var selectorForStatisticsBoxesValues = selectorForStatisticsBoxes;
        var rememberPhenotype = phenotype;
        $.ajax({
            cache: false,
            type: "get",
            url: "${createLink(controller:'variantInfo',action: 'variantDescriptiveStatistics')}",
            data: {variantId: '<%=variantToSearch%>',
                phenotype: phenotype,
                datasets: JSON.stringify(datasetDescription)},
            async: true,
            success: function (data) {
                var variantAssociationStrings = {
                    genomeSignificance:'<g:message code="variant.variantAssociations.significance.genomeSignificance" default="GWAS significance" />',
                    locusSignificance:'<g:message code="variant.variantAssociations.significance.locusSignificance" default="locus wide significance" />',
                    nominalSignificance:'<g:message code="variant.variantAssociations.significance.nominalSignificance" default="nominal significance" />',
                    nonSignificance:'<g:message code="variant.variantAssociations.significance.nonSignificance" default="no significance" />',
                    variantPValues:'<g:message code="variant.variantAssociations.variantPValues" default="click here to see a table of P values" />',
                    associationPValueQ:'<g:helpText title="variant.variantAssociations.pValue.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.pValue.help.text"/>',
                    associationOddsRatioQ:'<g:helpText title="variant.variantAssociations.oddsRatio.help.header"  qplacer="2px 0 0 6px" placement="right" body="variant.variantAssociations.oddsRatio.help.text"/>'
                };
                var collector = {};
                console.log('rememberPhenotype='+rememberPhenotype);
                if ((typeof data !== 'undefined')&&
                        (typeof data.variantInfo !== 'undefined')&&
                        (typeof data.variantInfo.results !== 'undefined')&&
                        (typeof data.variantInfo.results[0].pVals !== 'undefined')){
                    for (var j = 0 ; j < data.variantInfo.results[0].pVals.length ; j++ ){
                        if (typeof collector[data.variantInfo.results[0].pVals[j].dataset]=== 'undefined'){
                            collector[data.variantInfo.results[0].pVals[j].dataset] = {};
                        }
                        if (data.variantInfo.results[0].pVals[j].dataset === 'common'){
                            (collector[data.variantInfo.results[0].pVals[j].dataset])[data.variantInfo.results[0].pVals[j].level] = data.variantInfo.results[0].pVals[j].count;
                        } else {
                            (collector[data.variantInfo.results[0].pVals[j].dataset])[data.variantInfo.results[0].pVals[j].meaning] = data.variantInfo.results[0].pVals[j].count[0];
                        }
                    }
                }
                var datasetList = [];
                for (var dataSetKey in collector) {
                    if ((dataSetKey!=='common')&&
                            (collector.hasOwnProperty(dataSetKey))) {
                        var dsObject = collector[dataSetKey];
                        if (dsObject["p_value"]!==null){ // if there are no associations then we're done with this data set
                            var tempObject = {};
                            tempObject['dataset'] = dataSetKey;
                            for (var dsElement in dsObject) {
                                if (dsObject.hasOwnProperty(dsElement)){
                                    tempObject[dsElement] =  dsObject [dsElement] ;
                                }
                            }
                            datasetList.push(tempObject);
                        }
                    }
                }
                var sortedDatasetList = [];
                if (datasetList.length>0){
                    sortedDatasetList = datasetList.sort(function(a,b){
                        return (a.p_value - b.p_value);
                    })
                }
                if ((sortedDatasetList.length>0)&&
                        (sortedDatasetList[0].p_value <.05)){
                    var formSelector = "#"+selectorForStatisticsBoxesValues;
                    var titleSelector = formSelector+"_title";
                    $(titleSelector).text(mpgSoftware.trans.translator(rememberPhenotype));
                    mpgSoftware.variantInfo.variantAssociations(
                            collector['common'], // object
                            sortedDatasetList, // array
                            "<%=variantToSearch%>",
                            "<g:createLink controller='trait' action='traitInfo' />",
                            variantAssociationStrings,
                            formSelector);
                    // lower boxes
                    $(formSelector).lightSlider({
                        //loop:true,
                        //keyPress:true,
                        autoWidth: false,
                        //vertical: false,
                        onSliderLoad: function() {
                            $(formSelector).removeClass('cS-hidden');
                        }
                    });
                }
            },
            error: function (jqXHR, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);
            }
        });

    };



    UTILS.retrieveSampleGroupsbyTechnologyAndPhenotype(['GWAS','ExChip','ExSeq'],'T2D',
            "${createLink(controller: 'VariantSearch', action: 'retrieveTopSGsByTechnologyAndPhenotypeAjax')}",fillVariantStatistics );
    $(function() {
        $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(controller: 'VariantSearch', action: 'retrievePhenotypesAjax')}",
            data: {},
            async: true,
            success: function (data) {
                if (( data !==  null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !==  null )  &&
                        ( typeof data.datasets.dataset !== 'undefined' ) ) {
                    for ( var category in data.datasets.dataset ){

                        if (data.datasets.dataset.hasOwnProperty(category)) {
                            var propertyArray = data.datasets.dataset[category];
                            for ( var i = 0 ; i < propertyArray.length ; i++ ){
                                if (propertyArray[i] !== 'T2D'){ // T2D is handled first by default, so we can skip it here
                                    var holdAssociationStatistics = "holdAssociationStatisticsBoxes_"+propertyArray[i];
                                    $('#VariantsAndAssociationsExist').append( "<div id='"+holdAssociationStatistics+"_title' class='rowTitle'></div><div class='items'><div class='item'><ul id='"+holdAssociationStatistics+"' class='content-slider'></ul></div></div>");
                                    UTILS.retrieveSampleGroupsbyTechnologyAndPhenotype(['GWAS','ExChip','ExSeq'],propertyArray[i],
                                            "${createLink(controller: 'VariantSearch', action: 'retrieveTopSGsByTechnologyAndPhenotypeAjax')}",gatherVariantStatistics, holdAssociationStatistics );

                                }

                            }
                        }
                    }

                }
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });
    });
    var launchVarAssocRefresh = function(phenotypeChooser){
        UTILS.retrieveSampleGroupsbyTechnologyAndPhenotype(['GWAS','ExChip','ExSeq'],phenotypeChooser.value,
                "${createLink(controller: 'VariantSearch', action: 'retrieveTopSGsByTechnologyAndPhenotypeAjax')}",fillVariantStatistics );
    };
    var gatherAssociationsForPhenotype = function(phenotype){
        UTILS.retrieveSampleGroupsbyTechnologyAndPhenotype(['GWAS','ExChip','ExSeq'],phenotype,
                "${createLink(controller: 'VariantSearch', action: 'retrieveTopSGsByTechnologyAndPhenotypeAjax')}",fillVariantStatistics );
    };

</script>


<br/>

<div id="VariantsAndAssociationsExist" style="overflow-y: scroll; height: 500px;">
    <div class="items">
        <div class="item">
            <div id='holdAssociationStatisticsBoxes_title' class='rowTitle'></div>
            <ul id="holdAssociationStatisticsBoxes" class="content-slider">

            </ul>
        </div>
    </div>
</div>

<div id="VariantsAndAssociationsNoExist"  style="display: none">
    <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/></h4>
</div>

<br/>

%{--<p>--}%
    %{--<span id="variantInfoAssociationStatisticsLinkToTraitTable"></span>--}%

%{--</p>--}%


