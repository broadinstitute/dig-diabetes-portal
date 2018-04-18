<!DOCTYPE html>
<%@ page import="org.springframework.web.servlet.support.RequestContextUtils" %>
<%@ page import="temporary.BuildInfo" %>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
<html>
    <head>
        <g:if test="${g.portalTypeString()?.equals('stroke')}">
            <title><g:message code="portal.stroke.header.title.short"/> <g:message code="portal.stroke.header.title.genetics"/></title>
        </g:if>
        <g:elseif test="${g.portalTypeString()?.equals('mi')}">
            <title><g:message code="portal.mi.header.title.short"/> <g:message code="portal.mi.header.title.genetics"/></title>
        </g:elseif>
        <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
            <title><g:message code="portal.ibd.header.title"/></title>
        </g:elseif>
        <g:elseif test="${g.portalTypeString()?.equals('epilepsy')}">
            <title><g:message code="portal.epilepsy.header.title"/> <g:message code="portal.mi.header.title.genetics"/></title>
        </g:elseif>
        <g:else>
            <title><g:message code="portal.header.title.short"/> <g:message code="portal.header.title.genetics"/></title>
        </g:else>

        <r:require modules="core"/>
        <r:layoutResources/>

        <link href="https://fonts.googleapis.com/css?family=Lato|Oswald" rel="stylesheet">


        <g:layoutHead/>



        <g:if test="${g.portalTypeString()?.equals('stroke')}">
            <g:renderT2dGenesSection>
                <g:applyLayout name="analyticsStrokePortal"/>
            </g:renderT2dGenesSection>
        </g:if>
        <g:if test="${g.portalTypeString()?.equals('mi')}">
            <g:renderT2dGenesSection>
                <g:applyLayout name="analyticsMiPortal"/>
            </g:renderT2dGenesSection>
        </g:if>

        <g:else>
            <g:renderT2dGenesSection>
                <g:applyLayout name="analyticsT2dGenes"/>
            </g:renderT2dGenesSection>
        </g:else>

        <style>

    <g:if test="${g.portalTypeString()?.equals('stroke')}">
                a {color:#5cbc6d;}
                a:hover, a:active {color:#43957e; text-decoration: none;}
                .dk-t2d-yellow {  background-color: #d5cc29;  }
                .dk-t2d-orange {  background-color: #F68920;  }
                .dk-t2d-green {  background-color: #71CD73;  }
                .dk-t2d-blue {  background-color: #62B4C5;  }
                .dk-blue-bordered {
                    display:block;
                    border-top: solid 1px #5cbc6d;
                    border-bottom: solid 1px #5cbc6d;
                    color: #5cbc6d;
                    padding: 5px 0;
                    text-align:left;
                    line-height:26px;
                }

                a.front-search-example {
                    color:#cce6c3;
                }

            </g:if>
            <g:elseif test="${g.portalTypeString()?.equals('mi')}">
                a {color:#de8800;}
                a:hover, a:active {color:#ad6700; text-decoration: none;}
                .dk-t2d-green {  background-color: #e6af00;  }
                .dk-t2d-orange {  background-color: #F68920;  }
                .dk-t2d-blue {  background-color: #7ece93;  }
                .dk-t2d-yellow {  background-color: #62B4C5;  }
                .dk-blue-bordered {
                    display:block;
                    border-top: solid 1px #de8800;
                    border-bottom: solid 1px #de8800;
                    color: #de8800;
                    padding: 5px 0;
                    text-align:left;
                    line-height:26px;
                }


            a.front-search-example {
                color:#ffffb3;
            }
            </g:elseif>
            <g:elseif test="${g.portalTypeString()?.equals('ibd')}">
            a {color:#50AABB;}
            a:hover, a:active {color:#2779a7; text-decoration: none;}
            .dk-t2d-yellow {  background-color: #D2BC2C;  }
            .dk-t2d-orange {  background-color: #F68920;  }
            .dk-t2d-green {  background-color: #7fc343;  }
            .dk-t2d-blue {  background-color: #62B4C5;  }
            .dk-blue-bordered {
                display:block;
                border-top: solid 1px #57A7BA;
                border-bottom: solid 1px #57A7BA;
                color: #57A7BA;
                padding: 5px 0;
                text-align:left;
                line-height:26px;
            }

            a.front-search-example {
                color:#cccce6;
            }
            </g:elseif>
            <g:else>
                a {color:#50AABB;}
                a:hover, a:active {color:#2779a7; text-decoration: none;}
                .dk-t2d-yellow {  background-color: #D2BC2C;  }
                .dk-t2d-orange {  background-color: #F68920;  }
                .dk-t2d-green {  background-color: #7fc343;  }
                .dk-t2d-blue {  background-color: #62B4C5;  }
                .dk-blue-bordered {
                    display:block;
                    border-top: solid 1px #57A7BA;
                    border-bottom: solid 1px #57A7BA;
                    color: #57A7BA;
                    padding: 5px 0;
                    text-align:left;
                    line-height:26px;
                }

                a.front-search-example {
                    color:#cce6e6;
                }

            </g:else>


        </style>

        <script>
            $(function () {
                /*DK: find out if the user is viewing the front page*/

                if ($(".dk-user-name").length) {
                    var userName = $(".dk-user-name").find(".user-name-initial").text();
                    $(".dk-user-name").find(".user-name-initial").html(userName.charAt(0).toUpperCase()).attr("title",userName).css({"display":"block","color":"#fffff", "text-shadow":"none", "text-align":"center","font-size":"12px","width":"22px","padding":"2px 0","border-radius":"5px 0 0 5px"});
                }

                /* set the visibility of the user notification blob */
                var warningMessage = "";
                $("#userNotificationDisplay").text(warningMessage).attr("message",warningMessage);
                ($("#userNotificationDisplay").text() == "")? $("#userNotificationDisplay").css("display","none") : $("#userNotificationDisplay").css("display","inline-block");

                /* display notification as the mouse pointer rolls over the notification blob */
                $("#userNotificationDisplay").hover(function(){
                    $(this).append("<div class='user-notification-full' style='position:absolute; right: 15px; top: 35px; padding-top: 10px; width:200px;'><span style='display:block; font-size: 14px; background-color:#fff; box-shadow: 0 2px 3px rgba(0, 0, 0, .5); text-align:left; width: 200px !important; border-radius: 3px; padding: 5px 10px 5px 10px; color:#333;'>"+$(this).attr("message")+"</span></div>");
                }, function() {$( this ).find('.user-notification-full').remove();});

                var pathFullName = location.pathname.toLowerCase();
                var pathName = location.pathname.toLowerCase().split("/");
                var theLastPath = pathName.slice(-1)[0];

                switch(theLastPath){
                    case "":

                        var menuWidth = $(".dk-user-menu").width() + $(".dk-general-menu").width()+50;

                        if ($(".portal-front-banner").length){
                            $(".dk-logo-wrapper").css({"display":"none"});
                            setMenuTriangle(".home-btn");
                            $(".dk-menu-wrapper").css({"width":menuWidth,"margin-top":"0","border-bottom":"solid 1px #ffffff"});
                        } else {
                            $(".dk-menu-wrapper").css({"width":menuWidth,"margin-top":"0","border-bottom":"none"});
                        }
                        break;

                    case "portalhome":
                        $(".dk-logo-wrapper").css({"display":"none"});
                        var menuWidth = $(".dk-user-menu").width() + $(".dk-general-menu").width()+50;
                        $(".dk-menu-wrapper").css({"width":menuWidth,"margin-top":"0","border-bottom":"solid 1px #ffffff"})
                        setMenuTriangle(".home-btn")
                        break;

                    case "variantsearchwf":
                        setMenuTriangle(".variant-search-btn");
                        break;

                    case "data":
                        setMenuTriangle(".data-btn")
                        break;


                    case "about":
                        setMenuTriangle(".about-btn")
                        break;

                    case "policies":
                        setMenuTriangle(".policies-btn")
                        break;

                    case "tutorials":
                        setMenuTriangle(".tutorials-btn")
                        break;

                    case "contact":
                        setMenuTriangle(".contact-btn")
                        break;

                    case "datasubmission":
                        setMenuTriangle(".data-submission-btn")
                        break;

                    case "downloads":
                        setMenuTriangle(".downloads-btn")
                        break;
                }

                menuHeaderSet();
            });

            function setMenuTriangle(SELEVTEDBTN) {$(SELEVTEDBTN).css({"background-image":"url(${resource(dir: 'images', file: 'menu-triangle.svg')})","background-repeat":"no-repeat","background-position":"center bottom","background-size":"18px 9px"})}


            function menuHeaderSet() {
                var menuHeaderWidth = $(".dk-logo-wrapper").width() + $(".dk-general-menu").width() + 50;
                var windowWidth = $(window).width();

                if(menuHeaderWidth > windowWidth) {

                    $(".dk-menu-wrapper").css({"margin-top":"0px"});
                    $(".dk-menu-wrapper").find("ul").css({"float":"left"});
                } else {
                    var pathName = location.pathname.toLowerCase().split("/");
                    var theLastPath = pathName.slice(-1)[0];

                    if(theLastPath != "" && theLastPath != "portalhome") {

                        $(".dk-menu-wrapper").css({"margin-top":"-50px"});
                        $(".dk-menu-wrapper").find("ul").css({"float":"right"});
                    }
                }
            }

            /* LocusZoom UI */
            function massageLZ() {

                if($("#dk_lz_phenotype_list").hasClass("list-allset")) {

                } else {
                    var lzPhenotypes = [];

                    $("#dk_lz_phenotype_list").find("li").each(function() {
                        var lzPhenotype = $(this).text();
                        var lzExist = 0;
                        $.each(lzPhenotypes, function(key, value) {
                            (lzPhenotype == value)? lzExist = 1 : "";
                        });

                        (lzExist == 0)? lzPhenotypes.push(lzPhenotype) : "";
                    });

                    lzPhenotypes.sort(function(s1, s2){
                        var l=s1.toLowerCase(), m=s2.toLowerCase();
                        return l===m?0:l>m?1:-1;
                    });

                    var lzPhenotypeListContent = "<div><label style='display:block; margin-left: 20px;'>Filter phenotypes</label><input id='phenotype_search' type='text' name='search' style='margin: 0 20px 10px 20px; width: 250px;' placeholder='Filter phenotypes (keyword, keyword)'></div>";

                    $.each(lzPhenotypes, function(key, value) {
                        lzPhenotypeListContent += "<li><a href='javascript:;' onclick='setLZDatasets(event);showLZlist(event);'>"+value+"</a></li>";
                    });

                    $("#dk_lz_phenotype_list").html(lzPhenotypeListContent);

                    $(".lz-list").each(function() {
                        if ($(this).find("ul").find("li").length == 0){

                            $(this).css("opacity","0.5");
                            $(this).find("ul").remove();
                        }
                    });

                    $("#phenotype_search").focus(function() {
                        $(this).attr("placeholder", "");
                    });

                    $("#phenotype_search").focusout(function() {
                        $(this).attr("placeholder", "Filter phenotypes (keyword, keyword)");
                    });

                    $("#phenotype_search").on('input',function() {

                        $("#dk_lz_phenotype_list").find("li").removeClass("hidden-phenotype");

                        var searchWords = $("#phenotype_search").val().toLowerCase().split(",");

                        $.each(searchWords, function(index,value){


                            $("#dk_lz_phenotype_list").find("a").each(function() {

                                if($(this).closest("li").hasClass("hidden-phenotype")){

                                } else {

                                    var phenotypeString = $(this).text().toLowerCase();
                                    var searchWord = value.trim();

                                    if(phenotypeString.indexOf(searchWord) >= 0) {
                                        $(this).closest("li").removeClass("hidden-phenotype");
                                    } else {
                                        $(this).closest("li").addClass("hidden-phenotype");
                                    }

                                }
                            })
                        });


                    });

                    $("#dk_lz_phenotype_list").addClass("list-allset")

                }

            }

            function setLZDatasets(event) {

                $(event.target).closest(".col-md-12").find(".selected-phenotype").text("(Phenotype: " + $(event.target).text()+")");

                var phenotypeName = $.trim($(event.target).text());

                $("span.dk-lz-dataset").each(function() {
                    var trimmedPName = $.trim($(this).text());

                    (trimmedPName == phenotypeName)? $(this).closest("li").css("display","block") : $(this).closest("li").css("display","none");
                })
            }

            function showLZlist(event) {

                if($(event.target).closest(".lz-list").find("ul").find("li").length != 0) {
                    ($(event.target).closest(".lz-list").hasClass("open"))? $(event.target).closest(".lz-list").removeClass("open") : $(event.target).closest(".lz-list").addClass("open");
                }
            }

            /* traits table */

            function massageTraitsTable() {

                $(".open-glyphicon").hover(function() { $(this).css({"cursor":"pointer"});});


                var inputBox = "<div class='phenotype-searchbox-wrapper'><input id='traits_table_filter' type='text' name='search' style='display: block; width: 350px; height: 35px; padding-left: 10px;' placeholder='Filter phenotypes (keyword, keyword)'>";
                inputBox += "<div class='related-words'></div></div>";
                inputBox += "<a onclick='readDataset();' href='javascript:;'class='btn btn-default' style='float: right; margin-bottom: 10px;'>Switch view</a>";
                inputBox += '<div class="traits-svg-wrapper" style=""><div class="phenotypes-for-plot"></div></div>';
                inputBox += "<span style='font-size: 12px; margin: 15px 0 -10px 0; display: block;'>To sort the table by multi columns, hold shift key and click the head of the secondary column.</span>";
                //inputBox += '<div id="phePlotTooltip" class="hidden"><span id="value">100</span></div>';

                $("#traitsPerVariantTable_wrapper").find(".dt-buttons").css({"width":"100%","margin-bottom":"15px"}).append(inputBox);

                $("#traitsPerVariantTable").find("thead").find("tr").each(function() {
                    $(this).find("th").eq("1").insertBefore($(this).find("th").eq("0"));
                    $("<th>sample</th>").appendTo($(this));
                });

                $("#traits_table_filter").focus(function() {
                    $(this).attr("placeholder", "");
                });

                $("#traits_table_filter").focusout(function() {
                    $(this).attr("placeholder", "Filter phenotypes (keyword, keyword)");
                });

                $("#traits_table_filter").on('input',filterTraitsTable);

                var phenoTypeID = "";



                $("#traitsPerVariantTableBody").find("tr").each(function() {

                    $(this).find("td").eq("1").insertBefore($(this).find("td").eq("0"));

                    var pheName = $(this).find("div.vandaRowHdr").attr("phenotypename");
                    var dtsetName = $(this).find("div.vandaRowHdr").attr("datasetname");
                    var sampleNum = phenotypeDatasetMapping[pheName][dtsetName]["count"];

                    $("<td class='sample-size'>"+sampleNum+"</td>").appendTo($(this));

                });

                $("#traitsPerVariantTableBody").find("td").mouseenter(function() {
                    var phenotypeName = $(this).closest("tr").find("td").eq("0").text();

                    $("#traitsPerVariantTableBody").find("tr").each(function() {
                        ($(this).find("td").eq("0").text() == phenotypeName)? $(this).addClass("highlighted-phenotype"):$(this).removeClass("highlighted-phenotype");
                    });
                })


                phePlotApp();
            }

            function unique(list) {
                var result = [];
                $.each(list, function(i, e) {
                    if ($.inArray(e, result) == -1) result.push(e);
                });
                return result;
            }

            function filterTraitsTable() {


                $("#traitsPerVariantTableBody").find("tr").removeClass("hidden-traits-row");

                var searchWords = $("#traits_table_filter").val().toLowerCase().split(",");

                var phenotypesArray = [];

                $.each(searchWords, function(index,value){

                    $("#traitsPerVariantTableBody").find("tr").each(function() {

                        if($(this).hasClass("hidden-traits-row")) {

                        } else {

                            var phenotypeString = $(this).find("td").eq("0").text().toLowerCase();
                            var searchWord = value.trim();

                            if(searchWord.indexOf("=") >= 0) {

                                searchWord = searchWord.substring(1);

                                if(phenotypeString == searchWord) {
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


                    var phenotypes = "";

                    $("#traitsPerVariantTableBody").find("tr").each(function() {
                        if($(this).hasClass("hidden-traits-row")) {

                        } else {
                            phenotypes += "," + $(this).attr("phenotype");

                        };
                    });

                    phenotypesArray = phenotypes.split(",");

                    phenotypesArray = unique(phenotypesArray);

                });

                $("#pheSvg").find("svg").each(function() {

                    var svgClass = $(this).attr("class");

                    svgClass += (svgClass.indexOf("hidden-traits-row") >= 0)?  "" : " hidden-traits-row";
                    $(this).attr("class",svgClass);
                });



                ($("#traits_table_filter").val() != "")? $(".phenotypes-for-plot").html("<H5>Click to apply color </H5>") : $(".phenotypes-for-plot").html("");

                var plotColors = ["rgba(255, 0, 0, .75)",
                    "rgba(204, 102, 0, .75)",
                    "rgba(204, 153, 0, .75)",
                    "rgba(153, 204, 0, .75)",
                    "rgba(0, 153, 0, .75)",
                    "rgba(0, 204, 153, .75)",
                    "rgba(0, 153, 255, .75)",
                    "rgba(102, 102, 255, .75)",
                    "rgba(153, 51, 255, .75)",
                    "rgba(255, 0, 255, .75)",
                    "rgba(255, 153, 102, .75)"];

                var plotColorIndex = 0;

                $.each(phenotypesArray, function(index,value) {
                    plotColorIndex = (plotColorIndex == (plotColors.length-1))? 0 : plotColorIndex;

                    if(value != "" && $("#traits_table_filter").val() != "") { $(".phenotypes-for-plot").append("<a href='javascript:;' switch='off' onclick='setColorToPlot(event)' class='btn btn-default btn-xs' color='"+plotColors[plotColorIndex]+"'>"+value+"</a>");};

                    plotColorIndex++;

                    $("#pheSvg").find("svg").each(function() {

                        if($(this).attr("phenotype") == value) {

                            var svgClass = $(this).attr("class").replace(" hidden-traits-row","");
                            $(this).attr("class",svgClass);

                        }

                    });
                });



                var relatedWords = showRelatedWords();

                ( $("#traits_table_filter").val() != "" )? $(".related-words").html("").append(relatedWords) : $(".related-words").html("");

                phePlotApp();
            }

            function setColorToPlot(event) {

                var phenotype = $(event.target).text();
                var switchOnOff = $(event.target).attr("switch");

                var color = (switchOnOff == "off")? $(event.target).attr("color"):"rgba(0,0,0, .3)";

                $("#pheSvg").find("svg").each(function() {

                    if($(this).attr("phenotype") == phenotype) {
                        $(this).find("polygon").attr("style","fill:"+color);
                    }
                })

                if (switchOnOff == "off") {$(event.target).attr("switch","on")} else {$(event.target).attr("switch","off")}


            }

            function showRelatedWords() {
                var relatedWords = "";
                $(".targeted-trait-row").each(function() {
                    relatedWords += $(this).find("td").eq("0").text()+" ";
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

                /*for(var x=0; x < wordsByWeight.length; x++){
                    console.log("word: " + wordsByWeight[x].word + " appearance: " + wordsByWeight[x].appearance);
                }*/

                var returnText = "";

                var searchWords = $("#traits_table_filter").val().toLowerCase().split(",");

                for (var x = 0; x < wordsByWeight.length; x++) {

                    var comparingWord = wordsByWeight[x].word.toLowerCase();
                    var wordMatch = "";

                    $.each(searchWords, function(index,value) {
                        var searchWord = value.trim().toLowerCase();

                        if( searchWord != "" ){
                            if (comparingWord.indexOf(searchWord) >= 0) {
                                wordMatch = "<a class='related-word-red' href='javascript:;' onclick='addToPhenotypeFilter(event)'>" + wordsByWeight[x].word + "</a>";
                            } else {
                                wordMatch = "<a class='related-word' href='javascript:;' onclick='addToPhenotypeFilter(event)'>" + wordsByWeight[x].word + "</a>";
                            }
                        }



                    });

                    returnText += wordMatch;
                }


                return returnText;

            }

            function addToPhenotypeFilter(event) {
                var wordToAdd = $(event.target).text();
                var currnetVal = $("#traits_table_filter").val();

                $("#traits_table_filter").val(currnetVal + ", " + wordToAdd);

                filterTraitsTable();


            }


            function phePlotApp() {

                //inputBox += '<div id="phePlotTooltip" class="hidden"><span id="value">100</span></div>';

                ($("#phePlotTooltip").length)? "":d3.select("body").append("div").attr("id","phePlotTooltip").attr("class","hidden").append("span").attr("id","value");

                var svg,circles,group,group1,texts,w,h,xunit,yunit,xbumperLeft,xbumperRight,ybumperTop,ybumperBottom,arc;

                var traitsTableData = [];

                $("#traitsPerVariantTableBody").find("tr").each(function() {

                    if($(this).hasClass("hidden-traits-row")) {

                    } else {

                        var eachDataset = {};
                        eachDataset.dataset = $(this).attr("dataset");
                        eachDataset.phenotype = $(this).find("td").eq(0).text();
                        eachDataset.logValue = $(this).find("td").eq(2).text();
                        eachDataset.pvalue = $(this).find("td").eq(2).text();
                        eachDataset.effectDirection = effectDirection = ($(this).find("td").eq(3).html().indexOf("up") >= 0)? "up":($(this).find("td").eq(3).html().indexOf("down") >= 0)?"down":"";
                        eachDataset.oddsRatio = $(this).find("td").eq(4).text();
                        eachDataset.maf = $(this).find("td").eq(5).text();
                        eachDataset.sample = $(this).find("td").eq(7).text();

                        traitsTableData.push(eachDataset);

                    }

                });

                $.each(traitsTableData,function(index) {

                    traitsTableData[index].logValue = getLogValue(traitsTableData[index].pvalue);
                    traitsTableData[index].sample = parseFloat(traitsTableData[index].sample);
                    traitsTableData[index].oddsRatio = parseFloat(traitsTableData[index].oddsRatio);
                    traitsTableData[index].maf = parseFloat(traitsTableData[index].maf);

                })

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

                datasetArray = result;


                //console.log(datasetArray);

                w = $("#traitsPerVariantTable").width(), h = 500, xbumperLeft = 80, xbumperRight = 80, ybumperTop = 20, ybumperBottom = 150;


                var x = d3.scale.linear()
                    .domain([0, d3.max(traitsTableData, function(d) { return d.sample })])
                    .range([xbumperLeft, w-xbumperRight]);

                var y = d3.scale.linear()
                    .domain([0, d3.max(traitsTableData, function(d) { return d.logValue })])
                    .range([h-ybumperBottom, ybumperTop]);

                arc = d3.svg.symbol().type('triangle-up').size(60);

                $(".traits-svg-wrapper").html("");


                svg = d3.select(".traits-svg-wrapper").append("svg")
                    .attr("width", w)
                    .attr("height",h)
                    .attr("style","border:solid 1px #ddd;")
                    .attr("id","pheSvg");



                //draw x-axis grid lines
                svg.selectAll("line.x")
                    .data(x.ticks(10))
                    .enter().append("line")
                    .attr("class", "x")
                    .attr("x1", x)
                    .attr("x2", x)
                    .attr("y1", ybumperTop)
                    .attr("y2", h-ybumperBottom)
                    .style("stroke", "#eee");

                // Draw Y-axis grid lines
                svg.selectAll("line.y")
                    .data(y.ticks(10))
                    .enter().append("line")
                    .attr("class", "y")
                    .attr("x1", xbumperLeft)
                    .attr("x2", w-xbumperRight)
                    .attr("y1", y)
                    .attr("y2", y)
                    .style("stroke", "#eee");


                group = svg.selectAll("g.datasets")
                    .data(datasetArray)
                    .enter()
                    .append("g");


                group.append("g")
                    .attr("class","dataset-group")
                    .attr("transform", function(d) {
                        var xposition = x(d.sample);
                        var yposition = 380;
                        return "translate("+xposition+","+yposition+")"});

                group.select(".dataset-group")
                    .append("circle")
                    .attr("cx", 0)
                    .attr("cy", 0)
                    .attr("r", 4)
                    .attr("fill","rgba(255,0,0,.3)")
                    .attr("stroke","rgba(255,0,0,0)")
                    .attr("stroke-width","10")
                    .attr("shape-rendering","auto")
                    .attr("xp", function(d) {
                        return x(d.sample)
                    })
                    .attr("yp", function(d) {
                        return 380
                    })
                    .on("mouseover", function(d) {

                        //Get this bar's x/y values, then augment for the tooltip
                        var svgPosition = $(pheSvg).position();
                        var xPosition = parseFloat(d3.select(this).attr("xp")) + svgPosition.left;
                        var yPosition = parseFloat(d3.select(this).attr("yp")) + svgPosition.top - 50;

                        //Update the tooltip position and value
                        d3.select("#phePlotTooltip")
                            .style("left", xPosition + "px")
                            .style("top", yPosition + "px")
                            .select("#value")
                            .text(d.dataset +": " + d.sample);

                        //Show the tooltip
                        d3.select("#phePlotTooltip").classed("hidden", false);
                        d3.select(this).attr('stroke','rgba(255,0,0,0.2)');

                    })
                    .on("mouseout", function() {

                        //Hide the tooltip
                        d3.select("#phePlotTooltip").classed("hidden", true);
                        d3.select(this).attr('stroke','rgba(255,0,0,0.0)');

                    });

                group.select(".dataset-group")
                    .append("line")
                    .attr("x1", 0)
                    .attr("y1", -360)
                    .attr("x2", 0)
                    .attr("y2", 0)
                    .attr("stroke","rgba(255,150,150,.3)")
                    .attr("shape-rendering","auto");

                group.select(".dataset-group")
                    .append("text")
                    .attr("x", 7)
                    .attr("y", 5)
                    .text(function(d){ return d.dataset })
                    .attr("transform","rotate(35)")
                    .attr("style","text-anchor:start; font-size: 12px !important;");

                group = svg.selectAll("g.traits")
                    .data(traitsTableData)
                    .enter()
                    .append("g");

                group.append("g")
                    .attr("class","triangle-group")
                    .attr("transform", function(d) {
                        var xposition = x(d.sample);
                        var yposition = y(d.logValue);
                        return "translate("+xposition+","+yposition+")"})
                    .attr("xp", function(d) {
                        return x(d.sample)
                    })
                    .attr("yp", function(d) {
                        return y(d.logValue)
                    })
                    .on("mouseover", function(d) {

                        //Get this bar's x/y values, then augment for the tooltip
                        var svgPosition = $(pheSvg).position();
                        var xPosition = parseFloat(d3.select(this).attr("xp")) + svgPosition.left;
                        var yPosition = parseFloat(d3.select(this).attr("yp")) + svgPosition.top - 50;

                        //Update the tooltip position and value
                        d3.select("#phePlotTooltip")
                            .style("left", xPosition + "px")
                            .style("top", yPosition + "px")
                            .select("#value")
                            .text("Phenotype: "+ d.phenotype +", Dataset: "+ d.dataset +", p-value: " + d.pvalue +", odds-ratio: "+ d.oddsRatio);

                        //Show the tooltip
                        d3.select("#phePlotTooltip").classed("hidden", false);

                    })
                    .on("mouseout", function() {

                        //Hide the tooltip
                        d3.select("#phePlotTooltip").classed("hidden", true);

                    });


                group.select(".triangle-group").append('path')
                    .attr('d',arc)
                    .attr('fill','rgba(100,100,100,0.5)')
                    .attr('stroke','rgba(255,0,0,0.0)')
                    .attr('stroke-width','10')
                    .attr('stroke-linejoin','round')
                    .attr('transform',function(d){

                        var angle = (d.effectDirection == "up")? 0 : (d.effectDirection == "down")? 180: 90;

                        return 'rotate('+angle+')';
                    })
                    .attr("shape-rendering","auto")
                    .on("mouseover", function(d) {

                        d3.select(this).attr('stroke','rgba(255,0,0,0.3)');

                    })
                    .on("mouseout", function() {

                        d3.select(this).attr('stroke','rgba(255,0,0,0.0)');

                    });;

                group.select(".triangle-group").append("text")
                    .attr("x","0")
                    .attr("y","15")
                    .attr("class","")
                    .append('tspan')
                    .attr('x', "0")
                    .attr('dy', 5)
                    .text(function(d) {
                        var phenotypeName = (d.logValue > 4 )? d.phenotype : "";
                        return phenotypeName;
                    })
                    .attr("style","fill: #666; font-size: 10px; text-anchor: middle;");


                // add labels

                svg.append("g").attr("transform", "translate(0,"+(h-ybumperBottom)+")")
                    .attr("class","axis")
                    .call(d3.svg.axis().orient("bottom").scale(x))
                    .append("text")
                    .text("Sample")
                    .attr("x",xbumperLeft/2)
                    .attr("y", 3)
                    .attr("style","font-size: 9pt !important; font-weight: 400;text-anchor:middle");


                svg.append("g").attr("transform", "translate("+xbumperLeft+",0)")
                    .attr("class","axis")
                    .call(d3.svg.axis().orient("left").scale(y))
                    .append("text")
                    .text("p-value (-log10)")
                    .attr("x",-((h-ybumperBottom)/2))
                    .attr("y", -(xbumperLeft/2))
                    .attr("transform","rotate(-90)")
                    .attr("style","font-size: 9pt !important; font-weight: 400;text-anchor:middle");

                // add dataset names



            }

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


            /* GAIT TAB UI */

            function checkGaitTabs(event) {

                if($(".modeled-phenotype-div").css('display') == "block") {

                    $("#strata1_stratsTabs").css("background-color","#9fd3df");

                    if($("#stratifyDesignation").val() == "none") {

                        $(".modeled-phenotype-div").find("a").css("background","none");
                        $(".modeled-phenotype-div").find("li.active").find("a").css("background-color","#ffffff");

                        $(".modeled-phenotype-div").find("a").click(function() {

                            $(".modeled-phenotype-div").find("a").css("background","none");

                            $(this).css("background-color","#ffffff");

                        })
                    }

                } else {

                    $("#strata1_stratsTabs").css("background-color","#bfe3ef");

                }

            }

            function highlightActiveTabs(event) {

                var filterParmValue = $(event.target).val();

                var tabID = "#"+ $(event.target).closest(".tab-pane").attr("id");

                if(filterParmValue != "") {

                    $("li.active").find("a").each(function(){

                        if($(this).attr("data-target") == tabID){

                            $(this).closest("li.active").addClass("adjusted");

                            var scndTabID = "#" + $(this).closest(".tab-pane").attr("id");

                            $("li.active").find("a").each(function() {

                                if ($(this).attr("data-target") == scndTabID) {

                                    $(this).closest("li.active").addClass("adjusted");

                                }
                            });
                        }
                    });
                } else {
                    var totalInputNum = $(event.target).closest(".filterHolder").find("input.filterParm").length;

                    $(event.target).closest(".filterHolder").find("input.filterParm").each(function() {

                        totalInputNum = ($(this).val()) ? totalInputNum : totalInputNum-1;
                    });

                    if (totalInputNum == 0){
                        $("li.active").find("a").each(function(){
                            if($(this).attr("data-target") == tabID){$(this).closest("li.active").removeClass("adjusted")}
                        });

                        $("li.active").find("a").each(function() {

                            if ($(this).attr("data-target") == tabID) {

                                var adjustedTabNum = 0;

                                $(this).closest("ul").find("li").each(function(){
                                    adjustedTabNum = ($(this).hasClass("adjusted"))? adjustedTabNum + 1 : adjustedTabNum;
                                })

                                if(adjustedTabNum == 0) {
                                    var scndTabID = "#" + $(this).closest(".tab-pane").attr("id");

                                    $("li.active").find("a").each(function() {

                                        if ($(this).attr("data-target") == scndTabID) {

                                            $(this).closest("li.active").removeClass("adjusted");

                                        }
                                    });
                                }

                            }
                        });
                    }
                }
            }

            /* copy url of variant search result page to clipboard*/

            function copyVariantSearchURL() {
                document.addEventListener('copy', function(e) {

                    e.clipboardData.setData('text/plain', $(location).attr("href"));
                    e.preventDefault(); // default behaviour is to copy any selected text
                });

                document.execCommand('copy');
            }


            /* copy URL function end */

            $( window ).load( function() {

                /* massage LocusZoom UI */
                massageLZ();

            });


            $( window ).resize(function() {
                menuHeaderSet();
            })

        </script>

    </head>

<body>


<g:applyLayout name="errorReporter"/>


<div id="spinner" class="dk-loading-wheel center-block" style="display:none;">
    <img id="img-spinner" src="${resource(dir: 'images', file: 'ajax-loader.gif')}" alt="Loading"/>
</div>
<div id="header">

        <g:applyLayout name="headerTopT2dgenes"/>

        <g:applyLayout name="headerBottomT2dgenes"/>

        <g:applyLayout name="notice"/>

</div>
</div>

<g:layoutBody/>
<g:if test="${g.portalTypeString()?.equals('stroke')}">
    <div class="container-fluid dk-stroke-footer"><div class="container">
</g:if>
<g:elseif test="${g.portalTypeString()?.equals('mi')}">
    <div class="container-fluid dk-mi-footer"><div class="container">
</g:elseif>
<g:else>
    <div class="container-fluid dk-t2d-footer"><div class="container">
</g:else>

    <div class="row">
        <div class="col-md-12" style="text-align: center;">
            <div style="padding-top:10px;"><span class="glyphicon glyphicon-comment" style="color:#fff"></span> <a href="${createLink(controller:'informational', action:'contact')}"><g:message code="mainpage.send.feedback"/></a><div>
            <div style="font-size: 10px;"><g:message code="buildInfo.shared.build_message" args="${[BuildInfo?.buildHost, BuildInfo?.buildTime]}"/>.  <g:message code='buildInfo.shared.version'/>=${BuildInfo?.appVersion}.${BuildInfo?.buildNumber}</div>
        </div>
    </div>
        </div></div>

<g:applyLayout name="activatePopups"/>

</body>
</html>