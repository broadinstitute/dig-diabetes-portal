
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
<g:render template="./data/WGS_GoT2D_mdv2" />
<g:render template="./data/WGS_GoT2Dimputed_mdv2"/>
<g:render template="./data/WGS_WgnomAD_mdv2" />


<style type="text/css" class="init">

    div.datasets-filter {

    width:100%;
    }
		.datasets-filter table {
			width:100%;
		}

		.datasets-filter td {
            cursor: pointer;
			text-align: center;
			background-color:#eee;
			padding: 3px 0;
			border: solid 1px #fff;
		}

.phenotypetip {
    position: relative;
    width: 100%;
    display: inline-block;
}

.phenotypetip .phenotypetiptext {
    visibility: hidden;
    width: 200px;
    background-color: #555;
    color: #fff;
    font-size: 12px;
    text-align: center;
    border-radius: 6px;
    padding: 5px 5px;
    position: absolute;
    z-index: 1;
    bottom: 125%;
    left: 50%;
    margin-left: -60px;
    opacity: 0;
    transition: opacity 1s;
}

.phenotypetip .phenotypetiptext::after {
    content: "";
    position: absolute;
    top: 100%;
    left: 50%;
    margin-left: -5px;
    border-width: 5px;
    border-style: solid;
    border-color: #555 transparent transparent transparent;
}

.phenotypetip:hover .phenotypetiptext {
    visibility: visible;
    opacity: 1;
}

.dataset {
    font-weight: bold;
}

.dataset-filter table {
    width:100%;
}

.dataset-filter td {
    text-align: center;
    background-color:#eee;
    padding: 3px 0;
    border: solid 1px #fff;
}

.greyBG {
    background-color: #ccc;
}

.defaultBG {
    background-color: #fff;
    color: #000;
    display:td;
}

.blueBG {
    background-color:#e5f5Ff;
    display:td;
}

.whiteBG {
    background-color: #fff;
    color: #aaa;
    display:none;
}

.overlapBG {
    background-color:#39F;
    color: #fff;
}


.panel-body1 {
    padding: 15px 0 20px 30px !important;

    border: none;
}

.popover{

    min-width: 400px;

}

.popover-title {

    font-size: 14pt;

    font-weight: bold;

    text-align: left;

}

.popover-content {

    font-size: 12pt;

    max-width: 500px;

}

.aboutIconHolder {

    margin: auto;

    text-align: center;

    vertical-align: middle;

    height: 170px;

}



.consortium-spacing {

    padding-top: 25px;

}



p.dataset-name {

    font-size: 25px;

    font-weight: 500;

    margin: 0;

}



.datapage-body {

    font-size: 16px;

}


.dataset-summary {

    display: block;

    position: relative;

    font-size: 18px;

    font-weight: 200;

    float: right;

    color: #36c;

    top: 5px;

}



.data-status-open-access {

    color: #393;

}



.data-status-early-phase1-access {

    color: red;

}



.dataset-info {

    color: #777;

}



.open-info {

    display: block;

    color: #39F !important;

    font-size: 14px;

}

.notice  {

    font-weight: bold;
    line-height: 20px;
    text-decoration: none;
    margin: 0 auto 0 auto;
    color: #588fd3;
    margin: 0;

}

.notice .messageText {
    font-weight: bold;
    font-style: italic;
    color: black;
    margin: 0 auto 0 auto;
    font-size: 20px;
}
.notice  hr {
    width: 100%;
    color: black;
}
    /* only applies to tables for cohort information */
    .cohortDetail th {
        width: 50%;
    }

</style>

<script>
    $(document).ready(function(){
        var filterDatatype = "Show all";
        displaySelectedTechnology(filterDatatype);
    });
</script>

<script>
    function getAccessName(dataTypeName){
        var access;
        if (dataTypeName.includes( "BioMe")){
            access = "Early Access Phase 1";}
        else if(dataTypeName.includes('ForT2D')){
            access = "Unpublished";}
        else if(dataTypeName.includes('CAMP')){
            access = "Early Access Phase 2";}
        else{
            access = "Open access";}
        return access;}
</script>

