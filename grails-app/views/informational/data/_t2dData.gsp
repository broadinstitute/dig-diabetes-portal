<g:render template="./data/WGS_GoT2D_mdv2" />
<g:render template="./data/ExAC_r03_mdv2" />
<g:render template="./data/1kg_phase1_mdv2" />
<g:render template="./data/ExChip_82k_mdv2"/>
<g:render template="./data/ExChip_CAMP_mdv2"/>
<g:render template="./data/ExChip_SIGMA1_mdv2"/>
<g:render template="./data/ExChip_T2DGO_mdv2"/>
<g:render template="./data/ExSeq_13k_mdv2"/>
<g:render template="./data/ExSeq_17k_mdv2"/>
<g:render template="./data/ExSeq_19k_mdv2"/>
<g:render template="./data/ExSeq_EgnomAD_mdv2"/>
<g:render template="./data/ExSeq_EOMI_mdv2"/>
<g:render template="./data/GWAS_70kForT2D_mdv2"/>
<g:render template="./data/GWAS_BioMe_mdv2"/>
<g:render template="./data/GWAS_CADISP_mdv2"/>
<g:render template="./data/GWAS_CARDIoGRAM_mdv2"/>
<g:render template="./data/GWAS_CKDGenConsortium-eGFRcrea_mdv2"/>
<g:render template="./data/GWAS_CKDGenConsortium-UACR_mdv2"/>
<g:render template="./data/GWAS_CKDGenConsortium_mdv2"/>
<g:render template="./data/GWAS_DIAGRAM_mdv2"/>
<g:render template="./data/GWAS_GENESIS_eu_mdv2"/>
<g:render template="./data/GWAS_GERFHS_mdv2"/>
<g:render template="./data/GWAS_GIANT_mdv2"/>
<g:render template="./data/GWAS_GLGC_mdv2"/>
<g:render template="./data/GWAS_MAGIC_mdv2"/>
<g:render template="./data/GWAS_MEGASTROKE_mdv2"/>
<g:render template="./data/GWAS_MICAD_mdv2"/>
<g:render template="./data/GWAS_OxBB_mdv2"/>
<g:render template="./data/GWAS_PGC_mdv2"/>
<g:render template="./data/GWAS_SIGMA1_mdv2"/>
<g:render template="./data/GWAS_SIGN_mdv2"/>
<g:render template="./data/GWAS_Stroke_mdv2"/>
<g:render template="./data/GWAS_VATGen_mdv2"/>


<style>
    /* only applies to tables for cohort information */
    .cohortDetail th {
        width: 50%;
    }
</style>

<script>
    $(document).ready(function() {
        var data = {
            dataType: "Data type:",
        };
        var template = $("#selectDataType")[0].innerHTML;
        var dynamic_html = Mustache.to_html(template,data);
        $("#DataTypeList").append(dynamic_html);
    })
</script>

<script>
    function displaySelectedTechnology() {
        var selectedTech = $("#technologyTypeSelector").val();
            $.ajax({
                cache: false,
                type: "get",
                url: "${createLink(controller:'informational',action: 'aboutTheDataAjax')}",
                data: {technology: selectedTech},
                async: true
            }).done(function (data, textStatus, jqXHR) {
                var jsonArray = [];
                var informationGspFileNames=[];
                _.forEach(data.children, function (each_key,val) {
                    console.log(selectedTech);
                    if(selectedTech == "") {
                        jsonArray.push(each_key);
                        console.log("Show All clicked/default list");
                        //informationGspFileName = "";
                    }
                    else if (each_key.name.includes(selectedTech)) {
                        jsonArray.push(each_key);
                        console.log("this tech was selected" + selectedTech)
                        console.log(jsonArray);
                        informationGspFileNames.push("#" + each_key.name + '_script');
                        //console.log(each_key.children);
                    }
                    else {
                        console.log("I didn't find any");
                    }
                });
                var holder = {};
                holder["parents"] = jsonArray;
                var template = $("#metaData")[0].innerHTML;
                var dynamic_html = Mustache.to_html(template,holder);
                $("#metaDataDisplay").empty().append(dynamic_html);
                console.log(informationGspFileNames);
                _.forEach(informationGspFileNames, function (each_Gspfile,val){
                    console.log(each_Gspfile);
                    $('#insertScript').append(Mustache.render($(each_Gspfile)[0].innerHTML));
                })
            }).fail(function (jqXHR, textStatus, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);
            });
        };

</script>
<script id="selectDataType" type="x-tmpl-mustache">
    <div class="form-inline">
        <label>Data Type</label>
        <select id="technologyTypeSelector" class="form-control" onchange="displaySelectedTechnology()">
            <option value="" selected="selected" >Show all</option>
            <option value="ExSeq">Exome Sequencing</option>
            <option value="WGS">Whole genome Sequencing</option>
            <option value="GWAS">GWAS</option>
            <option value="ExChip">Exome chip</option>
            <option value="1kg">1000 Genome</option>
            <option value="ExAC">ExAC</option>
        </select>
    </div>
</script>

<script>
    $(document).ready(function(){
        displaySelectedTechnology();
    });
</script>

<script id="metaData" type="x-tmpl-mustache">
    <table>
    <tbody>
    {{#parents}}
    <td>{{ancestry}}</td>
    <td>{{descr}}</td>
    <td>{{label}}</td>
    <td>{{name}}</td>
    {{/parents}}
    <div class="accordion" id="accordionTest">
         <div class="accordion-group">
             <div class="accordion-heading">
                 <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionTest"
                    href="#collapseDataDescription" aria-expanded="true">
                    <h4>Description</h4>
                 </a>
              </div>
             <div id="collapseDataDescription" class="accordion-body collapse">
                 <div class="accordion-inner">
                     <div id="insertScript"></div>
                 </div>
             </div>
         </div>
     </div>
    </div>
    </tbody>
    </table>
</script>

<div class="row" style="padding-top: 50px;">
    <div  id ="DataTypeList" class="form-inline"></div>
    <div  id ="metaDataDisplay" class="form-inline"></div>



</div>


