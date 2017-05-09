/**
 * datasetsPage.js has functions to do api call, filter the JSON data and render it as table on datasets page.

 */

var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";

    mpgSoftware.datasetsPage = (function () {


        var storedJsonArray=[];
        var phenotypeDatasetsMap = {};
        var phenotypeLevel2holder = {};
        var datatype = [];
        var informationGspFileNames=[];
        var phenotypeGroupUniqueNameMap = {};
        var regexStr = "";
        var sortedStoredJsonArray = [];
        var datasetPhenotypesMap = {};
        var datasetArray = [];
        var allPhenotypeArrayofArray = [];


        /**
         * Returns access names for special datasets
         */
        var getAccessName = function (dataTypeName){
            var access;
            if (dataTypeName.includes( "BioMe")){
                access = "Early Access Phase 2";}
            else if(dataTypeName.includes('ForT2D')){
                access = "Unpublished";}
            else{
                access = "Open access";}
            return access;
        }

        /**
         * Takes "selected level2 phenotype" as a parameter else renders all of the datasets without filtering.
         */
        var renderFilteredData = function (selectedLevel2Phenotype){
            var jsonHolder={};
            if(typeof selectedLevel2Phenotype !== 'undefined'){
                var filteredjsonArray = $.grep(storedJsonArray, function(element) {
                    return $.inArray(element.name, phenotypeDatasetsMap[selectedLevel2Phenotype] ) !== -1;});
                sortedStoredJsonArray = filteredjsonArray.sort(
                    function(x,y){
                        console.log(y.sortOrder);
                        if(x.sortOrder > y.sortOrder){
                            return 1;
                        }
                        return -1;
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
                        return -1;
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

        /**
         * Expands cohort section inside dataset-description
         */
        function showSection(event) {
            $(event.target.nextElementSibling).toggle();
        }

        /**
         * called on click of datatype filter, it renders datasets for selected datatype.
         */
        var onClickdatatype = function (selectedtech){
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
                    displaySelectedTechnology(selectedtech, true,"/dig-diabetes-portal/informational/aboutTheDataAjax");
                }
            })
        }

        /**
         * called on click of phenotype filter, it renders phenotype level2 filter
         */
        var onClickPhenotypeGroup= function (selectedPhenotypegroup){
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

        /**
         * called on click of phenotype level2 filter, it renders filtered dataset by calling "renderFilteredData" function
         */
        var  onClickPhenotypelevel2 = function (selectedLevel2Phenotype){
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

        /**
         * Helper function to add only unique elements to an array
         */
        function addOnlyUniqueElements(arr) {
            var u = {}, a = [];
            for(var i = 0, l = arr.length; i < l; ++i){
                if(!u.hasOwnProperty(arr[i])) {
                    a.push(arr[i]);
                    u[arr[i]] = 1;}}
            return a;
        }

        /**
         * Helper function to create a map where key is phenotype group and value is an array of level2 phenotype
         */
        function getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray){
            var phenotypeGroupNameMap = {};
            _.forEach(phenotypeGroupArray,function(k,v){
                var b = [];
                _.forEach(allPhenotypeArrayofArray, function(k1,v1){
                    _.forEach(k1, function(k2,v2){
                        if(k==k2.group){
                            b.push(k2.fullName);
                        }
                        phenotypeGroupNameMap[k] = addOnlyUniqueElements(b);})})})
            return phenotypeGroupNameMap;
        }

        /**
         * This function does the AJAX call and does filtering of data based on selected technology
         */
        var displaySelectedTechnology = function (filterDatatype,doNotRedraw, aboutTheDataAjaxURL) {
            var selectedTech="";
            storedJsonArray=[];
            if(filterDatatype=="Show all"){selectedTech="";}
            else if(filterDatatype=="Exome sequencing"){selectedTech="ExSeq";}
            else if(filterDatatype=="Whole genome sequencing"){selectedTech="WGS";}
            else if(filterDatatype=="GWAS"){selectedTech="GWAS";}
            else if(filterDatatype=="Exome chip"){selectedTech="ExChip";}
            $.ajax({
                cache: false,
                type: "get",
                url: aboutTheDataAjaxURL,
                data: {technology: selectedTech},
                async: true
            }).done(function (data, textStatus, jqXHR) {
                datasetPhenotypesMap = {};
                var distinctPhenotypeGroups = [];
                var phenotypeGroupArray = [];
                var map = {};
                phenotypeGroupUniqueNameMap = {};
                allPhenotypeArrayofArray = [];
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
                        phenotypeGroupUniqueNameMap = getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray );
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
                        datasetPhenotypesMap[each_key.name] = each_key.phenotypes;
                        distinctPhenotypeGroups =  _.chain(each_key.phenotypes).uniqBy('group').map('group').value();
                        _.forEach(distinctPhenotypeGroups, function (k,v){
                            if(!map.hasOwnProperty(k)){
                                phenotypeGroupArray.push(k);
                                map[k] = [1];}})
                        allPhenotypeArrayofArray.push(each_key.phenotypes);
                        phenotypeGroupUniqueNameMap = getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray );
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
                    var c = [];
                    _.forEach(datasetPhenotypesMap[key], function(nk,nv){
                        if(phenotypeDatasetsMap.hasOwnProperty(nk.fullName)){
                            phenotypeDatasetsMap[nk.fullName].push(key);}
                        else{
                            phenotypeDatasetsMap[nk.fullName] = [key];}
                    })
                }

                var phenotypeGroupArrayholder = { "groups" : phenotypeGroupArray.sort(),
                    "size"  : 100/(phenotypeGroupArray.length +1)};
                var phenotypeFilterLevel1Template = $("#phenotypeFilter")[0].innerHTML;
                var filter_dynamic_html = Mustache.to_html(phenotypeFilterLevel1Template,phenotypeGroupArrayholder);
                $("#phenotypeFilterLevel1Display").empty().append(filter_dynamic_html);

                renderFilteredData();

                return {
                    storedJsonArray: storedJsonArray,
                    phenotypeDatasetsMap: phenotypeDatasetsMap
                };

            }).fail(function (jqXHR, textStatus, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);});
        };
        //
        return {
            displaySelectedTechnology: displaySelectedTechnology,
            onClickdatatype: onClickdatatype,
            onClickPhenotypeGroup: onClickPhenotypeGroup,
            onClickPhenotypelevel2:onClickPhenotypelevel2
        }
    } ());
})();

