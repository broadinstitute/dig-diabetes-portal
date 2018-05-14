var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.traitSample = (function () {


        var unique = function (list) {
            var result = [];
            $.each(list, function(i, e) {
                if ($.inArray(e, result) == -1) result.push(e);
            });
            return result;
        }



        var showRelatedWords = function () {
            var relatedWords = "";
            $(".targeted-trait-row").each(function() {

                var phenotypeAndGroup = $(this).attr("phenotype").replace(","," ");

                relatedWords += phenotypeAndGroup + " ";
            });

            relatedWords = relatedWords.split(" ").sort();

            var appearedWords = [];

            for(var x=1; x < relatedWords.length; x++){
                (relatedWords[x] != relatedWords[x-1])? appearedWords.push(relatedWords[x]):"";
            }

            var wordsByWeight = [];

            $.each(appearedWords, function(index, value) {

                var coutAppearance = 0;

                for(var x=0; x < relatedWords.length; x++){
                    (relatedWords[x] == value)? coutAppearance ++ :"";
                }

                wordsByWeight.push({"word":value,"appearance":coutAppearance});

            });

            wordsByWeight.sort( function(a,b){ return b.appearance - a.appearance } );


            var returnText = "";

            var searchWords = $("#traits_table_filter").val().toLowerCase().split(",");

            for (var x = 0; x < wordsByWeight.length; x++) {

                var comparingWord = wordsByWeight[x].word.toLowerCase();
                var wordMatch = "";

                $.each(searchWords, function(index,value) {
                    var searchWord = value.trim().toLowerCase();

                    if( searchWord != "" ){
                        if (comparingWord.indexOf(searchWord) >= 0) {
                            wordMatch = "<a class='related-word-red' href='javascript:;' onclick='mpgSoftware.traitSample.addToPhenotypeFilter(event)'>" + wordsByWeight[x].word + "</a>";
                        } else {
                            wordMatch = "<a class='related-word' href='javascript:;' onclick='mpgSoftware.traitSample.addToPhenotypeFilter(event)'>" + wordsByWeight[x].word + "</a>";
                        }
                    }
                });

                returnText += wordMatch;
            }


            return returnText;

        }

        var addToPhenotypeFilter = function (event) {
            var wordToAdd = $(event.target).text();
            var currentVal = $("#traits_table_filter").val().trim();

            var newKeyword = (currentVal[currentVal.length -1] == ",")? true : false;

            currentVal = currentVal.split(",");

            if(currentVal[currentVal.length -1] == "") currentVal.splice(currentVal.length -1,1);


            if(newKeyword) {

                $("#traits_table_filter").val(currentVal + ", " + wordToAdd);

            } else {

                currentVal[currentVal.length -1] = wordToAdd;

                $("#traits_table_filter").val(currentVal+", ");

            }



            mpgSoftware.traitSample.filterTraitsTable();;

        }


        var massageTraitsTable = function () {

            $(".open-glyphicon").hover(function() { $(this).css({"cursor":"pointer"});});

            if (typeof phenotypeDatasetMapping != 'undefined' && phenotypeDatasetMapping) {

                var inputBox = "";

                inputBox += '<div class="traits-svg-wrapper" style=""></div>';

                inputBox += '<div style="font-size: 12px; text-align: center;">Legend: <span style="color:rgba(31,119,180, 1); margin-right: 5px;">&#9679 ANTHROPOMETRIC</span> <span style="color:rgba(255, 127, 14, 1); margin-right: 5px;">&#9679 BLOOD PRESSURE</span> <span style="color:rgba(44, 160, 44, 1); margin-right: 5px;">&#9679 CORONARY ARTERY DISEASE</span> <span style="color:rgba(214, 39, 40, 1); margin-right: 5px;">&#9679 GLYCEMIC</span> <span style="color:rgba(148, 103, 189, 1); margin-right: 5px;">&#9679 LIPIDS</span> <span style="color:rgba(140, 86, 75, 1); margin-right: 5px;">&#9679 PSYCHIATRIC</span> <span style="color:rgba(227, 119, 194, 1); margin-right: 5px;">&#9679 RENAL</span></div>';

                $(inputBox).appendTo($("#dkPhePlot"));

            }


            $("#traitsPerVariantTable_wrapper").find(".dt-buttons").css({"width":"100%","margin-bottom":"15px"}).insertAfter($("#traitsPerVariantTable"));

            // traits table filter ui

            mpgSoftware.traitSample.addPlotFilter();


            //$(suggestedToFilter).insertBefore($("div.gwas-table-container"));

            var suggestedToSort = "<span style='font-size: 12px; margin: 15px 0 10px 0; display: block;'>To sort the table by multi columns, hold shift key and click the head of the secondary column.</span>";

            $(suggestedToSort).insertBefore($("#traitsPerVariantTable"));

            $("#traitsPerVariantTable").find("thead").find("tr").each(function() {
                $(this).find("th").eq("1").insertBefore($(this).find("th").eq("0"));

                if (typeof phenotypeDatasetMapping != 'undefined' && phenotypeDatasetMapping) $("<th>sample</th>").appendTo($(this));
            });

            $("#traits_table_filter").on('input',mpgSoftware.traitSample.filterTraitsTable);
            $("#pvalue-min").on('input',mpgSoftware.traitSample.filterTraitsTable);
            $("#pvalue-max").on('input',mpgSoftware.traitSample.filterTraitsTable);
            $("#sample-min").on('input',mpgSoftware.traitSample.filterTraitsTable);
            $("#sample-max").on('input',mpgSoftware.traitSample.filterTraitsTable);
            $("#phePlotGroups").on('input',function() {

                if( $("#traits_table_filter").val() == "") {

                    $("#traits_table_filter").val($("#phePlotGroups option:selected").val()+", ");

                } else {
                    var currentVal = $("#traits_table_filter").val().trim();

                    $("#phePlotGroups").find("option").each(function() {
                        currentVal = (currentVal.indexOf($(this).attr("value")) >= 0)? currentVal.replace($(this).attr("value"), "") : currentVal;
                    })

                    var addingGroup = (currentVal.charAt(currentVal.length-1) == ",")? " " + $("#phePlotGroups option:selected").val() : ", " + $("#phePlotGroups option:selected").val();

                    $("#traits_table_filter").val(currentVal + addingGroup);
                }

                mpgSoftware.traitSample.filterTraitsTable();
            });



            var phenoTypeID = "";
            var phenotypeGroupList = []



            $("#traitsPerVariantTableBody").find("tr").each(function() {

                var pheName = $(this).find("div.vandaRowHdr").attr("phenotypename");
                var dtsetName = $(this).find("div.vandaRowHdr").attr("datasetname");

                if (typeof phenotypeDatasetMapping != 'undefined' && phenotypeDatasetMapping) {

                    var sampleNum = phenotypeDatasetMapping[pheName][dtsetName].count;
                    var phenotypeGroup = phenotypeDatasetMapping[pheName][dtsetName].phenotypeGroup;

                    phenotypeGroupList.push(phenotypeGroup)

                    $(this).attr("phenotype", $(this).find("td").eq("1").text()+","+phenotypeGroup );

                    $("<td class='sample-size'>"+sampleNum+"</td>").appendTo($(this));

                } else {

                    $(this).attr("phenotype", $(this).find("td").eq("1").text());

                }

                $(this).find("td").eq("1").insertBefore($(this).find("td").eq("0"));

            });

            phenotypeGroupList = mpgSoftware.traitSample.unique(phenotypeGroupList).sort();

            $.each(phenotypeGroupList, function(index, value) {



                $("#phePlotGroups").append('<option value="'+value+'">'+value+'</option>');

            });

            $("#traitsPerVariantTableBody").find("td").mouseenter(function() {
                var phenotypeName = $(this).closest("tr").find("td").eq("0").text();

                $("#traitsPerVariantTableBody").find("tr").each(function() {
                    ($(this).find("td").eq("0").text() == phenotypeName)? $(this).addClass("highlighted-phenotype"):$(this).removeClass("highlighted-phenotype");
                });
            })

            mpgSoftware.traitSample.filterTraitsTable();

        }


        var filterTraitsTable = function () {


            $("#traitsPerVariantTableBody").find("tr").removeClass("hidden-traits-row");


            var searchWords = (typeof phenotypeDatasetMapping != 'undefined' && phenotypeDatasetMapping)? $("#traits_table_filter").val() + "," + $("#phePlotGroups option:selected").val() : $("#traits_table_filter").val();
            searchWords = searchWords.toLowerCase().split(",");


            var phenotypesArray = [];

            $.each(searchWords, function(index,value){

                $("#traitsPerVariantTableBody").find("tr").each(function() {

                    if($(this).hasClass("hidden-traits-row")) {

                    } else {


                        var phenotypeString = $(this).attr("phenotype").toLowerCase();

                        var searchWord = value.trim();



                        if(searchWord.indexOf("=") >= 0) {

                            searchWord = searchWord.substring(1);
                            phenotypeString = phenotypeString.split(",");

                            if(phenotypeString[0] == searchWord) {
                                $(this).removeClass("hidden-traits-row").addClass("targeted-trait-row");
                            } else {
                                $(this).addClass("hidden-traits-row").removeClass("targeted-trait-row");
                            }


                        } else {

                            if(phenotypeString.indexOf(searchWord) >= 0) {
                                $(this).removeClass("hidden-traits-row").addClass("targeted-trait-row");
                            } else {
                                $(this).addClass("hidden-traits-row").removeClass("targeted-trait-row");
                            }

                        }

                    }

                });


            });


            var relatedWords = mpgSoftware.traitSample.showRelatedWords();

            ( $("#traits_table_filter").val() != "" )? $(".related-words").html("").append(relatedWords) : $(".related-words").html("");



            if (showPhePlot == true) {

                mpgSoftware.traitSample.randerTraitSamplePlot();

            } else {
                $("#dkPhePlot").css("display","none");
                $("#pheplot").css("display","none");
                $(".pheplot").closest("li").css("display","none");
            }

        }


        var resetPhePlotAndTable = function(PHENOTYPE) {

            var phenotypeName = PHENOTYPE || "";
            $("#traits_table_filter").val(PHENOTYPE);
            $("#pvalue-min").val("");
            $("#pvalue-max").val("");
            $("#sample-min").val("");
            $("#sample-max").val("");
            $("#phePlotGroups").val("");
            mpgSoftware.traitSample.filterTraitsTable();
        }

        var addPlotFilter = function() {
            var suggestedToFilter = "";

            if(typeof phenotypeDatasetMapping != 'undefined' && phenotypeDatasetMapping) {

                suggestedToFilter += "<div class='phenotype-searchbox-inner-wrapper'><div style='display:inline-block; padding-right: 10px; float: left;'><h5>Filter plot and table by trait (ex: bmi, glycemic; '=phenotype' for exact match)</h5><input id='traits_table_filter' type='text' name='search' style='display: inline-block; width: 200px; height: 35px; padding-left: 10px;' placeholder='' value=''><select id='phePlotGroups' class='minimal' style='margin: 0 0 0 15px;'><option value=''>Trait groups - all</option></select></div>";

                //DK's plot filter ui
                suggestedToFilter += "<div style='display:inline-block; padding: 0 10px; border-left:solid 1px #ddd;'><h5 style='padding-top: 0;'>Filter plot (p-value: -log10, sample number: *1000) </h5><input id='pvalue-min' style='display: inline-block; height: 35px; width: 40px; padding-left: 10px;' value='' /><span style='display: inline-block; padding: 0 5px'> < p-value < </span><input id='pvalue-max' style='display: inline-block; height: 35px; width: 40px; padding-left: 10px;' /><input id='sample-min' value=''  style='display: inline-block; height: 35px; width: 40px; padding-left: 10px; margin-left: 25px;' /><span style='display: inline-block; padding: 0 5px'>< sample < </span><input id='sample-max' style='display: inline-block; height: 35px; width: 40px; padding-left: 10px;' />";

                // reset button
                suggestedToFilter += "<a href='javascript:;' class='btn btn-primary' style='margin-left: 10px;' onclick='mpgSoftware.traitSample.resetPhePlotAndTable()'><span class='glyphicon glyphicon-refresh' aria-hidden='true'></span> reset</a></div></div><div class='related-words' style='clear: left;'>";

            } else {

                suggestedToFilter += "<div class='phenotype-searchbox-inner-wrapper'><div style='display:inline-block; padding-right: 10px; float: left;'><h5>Filter plot and table by trait (ex: bmi, glycemic; '=phenotype' for exact match)</h5><input id='traits_table_filter' type='text' name='search' style='display: inline-block; width: 400px; height: 35px; padding-left: 10px;' placeholder='' value=''>";

                // reset button
                suggestedToFilter += "<a href='javascript:;' class='btn btn-primary' style='display:inline-block; margin-left: 10px;' onclick='mpgSoftware.traitSample.resetPhePlotAndTable()'><span class='glyphicon glyphicon-refresh' aria-hidden='true'></span> reset</a></div></div><div class='related-words' style='clear: left;'></div>";


            }

            $(suggestedToFilter).appendTo($(".phenotype-searchbox-wrapper"));

        }

        var randerTraitSamplePlot = function() {

            ($("#phePlotTooltip").length)? "":d3.select("body").append("div").attr("id","phePlotTooltip").attr("class","hidden").append("span").attr("id","value");
            ($("#phePlotTooltip").find(".pointer").length)? "" : d3.select("#phePlotTooltip").append("div").attr("class","pointer");


            var svg,circles,group,group1,texts,w,h,xunit,yunit,xbumperLeft,xbumperRight,ybumperTop,ybumperBottom,arc;
            var pvalueMin = $("#pvalue-min").val();
            var pvalueMax = ($("#pvalue-max").val() == "")? 1000000 : $("#pvalue-max").val();
            var sampleMin = $("#sample-min").val()*1000;
            var sampleMax = ($("#sample-max").val() == "" || $("#sample-max").val() == 0)? 10000000000000 : $("#sample-max").val()*1000;

            var traitsTableData = [];

            $("#traitsPerVariantTableBody").find("tr").each(function() {

                if($(this).hasClass("hidden-traits-row")) {

                } else {

                    if(getLogValue($(this).find("td").eq(2).text()) < pvalueMax && getLogValue($(this).find("td").eq(2).text()) > pvalueMin && parseFloat(parseFloat($(this).find("td").eq(7).text())) > sampleMin && parseFloat(parseFloat($(this).find("td").eq(7).text())) < sampleMax) {

                        var eachDataset = {};
                        eachDataset.dataset = $(this).attr("dataset");
                        eachDataset.phenotype = $(this).find("td").eq(0).text();
                        eachDataset.logValue = getLogValue($(this).find("td").eq(2).text());
                        eachDataset.pvalue = $(this).find("td").eq(2).text();
                        eachDataset.effectDirection = ($(this).find("td").eq(3).html().indexOf("up") >= 0)? "up":($(this).find("td").eq(3).html().indexOf("down") >= 0)?"down":"";
                        eachDataset.oddsRatio = parseFloat($(this).find("td").eq(4).text());
                        eachDataset.maf = $(this).find("td").eq(5).text();
                        eachDataset.sample = parseFloat(parseFloat($(this).find("td").eq(7).text()));
                        eachDataset.group = $(this).attr("phenotype").split(",")[1];

                        traitsTableData.push(eachDataset);
                    }
                }

            });

            traitsTableData = traitsTableData.sort(function (a, b) {
                return  b.logValue - a.logValue ;
            });

            var datasetArray = [];

            $.each(traitsTableData,function(index) {

                var eachDataset = {};

                eachDataset.dataset = traitsTableData[index].dataset;
                eachDataset.sample = parseFloat(traitsTableData[index].sample);

                datasetArray.push(eachDataset);

            })

            datasetArray.sort(function (a, b) {
                return a.dataset.localeCompare(b.dataset);
            });

            var result = [];

            $.each(datasetArray,function(index, value) {
                if (index == 0) {

                    result.push(value);

                } else {
                    (datasetArray[index-1].dataset != value.dataset)? result.push(value) :"";
                }
            });


            datasetArray = result.sort(function (a, b) {
                return  a.sample - b.sample ;
            });

            var phenotypes = "";

            $.each(traitsTableData, function(index,value){
                phenotypes += value.phenotype + ",";
            });

            var phenotypesArray = phenotypes.split(",");

            phenotypesArray.splice(-1,1);

            phenotypesArray = mpgSoftware.traitSample.unique(phenotypesArray);

            result = [];

            $.each(phenotypesArray, function(index,value) {
                for (var i=0; i < traitsTableData.length; i++) {
                    if (traitsTableData[i].phenotype == value) {

                        //if(traitsTableData[i].logValue >= 8) {
                        result.push(traitsTableData[i]);
                        break;
                        //}

                    }
                }
            })

            phenotypesArray = result;


            w = $("#traitsPerVariantTable").width(), h = 450, xbumperLeft = 50, xbumperRight = 50, ybumperTop = 30, ybumperBottom = 140;


            $(".traits-svg-wrapper").html("");

            $(".traits-svg-wrapper").append('<div class="phenotypes-for-plot" style="margin: 5px 0 5px 0;"></div>');



            //console.log(phenotypesArray);


            var x = d3.scale.linear()
                .domain([sampleMin, d3.max(traitsTableData, function(d) { return d.sample }) * 1.02])
                .range([xbumperLeft, w-xbumperRight]);

            var y = d3.scale.linear()
                .domain([pvalueMin, d3.max(traitsTableData, function(d) { return d.logValue }) * 1.02])
                .range([h-ybumperBottom, ybumperTop]);

            arc = d3.svg.symbol().type('triangle-up').size(60);


            svg = d3.select(".traits-svg-wrapper").append("svg")
                .attr("width", w)
                .attr("height",h)
                .attr("style","border:solid 1px #ddd;")
                .attr("id","pheSvg");


            // Draw p-value significance line

            console.log(pvalueMin);

            if(pvalueMin <= 8) {

                svg.selectAll("line.gws")
                    .data(y.ticks(1))
                    .enter().append("line")
                    .attr("class", "gws")
                    .attr("x1", xbumperLeft)
                    .attr("x2", w-xbumperRight)
                    .attr("y1", y(8))
                    .attr("y2", y(8))
                    .style("stroke", "rgba(0, 102, 51, .5)");

                svg.selectAll("text.gws")
                    .data(y.ticks(1))
                    .enter().append("text")
                    .attr("x", w-xbumperRight)
                    .attr("y", y(8))
                    .text("genome-wide significant: 8")
                    .attr("style","fill:rgba(0, 102, 51, .3); text-anchor: end");

            }

            if(pvalueMin <= 4) {

                svg.selectAll("line.lws")
                    .data(y.ticks(1))
                    .enter().append("line")
                    .attr("class", "lws")
                    .attr("x1", xbumperLeft)
                    .attr("x2", w-xbumperRight)
                    .attr("y1", y(4))
                    .attr("y2", y(4))
                    .style("stroke", "rgba(122, 179, 23, .1)");

                svg.selectAll("text.lws")
                    .data(y.ticks(1))
                    .enter().append("text")
                    .attr("x", w-xbumperRight)
                    .attr("y", y(4))
                    .text("locus-wide significant: 4")
                    .attr("style","fill:rgba(122, 179, 23, .3); text-anchor: end");

            }


            // draw titles on the right column



            svg.append("text")
                .text("*Roll over to highlight studies *Click a triangle to drill down to one trait view *Click 'Reset' button to go back to all traits view")
                .attr("x", 15)
                .attr("y", 15)
                .attr("style","font-size: 11px;");


            // add dataset names
            group = svg.selectAll("g.datasetnames")
                .data(datasetArray)
                .enter()
                .append("g");

            var namesLeftEnd = ((w - xbumperRight)-(datasetArray.length * 25))/2;

            group.append("g")
                .attr("class","dataset-name-group")
                .attr("transform", function(d,i) {
                    var xposition = (i * 25) + namesLeftEnd;
                    var yposition = h-ybumperBottom + 35;
                    return "translate("+xposition+","+yposition+")"
                });

            group.select(".dataset-name-group")
                .append("line")
                .attr("x1", function(d,i){ return x(d.sample) - ((i * 25) + namesLeftEnd) })
                .attr("y1", -10)
                .attr("x2", 0)
                .attr("y2", 0)
                .attr("stroke","rgba(255,150,150,.3)")
                .attr("shape-rendering","auto");

            group.select(".dataset-name-group")
                .append("line")
                .attr("x1", 0)
                .attr("y1", 0)
                .attr("x2", 0)
                .attr("y2", 5)
                .attr("stroke","rgba(255,150,150,.5)")
                .attr("shape-rendering","auto");

            group.select(".dataset-name-group")
                .append("text")
                .attr("x", 3)
                .attr("y", 12)
                .text(function(d){ return d.dataset })
                .attr("transform","rotate(35)")
                .attr("style","text-anchor:start; font-size: 10px !important;")
                .attr("xp", function(d) {
                    return x(d.sample)
                })
                .attr("yp", h-ybumperBottom+25)
                .on("mouseover", function(d) {

                    //Get this bar's x/y values, then augment for the tooltip
                    var svgPosition = $(pheSvg).position();
                    var xPosition = parseFloat(d3.select(this).attr("xp")) + svgPosition.left;
                    var yPosition = parseFloat(d3.select(this).attr("yp")) + svgPosition.top;

                    //Update the tooltip position and value
                    d3.select("#phePlotTooltip")
                        .style("left", xPosition + "px")
                        .style("top", yPosition + "px");

                    var tipValue = d.dataset +"<br>sample: " + d.sample;

                    $("#phePlotTooltip").find("#value").html(tipValue);

                    //Show the tooltip
                    d3.select("#phePlotTooltip").classed("hidden", false);
                })
                .on("mouseout", function() {

                    //Hide the tooltip
                    d3.select("#phePlotTooltip").classed("hidden", true);
                });;

            /// add dataset dots
            group = svg.selectAll("g.datasetdots")
                .data(datasetArray)
                .enter()
                .append("g");


            group.append("g")
                .attr("class","dataset-dot-group")
                .attr("transform", function(d) {
                    var xposition = x(d.sample);
                    var yposition = h-ybumperBottom+25;
                    return "translate("+xposition+","+yposition+")"
                });


            group.select(".dataset-dot-group")
                .append("circle")
                .attr("cx", 0)
                .attr("cy", 0)
                .attr("r", 3)
                .attr("fill","rgba(255,0,0,.3)")
                .attr("stroke","rgba(255,0,0,0)")
                .attr("stroke-width","10")
                .attr("shape-rendering","auto")
                .attr("xp", function(d) {
                    return x(d.sample)
                })
                .attr("yp", h-ybumperBottom+25)
                .on("mouseover", function(d) {

                    //Get this bar's x/y values, then augment for the tooltip
                    var svgPosition = $(pheSvg).position();
                    var xPosition = parseFloat(d3.select(this).attr("xp")) + svgPosition.left;
                    var yPosition = parseFloat(d3.select(this).attr("yp")) + svgPosition.top;

                    //Update the tooltip position and value
                    d3.select("#phePlotTooltip")
                        .style("left", xPosition + "px")
                        .style("top", yPosition + "px");

                    var tipValue = d.dataset +"<br>sample: " + d.sample;

                    $("#phePlotTooltip").find("#value").html(tipValue);

                    //Show the tooltip
                    d3.select("#phePlotTooltip").classed("hidden", false);
                    d3.select(this).attr('stroke','rgba(255,0,0,0.2)');

                })
                .on("mouseout", function() {

                    //Hide the tooltip
                    d3.select("#phePlotTooltip").classed("hidden", true);
                    d3.select(this).attr('stroke','rgba(255,0,0,0.0)');

                });


            /// add phenotype names
            if (phenotypesArray.length == 1) {

                group = svg.selectAll("g.phenotypenames")
                    .data(traitsTableData)
                    .enter()
                    .append("g");

                // console.log(traitsTableData);

            } else {

                group = svg.selectAll("g.phenotypenames")
                    .data(phenotypesArray)
                    .enter()
                    .append("g");

            }


            var phenotypeNameLineH = 17;
            var phenotypeNameNum = 20;
            var phenotypeNameTop = ((h - (phenotypeNameLineH * phenotypeNameNum) - ybumperTop)/2) + 25;

            group.append("g")
                .attr("class","phenotype-name-group")
                .attr("transform", function(d, i) {

                    var namesTopPos = phenotypeNameTop;

                    var xposition = x(d.sample)+10;
                    var yposition = y(d.logValue)-7;

                    return "translate("+xposition+","+yposition+")"
                })
                .attr("style", function(d,i) {
                    var returnStyle = (d.logValue >= 8)? "visibility: visible":"visibility: hidden";

                    return returnStyle;
                });


            group.select(".phenotype-name-group")
                .append("text")
                .attr("y", 10)
                .text(function(d){
                    var returnText = (phenotypesArray.length == 1)? "" : d.phenotype ;
                    return returnText;
                })
                .attr("style","font-size: 11px; text-anchor: start;")
                .attr("fill", function(d) {
                    var dotColor = (d.logValue >= 8)? "rgba(0, 102, 51, 1)" : (d.logValue >= 4)? "rgba(122, 179, 23, 1)" : (d.logValue >= 0.5)? "rgba(172, 230, 0, 1)" : "rgba(200, 200, 200, 1)"
                    dotColor = "rgba(0, 0, 0, 1)"
                    return dotColor ;
                })
                .attr("xp", function(d) {
                    return x(d.sample);
                })
                .attr("yp", function(d) {
                    return y(d.logValue);
                })
                .attr("phenotype", function(d){
                    return d.phenotype;
                });


            // add labels

            svg.append("g").attr("transform", "translate(0,"+(h-ybumperBottom)+")")
                .attr("class","axis")
                .call(d3.svg.axis().orient("bottom").scale(x))
                .append("text")
                .text("Sample >")
                .attr("x",10)
                .attr("y", 50)
                .attr("style","font-size: 9pt !important; font-weight: 400;text-anchor:start");


            svg.append("g").attr("transform", "translate("+xbumperLeft+",0)")
                .attr("class","axis")
                .call(d3.svg.axis().orient("left").scale(y))
                .append("text")
                .text("p-value (-log10)")
                .attr("x",-200)
                .attr("y",-30 )
                .attr("transform","rotate(-90)")
                .attr("style","font-size: 9pt !important; font-weight: 400;text-anchor:start");




            group = svg.selectAll("g.traits")
                .data(traitsTableData)
                .enter()
                .append("g");

            group.append("g")
                .attr("class","triangle-group")
                .attr("transform", function(d) {
                    var xposition = x(d.sample);
                    var yposition = y(d.logValue);
                    return "translate("+xposition+","+yposition+")"});


            group.select(".triangle-group").append('path')
                .attr('d',arc)
                .attr('fill',function(d) {

                    var triangleColor;

                    switch(d.group) {

                        case 'ANTHROPOMETRIC':
                            triangleColor = "rgba(31,119,180, 0.5)";
                            break;

                        case 'BLOOD PRESSURE':
                            triangleColor = "rgba(255, 127, 14, 0.5)";
                            break;

                        case 'CORONARY ARTERY DISEASE':
                            triangleColor = "rgba(44, 160, 44, 0.5)";
                            break;

                        case 'GLYCEMIC':
                            triangleColor = "rgba(214, 39, 40, 0.5)";
                            break;

                        case 'LIPIDS':
                            triangleColor = "rgba(148, 103, 189, 0.5)";
                            break;

                        case 'PSYCHIATRIC':
                            triangleColor = "rgba(140, 86, 75, 0.5)";
                            break;

                        case 'RENAL':
                            triangleColor = "rgba(227, 119, 194, 0.5)";
                            break;

                        default:
                            triangleColor = "rgba(0,0,0,0.2)";

                    }

                    return triangleColor;
                })
                .attr('stroke','rgba(255,0,0,0.0)')
                .attr('stroke-width','10')
                .attr('stroke-linejoin','round')
                .attr('transform',function(d){

                    var angle = (d.effectDirection == "up")? 0 : (d.effectDirection == "down")? 180: 90;

                    return 'rotate('+angle+')';
                })
                .attr("shape-rendering","auto")
                .attr("phenotype-name",function(d) { return d.phenotype})
                .attr("class","phenotype-triangle")
                .attr("xp", function(d) {
                    return x(d.sample)
                })
                .attr("yp", function(d) {
                    return y(d.logValue)
                })
                .on("mouseover", function(d) {

                    d3.select(this).attr('stroke','rgba(255,0,0,0.3)');

                    //Get this bar's x/y values, then augment for the tooltip
                    var svgPosition = $(pheSvg).position();
                    var xPosition = parseFloat(d3.select(this).attr("xp")) + svgPosition.left;
                    var yPosition = parseFloat(d3.select(this).attr("yp")) + svgPosition.top;

                    //Update the tooltip position and value
                    d3.select("#phePlotTooltip")
                        .style("left", xPosition + "px")
                        .style("top", yPosition + "px");

                    var tipValue = d.phenotype +"<br>"+ d.dataset +"<br>p-value: " + d.pvalue +"<br>samples: "+ d.sample+"<br>odds ratio: "+ d.oddsRatio+"<br>MAF: "+ d.maf;

                    $("#phePlotTooltip").find("#value").html(tipValue).css("font-size: 10px !important");

                    //Show the tooltip
                    d3.select("#phePlotTooltip").classed("hidden", false);

                    if(phenotypesArray.length != 1) { highlightTriangle(d.phenotype); }

                })
                .on("mouseout", function() {

                    d3.select(this).attr('stroke','rgba(255,0,0,0.0)');
                    dimTriangle();
                    //Hide the tooltip
                    d3.select("#phePlotTooltip").classed("hidden", true);


                })
                .on("click", function() {

                    if (phenotypesArray.length != 1) {
                        var phenotypeName = "="+d3.select(this).attr("phenotype-name");

                        mpgSoftware.traitSample.resetPhePlotAndTable(phenotypeName);

                        d3.select("#phePlotTooltip").classed("hidden", true);

                    }

                });

            // add phenotype name to the triangles


            function getLogValue(pValue) {
                var logValue;
                if(pValue != ""){
                    if (pValue.indexOf("e") >= 0) {

                        var pValues = pValue.split("e-");
                        var num1 = pValues[0];
                        var num2 = Math.pow(10, parseFloat(pValues[1]));
                        var num3 = num1/num2;
                        logValue = -Math.log10(num3);

                        //console.log(num1 +" : "+ num2 +" : "+ num3 +" : "+ logValue)
                    } else {
                        logValue = -Math.log10(pValue);
                    }
                } else {
                    logValue = 0;
                }

                return logValue;
            }

            function highlightTriangle(PNAME) {

                $(".phenotype-triangle").each(function() {
                    if ($(this).attr("phenotype-name") == PNAME) $(this).attr("stroke","rgba(255,0,0, .3)");
                })
            }

            function dimTriangle() {

                $(".phenotype-triangle").each(function() {
                    $(this).attr("stroke","rgba(255,0,0, 0)");
                })
            }


        }

        return{
            randerTraitSamplePlot:randerTraitSamplePlot,
            addPlotFilter:addPlotFilter,
            resetPhePlotAndTable:resetPhePlotAndTable,
            filterTraitsTable:filterTraitsTable,
            massageTraitsTable:massageTraitsTable,
            addToPhenotypeFilter:addToPhenotypeFilter,
            showRelatedWords:showRelatedWords,
            unique:unique
        }
    }());
})();
