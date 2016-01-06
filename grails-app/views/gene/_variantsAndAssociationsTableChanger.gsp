
<g:javascript>
    var extractAnchorTextAsInteger = function (fullAnchor){
      var returnValue = 0;
      var re = new RegExp("\>[0-9]+\<"); // retrieve text, but with angle brackets
      var re2 = new RegExp("[0-9]+"); // specifically get the presumed integer
      if (typeof fullAnchor !== 'undefined') {
         var textWithAngles = fullAnchor.match(re);
         if ( (typeof textWithAngles !== 'undefined') &&
              (textWithAngles.length > 0) ) {
                var textWithoutAngles = textWithAngles[0].match(re2);
                if ( (typeof textWithoutAngles !== 'undefined') &&
                     (textWithoutAngles.length > 0) ) {
                        var textWeWant = textWithoutAngles[0];
                        returnValue = parseInt (textWeWant,10);
                }
         }
      }
      return returnValue;
    };
    jQuery.fn.dataTableExt.oSort['allAnchor-asc']  = function(a,b) {
        var x = extractAnchorTextAsInteger(a);
        var y = extractAnchorTextAsInteger(b);
        if (!x) { x = 0; }
        if (!y) { y = 0; }
        return ((x < y) ? -1 : ((x > y) ?  1 : 0));
    };

    jQuery.fn.dataTableExt.oSort['allAnchor-desc']  = function(a,b) {
        var x = extractAnchorTextAsInteger(a);
        var y = extractAnchorTextAsInteger(b);
        if (!x) { x = 0; }
        if (!y) { y = 0; }
        return ((x < y) ? 1 : ((x > y) ?  -1 : 0));
    };

