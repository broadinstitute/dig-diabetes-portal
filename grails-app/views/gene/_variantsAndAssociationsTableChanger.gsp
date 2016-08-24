<script>
    $(document).ready(function () {
        var labelIndenter = function (tableId) {
            var rowSGLabel = $('#' + tableId + ' td.vandaRowTd div.vandaRowHdr');
            if (typeof rowSGLabel !== 'undefined') {
                var adjustmentMadeSoCheckAgain;
                var indentationMultiplier = 0;
                var usedAsCore = [];
                var indentation = 0;
                do {
                    var coreSGName = undefined;
                    indentationMultiplier++;
                    adjustmentMadeSoCheckAgain = false;
                    for (var i = 0; i < rowSGLabel.length; i++) {
                        var currentDiv = $(rowSGLabel[i]);
                        var sampleGroupName = currentDiv.attr('datasetname');
                        sampleGroupName = sampleGroupName.substring(0, sampleGroupName.length - 4);
                        if (typeof coreSGName === undefined) {
                            coreSGName = sampleGroupName;
                            usedAsCore.push(coreSGName);
                        } else {
                            if (sampleGroupName.indexOf(coreSGName) > -1) {
                                indentation = 12 * indentationMultiplier;
                                currentDiv.css('padding-left', indentation + 'px');
                                adjustmentMadeSoCheckAgain = true;
                            } else {
                                if (usedAsCore.indexOf(sampleGroupName) === -1) { // you only get to be the core once
                                    coreSGName = sampleGroupName;
                                    usedAsCore.push(coreSGName);
                                }
                            }
                        }
                    }
                } while (adjustmentMadeSoCheckAgain);
                if (indentation === 0) { // if nothing was intentionally indented then let's reset all the padding to zero
                    rowSGLabel.css('padding-left', '0px');
                }
            }
        };

        var vAndALabelIndenter = function () {
            labelIndenter('variantsAndAssociationsTable');
        };
        var continentalVariationLabelIndenter = function () {
            labelIndenter('continentalVariation');
        }


        // can we do a little formatting after a reorder of the table
        $('#variantsAndAssociationsTable').on('order.dt', vAndALabelIndenter);
        $('#continentalVariation').on('order.dt', continentalVariationLabelIndenter);

    });

    var variantsAndAssociationTable = function (phenotype, datasets) {
        var loader = $('#rSpinner');
        loader.show();
        var datasetIds = [];

        if ( (typeof datasets !== 'undefined') && datasets) {
            datasetIds = _.map(datasets, 'name');
        }

        // make sure table is empty
        if ($.fn.DataTable.isDataTable('#variantsAndAssociationsTable')) {
            $('#variantsAndAssociationsTable').dataTable({retrieve: true}).fnDestroy();
        }

        $('#variantsAndAssociationsTable').empty();
        $('#variantsAndAssociationsTable').append('<tbody id="variantsAndAssociationsTableBody"></tbody>');
        $('#variantsAndAssociationsTable').prepend('<thead id="variantsAndAssociationsHead"></thead>');


        var variantsAndAssociationsTableHeaders = {
            hdr1: '<g:message code="gene.continentalancestry.title.colhdr.1" default="data set"/>',
            hdr2: '<g:message code="gene.variantassociations.table.colhdr.2" default="sample size"/>',
            hdr3: '<g:message code="gene.variantassociations.table.colhdr.3" default="total variants"/>',
            hdr4: '<g:message code="gene.continentalancestry.title.colhdr.2" default="data type"/>',
            gwasSig: '<g:helpText title="gene.variantassociations.table.colhdr.4.help.header" placement="top"
                                         body="gene.variantassociations.table.colhdr.4.help.text" qplacer="2px 0 0 6px"/>' +
            '<g:message code="gene.variantassociations.table.colhdr.4b" default="genome wide"/>',
            locusSig: '<g:helpText title="gene.variantassociations.table.colhdr.5.help.header" placement="top"
                                          body="gene.variantassociations.table.colhdr.5.help.text" qplacer="2px 0 0 6px"/>' +
            '<g:message code="gene.variantassociations.table.colhdr.5b" default="locus wide"/>',
            nominalSig: '<g:helpText title="gene.variantassociations.table.colhdr.6.help.header" placement="top"
                                            body="gene.variantassociations.table.colhdr.6.help.text" qplacer="2px 0 0 6px"/>' +
            '<g:message code="gene.variantassociations.table.colhdr.6b" default="nominal"/>'
        };
        var variantsAndAssociationsRowHelpText = {
            genomeWide: '<g:message code="gene.variantassociations.table.rowhdr.gwas" default="gwas"/>',
            genomeWideQ: '<g:helpText title="gene.variantassociations.table.rowhdr.gwas.help.header"
                                              qplacer="2px 0 0 6px" placement="right"
                                              body="gene.variantassociations.table.rowhdr.gwas.help.text"/>',
            exomeChip: '<g:message code="gene.variantassociations.table.rowhdr.exomeChip" default="gwas"/>',
            exomeChipQ: '<g:helpText title="gene.variantassociations.table.rowhdr.exomeChip.help.header"
                                             qplacer="2px 0 0 6px" placement="right"
                                             body="gene.variantassociations.table.rowhdr.exomeChip.help.text"/>',
            sigma: '<g:message code="gene.variantassociations.table.rowhdr.sigma" default="gwas"/>',
            sigmaQ: '<g:helpText title="gene.variantassociations.table.rowhdr.sigma.help.header"
                                         qplacer="2px 0 0 6px" placement="right"
                                         body="gene.variantassociations.table.rowhdr.sigma.help.text"/>',
            exomeSequence: '<g:message code="gene.variantassociations.table.rowhdr.exomeSequence" default="gwas"/>',
            exomeSequenceQ: '<g:helpText title="gene.variantassociations.table.rowhdr.exomeSequence.help.header"
                                                 qplacer="2px 0 0 6px" placement="right"
                                                 body="gene.variantassociations.table.rowhdr.exomeSequence.help.text"/>'
        };

        var columnInfo = <g:renderColMaps data='${columnInformation}'/>;

        var tablePromises = mpgSoftware.geneInfo.fillVariantsAndAssociationsTable(
            '<g:createLink controller="gene" action="genepValueCounts"/>',
            '<g:createLink controller="variantSearch" action="gene"/>',
            variantsAndAssociationsTableHeaders,
            variantsAndAssociationsRowHelpText,
            '${geneChromosome}', ${geneExtentBegin}, ${geneExtentEnd},
            datasetIds,
            columnInfo,
            '<%=geneName%>',
            phenotype
        );

        // all of the table data has been collected and put in the table
        $.when.apply($, tablePromises).then(function() {
            for (var i = 0; i < datasetIds.length; i++) {
                var divId = '#vandaRow' + i;
                UTILS.jsTreeDataRetriever(divId,
                                          '#variantsAndAssociationsTable',
                                          phenotype,
                                          datasetIds[i],
                                          "${createLink(controller: 'VariantSearch', action: 'retrieveJSTreeAjax')}");
                $(divId).on('after_open.jstree', function(e, data) {
                    reviseRows();
                });
            }
            var numberOfDataColumns  = columnInfo.length;
            var anchorColumnMarkers = [];
            // this is used to tell datatables which columns have anchor tags in them
            for (var i = 0; i < numberOfDataColumns; i++) {
                anchorColumnMarkers.push(i + 3);
            }

            var table = $('#variantsAndAssociationsTable').dataTable({
                destroy: true,
                paging: false,
                searching: false,
                info: false,
                ordering: [[0, "asc"]],
                columnDefs: [{type: "allAnchor", targets: anchorColumnMarkers},
                    {type: "headerAnchor", targets: [0]}]
            });
            
            $('[data-toggle="popover"]').popover();
            loader.hide();
        });
    };


    $(document).ready(function () {
        $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(controller: 'VariantSearch', action: 'retrievePhenotypesAjax')}",
            data: {},
            async: true,
            success: function (data) {
                if (( data !== null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !== null )) {
                    UTILS.fillPhenotypeCompoundDropdown(data.datasets, '#phenotypeChooser', true);
                    // Can we set the default option on the phenotype list?
                    $('#phenotypeChooser').val('${phenotype}');
                    // resetting the phenotype clears all boxes except for the technology chooser
                    var dataSetChooser = $('#dataSetChooser');
                    dataSetChooser.empty();
                    dataSetChooser.append($("<option>").text("---"));
                    $('#phenotypeChooser').removeAttr('disabled');
                }
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });

    });
    var getTechnologies = function (sel, clearExistingRows) {
        $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(controller: 'VariantSearch', action: 'retrieveTechnologiesAjax')}",
            data: {phenotype: sel.value},
            async: true,
            success: function (data) {
                if (( data !== null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.technologyList !== 'undefined' ) &&
                        ( typeof data.technologyList.dataset !== 'undefined' ) &&
                        (  data.technologyList.dataset !== null )) {
                    var technologies = data.technologyList.dataset;
                    if (typeof technologies !== 'undefined') {
                        var technologyChooser = $('#technologyChooser');
                        technologyChooser.empty();
                        if (clearExistingRows) {
                            $('.savedRowHolder .checkbox label').empty();
                            $('.savedRowHolderLabel').hide()
                        }
                        for (var i = 0; i < technologies.length; i++) {
                            if (technologies[i] === "ExSeq") {
                                technologyChooser.append($("<option>").val(technologies[i]).text("<g:message code="gene.variantassociations.technologyChooser.option.exome_sequencing"/>"));
                            } else if (technologies[i] === "ExChip") {
                                technologyChooser.append($("<option>").val(technologies[i]).text("<g:message code="gene.variantassociations.technologyChooser.option.exome_chip"/>"));
                            } else {
                                technologyChooser.append($("<option>").val(technologies[i]).text(technologies[i]));
                            }

                        }
                        var ancestryChooser = $('#ancestryChooser');
                        ancestryChooser.empty();
                        ancestryChooser.append($("<option>").text("---"));
                        var dataSetChooser = $('#dataSetChooser');
                        dataSetChooser.empty();
                        dataSetChooser.append($("<option>").text("---"));
                        $('#technologyChooser').removeAttr('disabled');
                    }
                }
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });

    }
    var refreshVAndAByPhenotype = function (sel) {
        var phenotypeName = sel.value;
        $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(controller: 'VariantSearch', action: 'retrieveTechnologiesAjax')}",
            data: {phenotype: phenotypeName},
            async: true,
            success: function (data) {
                if (( data !== null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.technologyList !== 'undefined' ) &&
                        ( typeof data.technologyList.dataset !== 'undefined' ) &&
                        (  data.technologyList.dataset !== null )) {
                    var technologies = data.technologyList.dataset;
                    if (typeof technologies !== 'undefined') {
                        UTILS.retrieveSampleGroupsbyTechnologyAndPhenotype(technologies,
                                phenotypeName,
                                "${createLink(controller: 'VariantSearch', action: 'retrieveTopSGsByTechnologyAndPhenotypeAjax')}",
                                variantsAndAssociationTable);
                    }
                }
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });

    };



    var getAncestries = function (sel) {
        $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(controller: 'VariantSearch', action: 'retrieveAncestriesAjax')}",
            data: {
                technology: sel.value,
                phenotype: $("#phenotypeChooser option:selected").val()
            },
            async: true,
            success: function (data) {
                if (( data !== null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.ancestryList !== 'undefined' ) &&
                        ( typeof data.ancestryList.dataset !== 'undefined' ) &&
                        (  data.ancestryList.dataset !== null )) {
                    var ancestries = data.ancestryList.dataset;
                    if (typeof ancestries !== 'undefined') {
                        var ancestryChooser = $('#ancestryChooser');
                        ancestryChooser.empty();
                        for (var i = 0; i < ancestries.length; i++) {
                            ancestryChooser.append($("<option>").val(ancestries[i]).text(ancestries[i]));
                        }
                    }
                    var dataSetChooser = $('#dataSetChooser');
                    dataSetChooser.empty();
                    dataSetChooser.append($("<option>").text("---"));
                    $('#ancestryChooser').removeAttr('disabled');
                }
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });
    }
    var getDataSets = function (sel) {
        $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(controller: 'VariantSearch', action: 'retrieveSampleGroupsAjax')}",
            data: {
                ancestry: sel.value,
                phenotype: $("#phenotypeChooser option:selected").val(),
                technology: $("#technologyChooser option:selected").val()
            },
            async: true,
            success: function (data) {
                if (( data !== null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.dataSetList !== 'undefined' ) &&
                        ( typeof data.dataSetList.dataset !== 'undefined' ) &&
                        (  data.dataSetList.dataset !== null )) {
                    var dataSets = data.dataSetList.dataset;
                    if (typeof dataSets !== 'undefined') {
                        var dataSetChooser = $('#dataSetChooser');
                        dataSetChooser.empty();
                        for (var key in dataSets) {
                            if (dataSets.hasOwnProperty(key)) {
                                dataSetChooser.append($("<option>").val(key + "^" + dataSets[key]).text(key));
                            }
                        }
                        dataSetChooser.removeAttr('disabled');
                    }
                }
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });
    }