<script>
    var jsonHolder={};
    var storedJsonArray=[];
    var phenotypeDatasetsMap = {};
    var phenotypeLevel2holder = {};
    var datatype = [];
    var sort_order = "";
    var sortedStoredJsonArray = [];


    function renderFilteredData(selectedLevel2Phenotype){
        if(typeof selectedLevel2Phenotype !== 'undefined'){
           var filteredjsonArray = $.grep(storedJsonArray, function(element) {
                return $.inArray(element.name, phenotypeDatasetsMap[selectedLevel2Phenotype] ) !== -1;});
            jsonHolder["parents"] = filteredjsonArray;
            var templatef = $("#metaData2")[0].innerHTML;
            var dynamic_htmlf = Mustache.to_html(templatef,jsonHolder);
            $("#metaDataDisplay").empty().append(dynamic_htmlf);}
        else{
            //console.log(sort_order + "sort inside render");
            sortedStoredJsonArray = storedJsonArray.sort(
                    function(x,y){
                        //console.log(y);
                        //console.log(x.sortOrder);
                        console.log(y.sortOrder);
                        if(x.sortOrder > y.sortOrder){
                            return 1;
                        }
                        else if(x.sortOrder > y.sortOrder){
                            return -1;
                        }
                        return 0;
                    }
            )
            jsonHolder["parents"] = sortedStoredJsonArray;
            var template = $("#metaData2")[0].innerHTML;
            var dynamic_html = Mustache.to_html(template,jsonHolder);
            $("#metaDataDisplay").empty().append(dynamic_html);
        }
    }

    function onClickPhenotype(selectedLevel2Phenotype){
       // selectedLevel2Phenotype1 = selectedLevel2Phenotype;
        var allPhenotypes = $("td.phenotype-level2-option");
        _.forEach(allPhenotypes, function(k,v){
            $(k).css("background-color", "#eee");
            $(k).css("color", "#000000");
            if($(k).text() == selectedLevel2Phenotype){
                //console.log("found" + $(k).text());
                $(k).css("background-color", "#39f");
                $(k).css("color", "#ffffff");
                renderFilteredData(selectedLevel2Phenotype);}})}

    function onClickdatatype(selectedtech){
        console.log("i am clicked" + selectedtech);

        // selectedLevel2Phenotype1 = selectedLevel2Phenotype;
        var allDatatypes = $("td.datatype-option");
        _.forEach(allDatatypes, function(k,v){
            $(k).css("background-color", "#eee");
            $(k).css("color", "#000000");

            if($(k).text() == selectedtech){
                //console.log("found" + $(k).text());
                $(k).css("background-color", "#39f");
                $(k).css("color", "#ffffff");
                $('tr.phenotype-level2-row').empty();
                displaySelectedTechnology(selectedtech, true);}
            })}

    function addOnlyUniqueElements(arr) {
        var u = {}, a = [];
        for(var i = 0, l = arr.length; i < l; ++i){
            if(!u.hasOwnProperty(arr[i])) {
                a.push(arr[i]);
                u[arr[i]] = 1;}}
        return a;}

    var phenotypeGroupNameMap = {};
    var uniqueNames = [];
    function getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray){
        _.forEach(phenotypeGroupArray,function(k,v){
            var b = [];
            _.forEach(allPhenotypeArrayofArray, function(k1,v1){
                _.forEach(k1, function(k2,v2){
                    if(k==k2.group){
                        b.push(k2.name);
                    }

                    phenotypeGroupNameMap[k] = addOnlyUniqueElements(b);})})})
        return phenotypeGroupNameMap;}


    function displaySelectedTechnology(filterDatatype,doNotRedraw) {
        var selectedTech="";
        if(filterDatatype=="Show all"){selectedTech="";}
        else if(filterDatatype=="Exome sequencing"){selectedTech="ExSeq";}
        else if(filterDatatype=="Whole genome sequencing"){selectedTech="WGS";}
        else if(filterDatatype=="GWAS"){selectedTech="GWAS";}
        else if(filterDatatype=="Exome chip"){selectedTech="ExChip";}
        //console.log(selectedTech + "selectedtech");

            $.ajax({
                cache: false,
                type: "get",
                url: "${createLink(controller:'informational',action: 'aboutTheDataAjax')}",
                data: {technology: selectedTech},
                async: true
            }).done(function (data, textStatus, jqXHR) {
                var informationGspFileNames=[];
                var phenotypeGroupArray = [];
                var map = {};
                var distinctPhenotypeGroups = [];
                var datasetPhenotypesMap = {};
                var datasetArray = [];
                storedJsonArray = [];
                phenotypeDatasetsMap = {};
                var allPhenotypeArrayofArray = [];
                var phenotypeGroupUniqueNameMap = {};
                //var datatypeFilter = [];
                //var datatypeFilterHolder = {};
                var sortOrderNameMap = {};
                _.forEach(data.children, function (each_key,val) {
                    datatype.push(each_key.technology);
                    if(selectedTech == "") {
                        sort_order = each_key.sortOrder;
                        sortOrderNameMap[each_key.name] = sort_order;
                        //console.log(sort_order + " " + each_key.name);

                        each_key["access"]= getAccessName(each_key.name);
                        storedJsonArray.push(each_key);
                        datasetArray.push(each_key.name);
                        datasetPhenotypesMap[each_key.name] = each_key.phenotypes;
                        distinctPhenotypeGroups =  _.chain(each_key.phenotypes).uniqBy('group').map('group').value();
                        _.forEach(distinctPhenotypeGroups, function (k,v){
                            if(!map.hasOwnProperty(k)){
                                phenotypeGroupArray.push(k);
                               // console.log(phenotypeGroupArray);
                                map[k] = k;}})
                        allPhenotypeArrayofArray.push(each_key.phenotypes);
                        phenotypeGroupUniqueNameMap = getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray );
                        informationGspFileNames.push("#" + each_key.name + '_script');}
                    else if (selectedTech == each_key.technologyUntranslated){
                        //console.log(each_key.name + "was found");
                        each_key["access"] = getAccessName(each_key.name);
                        storedJsonArray.push(each_key);
                        datasetPhenotypesMap[each_key.name] = each_key.phenotypes;
                        distinctPhenotypeGroups =  _.chain(each_key.phenotypes).uniqBy('group').map('group').value();
                        _.forEach(distinctPhenotypeGroups, function (k,v){
                            if(!map.hasOwnProperty(k)){
                                phenotypeGroupArray.push(k);
                                map[k] = [1];}})
                        allPhenotypeArrayofArray.push(each_key.phenotypes);
                        phenotypeGroupUniqueNameMap = getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray );
                        informationGspFileNames.push("#" + each_key.name + '_script');}
                    else {
                        console.log("Not found in the selected technologies" + each_key.name);}});

                datatypeFilter = addOnlyUniqueElements(datatype);
                datatypeFilterHolder = {"datatype":datatypeFilter, "size":100/(datatypeFilter.length +1)};
                if(doNotRedraw != true){
                    var datatypeFilterTemplate = $("#datatypeFilter")[0].innerHTML;
                    var filter_dynamic_html_d = Mustache.to_html(datatypeFilterTemplate,datatypeFilterHolder);
                    $("#datatypeFilterDisplay").empty().append(filter_dynamic_html_d);
                }

                for(var key in datasetPhenotypesMap){
                    c = []
                        _.forEach(datasetPhenotypesMap[key], function(nk,nv){
                           // console.log(nk.name + "-->" + key);
                            if(phenotypeDatasetsMap.hasOwnProperty(nk.name)){
                                //console.log("hi");
                                phenotypeDatasetsMap[nk.name].push(key);}
                            else{
                                phenotypeDatasetsMap[nk.name] = [key];}})}

                renderFilteredData();
                if((phenotypeGroupArray.length) == 1 && phenotypeGroupArray[0] == "OTHER"){
                    console.log("other");
                    phenotypeGroupArray[0] = "None";}
                else{
                    var phenotypeGroupArrayholder = { "groups" : phenotypeGroupArray.sort(),
                        "size"  : 100/(phenotypeGroupArray.length +1)};
                    // console.log(phenotypeGroupArrayholder);
                    var phenotypeFilterLevel1Template = $("#phenotypeFilter")[0].innerHTML;
                    var filter_dynamic_html = Mustache.to_html(phenotypeFilterLevel1Template,phenotypeGroupArrayholder);
                    $("#phenotypeFilterLevel1Display").empty().append(filter_dynamic_html);}
                $(".phenotype-option").click(function (event) {
                    var filterPhenotype = $(this).text();
                    if(filterPhenotype == "Show all"){
                        $('tr.phenotype-level2-row').empty();
                        displaySelectedTechnology(filterDatatype);}
                        phenotypeLevel2holder= {"phenotype": phenotypeGroupUniqueNameMap[filterPhenotype]};
                        $(this).parent().find("td").each(function () {
                            $(this).css({"background-color": "#eee", "color": "#000000"});
                        });
                        $(this).css({"background-color": "#39f", "color": "#ffffff"});
                        var phenotypeFilterLevel2Template = $("#phenotypeFilterLevel2")[0].innerHTML;
                        var filter_dynamic_html_level2 = Mustache.to_html(phenotypeFilterLevel2Template,phenotypeLevel2holder);
                        $("#phenotypeFilterLevel2Display").empty().append(filter_dynamic_html_level2);});
                _.forEach(informationGspFileNames, function (each_Gspfile,val){
                    $(each_Gspfile + "_holder").append(Mustache.render($(each_Gspfile)[0].innerHTML));
//                    try{
//                        $(each_Gspfile + "_holder").append(Mustache.render($(each_Gspfile)[0].innerHTML));
//                    }
//                    catch(e if e instanceof TypeError){
//                        console.log(e);
//                    }
                    })
            }).fail(function (jqXHR, textStatus, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);});};
