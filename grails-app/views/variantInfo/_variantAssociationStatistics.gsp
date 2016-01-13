
<style>
    h1,h2,h3,h4,label{
        font-weight: 300;
    }
</style>


<script>
    var variant;
    var fillVariantStatistics = function (phenotype,datasetDescription){
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
                // we use the common properties for other touchups around the page
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

                var variantAssociationStatistics = mpgSoftware.variantInfo.variantAssociations;
                variantAssociationStatistics(
                        collector['common'], // object
                        sortedDatasetList, // array
                        "<%=variantToSearch%>",
                        "<g:createLink controller='trait' action='traitInfo' />",
                        variantAssociationStrings);
                var dataSetAndPValues = {};

                if (sortedDatasetList.length>0){
                    var chosenDataSet = sortedDatasetList[0];
                    $('#variantPValue').append(chosenDataSet['p_value'].toPrecision(4));
                    $('#variantInfoGeneratingDataSet').append(mpgSoftware.trans.translator(chosenDataSet['dataset']));

                } else {
                    $('#describeBestAssociation').hide();
                    $('#noAssociationWithPhenotype').append(mpgSoftware.trans.translator(rememberPhenotype));
                    $('#describeNoAssociation').show();
                }

                $('[data-toggle="popover"]').popover();

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
                        (  data.datasets !==  null ) ) {
                    UTILS.fillPhenotypeCompoundDropdown(data.datasets,'#phenotypeTableChooser',true);
                    // Can we set the default option on the phenotype list?
                    $('#phenotypeTableChooser').val('T2D');
                    %{--refreshVAndAByPhenotype({'value':'T2D'});--}%
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

</script>



<br/>
<div class="row clearfix">

    <div class="col-md-6" style="text-align: left; font-size: 18px; font-weight: bold">
        <div  class="form-horizontal">
            <div class="form-group">
                <label for="phenotypeTableChooser"><g:message code="gene.variantassociations.change.phenotype" default="Change phenotype choice"/></label>
                &nbsp;
                <select id="phenotypeTableChooser" name="phenotypeTableChooser" onchange="launchVarAssocRefresh(this)">
                 </select>
            </div>
        </div>
    </div>
    <div class="col-md-6"></div>
</div>
<div id="VariantsAndAssociationsExist" style="display: block">
    <div class="row clearfix">

        <g:renderT2dGenesSection>
            <div  class="col-md-12 association_stats_boxes" id="holdAssociationStatisticsBoxes">

            </div>
        </g:renderT2dGenesSection>

    </div>
</div>

<div id="VariantsAndAssociationsNoExist"  style="display: none">
    <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/></h4>
</div>

<br/>

%{--<p>--}%
    %{--<span id="variantInfoAssociationStatisticsLinkToTraitTable"></span>--}%

%{--</p>--}%


