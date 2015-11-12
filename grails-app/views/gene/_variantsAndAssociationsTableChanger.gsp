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
                                   technologyChooser.append($("<option>").val(technologies[i]).text("Exome Sequencing"));
                                } else if (technologies[i] === "ExChip") {
                                   technologyChooser.append($("<option>").val(technologies[i]).text("Exome Chip"));
                                } else {
                                   technologyChooser.append($("<option>").val(technologies[i]).text(technologies[i]));
                                }

                            }
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
        <h4 class="modal-title" id="dataModalLabel">Variants and Associations table modifier</h4>
    </div>

    <div class="modal-body">
        <g:form role="form" class="dk-modal-form" action="geneInfo" id="${geneName}">
            <div class="dk-modal-form-input-group">
                <h4>Add / hide column</h4>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        Column title (optional)
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        %{--<input type="text" class="form-control">--}%
                        <input  type="text" class="form-control"  id="newColumnName">
                    </div>
                </div>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        P-value
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
                        Hide added columns
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <g:renderColumnCheckboxes data='${columnInformation}'></g:renderColumnCheckboxes>
                    </div>
                </div>
                <h4>Add / hide row</h4>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        Phenotype
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <select class="form-control" id="phenotypeChooser" onchange="getTechnologies(this)">

                        </select>
                    </div>
                </div>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        Technology
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <select class="form-control"  id="technologyChooser">

                        </select>
                    </div>
                </div>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        Ancestry
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <select class="form-control">
                            <option selected>No limit</option>
                            <option>African-American</option>
                            <option>Latino</option>
                            <option>East Asian</option>
                            <option>South Asian</option>
                            <option>European</option>
                        </select>
                    </div>
                </div>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        Available dataset
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <select class="form-control">
                            <option selected>Select a dataset</option>
                            <option>17k</option>
                            <option>17k_aa</option>
                            <option>17k_aa_genes</option>
                            <option>17k_aa_genes_aj</option>
                            <option>17k_aa_genes_aw</option>
                            <option>17k_ea_genes</option>
                            <option>17k_ea_genes_ek</option>
                            <option>17k_ea_genes_es</option>
                            <option>17k_eu</option>
                            <option>17k_eu_genes</option>
                            <option>17k_eu_genes_ua</option>
                            <option>17k_eu_genes_um</option>
                            <option>17k_eu_go</option>
                            <option>17k_hs</option>
                            <option>17k_hs_genes</option>
                            <option>17k_hs_genes_ha</option>
                            <option>17k_hs_genes_hs</option>
                            <option>17k_hs_sigma</option>
                            <option>17k_hs_sigma_mec</option>
                            <option>17k_hs_sigma_mexb1</option>
                            <option>17k_hs_sigma_mexb2</option>
                            <option>17k_hs_sigma_mexb3</option>
                            <option>17k_sa_genes</option>
                            <option>17k_sa_genes_sl</option>
                            <option>17k_sa_genes_ss</option>
                            <option>13k</option>
                            <option>13k_aa_genes</option>
                            <option>13k_ea_genes</option>
                            <option>13k_eu</option>
                            <option>13k_hs_genes</option>
                            <option>13k_sa_genes</option>
                            <option>82k</option>
                            <option>CARDIoGRAM</option>
                            <option>CKDGenConsortium</option>
                            <option>DIAGRAM</option>
                            <option>GIANT</option>
                            <option>GLGC</option>
                            <option>MAGIC</option>
                            <option>PGC</option>
                        </select>
                    </div>
                </div>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        Row title (optional)
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <input type="text" class="form-control">
                    </div>
                </div>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        Hide added rows
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
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="$('#vandasubmit').click()">Rebuild table</button>
        <button type="button" class="btn btn-warning" data-dismiss="modal" onclick="$('#dialog').dialog('close')">Cancel</button>
    </div>
</div>


