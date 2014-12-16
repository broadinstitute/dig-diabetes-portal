<!DOCTYPE html>
<html>
<head>

    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="geneInfo"/>
    <r:layoutResources/>

</head>

<body>
<script>
    var launchDynamicBurdenTest;



    function gatherFieldsAndPostResults(){
        var varsToSend = {};
       // var customSignificance = UTILS.extractValFromTextboxes(['custom_significance_input']);
        var restrictToRegion = UTILS.extractValFromTextboxes(['region_gene_input','region_chrom_input','region_start_input','region_stop_input']);
        var restrictToOr = UTILS.extractValFromTextboxes(['or-value']);
        var orInequality = UTILS.extractValsFromCombobox(['or-select']);
        var alleleFrequencies = UTILS.extractAlleleFrequencyRanges($('.form-control'));
     //   var caseControlRequests = UTILS.extractValFromCheckboxes(['id_onlyseen_t2dcases','id_onlyseen_t2dcontrols']);
        var missensePredictions = [];
        varsToSend["predictedEffects"]  = $("input:radio[name='predictedEffects']:checked").val();
        if (varsToSend["predictedEffects"]==='missense'){
            missensePredictions = UTILS.extractValsFromCombobox(['polyphenSelect','siftSelect','condelSelect']);
        }
       // varsToSend = UTILS.concatMap(varsToSend,customSignificance) ;
       // varsToSend = UTILS.concatMap(varsToSend,caseControlRequests) ;
        varsToSend = UTILS.concatMap(varsToSend,alleleFrequencies) ;
        varsToSend = UTILS.concatMap(varsToSend,restrictToRegion) ;
        varsToSend = UTILS.concatMap(varsToSend,missensePredictions) ;
        varsToSend = UTILS.concatMap(varsToSend,restrictToOr) ;
        varsToSend = UTILS.concatMap(varsToSend,orInequality) ;

        //   add some defaults:
        varsToSend = UTILS.concatMap(varsToSend,{'datatype':'exomeseq'}) ;

        UTILS.postQuery('./variantSearch',varsToSend);
    };
    %{--var encParams="${encParams}";--}%
    /***
     *  Initialize the fields so that they match the last query call
     * @param fields
     */
    function initializeFields( fields,
                               region_gene_input,
                               id_datatype_sigma,
                               id_datatype_exomeseq,
                               id_datatype_exomechip,
                               id_datatype_gwas,
                               id_significance_genomewide,
                               id_significance_nominal,
                               id_significance_custom,
                               custom_significance_input,
                               region_chrom_input,
                               region_start_input,
                               region_stop_input,
                               ethnicity_af_AA_min,
                               ethnicity_af_AA_max,
                               ethnicity_af_EA_min,
                               ethnicity_af_EA_max,
                               ethnicity_af_SA_min,
                               ethnicity_af_SA_max,
                               ethnicity_af_EU_min,
                               ethnicity_af_EU_max,
                               ethnicity_af_HS_min,
                               ethnicity_af_HS_max,
                               id_onlyseen_t2dcases,
                               id_onlyseen_t2dcontrols,
                               id_onlyseen_homozygotes,
                               all_functions_checkbox,
                               protein_truncating_checkbox,
                               missense_checkbox,
                               synonymous_checkbox,
                               noncoding_checkbox,
                               polyphenSelect,
                               siftSelect,
                               condelSelect,
                               or_select,
                               or_value) {
        var safeRadioButtonSaver = function (value, defaultValue, id0, id1, id2, id3, id4){
                    var radioButtonToCheck;
                    if ((typeof value === 'undefined') || (value < 0) || (value > 4)) { value = defaultValue; }
                    switch (variable){
                        case 0:
                            if (typeof id0 !== 'undefined') {
                                radioButtonToCheck = $(id0);
                            }
                            break;
                        case 1:
                            if (typeof id1 !== 'undefined') {
                                radioButtonToCheck = $(id1);
                            }
                            break;
                        case 2:
                            if (typeof id2 !== 'undefined') {
                                radioButtonToCheck = $(id2);
                            }
                            break;
                        case 3:
                            if (typeof id3 !== 'undefined') {
                                radioButtonToCheck = $(id3);
                            }
                            break;
                        case 4:
                            if (typeof id4 !== 'undefined') {
                                radioButtonToCheck = $(id4);
                            }
                            break;
                        default:
                            break;
                    }
                    radioButtonToCheck.attr('checked', true);
                },
                safeTextSaver = function (value, id){
                    if ((typeof id !== 'undefined') && (typeof value !== 'undefined')){
                        $(id).val(value);
                    }
                },
                safeCheckboxSaver = function (id){
                    if (typeof id !== 'undefined') {
                        $(id).attr('checked', true);
                    }
                },
                safeComboboxSaver = function (value, id){
                    if ((typeof id !== 'undefined') && (typeof value !== 'undefined')){
                        $(id).val(value);
                    }
                };
        $(region_gene_input).typeahead(
                {
                    source: function(query, process) {
                        $.get('<g:createLink controller="gene" action="index"/>', {query: query}, function(data) {
                            process(data);
                        })
                    }
                }
        );
        if (typeof fields!== "undefined"){
            var eachField = fields.split (',');
            if (eachField)  {
                for ( var  i=0 ; i<eachField.length ; i++ )  {
                    var keyvalue = eachField[i].split(':');
                    if (keyvalue.length=== 2)  {
                        var radioButtonToCheck;
                        var textField;
                        var comboBox;
                        var key = parseInt(keyvalue [0]) ;
                        var value = keyvalue [1];
                        switch (key) {
                            case 1:  // data value radio buttons
                                saferadioButtonSaver(value, 1, id_datatype_sigma, id_datatype_exomeseq, id_datatype_exomechip, id_datatype_gwas, id_datatype_exomeseq);
                                break;
                            case 2:  // data value radio buttons
                                saferadioButtonSaver(value, 0, id_significance_genomewide, id_significance_nominal, id_significance_custom);
                                break;
                            case 3:  //custom P value
                                safeTextSaver (value,custom_significance_input);
                                break;
                            case 4:  //gene name
                                safeTextSaver (value,region_gene_input);
                                break;
                            case 5:  //custom P value
                                safeTextSaver (value,region_chrom_input);
                                break;
                            case 6:  //custom P value
                                safeTextSaver (value,region_start_input);
                                break;
                            case 7:  //custom P value
                                safeTextSaver (value,region_stop_input);
                                break;
                            case 8:  //custom P value
                                safeTextSaver (value,ethnicity_af_AA_min);
                                break;
                            case 9:  //custom P value
                                safeTextSaver (value,ethnicity_af_AA_max);
                                break;
                            case 10:  //custom P value
                                safeTextSaver (value,ethnicity_af_EA_min);
                                break;
                            case 11:  //custom P value
                                safeTextSaver (value,ethnicity_af_EA_max);
                                break;
                            case 12:  //custom P value
                                safeTextSaver (value,ethnicity_af_SA_min);
                                break;
                            case 13:  //custom P value
                                safeTextSaver (value,ethnicity_af_SA_max);
                                break;
                            case 14:  //custom P value
                                safeTextSaver (value,ethnicity_af_EU_min);
                                break;
                            case 15:  //custom P value
                                safeTextSaver (value,ethnicity_af_EU_max);
                                break;
                            case 16:  //custom P value
                                safeTextSaver (value,ethnicity_af_HS_min);
                                break;
                            case  17:  //custom P value
                                safeTextSaver (value,ethnicity_af_HS_max);
                                break;
                            case 18:  //custom P value
                                break;
                            case  19:  //custom P value
                                break;
                            case  20:  //show variants only in cases
                                safeCheckboxSaver(id_onlyseen_t2dcases);
                                break;
                            case  21:  //show variants only and controls
                                safeCheckboxSaver(id_onlyseen_t2dcontrols);
                                break;
                            case  22:  //show variants seen only in homozygotes
                                safeCheckboxSaver(id_onlyseen_homozygotes);
                                break;
                            case 23:  // data value radio buttons
                                if (value === "0") {
                                    radioButtonToCheck = $(all_functions_checkbox);
                                } else if (value === "1") {
                                    radioButtonToCheck = $(protein_truncating_checkbox);
                                } else if (value === "2") {
                                    radioButtonToCheck = $(missense_checkbox);
                                    $("#missense_options").show()
                                } else if (value === "3") {
                                    radioButtonToCheck = $(synonymous_checkbox);
                                } else if (value === "4") {
                                    radioButtonToCheck = $(noncoding_checkbox);
                                } else {
                                    radioButtonToCheck = $(all_functions_checkbox);
                                }
                                radioButtonToCheck.attr('checked', true);
                                break;
                            case 24:  // data value radio buttons
                                safeComboboxSaver(value,polyphenSelect);
                                break;
                            case 25:  // data value radio buttons
                                safeComboboxSaver(value,siftSelect);
                                break;
                            case 26:  // data value radio buttons
                                safeComboboxSaver(value,condelSelect);
                                break;
                            case 27:  // data value radio buttons
                                if (value==="1") {
                                    $(or_select).val('GTE') ;
                                } else  if (value==="2") {
                                    $(or_select).val('LTE') ;
                                } else {
                                    $(or_select).val('') ;
                                }
                                break;
                            case 28:  // data value radio buttons
                                safeTextSaver (value,or_value);
                                break;

                            default: break;
                        }
                    }
                }

            }

        }
    }




    var fillResponseFields = function (data){
        if ((typeof data === 'undefined') ||
                (typeof data.burdenTestResults === 'undefined') ||
                (typeof data.burdenTestResults["is_error"] === 'undefined') ){
            // the call to the backend failed.  Correct Behavior  === ?
        } else if (typeof data.burdenTestResults["is_error"] === false){
            // call was executed successfully but the data returned. Correct Behavior  === ?
        }else{
            $('#dbtPValue').text(UTILS.realNumberFormatter(data.burdenTestResults.pValue));
            $('#dbtBeta').text(UTILS.realNumberFormatter(data.burdenTestResults.oddsRatio));
            $('#stdErr').text(UTILS.realNumberFormatter(data.burdenTestResults.stdErr));
            $('#resultsCage').show();
            $('#collapseOne').hide();
        }
    };


    /***
     *   launch the dynamic burden test and display the results when they show up
     *
     */
    var postVariantReq = function (path,
                                   params) {
        var loading = $('#spinner').show();
        loading.show();
        var stringForSending;
        stringForSending = params.join(',');
        $.ajax({
            type:'POST',
            cache:false,
            data:{'variants':stringForSending},
            url:path,
            async:true,
            success:function(data){
                fillResponseFields (data);
                loading.hide();
                $('#variantSelectingBox').removeClass('drawAttention');
                $('#doSomethingWithExistingList').removeClass('drawAttention');
                $('#doSomethingWithExistingList').hide();
                $('.resultsCage').show();
                $('.resultsCage').addClass('drawAttention');
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){
                loading.hide();
                errorReporter(XMLHttpRequest, exception) ;
                $('#variantSelectingBox').removeClass('drawAttention');
                $('#doSomethingWithExistingList').removeClass('drawAttention');
                $('#doSomethingWithExistingList').hide();
                $('.resultsCage').show();
                $('.resultsCage').addClass('drawAttention');
            }
        });
    };

    var requestExpandedVariantInfo = function (path,
                                               params) {
        var loading = $('#spinner').show();
        loading.show();
        $.ajax({
            type:'POST',
            cache:false,
            data:{'variants':params},
            url:path,
            async:true,
            success:function(data){
                fillBtVariantTable (data);
                $('#collapseTwo').collapse('show');
                loading.hide();
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){
                loading.hide();
                //errorReporter(XMLHttpRequest, exception) ;
            }
        });
    };


    var requestExpandedVariantSearch = function (path,
                                               params) {
        var loading = $('#spinner').show();
        loading.show();
        $.ajax({
            type:'POST',
            cache:false,
            data:{'variants':params},
            url:path,
            async:true,
            success:function(data){
                fillBtVariantTable (data);
                $('#collapseTwo').collapse('show');
                loading.hide();
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){
                loading.hide();
                //errorReporter(XMLHttpRequest, exception) ;
            }
        });
    };



    var  proteinEffectList;
