var variant;
var geneInfoRec = {
    ID: 1,
    CHROM: 2,
    BEG: 3,
    END: 4,
    Function_description: 5,
    _13k_T2D_VAR_TOTAL: 6,
    _13k_T2D_ORIGIN_VAR_TOTALS: 7,
    HS: 8,
    AA: 9,
    EU:10,
    EA:11,
    SA: 12,
    SING: 13,
    RARE: 14,
    LOW_FREQUENCY: 15,
    COMMON: 16,
    TOTAL: 17,
    NS: 18,
    _13k_T2D_lof_NVAR: 19,
    _13k_T2D_lof_MINA_MINU_RET: 20,
    _13k_T2D_lof_METABURDEN: 21,
    _13k_T2D_GWS_TOTAL: 22,
    _13k_T2D_NOM_TOTAL: 23,
    EXCHP_T2D_VAR_TOTALS: 24,
    EXCHP_T2D_GWS_TOTAL: 25,
    EXCHP_T2D_NOM_TOTAL: 26,
    GWS_TRAITS: 27,
    GWAS_T2D_GWS_TOTAL: 28,
    GWAS_T2D_NOM_TOTAL: 29,
    GWAS_T2D_VAR_TOTAL: 30,
    EXCHP_T2D_VAR_TOTALS_EU_TOTAL: 31,
    SIGMA_T2D_VAR_TOTAL: 32,
    SIGMA_T2D_GWS_TOTAL: 33,
    SIGMA_T2D_NOM_TOTAL: 34,
    _13k_T2D_lof_OBSA: 35,
    _13k_T2D_lof_OBSU: 36
};
function revG(d){
    var v;
    switch(d) {
        case 1:v="ID"; break;
        case 2:v="CHROM";break;
        case 3:v="BEG";break;
        case 4:v="END";break;
        case 5:v="Function_description";break;
        case 6:v="_13k_T2D_VAR_TOTAL";break;
        case 7:v="_13k_T2D_ORIGIN_VAR_TOTALS";break;
        case 8:v="HS";break;
        case 9:v="AA";break;
        case 10:v="EU";break;
        case 11:v="EA";break;
        case  12:v="SA";break;
        case  13:v="SING";break;
        case  14:v="RARE";break;
        case  15:v="LOW_FREQUENCY";break;
        case  16:v="COMMON";break;
        case  17:v="TOTAL";break;
        case  18:v="NS";break;
        case  19:v="_13k_T2D_lof_NVAR";break;
        case  20:v="_13k_T2D_lof_MINA_MINU_RET";break;
        case  21:v="_13k_T2D_lof_METABURDEN";break;
        case  22:v="_13k_T2D_GWS_TOTAL";break;
        case  23:v="_13k_T2D_NOM_TOTAL";break;
        case  24:v="EXCHP_T2D_VAR_TOTALS";break;
        case  25:v="EXCHP_T2D_GWS_TOTAL";break;
        case  26:v="EXCHP_T2D_NOM_TOTAL";break;
        case  27:v="GWS_TRAITS";break;
        case  28:v="GWAS_T2D_GWS_TOTAL";break;
        case  29:v="GWAS_T2D_NOM_TOTAL";break;
        case  30:v="GWAS_T2D_VAR_TOTAL";break;
        case  31:v="EXCHP_T2D_VAR_TOTALS.EU.TOTAL";break;
        case  32:v="SIGMA_T2D_VAR_TOTAL";break;
        case  33:v="SIGMA_T2D_GWS_TOTAL";break;
        case  34:v="SIGMA_T2D_NOM_TOTAL";break;
        case  35:v="_13k_T2D_lof_OBSA";break;
        case  36:v="_13k_T2D_lof_OBSU";break;
        default: v="";
    }
    return v;
}
function expandRegionBegin(geneExtentBeginning) {
    if (geneExtentBeginning)  {
        return Math.max(geneExtentBeginning-500000,0);
    } else {
        return 0;
    }
}
function expandRegionEnd(geneExtentEnding) {
    if (geneExtentEnding)  {
        return geneExtentEnding+500000;
    } else {
        return 0;
    }
}
// walk into nested fields
function geneFieldOrZero(geneInfo,filedNumber,defaultValue) {
    var retval = 0;
    var fieldName  = revG(filedNumber);
    if ((geneInfo)  && (fieldName.length>0)) {
        var fieldBreakdown = fieldName.split("."); // step into complex fields
        retval =   geneInfo[fieldBreakdown[0]];
        if ((retval)&&(fieldBreakdown.length>1)){
            for (  var i = 1 ; i < fieldBreakdown.length ; i++ ) {
                var nextLevelSpec =  fieldBreakdown[i];
                retval =  retval[nextLevelSpec];
            }
        }
    }
    if (!retval) {    // deal with a null.  Use a zero unless we are given an explicit alternative
        if (typeof defaultValue!=="undefined"){
            retval = defaultValue;
        }  else {
            retval=0;
        }
    }
    return retval;
}
function variantsAndAssociationsTitleLine (geneInfo, // Raw info
                                           totalNumberField,  // Which field are we reading
                                           description,  // Special text for each line
                                           chromosomeField,  // Chromosome number, in case we need it for the link
                                           beginPositionField, // Beginning extent, in case we needed for the link
                                           endPositionField, // Ending extent, in case we need it for the link
                                           typeOfSearch, // Is this a region search chip or by gene
                                           dataset,  // exomeseq, exomechip, gwas
                                           significance,
                                           textSpanId, // Span we are modifying
                                           anchorId, // Anchor we are modifying
                                           rootRegionUrl, // Root URL if this is a region search
                                           rootGeneUrl){
    var currentLine = "There are ";
    var totalNumber =  geneFieldOrZero(geneInfo,totalNumberField);
    if (totalNumber > 0){
        currentLine += '<strong>';
    }
    currentLine += (totalNumber+" total variants ");
    if (totalNumber > 0){
        currentLine += '</strong>';
    }
    currentLine += (" "+description+" | ");
    $(textSpanId).append (currentLine);
    if (typeOfSearch === "region")  {
        $(anchorId)[0].href= rootGeneUrl + "/"+ geneFieldOrZero(geneInfo,geneInfoRec.ID)+"?sig="+significance+"&dataset="+dataset +"&region=chr"+geneFieldOrZero(geneInfo,chromosomeField)+":"+expandRegionBegin(geneFieldOrZero(geneInfo,beginPositionField))+"-"+expandRegionEnd(geneFieldOrZero(geneInfo,endPositionField));
    }    else  {
        $(anchorId)[0].href = rootGeneUrl + "/"+ geneFieldOrZero(geneInfo,geneInfoRec.ID)+"?sig="+significance+"&dataset="+dataset ;
    }

}
function variantsAndAssociationsContentsLine (geneInfo, // Raw info
                                              totalNumberField,  // Which field are we reading
                                              description,  // Special text for each line
                                              chromosomeField,  // Chromosome number, in case we need it for the link
                                              beginPositionField, // Beginning extent, in case we needed for the link
                                              endPositionField, // Ending extent, in case we need it for the link
                                              typeOfSearch, // gene or region
                                              dataset,  // exomeseq, exomechip, gwas
                                              significance,    // anything, gwasSig, nominalSig
                                              textSpanId, // Span we are modifying
                                              anchorId, // Anchor we are modifying
                                              rootRegionUrl, // Root URL if this is a region search
                                              rootGeneUrl){
    var currentLine = "";
    var totalNumber =  geneFieldOrZero(geneInfo,totalNumberField);
    if ((totalNumber > 0)  && (description ==='genome-wide')){
        currentLine += '<strong>';
    }
    currentLine += (totalNumber+"  are associated with type 2 diabetes at or above "+description+" significance ");
    if ((totalNumber > 0)  && (description ==='genome-wide')){
        currentLine += '</strong>';
    }
    currentLine += " | ";
    $(textSpanId).append (currentLine);
    if (typeOfSearch === "region") {
        $(anchorId)[0].href = rootGeneUrl + "/" + geneFieldOrZero(geneInfo, geneInfoRec.ID) + "?sig=" + description + "&dataset=" + dataset+"&region=chr"+geneFieldOrZero(geneInfo,chromosomeField)+":"+expandRegionBegin(geneFieldOrZero(geneInfo,beginPositionField))+"-"+expandRegionEnd(geneFieldOrZero(geneInfo,endPositionField));
    } else {
        $(anchorId)[0].href = rootGeneUrl + "/" + geneFieldOrZero(geneInfo, geneInfoRec.ID) + "?sig=" + description + "&dataset=" + dataset;
    }
}
function fillVarianceAndAssociations (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootRegionUrl, rootGeneUrl,rootVariantUrl){

    // show traits
    if(show_gwas){
        var htmlAccumulator  =  "";
        if (rawGeneInfo["GWS_TRAITS"]){
            var traitArray = rawGeneInfo["GWS_TRAITS"];
            if (traitArray.length > 0){
                htmlAccumulator  +=  ("<strong> "+
                    "<p>Variants within "+rawGeneInfo['ID']+" 100kb of our also significantly associated with:</p>"+
                    "<ul>");
                for ( var i = 0 ; i < traitArray.length ; i++ ) {
                    var traitRepresentation = "";
                    if ((typeof phenotype !== "undefined" ) &&
                        (phenotype.phenotypeMap) &&
                        (phenotype.phenotypeMap [traitArray[i]])){
                        traitRepresentation =  phenotype.phenotypeMap [traitArray[i]];
                    } else {
                        traitRepresentation =  traitArray[i];
                    }
                    htmlAccumulator  += ("<li>"+traitRepresentation+"</li>")
                }
                htmlAccumulator  +=  ("</ul>"+
                    "</strong>");
            }
        }  else {
            htmlAccumulator  +=  "<p>Variants in or near this gene have not been convincingly associated with any traits at genome-wide significance in the GWAS meta-analyses included in this portal.</p>"
        }
        $('#gwasTraits').append(htmlAccumulator);
    }

//    // fill in trait vis
//    $('#linkToVariantTraitCross')[0].href= rootGeneUrl+"/chr"+
//        geneFieldOrZero(rawGeneInfo,geneInfoRec.CHROM)+":"+
//        expandRegionBegin(geneFieldOrZero(rawGeneInfo,geneInfoRec.BEG))+"-"+
//        expandRegionEnd(geneFieldOrZero(rawGeneInfo,geneInfoRec.END)) ;

}
function buildAnchorForVariantSearches (displayableContents,geneName, filter,rootVariantUrl){
    var returnValue = "";
    returnValue += ("<a class='boldlink' href='"+ rootVariantUrl+"/"+geneName+"?filter="+filter+"'>"+
        displayableContents+"</a>");
    return  returnValue;
}
function fillVariationAcrossEthnicity (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl) {
    if  ((rawGeneInfo)&&
        (rawGeneInfo["_13k_T2D_ORIGIN_VAR_TOTALS"]))  {
        var ethnicityMap = rawGeneInfo["_13k_T2D_ORIGIN_VAR_TOTALS"];
        for (var ethnicityKey in ethnicityMap) {
            if (ethnicityMap.hasOwnProperty(ethnicityKey)) {
                var ethnicityRec  = ethnicityMap[ethnicityKey];
                var sing = (ethnicityRec ["SING"])?(ethnicityRec ["SING"]): 0;
                var rare = (ethnicityRec ["RARE"])?(ethnicityRec ["RARE"]): 0;
                var displayableRare =  rare+sing;
                var lowFrequency = (ethnicityRec ["LOW_FREQUENCY"])?(ethnicityRec ["LOW_FREQUENCY"]): 0;
                var common = (ethnicityRec ["COMMON"])?(ethnicityRec ["COMMON"]): 0;
                var total = (ethnicityRec ["TOTAL"])?(ethnicityRec ["TOTAL"]): 0;
                var ns = (ethnicityRec ["NS"])?(ethnicityRec ["NS"]): 0;
                $('#continentalVariationTableBody').append ('<tr>'+
                    '<td>' + UTILS.expandEthnicityDesignation (ethnicityKey) + '</td>'+
                    '<td>exome sequence</td>'+
                    '<td>' + ns + '</td>'+
                    '<td>' + buildAnchorForVariantSearches(total,rawGeneInfo["ID"],'total-'+ethnicityKey,rootVariantUrl) + '</td>'+
                    '<td>' + buildAnchorForVariantSearches(common,rawGeneInfo["ID"],'common-'+ethnicityKey,rootVariantUrl) + '</td>'+
                    '<td>' + buildAnchorForVariantSearches(lowFrequency,rawGeneInfo["ID"],'lowfreq-'+ethnicityKey,rootVariantUrl) + '</td>'+
                    '<td>' + buildAnchorForVariantSearches(displayableRare,rawGeneInfo["ID"],'rare-'+ethnicityKey,rootVariantUrl) + '</td>'+
                    '</tr>');
            }
        }

        if (rawGeneInfo["EXCHP_T2D_VAR_TOTALS"]) {
            var excomeChip = rawGeneInfo["EXCHP_T2D_VAR_TOTALS"];
            if  (excomeChip["EU"] ){
                var excomeChipEuropean = excomeChip["EU"];
                if (excomeChipEuropean["NS"]){
                    $('#continentalVariationTableBody').append ('<tr>'+
                        '<td>European</td>'+
                        '<td>exome chip</td>'+
                        '<td>' + excomeChipEuropean["NS"] + '</td>'+
                        '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["TOTAL"],rawGeneInfo["ID"],'total-exchp',rootVariantUrl) + '</td>'+
                        '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["COMMON"],rawGeneInfo["ID"],'common-exchp',rootVariantUrl) + '</td>'+
                        '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["LOW_FREQUENCY"],rawGeneInfo["ID"],'lowfreq-exchp',rootVariantUrl) + '</td>'+
                        '<td>' + buildAnchorForVariantSearches(excomeChipEuropean["RARE"],rawGeneInfo["ID"],'rare-exchp',rootVariantUrl) + '</td>'+
                        '</tr>');

                }
            }

        }
    }
}
function buildAnchorForRegionVariantSearches (displayableContents,geneName, significanceFilter,dataset,regionSpecification,rootVariantUrl){
    var returnValue = "";
    returnValue += ("<a class='boldlink' href='"+ rootVariantUrl+"/"+geneName+"?sig="+significanceFilter+
        "&dataset="+dataset + "&region=" +regionSpecification+"'>"+
        displayableContents+"</a>");
    return  returnValue;
}
function buildAnchorForGeneVariantSearches (displayableContents,geneName, significanceFilter,dataset,junk,rootVariantUrl){
    var returnValue = "";
    returnValue += ("<a class='boldlink' href='"+ rootVariantUrl+"/"+geneName+"?sig="+significanceFilter+
        "&dataset="+dataset + "'>"+
        displayableContents+"</a>");
    return  returnValue;
}
function fillVariantsAndAssociationLine (geneInfo,// our gene record
                                         dataSetName,// code for data set -- must be gwas,exomechip,exomeseq,or sigma
                                         sampleSize, // listed sample size for this data set
                                         genomicRegion, // region specified as in this example: chr1:209348715-210349783
                                         totalVariantsFieldIdentifier, // where in the gen record do we find the total number of variants
                                         genomeWideFieldIdentifier, // where in the gen record do we find the number of genome wide significant variants
                                         locusWideFieldIdentifier, // where in the gen record do we find the number of locus wide variants
                                         nominalFieldIdentifier,  // where in the gen record do we find the number of nominally significance variants
                                         anchorBuildingFunction,  // which anchor building function should we use
                                         emphasizeGwas,    // 0->no emphasis, 1-> Emphasize middle row, 2-> Emphasize bottom row
                                         rootVariantUrl) {  // root URL is the basis for callbacks
    if  (geneInfo)  {
        var geneName = geneInfo["ID"];
        var dataSetNameForUser;
        switch (dataSetName) {
            case 'gwas':
                dataSetNameForUser = 'GWAS';
                break;
            case 'exomechip':
                dataSetNameForUser = 'exome chip';
                break;
            case 'exomeseq':
                dataSetNameForUser = 'exome sequence';
                break;
            case 'sigma':
                dataSetNameForUser = 'Sigma';
                break;
            default:
                dataSetNameForUser = 'unknown';
        }
        var totalVariants = geneFieldOrZero(geneInfo,totalVariantsFieldIdentifier);
        var genomeWideVariants = geneFieldOrZero(geneInfo,genomeWideFieldIdentifier);
        var locusWideVariants = geneFieldOrZero(geneInfo,locusWideFieldIdentifier);
        var nominallySignificantVariants = geneFieldOrZero(geneInfo,nominalFieldIdentifier);
        var tableRow = '';
        tableRow += '<tr>'+
            '<td>' + dataSetNameForUser + '</td>'+
            '<td>' + sampleSize + '</td>'+
            '<td>' + anchorBuildingFunction(totalVariants,geneName,'everything',dataSetName,genomicRegion,rootVariantUrl) + '</td>';
        if (emphasizeGwas == 2)   {
            tableRow += '<td class="emphasizedBottom">';
        }  else if (emphasizeGwas == 1)   {
            tableRow += '<td class="emphasized">';
        }  else {
            tableRow += '<td>';
        }
        tableRow +=  anchorBuildingFunction(genomeWideVariants,geneName,'genome-wide',dataSetName,genomicRegion,rootVariantUrl) + '</td>';
        tableRow += '<td>' + anchorBuildingFunction(locusWideVariants,geneName,'nominal',dataSetName,genomicRegion,rootVariantUrl) + '</td>'+   // TODO: should be locus wide
            '<td>' + anchorBuildingFunction(nominallySignificantVariants,geneName,'nominal',dataSetName,genomicRegion,rootVariantUrl) + '</td>'+
            '</tr>';
        $('#variantsAndAssociationsTableBody').append ( tableRow);
    }
}
function emphasisRecommended (geneInfo) {
    var returnValue = false;
    if (geneInfo) {
        if ((geneFieldOrZero(geneInfo,geneInfoRec.GWAS_T2D_GWS_TOTAL)>0)  ||
        (geneFieldOrZero(geneInfo,geneInfoRec.EXCHP_T2D_GWS_TOTAL)>0)  ||
        (geneFieldOrZero(geneInfo,geneInfoRec.EXCHP_T2D_GWS_TOTAL)>0)){
            returnValue = true;
        }
    }
    return  returnValue;
}
function fillVariantsAndAssociations (geneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl) {
    if  (geneInfo){
        var regionSpecifier =  "chr"+geneFieldOrZero(geneInfo,geneInfoRec.CHROM)+":"+
            expandRegionBegin(geneFieldOrZero(geneInfo,geneInfoRec.BEG))+"-"+
            expandRegionEnd(geneFieldOrZero(geneInfo,geneInfoRec.END));
        var emphasisRequired =   emphasisRecommended (geneInfo);
        var  emphasizeGwas = (emphasisRequired?1:0);
        var headerRow = "<tr>"+
            "<th>data type</th>"+
            "<th>sample size</th>"+
            "<th>total variants</th>";
        if (emphasizeGwas){
            headerRow += "<th class='emphasizedTop' style='border-top: 3px solid #ee0'>";
        } else {
            headerRow += "<th>";
        }
        headerRow += "genome-wide<br/>significant variants<br/><span class='headersubtext'>P&lt;5x10<sup>-8</sup></span></th>"+
            "<th>locus-wide<br/>significant variants<br/><span class='headersubtext'>P&lt;5x10<sup>-4</sup></span></th>"+
            "<th>nominal<br/>significant variants<br/><span class='headersubtext'>P&lt;0.05</sup></span></th>"+
            "</tr>";
        $('#variantsAndAssociationsHead').append ( headerRow);
        if (show_gwas) {
            fillVariantsAndAssociationLine (geneInfo,'gwas','69,033',regionSpecifier,
                geneInfoRec.GWAS_T2D_VAR_TOTAL,geneInfoRec.GWAS_T2D_GWS_TOTAL,geneInfoRec.GWAS_T2D_NOM_TOTAL,geneInfoRec.GWAS_T2D_NOM_TOTAL,
                buildAnchorForRegionVariantSearches,emphasizeGwas,rootVariantUrl);
        }
        if (show_exchp) {
            fillVariantsAndAssociationLine (geneInfo,'exomechip','79,854',regionSpecifier,
                geneInfoRec.EXCHP_T2D_VAR_TOTALS_EU_TOTAL,geneInfoRec.EXCHP_T2D_GWS_TOTAL,geneInfoRec.EXCHP_T2D_NOM_TOTAL,geneInfoRec.EXCHP_T2D_NOM_TOTAL,
                buildAnchorForGeneVariantSearches,emphasizeGwas,rootVariantUrl);
        }
        if (show_exseq) {
            if (emphasisRequired) {
                if (!show_sigma) {
                    emphasizeGwas = 2;
                }
            }
            fillVariantsAndAssociationLine (geneInfo,'exomeseq','12,940',regionSpecifier,
                geneInfoRec._13k_T2D_VAR_TOTAL,geneInfoRec._13k_T2D_GWS_TOTAL,geneInfoRec._13k_T2D_NOM_TOTAL,geneInfoRec._13k_T2D_NOM_TOTAL,
                buildAnchorForGeneVariantSearches,emphasizeGwas,rootVariantUrl);
        }
        if (show_sigma) {
            if (emphasisRequired) {
               emphasizeGwas = 2;
            }
            fillVariantsAndAssociationLine (geneInfo,'exomeseq','99, 999',regionSpecifier,
                geneInfoRec.SIGMA_T2D_VAR_TOTAL,geneInfoRec.SIGMA_T2D_GWS_TOTAL,geneInfoRec.SIGMA_T2D_NOM_TOTAL,geneInfoRec.SIGMA_T2D_NOM_TOTAL,
                buildAnchorForGeneVariantSearches,emphasizeGwas,rootVariantUrl);
        }

    }
}

