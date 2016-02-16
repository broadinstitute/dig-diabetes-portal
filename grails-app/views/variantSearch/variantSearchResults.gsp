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
        z-index: 10;
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
        z-index: 10;
    }

    div.propertyHolder .propertyHolderChk {
        color: black;
        margin: 5px 0 5px 0;
        z-index: 10;
    }

    .singprop {
        width: 100%;
        display: flex;
        flex-direction: row;
        align-items: center;
    }


    .chkBoxText {
        color: black;
        margin: 5px 0 5px 0;
        padding: 0 0 0 10px;
        white-space: normal;
        /* to make sure the checkbox stays fullsized */
        max-width: 90%;
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
        $(that).hide();
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
    var lookAtProperties = function (here, phenotype, dataSet, propertyList, currentPropertyList, title, greyedOptions, greyOutCheckedOptions) {

        // private method to write a single checkbox
        var composePropertyCheckbox = function (checkboxName, checkboxValue, checkedBoolean, disabledBoolean, displayString) {
            var checkboxClass = (disabledBoolean) ? 'chkBoxTextGrey' : 'chkBoxText';
            var returnValue = document.createElement('li');
            $(returnValue).attr({class: 'singprop'});

            var checkbox = document.createElement('input');
            $(checkbox).attr({
                class: 'propertyHolderChk',
                type: 'checkbox',
                name: checkboxName,
                value: checkboxValue
            });
            $(checkbox).prop({
                checked: checkedBoolean,
                disabled: disabledBoolean
            });
            var datasetNameLabel = document.createElement('label');
            $(datasetNameLabel).attr({
                class: checkboxClass
            });

            $(datasetNameLabel).append(translationFunction(displayString));
            $(returnValue).append(checkbox, datasetNameLabel);

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

                var expandedProperties = document.createElement('ul');
                $(expandedProperties).attr({
                    style: 'padding: 0'
                });
                // if external grey boxes then insert them
                if (typeof greyedOptions !== 'undefined') {
                    for (var i = 0; i < greyedOptions.length; i++) {
                        $(expandedProperties).append(composePropertyCheckbox(greyedOptions[i], greyedOptions[i], true, true, greyedOptions[i]));
                    }
                }
                var checkedPropertyList = [];
                var uncheckedPropertyList = [];

                if (greyOutCheckedOptions) {
                    for (var i = 0; i < propertyList.length; i++) {
                        if (currentPropertyList.indexOf(propertyList[i]) > -1) {
                            checkedPropertyList.push(propertyList[i]);
                        } else {
                            uncheckedPropertyList.push(propertyList[i]);
                        }
                    }
                    for (var index in checkedPropertyList) {
                        $(expandedProperties).append(composePropertyCheckbox(propId, checkedPropertyList[index], true, true, checkedPropertyList[index]));
                    }
                    for (var index in uncheckedPropertyList) {
                        $(expandedProperties).append(composePropertyCheckbox(propId, uncheckedPropertyList[index], false, false, uncheckedPropertyList[index]));
                    }
                } else {
                    for (var i = 0; i < propertyList.length; i++) {
                        $(expandedProperties).append(composePropertyCheckbox(propId, propertyList[i],
                                (currentPropertyList.indexOf(propertyList[i]) > -1),
                                false, propertyList[i]));
                    }
                }

                var datasetSelection = document.createElement('div');
                datasetSelection.setAttribute('id', propDivName);
                datasetSelection.setAttribute('class', 'propertyHolder');

                var titleSpan = document.createElement('span');
                titleSpan.setAttribute('class', 'propboxtitle text-center');
                $(titleSpan).append(title);
                var closeLink = document.createElement('a');
                closeLink.setAttribute('style', 'float:right');
                // the "text" for the link
                $(closeLink).append("X");
                closeLink.addEventListener('click', function(){
                    closer(datasetSelection);
                });
                $(titleSpan).append(closeLink);
                $(datasetSelection).append(titleSpan);

                var propertySubHolder = document.createElement('div');
                propertySubHolder.setAttribute('class', 'propertySubHolder');
                $(propertySubHolder).append("<input type=\"hidden\"  name=\"encodedParameters\" value=\"<%=encodedParameters%>\">");
                $(propertySubHolder).append("<input type=\"hidden\"  name=\"filters\" value=\"<%=filterForResend%>\">");
                $(propertySubHolder).append(expandedProperties);
                $(datasetSelection).append(propertySubHolder);

                var submitButton = document.createElement('button');
                submitButton.setAttribute('class', 'propBox btn btn-xs btn-primary center-block');
                submitButton.innerHTML = "Launch refined search";
                submitButton.addEventListener('click', function() {
                    $('#relauncher').click();
                });
                $(datasetSelection).append(submitButton);

                $(here).append(
                datasetSelection);

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

    var loadVariantTableViaAjax = function (filterDefinitions, additionalProperties) {
        var loading = $('#spinner').show();
        loading.show();
        $.ajax({
            type: 'POST',
            cache: false,
            data: {
                'keys': filterDefinitions,
                'properties': additionalProperties
            },
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
    // this kicks everything off
    loadVariantTableViaAjax("<%=filterForResend%>", "<%=additionalProperties%>");

    var uri_dec = decodeURIComponent("<%=filter%>");
    var encodedParameters = decodeURIComponent("<%=encodedParameters%>");
    var proteinEffectList = new UTILS.proteinEffectListConstructor(decodeURIComponent("${proteinEffectsList}"));

    function buildPropertyInteractor(data, phenotype, dataSet, existingCols, title) {
        var returnValue = document.createElement('span');
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

            returnValue.setAttribute("class", "glyphicon glyphicon-plus filterEditor propertyAdder");
            returnValue.setAttribute("aria-hidden", "true");
            returnValue.addEventListener('click', function() {
               lookAtProperties(this, phenotype, dataSet, propertyList, existingCols, title, [], true);
            });
        }
        return returnValue;
    }
    function buildCPropertyInteractor(propertyList, existingCols) {
        var returnValue = document.createElement('span');
        // get our property list
        if (typeof propertyList !== 'undefined') {
            returnValue.setAttribute("style", "float: right");
            returnValue.setAttribute("class", "glyphicon glyphicon-plus filterEditor propertyAdder");
            returnValue.setAttribute("aria-hidden", "true");
            returnValue.addEventListener('click', function() {
                lookAtProperties(this, "common", "common", propertyList, existingCols, "Choose common properties", ["VAR_ID"], false)
            });
        }
        return returnValue;
    }

    function fillTheFields(data) {
        variantProcessing.oldIterativeVariantTableFiller(data, '#variantTable',
                ${show_gene},
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

    /**
     * This function exists to avoid having to do
     * "if translationDictionary[string] defined, return that, else return string"
     * NOTE: the function is declared here so that it is in-scope for the
     * `composePropertyCheckbox` function declared earlier. It is defined within
     * `dynamicFillTheFields`, which has the necessary data for the function to
     * execute
     * @param stringToTranslate
     * @returns {*}
     */
    var translationFunction;

    function dynamicFillTheFields(data) {

        translationFunction = function (stringToTranslate) {
            return data.translationDictionary[stringToTranslate] || stringToTranslate
        }

        // common props section
        var sortCol = 0;
        var totCol = 0;
        var varIdIndex = data.columns.cproperty.indexOf('VAR_ID');
        if (varIdIndex > 0) {
            data.columns.cproperty.splice(varIdIndex, 1);
        }
        $('#variantTableHeaderRow2').children().first().append(buildCPropertyInteractor(data.cProperties.dataset, data.columns.cproperty));
        var commonWidth = 0;
        for (var common in data.columns.cproperty) {
            var colName = data.columns.cproperty[common];
            var translatedColName = translationFunction(colName);
            if (!((colName === 'VAR_ID') && (commonWidth > 0))) { // VAR_ID never shows up other than in the first column
                $('#variantTableHeaderRow3').append("<th class=\"datatype-header\">" + translatedColName + "</th>")
                commonWidth++;
            }

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
                var datasetDisp = translationFunction(dataset);
                for (var i = 0; i < data.columns.dproperty[pheno][dataset].length; i++) {
                    var column = data.columns.dproperty[pheno][dataset][i];
                    var columnDisp = translationFunction(column);
                    pheno_width++
                    dataset_width++
                    $('#variantTableHeaderRow3').append("<th class=\"datatype-header\">" + columnDisp + "</th>")
                }
                if (dataset_width > 0) {
                    rememberProperty('common', dataset, data.columns.dproperty[pheno][dataset], true);
                    var newTableHeader = document.createElement('th');
                    newTableHeader.setAttribute('class', 'datatype-header');
                    newTableHeader.setAttribute('colspan', dataset_width);
                    $(newTableHeader).append(datasetDisp)
                    $(newTableHeader).append(buildPropertyInteractor(data, 'common', dataset, data.columns.dproperty[pheno][dataset], "Choose data set properties"))
                    $('#variantTableHeaderRow2').append(newTableHeader);
                }
            }
            if (pheno_width > 0) {
                $('#variantTableHeaderRow').append("<th colspan=" + pheno_width + " class=\"datatype-header\"></th>")
            }
            totCol += pheno_width
        }

        // pheno specific props
        for (var pheno in data.columns.pproperty) {
            var pheno_width = 0;
            var phenoDisp = translationFunction(pheno);
            for (var dataset in data.columns.pproperty[pheno]) {
                var dataset_width = 0;
                var datasetDisp = translationFunction(dataset);
                for (var i = 0; i < data.columns.pproperty[pheno][dataset].length; i++) {
                    var column = data.columns.pproperty[pheno][dataset][i];
                    var columnDisp = translationFunction(column);
                    pheno_width++
                    dataset_width++
                    //HACK HACK HACK HACK HACK
                    if (column.substring(0, 2) == "P_") {
                        sortCol = totCol + pheno_width - 1;
                    }
                    $('#variantTableHeaderRow3').append("<th class=\"datatype-header\">" + columnDisp + "</th>")
                }
                if (dataset_width > 0) {
                    rememberProperty(pheno, dataset, data.columns.pproperty[pheno][dataset], true);
                    var newTableHeader = document.createElement('th');
                    newTableHeader.setAttribute('class', 'datatype-header');
                    newTableHeader.setAttribute('colspan', dataset_width);
                    $(newTableHeader).append(datasetDisp);
                    $(newTableHeader).append(buildPropertyInteractor(data, pheno, dataset, data.columns.pproperty[pheno][dataset], "Choose dataset properties"));
                    $('#variantTableHeaderRow2').append(newTableHeader);
                }
            }
            if (pheno_width > 0) {
                var newTableHeader = document.createElement('th');
                newTableHeader.setAttribute('class', 'datatype-header');
                newTableHeader.setAttribute('colspan', pheno_width);
                $(newTableHeader).append(phenoDisp);
                $(newTableHeader).append(buildPropertyInteractor(data, pheno, "common", Object.keys(data.columns.pproperty[pheno]), "Choose datasets"));
                $('#variantTableHeaderRow').append(newTableHeader);
            }
            totCol += pheno_width
        }

        variantProcessing.iterativeVariantTableFiller(data, totCol, sortCol, '#variantTable',
                '<g:createLink controller="variantInfo" action="variantInfo" />',
                '<g:createLink controller="gene" action="geneInfo" />',
                proteinEffectList, {}, "${locale}",
                '<g:message code="table.buttons.copyText" default="Copy" />',
                '<g:message code="table.buttons.printText" default="Print me!" />');
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

                <g:renderUlFilters encodedFilters='${encodedFilters}'/>

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
