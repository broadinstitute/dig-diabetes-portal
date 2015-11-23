<g:javascript>
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
var getTechnologies = function(sel){
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
                                dataSetChooser.append($("<option>").val(key+"^"+dataSets[key]).text(key));
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
                        <input  type="text" class="form-control"  id="newColumnName">
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
                <h4><g:message code="gene.variantassociations.tableModifier.modify_rows"/></h4>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        <g:message code="gene.variantassociations.shared.label.phenotype"/>
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <select class="form-control" id="phenotypeChooser" name="phenotypeChooser" onchange="getTechnologies(this)"  disabled>

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
                        <input type="text" class="form-control"   id="newRowName">
                    </div>
                </div>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        <g:message code="gene.variantassociations.tableModifier.show_rows"/>
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <g:renderRowCheckboxes data='${rowInformation}'></g:renderRowCheckboxes>
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


