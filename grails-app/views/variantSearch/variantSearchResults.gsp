<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="tableViewer"/>
    <r:require modules="variantWF"/>
    <r:layoutResources/>
    <style>
    .propertyAdder {
        margin: 0 0 0 15px;
    }

    span.singprop {
        white-space: nowrap;
    }

    div.propertyHolder {
        position: absolute;
        background-color: white;
        height: 170px;
        width: 290px;
        -moz-border-radius: 3px;
        -webkit-border-radius: 3px;
        -khtml-border-radius: 3px;
        border-radius: 3px;
        border: 2px outset rgba(43, 117, 207, 0.68);
        margin: 5px;
        padding: 5px 10px 10px 10px;
        text-align: left;
    }

    div.propertySubHolder {
        position: relative;
        margin: 3px;
        padding: 3px;
        height: 100px;
        width: 260px;
        overflow-y: auto;
        overflow-x: hidden;
        background-color: #fefefe;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        -khtml-border-radius: 5px;
        border-radius: 5px;
        border: 2px inset;
    }

    div.propertyHolder .propertyHolderChk {
        color: black;
        margin: 5px 0 5px 0;
    }

    .chkBoxText {
        color: black;
        margin: 5px 0 5px 0;
        padding: 0 0 0 10px;
        white-space: normal;
    }

    .chkBoxTextGrey {
        color: #777;
        margin: 5px 0 5px 0;
        padding: 0 0 0 10px;
        white-space: normal;
    }

    .propBox {
        color: white;
        bottom: 0;
        background-color: rgba(43, 117, 207, 0.68);
        border-style: double;
        font-weight: bold;
        margin: 8px 0 0 auto;
    }

    span.propboxtitle {
        color: black;
        text-align: center;
        font-weight: bold;
        line-height: 20px;
        padding-left: 40px;
    }

    </style>

</head>

<body>

