%{--this will go inside grails-app/views/template(new folder created by BenA)--}%
%{--this will have all the mustache templates--}%
%{--<g:elseif test="${g.portalTypeString()?.equals('stroke')}--}%

<g:render template="./data/GWAS_SIGN"/>
<g:render template="./data/GWAS_Stroke"/>
<g:render template="./data/ExChip_AFGen" />
<g:render template="./data/GWAS_UKBB" />
<g:render template="./data/GWAS_CKDGenConsortium-eGFRcrea"/>
<g:render template="./data/GWAS_CKDGenConsortium-UACR"/>
<g:render template="./data/GWAS_GIANT"/>
<g:render template="./data/GWAS_VATGen"/>
<g:render template="./data/GWAS_BioMe"/>
<g:render template="./data/GWAS_GIANT-PA" />
<g:render template="./data/GWAS_PGC"/>
<g:render template="./data/GWAS_CARDIoGRAM"/>
<g:render template="./data/GWAS_AGEN" />
<g:render template="./data/GWAS_SIGMA1"/>
<g:render template="./data/GWAS_METSIM_eu" />
<g:render template="./data/AMPLOAD_10_mdv1" />
<g:render template="./data/GWAS_DIAGRAM"/>
<g:render template="./data/GWAS_MAGIC"/>
<g:render template="./data/GWAS_GLGC"/>
<g:render template="./data/ExChip_CAMP"/>
<g:render template="./data/GWAS_CAMP"/>
<g:render template="./data/GWAS_CKDGenConsortium"/>
<g:render template="./data/GWAS_EXTEND_mdv1" />
<g:render template="./data/GWAS_GENESIS_eu"/>
<g:render template="./data/GWAS_70kForT2D"/>
<g:render template="./data/GWAS_OxBB"/>
<g:render template="./data/ExChip_SIGMA1"/>
<g:render template="./data/ExChip_T2DGO"/>
<g:render template="./data/WGS_GoT2Dimputed"/>
<g:render template="./data/WGS_WgnomAD" />
<g:render template="./data/WGS_GoT2D" />
<g:render template="./data/ExSeq_13k"/>
<g:render template="./data/ExSeq_17k"/>
<g:render template="./data/ExSeq_19k"/>
<g:render template="./data/ExSeq_EgnomAD"/>
<g:render template="./data/ExAC_r03" />
<g:render template="./data/1kg_phase1" />
<g:render template="./data/ExChip_82k"/>
<g:render template="./data/ExSeq_EOMI"/>
<g:render template="./data/GWAS_CADISP"/>
<g:render template="./data/GWAS_GERFHS"/>
<g:render template="./data/GWAS_MEGASTROKE"/>
<g:render template="./data/GWAS_MICAD"/>
<g:render template="./data/GWAS_PWI" />
<g:render template="./data/ExChip_AFGen" />
<g:render template="./data/GWAS_AFGen" />
<g:render template="./data/GWAS_GEI" />
<g:render template="./data/ExChip_MICAD" />
<g:render template="./data/ExChip_300k" />
<g:render template="./data/GWAS_DCSP2a610" />
<g:render template="./data/GWAS_DCSP2a1M" />
<g:render template="./data/ExSeq_RSNG" />
<g:render template="./data/GWAS_DCSP2" />
<g:render template="./data/GWAS_DIAGRAMimputed" />
<g:render template="./data/GWAS_DIAGRAMimputed_eu" />
<g:render template="./data/GWAS_AFHRC" />
<g:render template="./data/ExChip_ExTexT2D" />
<g:render template="./data/ExChip_FUSION" />
<g:render template="./data/GWAS_FUSION" />
<g:render template="./data/GWAS_FUSIONonlyMetaboChip" />
<g:render template="./data/ExChip_EPRI" />
<g:render template="./data/GWAS_MetaStroke" />
<g:render template="./data/GWAS_HPTxNCGM" />
<g:render template="./data/GWAS_VHIR" />
<g:render template="./data/GWAS_GiantUKBB" />
<g:render template="./data/GWAS_BFpercent" />
<g:render template="./data/GWAS_EGGC" />
<g:render template="./data/GWAS_HRgene" />
<g:render template="./data/GWAS_AGEN_ea" />
<g:render template="./data/GWAS_DCSP2_ea" />
<g:render template="./data/ExSeq_52k" />
<g:render template="./data/AMPLOAD_36" />
<g:render template="./data/ExChip_CHARGE-1_eu" />
<g:render template="./data/ExChip_CHARGE-2_aa" />
<g:render template="./data/GWAS_AAGILE" />
<g:render template="./data/AMPLOAD_7_illumina" />
<g:render template="./data/AMPLOAD_7_broad" />
<g:render template="./data/AMPLOAD_7_metabo" />
<g:render template="./data/AMPLOAD_7_exome" />
<g:render template="./data/AMPLOAD_7_affymetrix" />
<g:render template="./data/GWAS_Oxford_GoDARTS" />
<g:render template="./data/GWAS_SUMMITDKD-T1DT2D" />
<g:render template="./data/GWAS_SUMMITDKD-ESRDvControl_eu" />
<g:render template="./data/GWAS_GIANT-A" />
<g:render template="./data/GWAS_MAGIC-Metabochip" />
<g:render template="./data/GWAS_DIAMANTE_eu" />
<g:render template="./data/GWAS_DIAMANTE-CredibleSet_eu" />
<g:render template="./data/GWAS_DIAMANTE-UKBB_eu_dv2" />
<g:render template="./data/GWAS_UKBiobankACR_eu" />
<g:render template="./data/WGS_TOPMedAF_eu" />
<g:render template="./data/GWAS_UKBiobankHRC_eu" />
<g:render template="./data/GWAS_ADIPOGen" />
<g:render template="./data/GWAS_CHARGE_eu" />
<g:render template="./data/GWAS_GUGC_eu" />
<g:render template="./data/GWAS_Leptin" />
<g:render template="./data/GWAS_Leptin_eu" />
<g:render template="./data/GWAS_MAGIC-A1C_aa" />
<g:render template="./data/GWAS_MAGIC-A1C_ea" />
<g:render template="./data/GWAS_MAGIC-A1C_eu" />
<g:render template="./data/GWAS_MAGIC-A1C_sa" />
<g:render template="./data/GWAS_DNCRI" />
<g:render template="./data/GWAS_ISGC_eu_dv1" />
<g:render template="./data/GWAS_LOLIPOP" />




<script id="metaData2" type="x-tmpl-mustache">
    <div>
        <h3>Datasets</h3>
        <table id="datasets" class="table table-condensed" style="">
            <thead>
            <tr>

                <th>Dataset</th>
                <g:if test="${g.portalTypeString()?.equals('mi')}">
                <th>Samples</th>
                <th>Ancestry</th>
                <th>Data type</th>
                </g:if>

<g:elseif test="${g.portalTypeString()?.equals('sleep')}">
    <th>Samples</th>
    <th>Ancestry</th>
    <th>Data type</th>
</g:elseif>

                <g:else>
                <th>Access</th>
                <th>Samples</th>
                <th>Ancestry</th>
                <th>Data type</th>
                </g:else>
            </tr>
            </thead>
        <tbody>
        <div class="accordion" id="accordion">
        {{#parents}}
        <tr>
            <td class="dataset">
                    <div class="accordion-group">
                        <div class="accordion-heading">
                                <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion"
                                   href="#{{name}}_myTarget" aria-expanded="true" aria-controls="{{name}}_myTarget">
                                   {{label}}
                                </a>
                        </div>

                    </div>
            </td>

            <g:if test="${g.portalTypeString()?.equals('mi')}">
                <td class="samples">{{size}}</td>
                <td class="ethnicity">{{ancestry}}</td>
                <td class="datatype">{{technology}}</td>
            </g:if>

<g:elseif test="${g.portalTypeString()?.equals('sleep')}">
    <td class="samples">{{size}}</td>
    <td class="ethnicity">{{ancestry}}</td>
    <td class="datatype">{{technology}}</td>
</g:elseif>
            <g:else>
                <td class="access" style="color:{{accessColor}}">{{access}} </td>
                <td class="samples">{{size}}</td>
                <td class="ethnicity">{{ancestry}}</td>
                <td class="datatype">{{technology}}</td>
            </g:else>


        </tr>
        <tr>
        <td colspan="5" style="border: none; padding:0; margin: 0;"> <div id="{{name}}_myTarget" class="accordion-body collapse dataset-description" >
                            <div class="accordion-inner">
                                <div id="{{name}}_script_holder"></div>
                            </div>
                        </div>
                            </td>
        </tr>
        </div>
        {{/parents}}
        </tbody>
    </table>
</div>
</script>

<script id="datatypeFilter" type="x-tmpl-mustache">
    <h5>Data type</h5>
    <div class='filters-style' >
            {{#datatype}}
            <div class='datatype-option'  onclick='mpgSoftware.datasetsPage.onClickdatatype("{{.}}","${createLink(controller:'informational',action: 'aboutTheDataAjax')}")'>{{.}}</div>
            {{/datatype}}
            <div class='datatype-option datatype-option-showall' onclick='mpgSoftware.datasetsPage.onClickdatatype("Show all","${createLink(controller:'informational',action: 'aboutTheDataAjax')}")'>Show all</div>
    </div>
</script>

<script id="phenotypeFilter" type="x-tmpl-mustache">
  <h5>Phenotype</h5>
  <div class='filters-style'>
    {{#groups}}
    <div class='phenotype-option' onclick='mpgSoftware.datasetsPage.onClickPhenotypeGroup("{{.}}")'>{{.}}</div>
    {{/groups}}
    <div class='phenotype-option phenotype-option-showall' onclick='mpgSoftware.datasetsPage.onClickPhenotypeGroup("Show all")' >Show all</div>
  </div>
</script>

<!--this panel would display only when phenotype Filter is clicked -->
<script id="phenotypeFilterLevel2" type="x-tmpl-mustache">
  <div class='filters-style'>
    <div class="phenotype-level2-row">
    {{#phenotype}}
    <div class='phenotype-level2-option' onclick='mpgSoftware.datasetsPage.onClickPhenotypelevel2("{{.}}")'>{{.}}</div>
    {{/phenotype}}
    </div>
    </div>
</script>

<div class="row datasetsHolder">
    <div class="col-md-12">
        <div class="datasets-filter" style="display: inline-block; width: 100%;">
            <h3>Filter Dataset Table<small> (Click one to start)</small></h3>
            <div id="datatypeFilterDisplay" class="form-inline"></div>
            <div id="phenotypeFilterLevel1Display" class="form-inline"></div>
            <div id="phenotypeFilterLevel2Display" class="form-inline"></div>
        </div>
        <div  id ="metaDataDisplay" class="form-inline" style="width: 100%"></div>
    </div>
</div>