function fillUpBarChart (peopleWithDiseaseNumeratorString,peopleWithDiseaseDenominatorString,peopleWithoutDiseaseNumeratorString,peopleWithoutDiseaseDenominatorString) {
    var peopleWithDiseaseDenominator,
        peopleWithoutDiseaseDenominator,
        peopleWithDiseaseNumerator,
        peopleWithoutDiseaseNumerator,
        calculatedPercentWithDisease,
        calculatedPercentWithoutDisease,
        proportionWithDiseaseDescriptiveString,
        proportionWithoutDiseaseDescriptiveString;
    if ((typeof peopleWithDiseaseDenominatorString !== 'undefined') &&
        (typeof peopleWithoutDiseaseDenominatorString !== 'undefined')){
        peopleWithDiseaseDenominator  = parseInt(peopleWithDiseaseDenominatorString);
        peopleWithoutDiseaseDenominator  = parseInt(peopleWithoutDiseaseDenominatorString);
        peopleWithDiseaseNumerator  = parseInt(peopleWithDiseaseNumeratorString);
        peopleWithoutDiseaseNumerator  = parseInt(peopleWithoutDiseaseNumeratorString);
        if (( peopleWithDiseaseDenominator !== 0 ) &&
            ( peopleWithoutDiseaseDenominator !== 0 )) {
            calculatedPercentWithDisease = (100 * (peopleWithDiseaseNumerator / peopleWithDiseaseDenominator));
            calculatedPercentWithoutDisease = (100 * (peopleWithoutDiseaseNumerator / peopleWithoutDiseaseDenominator));
            proportionWithDiseaseDescriptiveString = "(" + peopleWithDiseaseNumerator + " out of " + peopleWithDiseaseDenominator + ")";
            proportionWithoutDiseaseDescriptiveString = "(" + peopleWithoutDiseaseNumerator + " out of " + peopleWithoutDiseaseDenominator + ")";
            var dataForBarChart = [
                    { value: calculatedPercentWithDisease,
                        barname: 'have T2D',
                        barsubname: '(cases)',
                        barsubnamelink:'http://www.google.com',
                        inbar: '',
                        descriptor: proportionWithDiseaseDescriptiveString},
                    {value: calculatedPercentWithoutDisease,
                        barname: 'do not have T2D',
                        barsubname: '(controls)',
                        barsubnamelink:'http://www.google.com',
                        inbar: '',
                        descriptor: proportionWithoutDiseaseDescriptiveString}
                ],
                roomForLabels = 120,
                maximumPossibleValue = (Math.max(calculatedPercentWithDisease,calculatedPercentWithoutDisease) *1.5),
                labelSpacer = 10;

            var margin = {top: 0, right: 20, bottom: 0, left: 70},
                width = 800 - margin.left - margin.right,
                height = 150 - margin.top - margin.bottom;


            var barChart = baget.barChart()
                .selectionIdentifier("#chart")
                .width(width)
                .height(height)
                .margin(margin)
                .roomForLabels (roomForLabels)
                .maximumPossibleValue (maximumPossibleValue)
                .labelSpacer (labelSpacer)
                .assignData(dataForBarChart);
            barChart.render();
        }

    }

}
function fillBiologicalHypothesisTesting (geneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl) {
    var bhtPeopleWithVariantWhoHaveDiabetes  = 0,
        bhtPeopleWithVariantWithoutDiabetes = 0,
        bhtPeopleWithVariant = 0,
        bhtPeopleWithoutVariant = 0,
        arrayOfMinaMinu = [],
        numberOfVariants,
        proportionsWithDisease,
        bhtMetaBurdenForDiabetes;

      numberOfVariants = geneFieldOrZero(geneInfo,geneInfoRec._13k_T2D_lof_NVAR);
      proportionsWithDisease =  geneFieldOrZero(geneInfo,geneInfoRec._13k_T2D_lof_MINA_MINU_RET) ;
      bhtPeopleWithVariant = geneFieldOrZero(geneInfo,geneInfoRec._13k_T2D_lof_OBSA);
      bhtPeopleWithoutVariant = geneFieldOrZero(geneInfo,geneInfoRec._13k_T2D_lof_OBSU);
      bhtMetaBurdenForDiabetes  = geneFieldOrZero(geneInfo,geneInfoRec._13k_T2D_lof_METABURDEN);

    $('#bhtLossOfFunctionVariants').append(numberOfVariants);

    // variables for bar chart
    var arrayOfProportionsWithDisease,
        peopleWithDiseaseDenominator,
        peopleWithDiseaseNumerator,
        peopleWithoutDiseaseDenominator,
        peopleWithoutDiseaseNumerator;
    if (proportionsWithDisease) {
        arrayOfProportionsWithDisease  = proportionsWithDisease.split('/');
        if (arrayOfProportionsWithDisease.length>1) {
            peopleWithDiseaseNumerator = arrayOfProportionsWithDisease[0];
            peopleWithoutDiseaseNumerator = arrayOfProportionsWithDisease[1];
            peopleWithDiseaseDenominator = bhtPeopleWithVariant;
            peopleWithoutDiseaseDenominator =  bhtPeopleWithoutVariant;
        }
        fillUpBarChart (peopleWithDiseaseNumerator,peopleWithDiseaseDenominator,peopleWithoutDiseaseNumerator,peopleWithoutDiseaseDenominator);
    }


//
//
//    // first subline
//    var minaMinu =  proportionsWithDisease ;
//    if (minaMinu) {   // we have a  _13k_T2D_lof_MINA_MINU_RET
//        arrayOfMinaMinu  = minaMinu.split('/');
//        if (arrayOfMinaMinu.length>1) {
//            bhtPeopleWithVariantWhoHaveDiabetes = arrayOfMinaMinu[0];
//            $('#bhtPeopleWithVariantWhoHaveDiabetes').append(bhtPeopleWithVariantWhoHaveDiabetes);
//        }
//    }  else {  // we don't
//        $('#bhtPeopleWithVariantWhoHaveDiabetes').append(0);
//    }
//    $('#bhtPeopleWithVariant').append(bhtPeopleWithVariant);
//    if (bhtPeopleWithVariant  > 0) {
//        var bhtPercentOfPeopleWithVariantWhoHaveDisease =  (100 * (bhtPeopleWithVariantWhoHaveDiabetes / bhtPeopleWithVariant));
//        $('#bhtPercentOfPeopleWithVariantWhoHaveDisease').append ( "(" +
//            (bhtPercentOfPeopleWithVariantWhoHaveDisease.toPrecision(2))+"%)");
//    }
//
//    // second subline
//    if (arrayOfMinaMinu.length>1) {  // we have a  _13k_T2D_lof_MINA_MINU_RET
//        bhtPeopleWithVariantWithoutDiabetes = arrayOfMinaMinu[1];
//        $('#bhtPeopleWithVariantWithoutDiabetes').append(bhtPeopleWithVariantWithoutDiabetes);
//    }  else {  // we don't
//        bhtPeopleWithVariantWithoutDiabetes = 0;
//        $('#bhtPeopleWithVariantWithoutDiabetes').append(0);
//    }
//
//    $('#bhtPeopleWithoutVariant').append(bhtPeopleWithoutVariant);
//    if (bhtPeopleWithoutVariant  > 0) {
//        var bhtPercentOfPeopleWithVariantWithoutDisease =  (100 * (bhtPeopleWithVariantWithoutDiabetes / bhtPeopleWithoutVariant));
//        $('#bhtPercentOfPeopleWithVariantWithoutDisease').append (  "(" +
//            (bhtPercentOfPeopleWithVariantWithoutDisease.toPrecision(2)) +"%)");
//    }
//


    if (bhtMetaBurdenForDiabetes  > 0)  {
        $('#bhtMetaBurdenForDiabetes').append("p="+
            (bhtMetaBurdenForDiabetes.toPrecision(3)));
    }
    var linkToVariantsPredictedToTruncate = $('#linkToVariantsPredictedToTruncate') ;
    if (typeof linkToVariantsPredictedToTruncate!== "undefined") {
        linkToVariantsPredictedToTruncate[0].href =  rootVariantUrl+"/"+(geneInfo["ID"])+"?filter=lof";
    }

}
function fillUniprotSummary(geneInfo,show_gwas,show_exchp,show_exseq,show_sigma) {
    var funcDescrLine = "";
    if ((geneInfo)&&(geneInfo["Function_description"])){
        funcDescrLine +=  ("<strong>Uniprot Summary:</strong> "+geneInfo['Function_description']);
    } else {
        funcDescrLine += "No uniprot summary available for this gene"
    }

    $('#uniprotSummaryGoesHere').append(funcDescrLine);
}
function fillTheGeneFields (data,show_gwas,show_exchp,show_exseq,show_sigma,rootRegionUrl, rootTraitUrl,rootVariantUrl)  {
    var rawGeneInfo =  data['geneInfo'];
    fillUniprotSummary(rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma);
    fillVarianceAndAssociations (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootRegionUrl, rootTraitUrl,rootVariantUrl);
    fillVariantsAndAssociations (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl);
    fillVariationAcrossEthnicity (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl);
    fillBiologicalHypothesisTesting (rawGeneInfo,show_gwas,show_exchp,show_exseq,show_sigma,rootVariantUrl);
}