//    var dynamicBurdenTest = function (variantIds){
//        $('dbtActualResultsExist').hide();
//        var loading = $('#spinner').show();
//        postVariantReq("./burdenAjax",variantIds);
//        return;
//    };

    var dynamicBurdenTest2 = function (variantIds){
        $('resultsCage').hide();
        var loading = $('#spinner').show();
        postVariantReq("./burdenAjax",variantIds);
        return;
    };

    var fillBtVariantTable = function (jsonObject){
        var safetyCellFiller = function (dataHolder,fieldName){
            if((typeof  dataHolder [fieldName]=== 'undefined') ||
                    (dataHolder [fieldName]=== null)){
                return ("<td></td>");
            }else {
                return ("<td>" + dataHolder [fieldName]+ "</td>");
            }
        };
        var returnValue = "";
        var arrayOfInfo = jsonObject.variants;
        var numberOfVariants = arrayOfInfo.length;
        for (var i = 0 ; i < numberOfVariants ; i++) {
            var highFreq = UTILS.determineHighestFrequencyEthnicity(arrayOfInfo[i]);
            returnValue += "<tr>";
            returnValue += safetyCellFiller(arrayOfInfo[i], "CLOSEST_GENE");
            returnValue += safetyCellFiller(arrayOfInfo[i], "ID");
            returnValue += safetyCellFiller(arrayOfInfo[i], "DBSNP_ID");
            returnValue += safetyCellFiller(arrayOfInfo[i], "Protein_change");
            returnValue += safetyCellFiller(arrayOfInfo[i], "Consequence");
            if (highFreq.highestFrequency)  {
                returnValue += "<td>" +UTILS.realNumberFormatter(highFreq.highestFrequency)+"</td>";
            } else {
                returnValue += "<td></td>";
            }
            if ((highFreq.populationWithHighestFrequency)&&
                    (!highFreq.noData)){
                returnValue += "<td>" +highFreq.populationWithHighestFrequency+"</td>";
            } else {
                returnValue += "<td></td>";
            }
            returnValue += "</tr>";
        }
        $('#btVariantTableBody').append(returnValue);
    };


   var launchDynamicBurdenTest = function (){
        //first we need to pull the variant IDs out of the table
        var jQueryTable=$('#btVariantTable').dataTable();
        var dataTable = jQueryTable.fnGetData();
        // extract the particular data we want
        var variantIds = [];
        if ((!(typeof dataTable === 'undefined') ) &&
                (dataTable.length > 0)){
            for ( var i = 0 ; i < dataTable.length ; i++ ){
                var tableRow = dataTable [i];
                if (!(typeof tableRow === 'undefined') ){
                    variantIds.push (tableRow [1]);
                }
            }
        }
        dynamicBurdenTest2(variantIds);

    };

    /***
     * Request  a variant-search look up.
     * @param params
     * @param show_gene
     * @param show_sigma
     * @param show_exseq
     * @param show_exchp
     * @param variantRootUrl
     * @param geneRootUrl
     * @param variantSearchAjaxUrl
     * @param dataSetDetermination
     */
    var requestDbtSearch =   function (params,
                                   show_gene,
                                   show_sigma,
                                   show_exseq,
                                   show_exchp,
                                   variantRootUrl,
                                   geneRootUrl,
                                   variantSearchAjaxUrl,
                                   dataSetDetermination) {
        var loading = $('#spinner').show();
        loading.show();
        $.ajax({
            type:'POST',
            cache:false,
            data:{'keys':params},
            url:variantSearchAjaxUrl,
            async:true,
            success:function(data,textStatus){
                // variant search succeeded --  display results
                fillBtVariantTable (data);

                loading.hide();
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){
                loading.hide();
                errorReporter(XMLHttpRequest, exception) ;
            }
        });
    };


    // provide names of form fields
    var initFormFields = function (){
        var  fields,
                region_gene_input = '#region_gene_input',
                id_datatype_sigma,
                id_datatype_exomeseq,
                id_datatype_exomechip,
                id_datatype_gwas,
                id_significance_genomewide,
                id_significance_nominal,
                id_significance_custom,
                custom_significance_input,
                region_chrom_input = '#region_chrom_input',
                region_start_input = '#region_start_input',
                region_stop_input = '#region_stop_input',
                ethnicity_af_AA_min,
                ethnicity_af_AA_max,
                ethnicity_af_EA_min,
                ethnicity_af_EA_max,
                ethnicity_af_SA_min,
                ethnicity_af_SA_max,
                ethnicity_af_EU_min,
                ethnicity_af_EU_max,
                ethnicity_af_HS_min,
                ethnicity_af_HS_max,
                id_onlyseen_t2dcases,
                id_onlyseen_t2dcontrols,
                id_onlyseen_homozygotes,
                all_functions_checkbox,
                protein_truncating_checkbox,
                missense_checkbox,
                synonymous_checkbox,
                noncoding_checkbox,
                polyphenSelect,
                siftSelect,
                condelSelect,
                or_select,
                or_value;
        initializeFields( fields,
                region_gene_input,
                id_datatype_sigma,
                id_datatype_exomeseq,
                id_datatype_exomechip,
                id_datatype_gwas,
                id_significance_genomewide,
                id_significance_nominal,
                id_significance_custom,
                custom_significance_input,
                region_chrom_input,
                region_start_input,
                region_stop_input,
                ethnicity_af_AA_min,
                ethnicity_af_AA_max,
                ethnicity_af_EA_min,
                ethnicity_af_EA_max,
                ethnicity_af_SA_min,
                ethnicity_af_SA_max,
                ethnicity_af_EU_min,
                ethnicity_af_EU_max,
                ethnicity_af_HS_min,
                ethnicity_af_HS_max,
                id_onlyseen_t2dcases,
                id_onlyseen_t2dcontrols,
                id_onlyseen_homozygotes,
                all_functions_checkbox,
                protein_truncating_checkbox,
                missense_checkbox,
                synonymous_checkbox,
                noncoding_checkbox,
                polyphenSelect,
                siftSelect,
                condelSelect,
                or_select,
                or_value)
    };





    $( document ).ready(function (){

    //
        initFormFields();

    // Decide what to do based on the state indicator.
    //   0= first time through-- we are just collecting information at this point
    //   3= We have a list of variants with which to work

    var caller = parseInt(${caller});
    if (caller===0){
        // adjust appearance
        $('#variantSelectingBox').addClass('drawAttention');

    } else if (caller>0) {  // user has chosen variants before
        console.log('caller=${caller}, '+caller+'.');
        var variantsInListString = "${variants2}",
                numberOfVariants = variantsInListString.length,
                variantInfo;

         // adjust appearance
        $('#variantSelectingBox').removeClass('drawAttention');
        $('#doSomethingWithExistingList').addClass('drawAttention');

        if (caller===3){
            $('#collapseTwo').show(); // We want to see the table  since we have variants ( either explicitly or implied )

            if (numberOfVariants > 0) {  // the user explicitly specified variants. We need to gather information about each one


                // we have a list of variants, but we need to go back to the server to get more info
                //   about each one in order to fill out the table.  So this path implies -> 1) Request variant info,
                //   2) display it when you get it; and 3) await further instructions
                requestExpandedVariantInfo("./variantInfoAjax","${variants}");

            }  else {  // the user is requesting a variant lookup.  We can do that

                // this path implies: perform a variant search look up, which will get us not only a set of variants
                //   but useful information about each one. Display that information when it finally comes back, and
                //   then await further instructions
                var  proteinEffectList =  new UTILS.proteinEffectListConstructor (decodeURIComponent("${proteinEffectsList}")) ;
                requestDbtSearch("<%=filter%>",
                        ${show_gene},
                        ${show_sigma},
                        ${show_exseq},
                        ${show_exchp},
                        '<g:createLink controller="variant" action="variantInfo"  />',
                        '<g:createLink controller="gene" action="geneInfo"  />',
                        '<g:createLink controller="HypothesisGen" action="variantDbtSearchAjax" />',
                        1 );
                var uri_dec = decodeURIComponent("<%=filter%>");
                var encodedParameters = decodeURIComponent("<%=encodedParameters%>");
            }
        }

    }

});
</script>

