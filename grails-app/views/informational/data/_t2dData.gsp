
<g:render template="./data/ExAC_r03" />
<g:render template="./data/1kg_phase1" />
<g:render template="./data/ExChip_82k"/>

<g:render template="./data/ExChip_CAMP"/>
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
            access = "Early Access Phase 2";}
        else if(dataTypeName.includes('ForT2D')){
            access = "Unpublished";}
//        else if(dataTypeName.includes('CAMP')){
//            access = "Early Access Phase 2";}
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
    var informationGspFileNames=[];

    var phenotypeGroupUniqueNameMap = {};
    var regexStr = "";


    function renderFilteredData(selectedLevel2Phenotype){
        var sortedStoredJsonArray = [];
        if(typeof selectedLevel2Phenotype !== 'undefined'){
           var filteredjsonArray = $.grep(storedJsonArray, function(element) {
                return $.inArray(element.name, phenotypeDatasetsMap[selectedLevel2Phenotype] ) !== -1;});
            sortedStoredJsonArray = filteredjsonArray.sort(
                    function(x,y){
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
        }
        else{
            sortedStoredJsonArray = storedJsonArray.sort(
                    function(x,y){
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

        }
        _.forEach(sortedStoredJsonArray, function(kl,vl){
            regexStr = kl.name.replace(/_mdv[0-9][0-9]/, "");
            informationGspFileNames.push("#" + regexStr + '_script');

        })
        jsonHolder["parents"] = sortedStoredJsonArray;
        var template = $("#metaData2")[0].innerHTML;
        var dynamic_html = Mustache.to_html(template,jsonHolder);
        $("#metaDataDisplay").empty().append(dynamic_html);

        _.forEach(informationGspFileNames, function (each_Gspfile,val){
            $(each_Gspfile + "_holder").append(Mustache.render($(each_Gspfile)[0].innerHTML));
        })
    }

    function onClickdatatype(selectedtech){
        console.log("i am clicked" + selectedtech);
        var allDatatypes = $("div.datatype-option");
        _.forEach(allDatatypes, function(k,v){
            $(k).css("background-color", "rgb(255, 255, 204)");
            $(k).css("color", "rgb(0, 0, 0)");
            if($(k).text() == selectedtech){
                //console.log("found" + $(k).text());
                $(k).css("background-color", "rgb(255, 153, 68)");
                $(k).css("color", "rgb(255, 255, 255)");
                $('div.phenotype-level2-row').empty();
                displaySelectedTechnology(selectedtech, true);}
            })}
    function onClickPhenotypeGroup(selectedPhenotypegroup){
        // selectedLevel2Phenotype1 = selectedLevel2Phenotype;
        console.log(selectedPhenotypegroup);

        $('div.phenotype-level2-row').empty();
        var allPhenotypeGroups = $("div.phenotype-option");

        _.forEach(allPhenotypeGroups, function(k,v){
            $(k).css("background-color", "rgb(204, 238, 255)");
            $(k).css("color", "rgb(0, 0, 0)");
            if($(k).text() == selectedPhenotypegroup){
                $(k).css("background-color", "rgb(51, 153, 255)");
                $(k).css("color", "rgb(255, 255, 255)");
            }
            phenotypeLevel2holder= {"phenotype": phenotypeGroupUniqueNameMap[selectedPhenotypegroup]};
            var phenotypeFilterLevel2Template = $("#phenotypeFilterLevel2")[0].innerHTML;
            var filter_dynamic_html_level2 = Mustache.to_html(phenotypeFilterLevel2Template,phenotypeLevel2holder);
            $("#phenotypeFilterLevel2Display").empty().append(filter_dynamic_html_level2);

        });
        renderFilteredData();
    }

    function onClickPhenotypelevel2(selectedLevel2Phenotype){
        var allPhenotypes = $("div.phenotype-level2-option");
        _.forEach(allPhenotypes, function(k,v){
            $(k).css("background-color", "rgb(204, 238, 255)");
            $(k).css("color", "rgb(0, 0, 0)");
            if($(k).text() == selectedLevel2Phenotype){
                $(k).css("background-color", "rgb(51, 153, 255)");
                $(k).css("color", "rgb(255, 255, 255)");
                renderFilteredData(selectedLevel2Phenotype);
            }
        })
    }

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
                        b.push(k2.fullName);
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
            $.ajax({
                cache: false,
                type: "get",
                url: "${createLink(controller:'informational',action: 'aboutTheDataAjax')}",
                data: {technology: selectedTech},
                async: true
            }).done(function (data, textStatus, jqXHR) {

                var phenotypeGroupArray = [];
                var map = {};
                var distinctPhenotypeGroups = [];
                var datasetPhenotypesMap = {};
                var datasetArray = [];
                storedJsonArray = [];
                phenotypeDatasetsMap = {};
                var allPhenotypeArrayofArray = [];
                var regexStr = "rrr";
                _.forEach(data.children, function (each_key,val) {

                    datatype.push(each_key.technology);
                    if(selectedTech == "") {
                        regexStr = each_key.name.replace(/_mdv[0-9][0-9]/, "");
                        each_key["access"]= getAccessName(each_key.name);
                        each_key.name = each_key.name.replace(/_mdv[0-9][0-9]/, "");
                        storedJsonArray.push(each_key);
                        //storedJsonArray.push(regexStr);
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

                       //informationGspFileNames.push("#" + regexStr + '_script');
                    }
                    else if (selectedTech == each_key.technologyUntranslated){
                        regexStr = each_key.name.replace(/_mdv[0-9][0-9]/, "");
                        each_key["access"] = getAccessName(each_key.name);
                        each_key.name = each_key.name.replace(/_mdv[0-9][0-9]/, "");
                        storedJsonArray.push(each_key);
                        //storedJsonArray.push(regexStr);
                        datasetPhenotypesMap[each_key.name] = each_key.phenotypes;
                        distinctPhenotypeGroups =  _.chain(each_key.phenotypes).uniqBy('group').map('group').value();
                        _.forEach(distinctPhenotypeGroups, function (k,v){
                            if(!map.hasOwnProperty(k)){
                                phenotypeGroupArray.push(k);
                                map[k] = [1];}})
                        allPhenotypeArrayofArray.push(each_key.phenotypes);
                        phenotypeGroupUniqueNameMap = getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray );
                        //informationGspFileNames.push("#" + regexStr + '_script');
                    }
                    else {
                        console.log("Not found in the selected technologies" + each_key.name);
                    }
                });
                datatypeFilter = addOnlyUniqueElements(datatype);
                datatypeFilterHolder = {
                                         "datatype": datatypeFilter,
                                         "size":100/(datatypeFilter.length +1)
                                       };
                if(doNotRedraw != true){
                    var datatypeFilterTemplate = $("#datatypeFilter")[0].innerHTML;
                    var filter_dynamic_html_d = Mustache.to_html(datatypeFilterTemplate,datatypeFilterHolder);
                    $("#datatypeFilterDisplay").empty().append(filter_dynamic_html_d);
                }

                for(var key in datasetPhenotypesMap){
                    c = []
                        _.forEach(datasetPhenotypesMap[key], function(nk,nv){
                            if(phenotypeDatasetsMap.hasOwnProperty(nk.fullName)){
                                phenotypeDatasetsMap[nk.fullName].push(key);}
                            else{
                                phenotypeDatasetsMap[nk.fullName] = [key];}
                        })
                }
                renderFilteredData();

                        var phenotypeGroupArrayholder = { "groups" : phenotypeGroupArray.sort(),
                            "size"  : 100/(phenotypeGroupArray.length +1)};
                        var phenotypeFilterLevel1Template = $("#phenotypeFilter")[0].innerHTML;
                        var filter_dynamic_html = Mustache.to_html(phenotypeFilterLevel1Template,phenotypeGroupArrayholder);
                        $("#phenotypeFilterLevel1Display").empty().append(filter_dynamic_html);


            }).fail(function (jqXHR, textStatus, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);});};
</script>

<script>

</script>

<script id="metaData2" type="x-tmpl-mustache">
    <div class="row" style="padding-top:30px;">
        <h3>Datasets</h3>
        <table id="datasets" class="table table-condensed">
            <thead>
            <tr>
                <th>Dataset</th>
                <th>Access</th>
                <th>Samples</th>
                <th>Ancestry</th>
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
            <td class="access" if({{access}}=="Open access"){style="color:green"} else {style="color:yellow"}>{{access}} </td>
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
    <div class='' style='display:table-row'>
            {{#datatype}}
            <div class='datatype-option'  onclick='onClickdatatype("{{.}}")' style='float: left; text-align: center; background-color:#ffc; padding: 3px 30px; border: solid 1px #fc4; margin: 0 3px 3px 0; border-radius: 3px;'>{{.}}</div>
            {{/datatype}}
            <div class='datatype-option' onclick='onClickdatatype("Show all")' style='float: left; text-align: center; background-color:#f94; padding: 3px 30px; border: solid 1px #fc4; margin: 0 3px 3px 0; border-radius: 3px; color:#fff'>Show all</div>
    </div>
</script>

<script id="phenotypeFilter" type="x-tmpl-mustache">
  <h5>Phenotype</h5>
  <div class='' style='display:table-row'>
    {{#groups}}
    <div class='phenotype-option' onclick='onClickPhenotypeGroup("{{.}}")' style='float: left; text-align: center; background-color:#cef; padding: 3px 30px; border: solid 1px #9cf; margin: 0 3px 3px 0; border-radius: 3px;'>{{.}}</div>
    {{/groups}}
    <div class='phenotype-option' onclick='onClickPhenotypeGroup("Show all")' style='float: left; text-align: center; background-color:#39f; padding: 3px 30px; border: solid 1px #9cf; margin: 0 3px 3px 0; border-radius: 3px;color:#fff' >Show all</div>
  </div>
</script>

<!--this panel would display only when phenotype Filter is clicked -->
<script id="phenotypeFilterLevel2" type="x-tmpl-mustache">
  <div class='' style='display:table-row '>

    <div class="phenotype-level2-row" style='margin-top:10px'>
    {{#phenotype}}
    <div class='phenotype-level2-option' style='width:auto; float: left; text-align: center; background-color:#cef; padding: 3px 30px; border: solid 1px #9cf; margin-right: 3px; margin-bottom: 3px; border-radius: 3px;' onclick='onClickPhenotypelevel2("{{.}}")'>{{.}}</div>
    {{/phenotype}}
    </div>
    </div>
</script>

<div class="row" style="padding-top: 50px; display: inline-block">
    <div>
        <div class="datasets-filter row">
            <h4>Filter Dataset Table<small> (Click one to start)</small></h4>

        <div id="datatypeFilterDisplay" class="form-inline"></div>
        <div id="phenotypeFilterLevel1Display" class="form-inline"></div>
        <div id="phenotypeFilterLevel2Display" class="form-inline"></div>
    </div>
    <div  id ="metaDataDisplay" class="form-inline"></div>
    </div>
</div>
