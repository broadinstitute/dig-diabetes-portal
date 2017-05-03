var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";

    mpgSoftware.datasetsPage = (function () {

        function getAccessName(dataTypeName){
            var access;
            if (dataTypeName.includes( "BioMe")){
                access = "Early Access Phase 2";}
            else if(dataTypeName.includes('ForT2D')){
                access = "Unpublished";}
            else{
                access = "Open access";}
            return access;}

        var displaySelectedTechnology = function (filterDatatype,doNotRedraw) {
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
                var storedJsonArray = [];
                var phenotypeDatasetsMap = {};
                var allPhenotypeArrayofArray = [];
                _.forEach(data.children, function (each_key,val) {

                    datatype.push(each_key.technology);
                    if(selectedTech == "") {
                        console.log(each_key.name + " " + each_key.sortOrder);
                        each_key["access"]= getAccessName(each_key.name);
                        each_key["accessColor"] = function(){
                            if(getAccessName(each_key.name) == "Open access"){
                                return "green";
                            }
                            else {
                                return "red";
                            }
                        };
                        each_key.name = each_key.name.replace(/_mdv[0-9][0-9]/, "");
                        storedJsonArray.push(each_key);
                        datasetArray.push(each_key.name);
                        datasetPhenotypesMap[each_key.name] = each_key.phenotypes;
                        distinctPhenotypeGroups =  _.chain(each_key.phenotypes).uniqBy('group').map('group').value();
                        _.forEach(distinctPhenotypeGroups, function (k,v){
                            if(!map.hasOwnProperty(k)){
                                phenotypeGroupArray.push(k);
                                map[k] = k;}
                        })
                        allPhenotypeArrayofArray.push(each_key.phenotypes);
                        var phenotypeGroupUniqueNameMap = getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray );
                    }
                    else if (selectedTech == each_key.technologyUntranslated){
                        each_key["access"] = getAccessName(each_key.name);
                        each_key["accessColor"] = function(){
                            if(getAccessName(each_key.name) == "Open access"){
                                return "green";
                            }
                            else {
                                return "red";
                            }
                        };
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
                        var phenotypeGroupUniqueNameMap = getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray );
                    }
                    else {
                        console.log("Not found in the selected technologies" + each_key.name);
                    }
                });
                var datatypeFilter = addOnlyUniqueElements(datatype);
                var datatypeFilterHolder = {
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
                core.errorReporter(jqXHR, exception);});
        };

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

        function showSection(event) {
            $(event.target.nextElementSibling).toggle();
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

    })


})