<script>


    var getPropData = function () {
        var varsToSend = {};
        var savedValuesList = [];
        var savedValue = {};
        var totalFilterCount = UTILS.extractValFromTextboxes(['totalFilterCount']);
        if (typeof totalFilterCount['totalFilterCount'] !== 'undefined') {
            var valueCount = parseInt(totalFilterCount['totalFilterCount']);
            if (valueCount > 0) {
                for (var i = 0; i < valueCount; i++) {
                    savedValuesList.push('savedValue' + i);
                }
                savedValue = UTILS.extractValFromTextboxes(savedValuesList);
            }
        }
        varsToSend = UTILS.concatMap(varsToSend, savedValue);
        return varsToSend;
    };
    var skipBubbleUp = false;
    var radbut = function (t, e, f) {
        console.log('t=' + t + ', this=' + this);
        t.checked = false;
    };
    var closer = function (that) {
        $(that).parent().parent().parent().children().first().hide();
        skipBubbleUp = true;
    };
    var rememberProperty = function (phenotype, dataSet, propertyList, addIt) {
        var mapOfExistingProperties = {};
        var numberOfFields = 0;
        for (var i = 0; i < 500; i++) {
            var savedField = $('#savedValue' + i);
            if (savedField.length > 0) {
                mapOfExistingProperties[savedField.val()] = savedField.attr('id');
                savedField.attr('id').substr(10, savedField.attr('id').length - 10)
                numberOfFields++;
            }
        }
        var hiddenFields = $('#hiddenFields');
        if ((hiddenFields.size() > 0) && (propertyList) && (propertyList.length > 0)) {
            for (var i = 0; i < propertyList.length; i++) {
                var totalFilterCount = parseInt($('#totalFilterCount').val());
                var codedValue = 'propId^' + phenotype + '^' + dataSet + '^' + propertyList[i];
                if (addIt) {// add the field of it doesn't exist already
                    if (!mapOfExistingProperties[codedValue]) {
                        hiddenFields.append('<input type="hidden" class="form-control" name="savedValue' + (totalFilterCount + 1) + '" id="savedValue' + (totalFilterCount + 1) + '" value="' + codedValue + '" style="height:0px">');
                    }
                    $('#totalFilterCount').val(totalFilterCount + 1);
                } else { // remove it
                    var existingField = mapOfExistingProperties[codedValue];
                    $('#' + existingField).remove();
                    $('#totalFilterCount').val(totalFilterCount - 1);
                }
            }
        }

    }
    /***
     * display a box with all of the properties and/or sample groups that a user might choose
     * to add to their current display.
     *
     * @param here
     * @param phenotype
     * @param dataSet
     * @param propertyList
     * @param currentPropertyList
     * @param title
     * @param greyedOptions
     */
    var lookAtProperties = function (here, phenotype, dataSet, propertyList, currentPropertyList, title, greyedOptions,greyOutCheckedOptions) {

        // private method to write a single checkbox
        var composePropertyCheckbox = function (checkboxName,checkboxValue,checkedBoolean,disabledBoolean,displayString){
            var checkedString = (checkedBoolean)? 'checked' : '';
            var disabledString = (disabledBoolean)? 'disabled' : '';
            var checkboxClass = (disabledBoolean)? 'chkBoxTextGrey' : 'chkBoxText';
            var returnValue =  '<span class="singprop"><input  class="propertyHolderChk" type="checkbox" name="' + checkboxName +
                    '" value="' + checkboxValue +'"  '+checkedString+' '+disabledString+'><label class="' +
                    checkboxClass+'">' +mpgSoftware.trans.translator(displayString) + '</label></input><br/></span>';
            return returnValue;
        };

        // Body of method
        if (skipBubbleUp) { // We may have some nested events to contend with
            skipBubbleUp = false;
            return;
        }
        var propId = "propId^" + phenotype + "^" + dataSet;
        var propDivName = "propId_" + phenotype + "_" + dataSet;
        if (!($('#' + propDivName).is(":visible"))) { // No need to display it if it is already on the screen

            if ($('#' + propDivName).size() === 0) {    // no need to create it if we have previously built it (once built, the user merely hides the box, not destroying it)

                var expandedProperties = "";
                // if external grey boxes then insert them
                if (typeof greyedOptions !== 'undefined') {
                    for (var i = 0; i < greyedOptions.length; i++) {
                        expandedProperties += composePropertyCheckbox (greyedOptions[i],greyedOptions[i], true, true,greyedOptions[i]);
                    }
                }
                var checkedPropertyList = [];
                var uncheckedPropertyList = [];

                if (greyOutCheckedOptions){
                    for (var i = 0; i < propertyList.length; i++) {
                        if (currentPropertyList.indexOf(propertyList[i]) > -1) {
                            checkedPropertyList.push(propertyList[i]);
                        } else {
                            uncheckedPropertyList.push(propertyList[i]);
                        }
                    }
                    for (var index in checkedPropertyList) {
                        expandedProperties += composePropertyCheckbox (propId,checkedPropertyList[index], true, true,checkedPropertyList[index]);
                    }
                    for (var index in uncheckedPropertyList) {
                        expandedProperties += composePropertyCheckbox (propId,uncheckedPropertyList[index], false, false,uncheckedPropertyList[index]);
                    }
                } else {
                    for (var i = 0; i < propertyList.length; i++) {
                        expandedProperties += composePropertyCheckbox (propId,propertyList[i],
                                (currentPropertyList.indexOf(propertyList[i]) > -1),
                                false,propertyList[i]);
                    }
                }
                $(here).append("<div id='" + propDivName + "' class ='propertyHolder'>" +//<form action=\"./relaunchAVariantSearch\">"+
                        "<span class='propboxtitle text-center'>" + title + "<a style='float:right' onclick='closer(this)'>X</a></span>" +
                        "<div class='propertySubHolder'>" +
                        "<input type=\"hidden\"  name=\"encodedParameters\" value=\"<%=encodedParameters%>\">" +
                        "<input type=\"hidden\"  name=\"filters\" value=\"<%=filter%>\">" +
                        expandedProperties +
                        "</div>" +
                        "<button onclick=\"$('#relauncher').click()\" class=\"propBox btn btn-xs btn-primary center-block\">Launch refined search</button>" +
                        "</div>");
                $('#' + propDivName).change(function (event) {
                    event.stopPropagation();
                    event.stopImmediatePropagation();
                    event.preventDefault();
                });

                $("input[type=checkbox]").change(function (event) {
                    $('#' + propDivName).show();
                    event.stopPropagation();
                    event.stopImmediatePropagation();
                    event.preventDefault();
                    var fieldName = $(this).attr('name');
                    var dividedFields = fieldName.split('^');
                    var property = $(this).val();
                    rememberProperty(dividedFields[1], dividedFields[2], [property], $(this)[0].checked);
                });
            } else {
                $('#' + propDivName).show();
            }
        }
    };
    var proteinEffectList = new UTILS.proteinEffectListConstructor(decodeURIComponent("${proteinEffectsList}"));
    var loadVariantTableViaAjax = function (filterDefinitions, additionalProperties) {
        var loading = $('#spinner').show();
        loading.show();
        $.ajax({
            type: 'POST',
            cache: false,
            data: {'keys': filterDefinitions,
                'properties': additionalProperties},
            url: '<g:createLink controller="variantSearch" action="variantSearchAndResultColumnsAjax" />',
            async: true,
            success: function (data, textStatus) {
                var variantTableContext = {
                    tooManyResults: '<g:message code="variantTable.searchResults.tooManyResults" default="too many results, sharpen your search" />'
                };
                dynamicFillTheFields(data);

                loading.hide();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                loading.hide();
                errorReporter(XMLHttpRequest, exception);
            }
        });
    }
    loadVariantTableViaAjax("<%=filter%>", "<%=additionalProperties%>");

    var uri_dec = decodeURIComponent("<%=filter%>");
    var encodedParameters = decodeURIComponent("<%=encodedParameters%>");


    var proteinEffectList = new UTILS.proteinEffectListConstructor(decodeURIComponent("${proteinEffectsList}"));
    function buildPropertyInteractor(data, phenotype, dataSet, existingCols, title) {
        var returnValue = "";
        // get our property list
        var propertyList = [];
        if ((typeof data !== 'undefined') && (data)) {
            if ((dataSet == 'common') && (data.metadata[phenotype])) {
                propertyList = Object.keys(data.metadata[phenotype]);
            } else if (phenotype == 'common') {
                propertyList = data.propertiesPerSampleGroup.dataset[dataSet];
            } else if ((data.metadata[phenotype][dataSet]) && ((data.metadata[phenotype][dataSet]).length > 0)) {
                propertyList = data.metadata[phenotype][dataSet];
            } else {// error
                propertyList = [];
            }
            returnValue = "<span class='glyphicon glyphicon-plus filterEditor propertyAdder' aria-hidden='true' onclick='lookAtProperties(this,\"" + phenotype + "\",\"" + dataSet + "\",[\"" +
                    propertyList.join('\",\"') + "\"],[\"" + existingCols.join('\",\"') + "\"],\"" + title + "\",[],true)'></span>";
        }
        return returnValue;
    }
    function buildCPropertyInteractor(propertyList, existingCols) {
        var returnValue = "";
        // get our property list
        if (typeof propertyList !== 'undefined') {
            returnValue = "<span style='float:right' class='glyphicon glyphicon-plus filterEditor propertyAdder' aria-hidden='true' onclick='lookAtProperties(this,\"common\",\"common\",[\"" +
                    propertyList.join('\",\"') + "\"],[\"" + existingCols.join('\",\"') + "\"],\"Choose common properties\",[\"VAR_ID\"],false)'></span>";
        }
        return returnValue;
    }

    function fillTheFields(data) {
        variantProcessing.oldIterativeVariantTableFiller(data, '#variantTable',
                ${show_gene},
                ${show_sigma},
                ${show_exseq},
                ${show_exchp},
                '<g:createLink controller="variantInfo" action="variantInfo" />',
                '<g:createLink controller="gene" action="geneInfo" />',
                proteinEffectList);

    }

    var contentExists = function (field) {
        return ((typeof field !== 'undefined') && (field !== null) );
    };
    var noop = function (field) {
        return field;
    };
    var lineBreakSubstitution = function (field) {
        return (contentExists(field)) ? field.replace(/[;,]/g, '<br/>') : '';
    };


    function dynamicFillTheFields(data) {

        // common props section
        var sortCol = 0;
        var totCol = 0;
        $('#variantTableHeaderRow2').children().first().append(buildCPropertyInteractor(data.cProperties.dataset, data.columns.cproperty));
        var commonWidth = 0;
        for (var common in data.columns.cproperty) {
            var colName = data.columns.cproperty[common];
            $('#variantTableHeaderRow3').append("<th class=\"datatype-header\">" + mpgSoftware.trans.translator(colName) + "</th>")
            commonWidth++;
        }
        rememberProperty('common', 'common', data.columns.cproperty, true);
        $('#variantTableHeaderRow').children().first().attr('colspan', commonWidth);
        $('#variantTableHeaderRow2').children().first().attr('colspan', commonWidth);

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
                    rememberProperty('common', dataset, data.columns.dproperty[pheno][dataset], true);
                    $('#variantTableHeaderRow2').append("<th colspan=" + dataset_width + " class=\"datatype-header\">" + datasetDisp +
                            buildPropertyInteractor(data, 'common', dataset, data.columns.dproperty[pheno][dataset], "Choose data set properties") +
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
                    if (column.substring(0, 2) == "P_") {
                        sortCol = totCol + pheno_width-1;
                    }
                    $('#variantTableHeaderRow3').append("<th class=\"datatype-header\">" + columnDisp + "</th>")
                }
                if (dataset_width > 0) {
                    rememberProperty(pheno, dataset, data.columns.pproperty[pheno][dataset], true);
                    $('#variantTableHeaderRow2').append("<th colspan=" + dataset_width + " class=\"datatype-header\">" + datasetDisp +
                            buildPropertyInteractor(data, pheno, dataset, data.columns.pproperty[pheno][dataset], "Choose dataset properties") +
                            "</th>")
                }
            }
            if (pheno_width > 0) {
                $('#variantTableHeaderRow').append("<th colspan=" + pheno_width + " class=\"datatype-header\">" + phenoDisp +
                        buildPropertyInteractor(data, pheno, 'common', Object.keys(data.columns.pproperty[pheno]), "     Choose datasets") +
                        "</th>")
            }
            totCol += pheno_width
        }

        variantProcessing.iterativeVariantTableFiller(data, totCol, sortCol, '#variantTable',
                '<g:createLink controller="variantInfo" action="variantInfo" />',
                '<g:createLink controller="gene" action="geneInfo" />',
                proteinEffectList, {});

    }