var variantsAndAssociationTable = function (phenotype,rowValueParameter,rowMapParameter){
    var rowValue = rowValueParameter;
    var rowMap = rowMapParameter;
    // make sure table is empty

    if ($.fn.DataTable.isDataTable( '#variantsAndAssociationsTable' )){
       $('#variantsAndAssociationsTable').dataTable({"bRetrieve":true}).fnDestroy();
    }
    $('#variantsAndAssociationsHead').empty();
    $('#variantsAndAssociationsTableBody').empty();
    $('#variantsAndAssociationsTable').empty();
    $('#variantsAndAssociationsTable').append('<tbody id="variantsAndAssociationsTableBody"></tbody>');

    $('#variantsAndAssociationsTable').prepend('<thead id="variantsAndAssociationsHead"></thead>');


    var compareDatasetsByTechnology = function (a, b) {
      if (a.technology < b. technology) return -1;
      if (a.technology > b. technology) return 1;
      return 0;
    };

    var determineNumberOfColumns  = function(data){
      var returnValue = 0;
      if ((typeof data !== 'undefined')  &&
          (typeof data.geneInfo !== 'undefined') &&
          (typeof data.geneInfo.results !== 'undefined') &&
          (data.geneInfo.results.length > 0) &&
          (typeof data.geneInfo.results[0] !== 'undefined') &&
          (typeof data.geneInfo.results[0].pVals !== 'undefined')){
         returnValue = data.geneInfo.results[0].pVals.length;
      }
      return returnValue;
    };
    $.ajax({
        cache: false,
        type: "post",
        url: "${createLink(controller: 'gene', action: 'genepValueCounts')}",
        data: {geneName: '<%=geneName%>',
               rowNames:rowValue,
               colNames:<g:renderColValues data='${columnInformation}'></g:renderColValues>,
               phenotype: phenotype},
            async: true,
            success: function (data) {


                        var variantsAndAssociationsTableHeaders = {
                    hdr1:'<g:message code="gene.variantassociations.table.colhdr.1" default="data type"/>',
                    hdr2:'<g:message code="gene.variantassociations.table.colhdr.2" default="sample size"/>',
                    hdr3:'<g:message code="gene.variantassociations.table.colhdr.3" default="total variants"/>',
                    gwasSig:'<g:helpText title="gene.variantassociations.table.colhdr.4.help.header" placement="top"
                                         body="gene.variantassociations.table.colhdr.4.help.text" qplacer="2px 0 0 6px"/>'+
                            '<g:message code="gene.variantassociations.table.colhdr.4b" default="genome wide"/>',
                    locusSig:'<g:helpText title="gene.variantassociations.table.colhdr.5.help.header" placement="top"
                                          body="gene.variantassociations.table.colhdr.5.help.text" qplacer="2px 0 0 6px"/>'+
                            '<g:message code="gene.variantassociations.table.colhdr.5b" default="locus wide"/>',
                    nominalSig:'<g:helpText title="gene.variantassociations.table.colhdr.6.help.header" placement="top"
                                            body="gene.variantassociations.table.colhdr.6.help.text" qplacer="2px 0 0 6px"/>'+
                         '<g:message code="gene.variantassociations.table.colhdr.6b" default="nominal"/>'
                };
                var variantsAndAssociationsPhenotypeAssociations = {
                    significantAssociations:'<g:message code="gene.variantassociations.significantAssociations"
                                                        default="variants were associated with" args="[geneName]"/>',
                    noSignificantAssociationsExist:'<g:message code="gene.variantassociations.noSignificantAssociations"
                                                               default="no significant associations"/>'
                };
                var variantsAndAssociationsRowHelpText ={
                     genomeWide:'<g:message code="gene.variantassociations.table.rowhdr.gwas" default="gwas"/>',
                     genomeWideQ:'<g:helpText title="gene.variantassociations.table.rowhdr.gwas.help.header"
                                              qplacer="2px 0 0 6px" placement="right"
                                              body="gene.variantassociations.table.rowhdr.gwas.help.text"/>',
                     exomeChip:'<g:message code="gene.variantassociations.table.rowhdr.exomeChip" default="gwas"/>',
                     exomeChipQ:'<g:helpText title="gene.variantassociations.table.rowhdr.exomeChip.help.header"
                                             qplacer="2px 0 0 6px" placement="right"
                                             body="gene.variantassociations.table.rowhdr.exomeChip.help.text"/>',
                     sigma:'<g:message code="gene.variantassociations.table.rowhdr.sigma" default="gwas"/>',
                     sigmaQ:'<g:helpText title="gene.variantassociations.table.rowhdr.sigma.help.header"
                                         qplacer="2px 0 0 6px" placement="right"
                                         body="gene.variantassociations.table.rowhdr.sigma.help.text"/>',
                     exomeSequence:'<g:message code="gene.variantassociations.table.rowhdr.exomeSequence" default="gwas"/>',
                     exomeSequenceQ:'<g:helpText title="gene.variantassociations.table.rowhdr.exomeSequence.help.header"
                                                 qplacer="2px 0 0 6px" placement="right"
                                                 body="gene.variantassociations.table.rowhdr.exomeSequence.help.text"/>'
                };

                if ((typeof data !== 'undefined') &&
                    (data)){
                        rowMap = [];
                        rowValue = [];
                        if ((data.geneInfo) &&
                            (data.geneInfo.results)){//assume we have data and process it
                              var sortedDataSetArray = data.geneInfo.results.sort(compareDatasetsByTechnology);
                              var collector = [];
                              for (var i = 0 ; i < sortedDataSetArray.length ; i++) {
                                   var d = [];
                                   rowValue.push(sortedDataSetArray[i].dataset);
                                   rowMap.push({"name":sortedDataSetArray[i].dataset,
                                                "value":sortedDataSetArray[i].dataset,
                                                "pvalue":"UNUSED",
                                                "count":sortedDataSetArray[i].subjectsNumber});
                                   for (var j = 0 ; j < sortedDataSetArray[i].pVals.length ; j++ ){
                                      d.push(sortedDataSetArray[i].pVals[j].count);
                                   }
                                   collector.push(d);
                                }

                                mpgSoftware.geneInfo.fillTheVariantAndAssociationsTableFromNewApi(data,
                                    ${show_gwas},
                                    ${show_exchp},
                                    ${show_exseq},
                                    '<g:createLink controller="region" action="regionInfo"/>',
                                    '<g:createLink controller="trait" action="traitSearch"/>',
                                    '<g:createLink controller="variantSearch" action="gene"/>',
                                    {variantsAndAssociationsTableHeaders:variantsAndAssociationsTableHeaders,
                                     variantsAndAssociationsPhenotypeAssociations:variantsAndAssociationsPhenotypeAssociations,
                                     variantsAndAssociationsRowHelpText: variantsAndAssociationsRowHelpText},
                                    '${geneChromosome}',${geneExtentBegin},${geneExtentEnd},
                                    rowMap,
                                    <g:renderColMaps data='${columnInformation}'/>,
                                    collector,
                                    '<%=geneName%>',
                                    phenotype
                                );
                                var rowsToExpand = rowValue;
                                if (typeof rowsToExpand !== 'undefined') {
                                   for ( var i = 0 ; i < rowsToExpand.length ; i++ ){
                                       jsTreeDataRetriever ('#vandaRow'+i,phenotype,rowsToExpand[i]);
                                   }
                                }
                                var numberOfColumns = determineNumberOfColumns(data);
                                var anchorColumnMarkers = [];
                                for ( var i = 0 ; i < numberOfColumns ; i++ ){
                                    anchorColumnMarkers.push(i+2);
                                }
                                $('#variantsAndAssociationsTable').dataTable({
                                        bDestroy: true,
                                        bPaginate:false,
                                        iDisplayLength: 5,
                                        bFilter: false,
                                        bInfo : false,
                                        aaSorting: [[ 1, "desc" ]],
                                        aoColumnDefs: [{sType: "allAnchor", aTargets: anchorColumnMarkers },
                                                       {"bSortable": false , aTargets: [0] }]
                                    });
                        }
                    }
                $('[data-toggle="popover"]').popover();
            },
            error: function (jqXHR, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);
            }
        });

    };