</script>

<script>

</script>

<script id="metaData2" type="x-tmpl-mustache">
    <div class="row" style="padding-top:30px;">
        <h3>Datasets</h3>
        <h4>To view the sub dataset overlaps between the datasets, rollover a  dataset name. To view detailed dataset information, click a dataset  name.</h4>
        <table id="datasets" class="table table-condensed">
            <thead>
            <tr>
                <th>Dataset</th>
                <th>Access</th>
                <th>Samples</th>
                <th>Ethnicity</th>
                <th>Data type</th>
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
                        <div id="{{name}}_myTarget" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <div id="{{name}}_script_holder"></div>
                            </div>
                        </div>
                    </div>
            </td>
            <td class="access">{{access}}</td>
            <td class="samples">{{size}}</td>
            <td class="ethnicity">{{ancestry}}</td>
            <td class="datatype">{{technology}}</td>
        </tr>
        </div>
        {{/parents}}
        </tbody>
    </table>
</div>
</script>

<script id="datatypeFilter" type="x-tmpl-mustache">
    <h5>Data type</h5>
    <table class="datasets-filter" style='width:100%'>
        <tbody>
          <tr>
            {{#datatype}}
            <td class='datatype-option' style='width:{{size}}%' onclick='onClickdatatype("{{.}}")'>{{.}}</td>
            {{/datatype}}
            <td class='datatype-option' onclick='onClickdatatype("Show all")' style='width: 20%; background-color: rgb(51, 153, 255); color: rgb(255, 255, 255);'>Show all</td>
          </tr>
        </tbody>
    </table>
</script>

<script id="phenotypeFilter" type="x-tmpl-mustache">
  <h5>Phenotype</h5>
  <table class="datasets-filter" style='width:100%'>
    <tbody>
    <tr>
    {{#groups}}
    <td class='phenotype-option' style='width:{{size}}%'>{{.}}</td>
    {{/groups}}
    <td class='phenotype-option' style='width:{{size}}%; background-color: rgb(51, 153, 255); color: rgb(255, 255, 255);'>Show all</td>
    </tr>
    </tbody>
    </table>
</script>

<!--this panel would display only when phenotype Filter is clicked -->
<script id="phenotypeFilterLevel2" type="x-tmpl-mustache">
  <table class="datasets-filter" style='width:100%'>
    <tbody>
    <tr class="phenotype-level2-row">
    {{#phenotype}}
    <td class='phenotype-level2-option' style='width:15em' onclick='onClickPhenotype("{{.}}")'>{{.}}</td>
    {{/phenotype}}
    </tr>
    </tbody>
    </table>
</script>

<div class="row" style="padding-top: 50px;">
    <div>
        <div class="datasets-filter row">
            <h4>Filter Dataset Table<small> (Click one to start)</small></h4>
        </div>
        <div id="datatypeFilterDisplay" class="form-inline"></div>
        <div id="phenotypeFilterLevel1Display" class="form-inline"></div>
        <div id="phenotypeFilterLevel1Displayt" class="form-inline"></div>
        <div id="phenotypeFilterLevel2Display" class="form-inline"></div>
    </div>
    <div  id ="metaDataDisplay" class="form-inline"></div>
</div>
