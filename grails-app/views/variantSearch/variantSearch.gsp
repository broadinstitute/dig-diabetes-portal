<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="tableViewer"/>
    <r:layoutResources/>
    <%@ page import="dport.RestServerService" %>
    <%
        RestServerService   restServerService = grailsApplication.classLoader.loadClass('dport.RestServerService').newInstance()
    %>
</head>

<body>
<script>
    var variant;
    function fillTheFields (data) {
        variant = data['variant'];
        variantTitle = UTILS.get_variant_title(variant);
    };
    /***
     * gather up all the information from all of the input fields, put it into a nice, tight data structure and
     * posted back to the Web server
     */


    function gatherFieldsAndPostResults(){
        var varsToSend = {};
        varsToSend["datatype"]  = $("input:radio[name='datatype']:checked").val();
        varsToSend["significance"]  = $("input:radio[name='significance']:checked").val();
        var customSignificance = UTILS.extractValFromTextboxes(['custom_significance_input']);
        var restrictToRegion = UTILS.extractValFromTextboxes(['region_gene_input','region_chrom_input','region_start_input','region_stop_input']);
        var restrictToOr = UTILS.extractValFromTextboxes(['or-value']);
        var orInequality = UTILS.extractValsFromCombobox(['or-select']);
        var alleleFrequencies = UTILS.extractAlleleFrequencyRanges($('.form-control'));
        var caseControlRequests = UTILS.extractValFromCheckboxes(['id_onlyseen_t2dcases','id_onlyseen_t2dcontrols']);
        var missensePredictions = [];
        varsToSend["predictedEffects"]  = $("input:radio[name='predictedEffects']:checked").val();
        if (varsToSend["predictedEffects"]==='missense'){
            missensePredictions = UTILS.extractValsFromCombobox(['polyphenSelect','siftSelect','condelSelect']);
        }
        varsToSend = UTILS.concatMap(varsToSend,customSignificance) ;
        varsToSend = UTILS.concatMap(varsToSend,caseControlRequests) ;
        varsToSend = UTILS.concatMap(varsToSend,alleleFrequencies) ;
        varsToSend = UTILS.concatMap(varsToSend,restrictToRegion) ;
        varsToSend = UTILS.concatMap(varsToSend,missensePredictions) ;
        varsToSend = UTILS.concatMap(varsToSend,restrictToOr) ;
        varsToSend = UTILS.concatMap(varsToSend,orInequality) ;
        UTILS.postQuery('../variantSearch/variantSearchRequest',varsToSend);
    }
    var encParams="${encParams}";
    /***
     *  Initialize the fields so that they match the last query call
     * @param fields
     */
    function initializeFields( fields) {
        $('#region_gene_input').typeahead(
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
                                if (value === "0") {
                                    radioButtonToCheck = $("#id_datatype_sigma");
                                } else if (value === "1") {
                                    radioButtonToCheck = $("#id_datatype_exomeseq");
                                } else if (value === "2") {
                                    radioButtonToCheck = $("#id_datatype_exomechip");
                                } else if (value === "3") {
                                    radioButtonToCheck = $("#id_datatype_gwas");
                                } else {
                                    radioButtonToCheck = $("#id_datatype_exomeseq");
                                }
                                radioButtonToCheck.attr('checked', true);
                                break;
                            case 2:  // data value radio buttons
                                if (value === "0") {
                                    radioButtonToCheck = $("#id_significance_genomewide");
                                } else if (value === "1") {
                                    radioButtonToCheck = $("#id_significance_nominal");
                                } else if (value === "2") {
                                    radioButtonToCheck = $("#id_significance_custom");
                                } else {     // should we have a default
                                    //radioButtonToCheck = $("#id_datatype_exomeseq");
                                }
                                radioButtonToCheck.attr('checked', true);
                                break;
                            case 3:  //custom P value
                                textField = $("#custom_significance_input");
                                textField.val(value);
                                break;
                            case 4:  //custom P value
                                textField = $("#region_gene_input");
                                textField.val(value);
                                break;
                            case 5:  //custom P value
                                textField = $("#region_chrom_input");
                                textField.val(value);
                                break;
                            case 6:  //custom P value
                                textField = $("#region_start_input");
                                textField.val(value);
                                break;
                            case 7:  //custom P value
                                textField = $("#region_stop_input");
                                textField.val(value);
                                break;
                            case 8:  //custom P value
                                textField = $("#ethnicity_af_AA-min");
                                textField.val(value);
                                break;
                            case 9:  //custom P value
                                textField = $("#ethnicity_af_AA-max");
                                textField.val(value);
                                break;
                            case 10:  //custom P value
                                textField = $("#ethnicity_af_EA-min");
                                textField.val(value);
                                break;
                            case 11:  //custom P value
                                textField = $("#ethnicity_af_EA-max");
                                textField.val(value);
                                break;
                            case 12:  //custom P value
                                textField = $("#ethnicity_af_SA-min");
                                textField.val(value);
                                break;
                            case 13:  //custom P value
                                textField = $("#ethnicity_af_SA-max");
                                textField.val(value);
                                break;
                            case 14:  //custom P value
                                textField = $("#ethnicity_af_EU-min");
                                textField.val(value);
                                break;
                            case 15:  //custom P value
                                textField = $("#ethnicity_af_EU-max");
                                textField.val(value);
                                break;
                            case 16:  //custom P value
                                textField = $("#ethnicity_af_HS-min");
                                textField.val(value);
                                break;
                            case  17:  //custom P value
                                textField = $("#ethnicity_af_HS-max");
                                textField.val(value);
                                break;
                            case 18:  //custom P value
                                //textField = $("#ethnicity_af_HS-min");
                                //textField.val(value);
                                break;
                            case  19:  //custom P value
                                //textField = $("#ethnicity_af_HS-max");
                                //.val(value);
                                break;
                            case  20:  //show variants only in cases
                                radioButtonToCheck = $("#id_onlyseen_t2dcases");
                                radioButtonToCheck.attr('checked', true);
                                break;
                            case  21:  //show variants only and controls
                                radioButtonToCheck = $("#id_onlyseen_t2dcontrols");
                                radioButtonToCheck.attr('checked', true);
                                break;
                            case  22:  //show variants seen only in homozygotes
                                radioButtonToCheck = $("#id_onlyseen_homozygotes");
                                radioButtonToCheck.attr('checked', true);
                                break;
                            case 23:  // data value radio buttons
                                if (value === "0") {
                                    radioButtonToCheck = $("#all_functions_checkbox");
                                } else if (value === "1") {
                                    radioButtonToCheck = $("#protein_truncating_checkbox");
                                } else if (value === "2") {
                                    radioButtonToCheck = $("#missense_checkbox");
                                    $("#missense-options").show()
                                } else if (value === "3") {
                                    radioButtonToCheck = $("#synonymous_checkbox");
                                } else if (value === "4") {
                                    radioButtonToCheck = $("#noncoding_checkbox");
                                } else {
                                    radioButtonToCheck = $("#all_functions_checkbox");
                                }
                                radioButtonToCheck.attr('checked', true);
                                break;
                            case 24:  // data value radio buttons
                                $("#polyphenSelect").val(value) ;
                                break;
                            case 25:  // data value radio buttons
                                $("#siftSelect").val(value) ;
                                break;
                            case 26:  // data value radio buttons
                                $("#condelSelect").val(value) ;
                                break;
                            case 27:  // data value radio buttons
                                    if (value==="1") {
                                        $("#or-select").val('GTE') ;
                                    } else  if (value==="2") {
                                        $("#or-select").val('LTE') ;
                                    } else {
                                        $("#or-select").val('') ;
                                    }
                                break;
                            case 28:  // data value radio buttons
                                textField = $("#or-value");
                                textField.val(value);
                                break;

                            default: break;
                        }
                    }
                }

            }

        }
    }

</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >

                <g:render template="variantSearchDataTypes" />
                <g:render template="variantSearchAssociationThreshold" />
                <g:render template="variantSearchSigmaOddsRatios" />
                <g:render template="variantSearchRestrictToRegion" />
                <g:render template="variantSearchRestrictToEthnicity" />
                <g:render template="variantSearchCaseControlRestriction" />
                <g:render template="variantSearchEffectsOnProteins" />


                <div class="big-button-container">
                     <button class="btn btn-lg btn-primary" onclick="gatherFieldsAndPostResults()">Go</button>
                </div>

            </div>

        </div>
    </div>

</div>
<script>
    initializeFields( encParams);
</script>

</body>
</html>