</script>

<div class="modal-content" id="dialog">
    <div class="modal-header">
        <h4 class="modal-title" id="dataModalLabel"><g:message
                code="gene.variantassociations.tableModifier.title"/></h4>
    </div>

    <div class="modal-body">
        <g:form role="form" class="dk-modal-form" action="geneInfo" id="${geneName}">
            <div class="dk-modal-form-input-group">
                <h4><g:message code="gene.variantassociations.tableModifier.modify_cols"/></h4>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        <g:message code="gene.variantassociations.tableModifier.col_label"/>
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <input type="text" class="form-control" name="columnName" id="columnName">
                    </div>
                </div>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        <g:message code="variantTable.columnHeaders.shared.pValue"/>
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <div class="col-md-3 col-sm-3 col-xs-3">
                            <select class="form-control">
                                <option>&lt;</option>
                                <option>&gt;</option>
                                <option>=</option>
                            </select>
                        </div>

                        <div class="col-md-8 col-sm-8 col-xs-8 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                            <g:textField name="pValue" type="text" class="form-control" id="addPValue"/>
                        </div>
                    </div>
                </div>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        <g:message code="gene.variantassociations.tableModifier.show_cols"/>
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <g:renderColumnCheckboxes data='${columnInformation}'></g:renderColumnCheckboxes>
                    </div>
                </div>
            </div>
            <button type="submit" id="vandasubmit" class="btn" style="display: none"/>
        </g:form>
    </div>

    <div class="modal-footer dk-modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal"
                onclick="$('#vandasubmit').click()"><g:message
                code="gene.variantassociations.tableModifier.rebuild_table"/></button>
        <button type="button" class="btn btn-warning" data-dismiss="modal"
                onclick="$('#dialog').dialog('close')"><g:message code="default.button.cancel.label"/></button>
    </div>
</div>
