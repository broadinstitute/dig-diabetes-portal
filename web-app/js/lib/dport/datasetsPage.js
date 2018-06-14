/**
 * datasetsPage.js has functions to do api call, filter the JSON data and render it as table on datasets page.
 */

var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";

    mpgSoftware.datasetsPage = (function () {

        var storedJsonArray=[];
        var phenotypeDatasetsMap = {};
        var phenotypeGroupUniqueNameMap = {};

        /**
         * Returns access names for special datasets
         */
        var getAccessName = function (dataTypeName){
            var access;
            if (dataTypeName.includes('FUSION')){
                access = "Early access phase 1";}
            else if (dataTypeName.includes('DCSP2')){
                access = "Early access phase 1";}
            else{
                access = "Open access";}
            return access;
        }

        /**
         * Takes "selected level2 phenotype" as a parameter else renders all of the datasets without filtering.
         */
        var renderFilteredData = function (selectedLevel2Phenotype,isPhenlevel2){
            var jsonHolder={};
            var informationGspFileNames=[];
            var regexStr = "";
            var sortedStoredJsonArray = [];
            var datasetArray = [];
            var PhenotypeGroupToDatasetsMap = {};
            if(typeof selectedLevel2Phenotype !== 'undefined' && isPhenlevel2){
                var filteredjsonArray = $.grep(storedJsonArray, function(element) {
                    return $.inArray(element.name, phenotypeDatasetsMap[selectedLevel2Phenotype] ) !== -1;});
                sortedStoredJsonArray = filteredjsonArray.sort(
                    function(x,y){
                        if(x.sortOrder > y.sortOrder){
                            return 1;
                        }
                        return -1;
                    }
                )
            }
            else if((typeof selectedLevel2Phenotype !== 'undefined' && selectedLevel2Phenotype !== 'Show all' && isPhenlevel2 == false)){
                _.forEach(storedJsonArray, function(k,v){
                    _.forEach(k.phenotypes, function(kl,vl){
                        if(kl.group == selectedLevel2Phenotype){
                            sortedStoredJsonArray.push(k);
                        }
                    })
                })

            }
            else{

                sortedStoredJsonArray = storedJsonArray.sort(
                    function(x,y){
                        if(x.sortOrder > y.sortOrder){
                            return 1;
                        }
                        return -1;
                    }
                )
            }
            sortedStoredJsonArray = _.uniq(sortedStoredJsonArray, 'name');


            _.forEach(sortedStoredJsonArray, function(kl,vl){
               // regexStr = kl.name.replace(/_mdv[0-9][0-9][0-9]/, "");
                informationGspFileNames.push("#" + kl.name + '_script');
            })

            jsonHolder["parents"] = sortedStoredJsonArray;
            var template = $("#metaData2")[0].innerHTML;
            var dynamicHtml = Mustache.to_html(template,jsonHolder);
            $("#metaDataDisplay").empty().append(dynamicHtml);

            _.forEach(informationGspFileNames, function (eachGspFile,val){
                $(eachGspFile + "_holder").append(Mustache.render($(eachGspFile)[0].innerHTML));
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
        var onClickdatatype = function (selectedtech,displaySelectedTechnologyURL){
            var allDatatypes = $("div.datatype-option");
            _.forEach(allDatatypes, function(k,v){
                $(k).css("background-color", "rgb(255, 255, 204)");
                $(k).css("color", "rgb(0, 0, 0)");
                if($(k).text() == selectedtech){
                    //$(k).css("background-color", "rgb(255, 153, 68)");
                    $(k).css("background-color", "rgb(246, 137, 32)");
                    $(k).css("color", "rgb(255, 255, 255)");
                    $('div.phenotype-level2-row').empty();
                    displaySelectedTechnology(selectedtech, true,displaySelectedTechnologyURL);
                }
            })
        }

        /**
         * called on click of phenotype filter, it renders phenotype level2 filter
         */
        var onClickPhenotypeGroup= function (selectedPhenotypegroup){
            var phenotypeLevel2holder = {};
            $('div.phenotype-level2-row').empty();
            var allPhenotypeGroups = $("div.phenotype-option");

            _.forEach(allPhenotypeGroups, function(k,v){
                $(k).css("background-color", "rgb(204, 238, 255)");
                $(k).css("color", "rgb(0, 0, 0)");
                if($(k).text() == selectedPhenotypegroup){
                    //$(k).css("background-color", "rgb(51, 153, 255)");
                    $(k).css("background-color", "rgb(52, 135, 175)");
                    $(k).css("color", "rgb(255, 255, 255)");
                }
                phenotypeLevel2holder= {"phenotype": phenotypeGroupUniqueNameMap[selectedPhenotypegroup]};
                var phenotypeFilterLevel2Template = $("#phenotypeFilterLevel2")[0].innerHTML;
                var filterDynamicHtmlLevel2 = Mustache.to_html(phenotypeFilterLevel2Template,phenotypeLevel2holder);
                $("#phenotypeFilterLevel2Display").empty().append(filterDynamicHtmlLevel2);

            });
            renderFilteredData(selectedPhenotypegroup,false);
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
                    //$(k).css("background-color", "rgb(51, 153, 255)");
                    $(k).css("background-color", "rgb(52, 135, 175)");
                    $(k).css("color", "rgb(255, 255, 255)");
                    renderFilteredData(selectedLevel2Phenotype,true);
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
                        phenotypeGroupNameMap[k] = addOnlyUniqueElements(b);
                    })
                })
            })
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
                var datasetPhenotypesMap = {};
                var distinctPhenotypeGroups = [];
                var phenotypeGroupArray = [];
                var map = {};
                var datatype = [];
                phenotypeGroupUniqueNameMap = {};
                var allPhenotypeArrayofArray = [];
                var datasetPhenotypesMap2 = {};
                _.forEach(data.children, function (eachKey,val) {
                    datatype.push(eachKey.technology);
                    if(selectedTech == "") {
                        eachKey["access"]= getAccessName(eachKey.name);
                        eachKey["accessColor"] = function(){
                            if(getAccessName(eachKey.name) == "Open access"){
                                return "green";
                            }
                            else {
                                return "red";
                            }
                        };
                        //check if its more than mdv99 then do
                        // eachKey.name = eachKey.name.replace(/_mdv[0-9][0-9][0-9]/, "");
                        //else  eachKey.name = eachKey.name.replace(/_mdv[0-9][0-9]/, "");


                        eachKey.name = eachKey.name.split("_mdv")[0]


                        storedJsonArray.push(eachKey);
                        datasetPhenotypesMap[eachKey.name] = eachKey.phenotypes;
                        distinctPhenotypeGroups =  _.chain(eachKey.phenotypes).uniqBy('group').map('group').value();
                        _.forEach(distinctPhenotypeGroups, function (k,v){
                            if(!map.hasOwnProperty(k)){
                                phenotypeGroupArray.push(k);
                                map[k] = k;}
                        })
                        allPhenotypeArrayofArray.push(eachKey.phenotypes);
                        phenotypeGroupUniqueNameMap = getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray );
                    }
                    else if (selectedTech == eachKey.technologyUntranslated){
                        eachKey["access"] = getAccessName(eachKey.name);
                        eachKey["accessColor"] = function(){
                            if(getAccessName(eachKey.name) == "Open access"){
                                return "green";
                            }
                            else {
                                return "red";
                            }
                        };


                        eachKey.name = eachKey.name.split("_mdv")[0]

                        storedJsonArray.push(eachKey);
                        datasetPhenotypesMap[eachKey.name] = eachKey.phenotypes;
                        distinctPhenotypeGroups =  _.chain(eachKey.phenotypes).uniqBy('group').map('group').value();
                        _.forEach(distinctPhenotypeGroups, function (k,v){
                            if(!map.hasOwnProperty(k)){
                                phenotypeGroupArray.push(k);
                                map[k] = [1];}})
                        allPhenotypeArrayofArray.push(eachKey.phenotypes);
                        phenotypeGroupUniqueNameMap = getPhenotypeGroupNameMap(allPhenotypeArrayofArray,phenotypeGroupArray);
                    }
                });
                //console.log(datasetPhenotypesMap2);
                var datatypeFilter = addOnlyUniqueElements(datatype);
                var datatypeFilterHolder = {
                    "datatype": datatypeFilter,
                    "size":100/(datatypeFilter.length +1)
                };
                if(doNotRedraw != true){
                    var datatypeFilterTemplate = $("#datatypeFilter")[0].innerHTML;
                    var filterDynamicHtmlD = Mustache.to_html(datatypeFilterTemplate,datatypeFilterHolder);
                    $("#datatypeFilterDisplay").empty().append(filterDynamicHtmlD);
                }

                _.forOwn(datasetPhenotypesMap, function(value, key){
                    _.forEach(datasetPhenotypesMap[key], function(nk,nv){
                        if(phenotypeDatasetsMap.hasOwnProperty(nk.fullName)){
                            phenotypeDatasetsMap[nk.fullName].push(key);}
                        else{
                            phenotypeDatasetsMap[nk.fullName] = [key];}
                    })
                })
                var phenotypeGroupArrayholder = { "groups" : phenotypeGroupArray.sort()};
                var phenotypeFilterLevel1Template = $("#phenotypeFilter")[0].innerHTML;
                var filterDynamicHtml = Mustache.to_html(phenotypeFilterLevel1Template,phenotypeGroupArrayholder);
                $("#phenotypeFilterLevel1Display").empty().append(filterDynamicHtml);
                renderFilteredData();
                return {
                    storedJsonArray: storedJsonArray,
                    phenotypeDatasetsMap: phenotypeDatasetsMap
                };
            }).fail(function (jqXHR, textStatus, exception) {
                loading.hide();
                core.errorReporter(jqXHR, exception);});
        };
        return {
            displaySelectedTechnology: displaySelectedTechnology,
            onClickdatatype: onClickdatatype,
            onClickPhenotypeGroup: onClickPhenotypeGroup,
            onClickPhenotypelevel2:onClickPhenotypelevel2
        }
    } ());
})();
