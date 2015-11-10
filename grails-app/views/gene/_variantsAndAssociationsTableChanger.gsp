%{--<div id="dialog" title="Variants and Associations table modifier">--}%
    %{--<div style="width: 500px">--}%

        %{--<div class="row burden-test-wrapper-options">--}%
            %{--<g:form role="form" action="geneInfo" id="${geneName}">--}%
                %{--<div class="row">--}%
                    %{--<div class="text-center" style="margin:15px 8px 15px 10px">Revise table</div>--}%
                %{--</div>--}%

                %{--<div class="col-md-12 col-sm-12 col-xs-12">--}%
                    %{--<div class="row">--}%
                        %{--<div class="form-group">--}%
                            %{--<div class="col-md-4 col-sm-4 col-xs-12">--}%
                                %{--<label>P value:&nbsp;&nbsp;</label>--}%

                            %{--</div>--}%

                            %{--<div class="col-md-8 col-sm-8 col-xs-12">--}%
                                %{--<g:textField style="display: inline-block" name="pValue" type="text"--}%
                                             %{--class="form-control" id="addPValue"--}%
                                             %{--placeholder="value">--}%
                                %{--</g:textField>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%

                    %{--<div class="row">--}%
                        %{--<div style="margin:15px 8px 15px 10px"></div>--}%
                    %{--</div>--}%

                    %{--<div class="row">--}%
                        %{--<div class="form-group">--}%
                            %{--<div class="col-md-4 col-sm-4 col-xs-12">--}%

                                %{--<label>Column name:</label><br>--}%
                                %{--<label>(optional)</label>--}%

                            %{--</div>--}%

                            %{--<div class="col-md-8 col-sm-8 col-xs-12">--}%
                                %{--<input style="display: inline-block" name="columnName" class="form-control"--}%
                                       %{--id="newColumnName"--}%
                                       %{--placeholder="value">--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%

                    %{--<div class="row">--}%
                        %{--<div class="form-group">--}%
                            %{--<div class="col-md-4 col-sm-4 col-xs-12">--}%

                                %{--<label>Existing columns:</label><br>--}%

                            %{--</div>--}%

                            %{--<div class="col-md-8 col-sm-8 col-xs-12">--}%
                                %{--<g:renderColumnCheckboxes data='${columnInformation}'></g:renderColumnCheckboxes>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%

                    %{--<div class="row">--}%
                        %{--<div class="form-group">--}%
                            %{--<div class="col-md-4 col-sm-4 col-xs-12">--}%

                                %{--<label>Existing rows:</label><br>--}%

                            %{--</div>--}%

                            %{--<div class="col-md-8 col-sm-8 col-xs-12">--}%
                                %{--<div class="row">--}%
                                    %{--<div class="col-xs-12" id="vandaRowHolder">--}%
                                        %{--<g:renderRowCheckboxes data='${rowInformation}'></g:renderRowCheckboxes>--}%
                                    %{--</div>--}%
                                %{--</div>--}%

                                %{--<div class="row">--}%
                                    %{--<div class="col-xs-12">--}%
                                        %{--<g:renderSampleGroupDropDown--}%
                                                %{--data='${allAvailableRows}'></g:renderSampleGroupDropDown>--}%
                                    %{--</div>--}%
                                %{--</div>--}%
                            %{--</div>--}%
                        %{--</div>--}%
                    %{--</div>--}%
                    %{--<button type="submit" id="vandasubmit" class="btn btn-default" style="display: none">Submit</button>--}%
                %{--</div>--}%
            %{--</g:form>--}%
        %{--</div>--}%

    %{--</div>--}%
%{--</div>--}%








%{--<div class="modal fade" id="dialog" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">--}%
%{--<div class="modal-dialog" role="document">--}%
<div class="modal-content" id="dialog">
    <div class="modal-header">
        <h4 class="modal-title" id="dataModalLabel">Variants and Associations table modifier</h4>
    </div>

    <div class="modal-body">
        <g:form role="form" class="dk-modal-form" action="geneInfo" id="${geneName}">
        %{--<form class="dk-modal-form">--}%
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
                            %{--<input type="text" class="form-control">--}%
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
                        <select class="form-control">
                            <option selected>No limit</option>
                            <option>type 2 diabetes</option>
                            <option>proinsulin levels</option>
                            <option>fasting glucose</option>
                            <option>HOMA-B</option>
                            <option>two-hour glucose</option>
                            <option>chronic kidney disease</option>
                            <option>triglycerides</option>
                            <option>LDL cholesterol</option>
                            <option>cholesterol</option>
                            <option>BMI</option>
                            <option>eGFR-cys (serum cystatin C)</option>
                            <option>waist-hip ratio</option>
                            <option>HbA1c</option>
                            <option>height</option>
                            <option>HDL cholesterol</option>
                            <option>bipolar disorder</option>
                            <option>eGFR-creat (serum creatinine)</option>
                            <option>schizophrenia</option>
                            <option>microalbuminuria</option>
                            <option>urinary albumin-to-creatinine ratio</option>
                            <option>fasting insulin</option>
                            <option>coronary artery disease</option>
                            <option>two-hour insulin</option>
                            <option>major depressive disorder</option>
                            <option>HOMA-IR</option>
                        </select>
                    </div>
                </div>

                <div class="dk-modal-form-input-row">
                    <div class="dk-variant-search-builder-title">
                        Technology
                    </div>

                    <div class="dk-variant-search-builder-ui">
                        <select class="form-control">
                            <option selected>No limit</option>
                            <option>GWAS</option>
                            <option>exome chip</option>
                            <option>exome sequence</option>
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