<div id="main">

    <div class="container">


            <div class="dynamicBurdenTest">
                <div class="row">
                    <div id="accordionDbt">

                         <div>



                            <div>

                                <div id="collapseTwo" style="display: none">
                                    <h2><strong>Refine variant list</strong></h2>
                                    <div >
                                        <g:render template="refineVariantList"/>
                                    </div>
                                </div>
                            </div>

                        <g:if test='${(caller!=3)}'>
                            <div id="collapseOne">
                                <h2><strong>Develop a list of variant</strong></h2>
                                <div>
                                    <g:render template="geneFilters"/>
                                </div>
                            </div>
                        </g:if>
                      </div>


                    </div>
                </div>
                <div class="resultsCage">
                    <div class="innerResultsCage">
                    <div class="row">
                    <div class="col-sm-12">
                        <h2><strong>Results from dynamic burden test:</strong></h2>
                    </div>
                    </div>

                    <div class="row">

                        <div class="col-sm-2">
                        </div>
                        <div class="col-sm-10">
                            <div id="dbtActualResultsExist">
                                <div class ="dbtResults">
                                    <div class ="dbtResultsSpecifics1">pValue = <span id="dbtPValue"></span></div>
                                    <div class ="dbtResultsSpecifics2">Beta = <span id="dbtBeta"></span></div>
                                    <div class ="dbtResultsSpecifics3">Std err = <span id="stdErr"></span></div>
                                </div>
                            </div>
                        </div>

                    </div>
                   </div>
                </div>
            </div>


    </div>

</div>


</body>

</html>