</script>


<div id="main">

    <div class="container">

        <div class="variant-info-container">
            <div class="variant-info-view">

                <h1><g:message code="variantTable.searchResults.title" default="Variant Search Results"/></h1>

                <div class="separator"></div>

                <h3><g:message code="variantTable.searchResults.meetFollowingCriteria1" default="Showing"/> <span
                        id="numberOfVariantsDisplayed"></span>
                    <g:message code="variantTable.searchResults.meetFollowingCriteria2"
                               default="variants that meet the following criteria:"/></h3>
                <script>
                    if (uri_dec) {
                        $('#tempfilter').append(uri_dec.split('+').join());
                    }
                </script>
                <ul>
                    <g:each in="${filterDescriptions}">
                        <li>${it}</li>
                    </g:each>
                </ul>

                <div id="warnIfMoreThan1000Results"></div>

                <p><a href="<g:createLink controller='variantSearch' action='variantSearchWF'
                                          params='[encParams: "${encodedParameters}"]'/>" class='boldlink'>
                    <g:message code="variantTable.searchResults.clickToRefine"
                               default="Click here to refine your results"/></a></p>


                <g:if test="${regionSearch}">
                    <g:render template="geneSummaryForRegion"/>
                </g:if>

                <g:render template="../region/newCollectedVariantsForRegion"/>

            </div>

        </div>
    </div>

</div>

<div style="display: hidden">
    <g:form name="relauncherForm" url="[action: 'relaunchAVariantSearch', controller: 'variantSearch']">
        <input type="hidden" name="encodedParameters" value="<%=encodedParameters%>">
        <input type="hidden" name="filters" value="<%=filter%>">

        <div id="hiddenFields">
            <input type="hidden" class="form-control" name="totalFilterCount" id="totalFilterCount" value="0"
                   style="height:0px">
        </div>
        <input id='relauncher' type="submit" class="propBox btn btn-xs btn-primary center-block" value="1"
               style="height:0px">
    </g:form>
</div>
<script>
    $(document).ready(function () {
        $('[data-toggle="tooltip"]').tooltip();
    });
</script>

</body>
</html>