$( document ).ready(function() {
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
                    UTILS.fillPhenotypeCompoundDropdown(data.datasets,'#phenotypeChooser',true);
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
var getTechnologies = function(sel,clearExistingRows){
            $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(controller: 'VariantSearch', action: 'retrieveTechnologiesAjax')}",
            data: {phenotype:sel.value},
            async: true,
            success: function (data) {
                if (( data !==  null ) &&
                    ( typeof data !== 'undefined') &&
                    ( typeof data.technologyList !== 'undefined' ) &&
                    ( typeof data.technologyList.dataset !== 'undefined' ) &&
                    (  data.technologyList.dataset !==  null ) ) {
                        var technologies = data.technologyList.dataset;
                        if (typeof technologies !== 'undefined'){
                            var technologyChooser = $('#technologyChooser');
                            technologyChooser.empty();
                            if (clearExistingRows){
                               $('.savedRowHolder .checkbox label').empty();
                               $('.savedRowHolderLabel').hide()
                            }
                            for ( var i = 0 ; i < technologies.length ; i++ ){
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
// this is a two-part call: first we use the phenotype to get the relevant technologies, and
//  then we can launch the table refresh
var retrieveSampleGroupsbyTechnologyAndPhenotype = function(technologies,phenotype){
    var phenotypeName = phenotype;
    var compareDatasetsByTechnology = function (a, b) {
      if (a.technology < b. technology) return -1;
      if (a.technology > b. technology) return 1;
      return 0;
    }
    $.ajax({
        cache: false,
        type: "post",
        url: "${createLink(controller: 'VariantSearch', action: 'retrieveTopSGsByTechnologyAndPhenotypeAjax')}",
        data: {phenotype:phenotype,
               technologies: technologies},
        async: true,
        success: function (data) {
            if (( data !==  null ) &&
            ( typeof data !== 'undefined') &&
            ( typeof data.sampleGroupMap !== 'undefined' )  ) {
                var sampleGroupMap = data.sampleGroupMap;
                if (typeof sampleGroupMap !== 'undefined'){
                   var dataSetNames =  Object.keys(sampleGroupMap);
                   var dataSetArray = [];
                   for (var i = 0; i < dataSetNames.length; i++) {
                       dataSetArray.push(sampleGroupMap[dataSetNames[i]]);
                   }
                   var sortedDataSetArray = dataSetArray.sort(compareDatasetsByTechnology);
                   var dataSetPropertyValues = [];
                   for (var i = 0; i < sortedDataSetArray.length; i++) {
                        if (sortedDataSetArray[i]) {
                            dataSetPropertyValues.push(sortedDataSetArray[i]);
                        }
                    }
                   variantsAndAssociationTable (phenotypeName,dataSetNames,dataSetPropertyValues);

                }
            }
            },
        error: function (jqXHR, exception) {
        core.errorReporter(jqXHR, exception);
    }
});
};
var refreshVAndAByPhenotype = function(sel){
    var phenotypeName = sel.value;
    $.ajax({
        cache: false,
        type: "post",
        url: "${createLink(controller: 'VariantSearch', action: 'retrieveTechnologiesAjax')}",
        data: {phenotype:phenotypeName},
        async: true,
        success: function (data) {
            if (( data !==  null ) &&
            ( typeof data !== 'undefined') &&
            ( typeof data.technologyList !== 'undefined' ) &&
            ( typeof data.technologyList.dataset !== 'undefined' ) &&
            (  data.technologyList.dataset !==  null ) ) {
                var technologies = data.technologyList.dataset;
                if (typeof technologies !== 'undefined'){
                    retrieveSampleGroupsbyTechnologyAndPhenotype(technologies,phenotypeName);
                }
            }
        },
        error: function (jqXHR, exception) {
        core.errorReporter(jqXHR, exception);
    }
});

};



var getAncestries = function(sel){
    $.ajax({
        cache: false,
        type: "post",
        url: "${createLink(controller: 'VariantSearch', action: 'retrieveAncestriesAjax')}",
        data: { technology:sel.value,
                phenotype:$("#phenotypeChooser option:selected").val()},
        async: true,
        success: function (data) {
            if (( data !==  null ) &&
                ( typeof data !== 'undefined') &&
                ( typeof data.ancestryList !== 'undefined' ) &&
                ( typeof data.ancestryList.dataset !== 'undefined' ) &&
                (  data.ancestryList.dataset !==  null ) ) {
                    var ancestries = data.ancestryList.dataset;
                    if (typeof ancestries !== 'undefined'){
                        var ancestryChooser = $('#ancestryChooser');
                        ancestryChooser.empty();
                        for ( var i = 0 ; i < ancestries.length ; i++ ){
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
var getDataSets = function(sel){
    $.ajax({
        cache: false,
        type: "post",
        url: "${createLink(controller: 'VariantSearch', action: 'retrieveSampleGroupsAjax')}",
        data: { ancestry:sel.value,
                phenotype:$("#phenotypeChooser option:selected").val(),
                technology:$("#technologyChooser option:selected").val()},
        async: true,
        success: function (data) {
            if (( data !==  null ) &&
                ( typeof data !== 'undefined') &&
                ( typeof data.dataSetList !== 'undefined' ) &&
                ( typeof data.dataSetList.dataset !== 'undefined' ) &&
                (  data.dataSetList.dataset !==  null ) ) {
                    var dataSets = data.dataSetList.dataset;
                    if (typeof dataSets !== 'undefined'){
                        var dataSetChooser = $('#dataSetChooser');
                        dataSetChooser.empty();
                        for (var key in dataSets) {
                        if (dataSets.hasOwnProperty(key)) {
                                dataSetChooser.append($("<option>").val(key+"^"+dataSets[key]).text( mpgSoftware.trans.translator(key)));
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
function cb(a,b){
return b;
}
var jsTreeDataRetriever = function (divId,phenotypeName,sampleGroupName){
    var dataPasser = {phenotype:phenotypeName,sampleGroup:sampleGroupName};
    $(divId).jstree({
          "core" : {
                "animation" : 0,
                "check_callback" : true,
                "themes" : { "stripes" : false },
                'data' : {
                  'type': "post",
                  'url' :  "${createLink(controller: 'VariantSearch', action: 'retrieveJSTreeAjax')}",
                  'data': function (c,i) {
                         return dataPasser;
                   },
                  'metadata': dataPasser
                }
          },
          "checkbox" : {
            "keep_selected_style" : false,
            "three_state": false
          },
          "plugins" : [  "themes","core", "wholerow", "checkbox", "json_data", "ui", "types"]
    });
    $(divId).on ('after_open.jstree', function (e, data) {
    for ( var i = 0 ; i < data.node.children.length ; i++ )  {
       $('#'+data.node.children[i]+' .jstree-checkbox').click   ();
    }
    }) ;
};


</g:javascript>
<div class="modal-content" id="dialog">
    <div class="modal-header">
        <h4 class="modal-title" id="dataModalLabel"><g:message code="gene.variantassociations.tableModifier.title"/></h4>
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
                        <input  type="text" class="form-control"  name="columnName" id="columnName">
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

                <div style="display:none">
                    <h4><g:message code="gene.variantassociations.tableModifier.modify_rows"/></h4>

                    <div class="dk-modal-form-input-row">
                        <div class="dk-variant-search-builder-title">
                          <g:message code="gene.variantassociations.shared.label.phenotype"/>
                        </div>

                        <div class="dk-variant-search-builder-ui">
                            <select class="form-control" id="phenotypeChooser" name="phenotypeChooser" onchange="getTechnologies(this,true)"  onclick="getTechnologies(this,false)" disabled>

                            </select>
                        </div>
                    </div>


                    <div class="dk-modal-form-input-row">
                        <div class="dk-variant-search-builder-title">
                          <g:message code="gene.variantassociations.shared.label.technology"/>
                        </div>


                        <div class="dk-variant-search-builder-ui">
                            <select class="form-control"  id="technologyChooser" onchange="getAncestries(this)" onclick="getAncestries(this)" disabled>
                                <option selected>---</option>
                            </select>
                        </div>
                    </div>


                    <div class="dk-modal-form-input-row">
                        <div class="dk-variant-search-builder-title">
                          <g:message code="gene.variantassociations.shared.label.ancestry"/>
                        </div>

                        <div class="dk-variant-search-builder-ui">
                            <select class="form-control" id="ancestryChooser" onchange="getDataSets(this)" onclick="getDataSets(this)"  disabled>
                                <option selected>---</option>
                            </select>
                        </div>
                    </div>


                    <div class="dk-modal-form-input-row">
                        <div class="dk-variant-search-builder-title">
                          <g:message code="gene.variantassociations.tableModifier.available_dataset"/>
                            <div id="jstree"></div>
                        </div>

                        <div class="dk-variant-search-builder-ui">
                            <select class="form-control" name="dataSetChooser" id="dataSetChooser"  disabled>
                                <option selected>---</option>
                            </select>
                        </div>
                    </div>


                    <div class="dk-modal-form-input-row">
                        <div class="dk-variant-search-builder-title">
                          <g:message code="gene.variantassociations.tableModifier.row_label"/>
                        </div>

                        <div class="dk-variant-search-builder-ui">
                            <input type="text" class="form-control" name="newRowName"   id="newRowName">
                        </div>
                    </div>


                    <div class="dk-modal-form-input-row">
                        <div class="dk-variant-search-builder-title savedRowHolderLabel">
                          <g:message code="gene.variantassociations.tableModifier.show_rows"/>
                        </div>

                        <div class="dk-variant-search-builder-ui savedRowHolder">
                            <g:renderRowCheckboxes data='${rowInformation}'></g:renderRowCheckboxes>
                        </div>
                    </div>

                </div>
            </div>
        <button type="submit" id="vandasubmit" class="btn" style="display: none">
        </g:form>
    </div>

    <div class="modal-footer dk-modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="$('#vandasubmit').click()"><g:message code="gene.variantassociations.tableModifier.rebuild_table"/></button>
        <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="$('#dialog').dialog('close')"><g:message code="default.button.cancel.label"/></button>
    </div>
</div>
