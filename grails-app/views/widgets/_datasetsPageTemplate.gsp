%{--this will go inside grails-app/views/template(new folder created by BenA)--}%
%{--this will have all the mustache templates--}%
%{--<g:elseif test="${g.portalTypeString()?.equals('stroke')}--}%

<g:render template="./data/ExAC_r03" />
<g:render template="./data/1kg_phase1" />
<g:render template="./data/ExChip_82k"/>
<g:render template="./data/ExChip_CAMP"/>
<g:render template="./data/GWAS_CAMP"/>
<g:render template="./data/ExChip_SIGMA1"/>
<g:render template="./data/ExChip_T2DGO"/>
<g:render template="./data/ExSeq_13k"/>
<g:render template="./data/ExSeq_17k"/>
<g:render template="./data/ExSeq_19k"/>
<g:render template="./data/ExSeq_EgnomAD"/>
<g:render template="./data/ExSeq_EOMI"/>
<g:render template="./data/GWAS_70kForT2D"/>
<g:render template="./data/GWAS_BioMe"/>
<g:render template="./data/GWAS_CADISP"/>
<g:render template="./data/GWAS_CARDIoGRAM"/>
<g:render template="./data/GWAS_CKDGenConsortium-eGFRcrea"/>
<g:render template="./data/GWAS_CKDGenConsortium-UACR"/>
<g:render template="./data/GWAS_CKDGenConsortium"/>
<g:render template="./data/GWAS_DIAGRAM"/>
<g:render template="./data/GWAS_GENESIS_eu"/>
<g:render template="./data/GWAS_GERFHS"/>
<g:render template="./data/GWAS_GIANT"/>
<g:render template="./data/GWAS_GLGC"/>
<g:render template="./data/GWAS_MAGIC"/>
<g:render template="./data/GWAS_MEGASTROKE"/>
<g:render template="./data/GWAS_MICAD"/>
<g:render template="./data/GWAS_OxBB"/>
<g:render template="./data/GWAS_PGC"/>
<g:render template="./data/GWAS_SIGMA1"/>
<g:render template="./data/GWAS_SIGN"/>
<g:render template="./data/GWAS_Stroke"/>
<g:render template="./data/GWAS_VATGen"/>
<g:render template="./data/WGS_GoT2D" />
<g:render template="./data/WGS_GoT2Dimputed"/>
<g:render template="./data/WGS_WgnomAD" />
<g:render template="./data/ExChip_AFGen" />
<g:render template="./data/GWAS_AFGen" />
<g:render template="./data/ExChip_MICAD" />
<g:render template="./data/ExChip_300k" />
<g:render template="./data/GWAS_GIANT-PA" />
<g:render template="./data/GWAS_AGEN" />
<g:render template="./data/GWAS_DCSP2a610" />
<g:render template="./data/GWAS_DCSP2a1M" />

<script id="metaData2" type="x-tmpl-mustache">
    <div>
        <h3>Datasets</h3>
        <table id="datasets" class="table table-condensed" style="margin-left:20px">
            <thead>
            <tr>

                <th>Dataset</th>
                <g:if test="${g.portalTypeString()?.equals('mi')}">
                <th>Samples</th>
                <th>Ancestry</th>
                <th>Data type</th>
                </g:if>
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

<div class="container datasetsHolder">
    <div class="row" style="display: inline-block; width: 100%;">
        <div class="col-md-12">
            <div class="datasets-filter">
                <h3>Filter Dataset Table<small> (Click one to start)</small></h3>
                <div id="datatypeFilterDisplay" class="form-inline"></div>
                <div id="phenotypeFilterLevel1Display" class="form-inline"></div>
                <div id="phenotypeFilterLevel2Display" class="form-inline"></div>
            </div>
            <div  id ="metaDataDisplay" class="form-inline" style="width: 100%"></div>
        </div>
    </div>
</div>

