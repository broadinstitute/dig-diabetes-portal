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

                    case "grsinfo":
                        setMenuTriangle(".grs-btn");
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

            function resetPhePlot(PHENOTYPE) {

                var phenotypeName = PHENOTYPE || "";
                $("#traits_table_filter").val(PHENOTYPE);
                $("#pvalue-min").val("");
                $("#pvalue-max").val("");
                $("#sample-min").val("");
                $("#sample-max").val("");
                $("#phePlotGroups").val("");
                filterTraitsTable();
            }

            function massageTraitsTable() {

                $(".open-glyphicon").hover(function() { $(this).css({"cursor":"pointer"});});


                var inputBox = "";
                inputBox += "<div style='display:inline-block; margin-left: 15px; padding-left: 15px;'><h5>Filter plot (*1000 for sample)</h5><input id='pvalue-min' style='display: inline-block; width: 80px; padding-left: 10px;' value='' /><span style='display: inline-block; padding: 0 5px'> < p-value(-log10) < </span><input id='pvalue-max' style='display: inline-block; width: 80px; padding-left: 10px;' />";
                inputBox += "<input id='sample-min' value=''  style='display: inline-block; width: 80px; padding-left: 10px; margin-left: 25px;' /><span style='display: inline-block; padding: 0 5px'>< sample < </span><input id='sample-max' style='display: inline-block; width: 80px; padding-left: 10px;' />";
                inputBox += "<a href='javascript:;' class='btn btn-sm btn-default' style='margin: 0 0 0 30px; float: right;' onclick='resetPhePlot()'><span class='glyphicon glyphicon-refresh' aria-hidden='true'></span> Reset</a></div>"
                inputBox += "</div>";
                //inputBox += "<a onclick='readDataset();' href='javascript:;'class='btn btn-default' style='float: right; margin-bottom: 10px;'>Switch view</a>";
                inputBox += '<div class="traits-svg-wrapper" style=""></div>';


                $("#traitsPerVariantTable_wrapper").find(".dt-buttons").css({"width":"100%","margin-bottom":"15px"}).insertAfter($("#traitsPerVariantTable"));

                $(inputBox).appendTo($("#dkPhePlot"));

                var suggestedToSort = "<div class='phenotype-searchbox-wrapper'><div style='display:inline-block'><h5>Filter phenotypes (ex: bmi, glycemic; '=phenotype' for exact match)</h5><input id='traits_table_filter' type='text' name='search' style='display: inline-block; width: 400px; height: 35px; padding-left: 10px;' placeholder='' value=''><select id='phePlotGroups' class='minimal' style='margin: 0 0 0 15px;'><option value=''>Phenotype groups - all</option></select><a href='javascript:;' class='dt-button buttons-copy buttons-html5' style='margin: 0 0 0 30px; float: right;' onclick='resetPhePlot()'><span class='glyphicon glyphicon-refresh' aria-hidden='true'></span> Reset</a></div><div class='related-words' style='clear: left;'></div>";

                suggestedToSort += ""

                suggestedToSort += "<span style='font-size: 12px; margin: 15px 0 10px 0; display: block;'>To sort the table by multi columns, hold shift key and click the head of the secondary column.</span>";

                $(suggestedToSort).insertBefore($("#traitsPerVariantTable"));

                $("#traitsPerVariantTable").find("thead").find("tr").each(function() {
                    $(this).find("th").eq("1").insertBefore($(this).find("th").eq("0"));
                    $("<th>sample</th>").appendTo($(this));
                });


                $("#traits_table_filter").on('input',filterTraitsTable);
                $("#pvalue-min").on('input',filterTraitsTable);
                $("#pvalue-max").on('input',filterTraitsTable);
                $("#sample-min").on('input',filterTraitsTable);
                $("#sample-max").on('input',filterTraitsTable);
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

                    filterTraitsTable();
                });



                var phenoTypeID = "";
                var phenotypeGroupList = []



                $("#traitsPerVariantTableBody").find("tr").each(function() {

                    var pheName = $(this).find("div.vandaRowHdr").attr("phenotypename");
                    var dtsetName = $(this).find("div.vandaRowHdr").attr("datasetname");
                    var sampleNum = phenotypeDatasetMapping[pheName][dtsetName].count;
                    var phenotypeGroup = phenotypeDatasetMapping[pheName][dtsetName].phenotypeGroup;

                    phenotypeGroupList.push(phenotypeGroup)

                    $(this).attr("phenotype", $(this).find("td").eq("1").text()+","+phenotypeGroup );

                    $(this).find("td").eq("1").insertBefore($(this).find("td").eq("0"));

                    $("<td class='sample-size'>"+sampleNum+"</td>").appendTo($(this));

                });

                phenotypeGroupList = unique(phenotypeGroupList).sort();

                $.each(phenotypeGroupList, function(index, value) {

                    //console.log(value);

                    $("#phePlotGroups").append('<option value="'+value+'">'+value+'</option>');

                });

                $("#traitsPerVariantTableBody").find("td").mouseenter(function() {
                    var phenotypeName = $(this).closest("tr").find("td").eq("0").text();

                    $("#traitsPerVariantTableBody").find("tr").each(function() {
                        ($(this).find("td").eq("0").text() == phenotypeName)? $(this).addClass("highlighted-phenotype"):$(this).removeClass("highlighted-phenotype");
                    });
                })

                filterTraitsTable();
                //phePlotApp();
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

                var searchWords = $("#traits_table_filter").val() + "," + $("#phePlotGroups option:selected").val();
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


                var relatedWords = showRelatedWords();

                ( $("#traits_table_filter").val() != "" )? $(".related-words").html("").append(relatedWords) : $(".related-words").html("");

                phePlotApp();
            }


            function showRelatedWords() {
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
                var currentVal = $("#traits_table_filter").val().trim();

                var newKeyword = (currentVal[currentVal.length -1] == ",")? true : false;

                currentVal = currentVal.split(",");

                if(currentVal[currentVal.length -1] == "") currentVal.splice(currentVal.length -1,1);

                console.log(currentVal);

                if(newKeyword) {

                    $("#traits_table_filter").val(currentVal + ", " + wordToAdd);

                } else {

                    currentVal[currentVal.length -1] = wordToAdd;

                    $("#traits_table_filter").val(currentVal+", ");

                }



                filterTraitsTable();

            }


            function openPhePlotTab(PHENOTYPE) {

                $("#traitAssociationInner").find("a.phewas").closest("li").attr("class","")
                $("#traitAssociationInner").find("a.pheplot").closest("li").attr("class","active")

                $("#traitAssociationInner").find(".plot-tabs").find(".tab-pane").each(function() {
                    var classSet = ($(this).attr("id") == "pheplot")? "tab-pane fade active in" : "tab-pane fade";

                    $(this).attr("class", classSet);
                })

                resetPhePlot(PHENOTYPE);
            }


            function phePlotApp() {



                ($("#phePlotTooltip").length)? "":d3.select("body").append("div").attr("id","phePlotTooltip").attr("class","hidden").append("span").attr("id","value");
                ($("#phePlotTooltip").find(".pointer").length)? "" : d3.select("#phePlotTooltip").append("div").attr("class","pointer");

                    ;

                //$("#phePlotTooltip").append("<div class='pointer'>&nbsp;</div>");

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
                            eachDataset.effectDirection = effectDirection = ($(this).find("td").eq(3).html().indexOf("up") >= 0)? "up":($(this).find("td").eq(3).html().indexOf("down") >= 0)?"down":"";
                            eachDataset.oddsRatio = parseFloat($(this).find("td").eq(4).text());
                            eachDataset.maf = $(this).find("td").eq(5).text();
                            eachDataset.sample = parseFloat(parseFloat($(this).find("td").eq(7).text()));

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


                //console.log(datasetArray);

                w = $("#traitsPerVariantTable").width(), h = 500, xbumperLeft = 50, xbumperRight = 200, ybumperTop = 20, ybumperBottom = 140;


                $(".traits-svg-wrapper").html("");

                $(".traits-svg-wrapper").append('<div class="phenotypes-for-plot" style="margin: 5px 0 5px 0;"></div>');

                var phenotypes = "";

                $.each(traitsTableData, function(index,value){
                    phenotypes += value.phenotype + ",";
                });

                var phenotypesArray = phenotypes.split(",");

                phenotypesArray.splice(-1,1);

                phenotypesArray = unique(phenotypesArray);

                result = [];

                $.each(phenotypesArray, function(index,value) {
                    for (var i=0; i < traitsTableData.length; i++) {
                        if (traitsTableData[i].phenotype == value) {result.push(traitsTableData[i]); break;}
                    }
                })

                phenotypesArray = result;


                //add phenotype name buttons above the plot
                /*

                if ($("#traits_table_filter").val() != "") $(".phenotypes-for-plot").append("<p>Click to apply color to the plot</p>");

                $.each(phenotypesArray, function(index,value){
                    if($("#traits_table_filter").val() != "") {
                        if(value != " " || value != null) $(".phenotypes-for-plot").append("<span class='btn btn-default btn-xs' style='margin-right: 5px;'>"+value + "</span>");
                    }

                });

                */


                /*

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



                */



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



                //draw x-axis grid lines
                /*svg.selectAll("line.x")
                    .data(x.ticks(10))
                    .enter().append("line")
                    .attr("class", "x")
                    .attr("x1", x)
                    .attr("x2", x)
                    .attr("y1", ybumperTop)
                    .attr("y2", h-ybumperBottom)
                    .style("stroke", "#eee");*/

                // Draw Y-axis grid lines
                /*
                svg.selectAll("line.y")
                    .data(y.ticks(10))
                    .enter().append("line")
                    .attr("class", "y")
                    .attr("x1", xbumperLeft)
                    .attr("x2", w-xbumperRight)
                    .attr("y1", y)
                    .attr("y2", y)
                    .style("stroke", "#eee");
                    */



                // Draw p-value significance line
                svg.selectAll("line.gws")
                    .data(y.ticks(1))
                    .enter().append("line")
                    .attr("class", "gws")
                    .attr("x1", xbumperLeft)
                    .attr("x2", w-xbumperRight)
                    .attr("y1", y(8))
                    .attr("y2", y(8))
                    .style("stroke", "rgba(0, 102, 51, .1)");

                svg.selectAll("text.gws")
                    .data(y.ticks(1))
                    .enter().append("text")
                    .attr("x", w-xbumperRight)
                    .attr("y", y(8))
                    .text("genome-wide significant: 8")
                    .attr("style","fill:rgba(0, 102, 51, .3); text-anchor: end");

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

                svg.append("text")
                    .text("Top 20 unique phenotypes")
                    .attr("x", w-xbumperRight+ 45)
                    .attr("y", ybumperTop+5)
                    .attr("style","font-size: 12px;");

                svg.append("text")
                    .text("against p-value")
                    .attr("x", w-xbumperRight+ 45)
                    .attr("y", ybumperTop + 20)
                    .attr("style","font-size: 12px;");



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
                    .append("line")
                    .attr("x1", 0)
                    .attr("y1", -(h-ybumperBottom+5))
                    .attr("x2", 0)
                    .attr("y2", 0)
                    .attr("stroke","rgba(255,150,150,.2)")
                    .attr("shape-rendering","auto");

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
                group = svg.selectAll("g.phenotypenames")
                    .data(phenotypesArray)
                    .enter()
                    .append("g");

                var phenotypeNameLineH = 17;
                var phenotypeNameNum = 20;
                var phenotypeNameTop = (h - (phenotypeNameLineH * phenotypeNameNum) - ybumperTop)/2;

                group.append("g")
                    .attr("class","phenotype-name-group")
                    .attr("transform", function(d, i) {

                        var namesTopPos = phenotypeNameTop;

                        var xposition = w-xbumperRight + 45;
                        var yposition = ((i%phenotypeNameNum)*phenotypeNameLineH)+namesTopPos;
                        return "translate("+xposition+","+yposition+")"})
                    .attr("style", function(d,i) {
                        var returnStyle = (i<phenotypeNameNum)? "visibility: visible":"visibility: hidden";

                        return returnStyle;
                    });

                group.select(".phenotype-name-group")
                    .append("line")
                    .attr("x1", -30)
                    .attr("y1", function(d,i) {
                        var namesTopPos = phenotypeNameTop;
                        return y(d.logValue) - (((i%phenotypeNameNum)*phenotypeNameLineH)+namesTopPos)
                    })
                    .attr("x2", -(w-xbumperLeft-xbumperRight+45))
                    .attr("y2", function(d, i) {
                        var namesTopPos = phenotypeNameTop;
                        return y(d.logValue) - (((i%phenotypeNameNum)*phenotypeNameLineH)+namesTopPos)
                    })
                    .attr("stroke",function(d) {

                        var dotColor = (d.logValue >= 8)? "rgba(0, 102, 51, .5)" : (d.logValue >= 4)? "rgba(122, 179, 23, .5)" : (d.logValue >= 0.5)? "rgba(172, 230, 0, .7)" : "rgba(200, 200, 200, .3)"
                        return dotColor ;
                    })
                    .attr("shape-rendering","auto");

                group.select(".phenotype-name-group")
                    .append("line")
                    .attr("x1", -10)
                    .attr("y1", 5)
                    .attr("x2", -30)
                    .attr("y2", function(d, i) {
                        var namesTopPos = phenotypeNameTop;
                        return y(d.logValue) - (((i%phenotypeNameNum)*phenotypeNameLineH)+namesTopPos)
                    })
                    .attr("stroke",function(d) {

                        var dotColor = (d.logValue >= 8)? "rgba(0, 102, 51, .5)" : (d.logValue >= 4)? "rgba(122, 179, 23, .5)" : (d.logValue >= 0.5)? "rgba(172, 230, 0, .7)" : "rgba(200, 200, 200, .3)"
                        return dotColor ;
                    })
                    .attr("shape-rendering","auto");

                group.select(".phenotype-name-group")
                    .append("line")
                    .attr("x1", -10)
                    .attr("y1", 5)
                    .attr("x2", -5)
                    .attr("y2", 5)
                    .attr("stroke",function(d) {

                        var dotColor = (d.logValue >= 8)? "rgba(0, 102, 51, .5)" : (d.logValue >= 4)? "rgba(122, 179, 23, .5)" : (d.logValue >= 0.5)? "rgba(172, 230, 0, .7)" : "rgba(200, 200, 200, .3)"
                        return dotColor ;
                    })
                    .attr("shape-rendering","auto");

                group.select(".phenotype-name-group")
                    .append("text")
                    .attr("y", 10)
                    .text(function(d){ return d.phenotype})
                    .attr("style","font-size: 12px; text-anchor: start;")
                    .attr("fill", function(d) {
                        var dotColor = (d.logValue >= 8)? "rgba(0, 102, 51, 1)" : (d.logValue >= 4)? "rgba(122, 179, 23, 1)" : (d.logValue >= 0.5)? "rgba(172, 230, 0, 1)" : "rgba(200, 200, 200, 1)"
                        return dotColor ;
                    })
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
                        var yPosition = parseFloat(d3.select(this).attr("yp")) + svgPosition.top;

                        //Update the tooltip position and value
                        d3.select("#phePlotTooltip")
                            .style("left", xPosition + "px")
                            .style("top", yPosition + "px");

                        var tipValue = d.phenotype +"<br>"+ d.dataset +"<br>p-value: " + d.pvalue +"<br>sample: "+ d.sample+"<br>odds-ratio: "+ d.oddsRatio+"<br>MAF: "+ d.maf;

                        $("#phePlotTooltip").find("#value").html(tipValue).css("font-size: 10px !important");

                        //Show the tooltip
                        d3.select("#phePlotTooltip").classed("hidden", false);

                        highlightTriangle(d.phenotype);

                    })
                    .on("mouseout", function() {

                        //Hide the tooltip

                        dimTriangle();

                        d3.select("#phePlotTooltip").classed("hidden", true);

                    });


                /// add phenotype dots
                group = svg.selectAll("g.phenotypedots")
                    .data(traitsTableData)
                    .enter()
                    .append("g");

                group.append("g")
                    .attr("class","phenotype-dot-group")
                    .attr("transform", function(d) {
                        var xposition = w - (xbumperRight - 15);
                        var yposition = y(d.logValue);
                        return "translate("+xposition+","+yposition+")"});

                group.select(".phenotype-dot-group")
                    .append("line")
                    .attr("x1", 0 )
                    .attr("y1", 0)
                    .attr("x2", function(d) { return -(w -xbumperLeft -xbumperRight + 15) })
                    .attr("y2", 0)
                    .attr("stroke",function(d) {

                        var dotColor = (d.logValue >= 8)? "rgba(0, 102, 51, .2)" : (d.logValue >= 4)? "rgba(122, 179, 23, .2)" : (d.logValue >= 0.5)? "rgba(172, 230, 0, .4)" : "rgba(200, 200, 200, .3)"
                        return dotColor ;
                    })
                    .attr("shape-rendering","auto");

                group.select(".phenotype-dot-group")
                    .append("circle")
                    .attr("cx", 0)
                    .attr("cy", 0)
                    .attr("r", 3)
                    .attr("fill",function(d) {

                        var dotColor = (d.logValue >= 8)? "rgba(0, 102, 51, .3)" : (d.logValue >= 4)? "rgba(122, 179, 23, .3)" : (d.logValue >= 0.5)? "rgba(172, 230, 0, .4)" : "rgba(200, 200, 200, .3)"
                        return dotColor ;
                    })
                    .attr("stroke",function(d) {

                        var dotColor = (d.logValue >= 8)? "rgba(0, 102, 51, .0)" : (d.logValue >= 4)? "rgba(122, 179, 23, .0)" : (d.logValue >= 0.5)? "rgba(172, 230, 0, .0)" : "rgba(200, 200, 200, .0)"
                        return dotColor ;
                    })
                    .attr("stroke-width","10")
                    .attr("shape-rendering","auto")
                    .attr("xp", function(d) {
                        return x(d.sample)
                    })
                    .attr("yp", function(d) {
                        return y(d.logValue)
                    })
                    .on("mouseover", function(d) {

                        d3.select(this).attr('stroke',function(d) {

                            var dotColor = (d.logValue >= 8)? "rgba(0, 102, 51, .3)" : (d.logValue >= 4)? "rgba(122, 179, 23, .3)" : (d.logValue >= 0.5)? "rgba(172, 230, 0, .7)" : "rgba(200, 200, 200, .3)"
                            return dotColor ;
                        });

                        //Get this bar's x/y values, then augment for the tooltip
                        var svgPosition = $(pheSvg).position();
                        var xPosition = parseFloat(d3.select(this).attr("xp")) + svgPosition.left;
                        var yPosition = parseFloat(d3.select(this).attr("yp")) + svgPosition.top;

                        //Update the tooltip position and value
                        d3.select("#phePlotTooltip")
                            .style("left", xPosition + "px")
                            .style("top", yPosition + "px");

                        var tipValue = d.phenotype +"<br>"+ d.dataset +"<br>p-value: " + d.pvalue +"<br>sample: "+ d.sample+"<br>odds-ratio: "+ d.oddsRatio+"<br>MAF: "+ d.maf;

                        $("#phePlotTooltip").find("#value").html(tipValue).css("font-size: 10px !important");

                        //Show the tooltip
                        d3.select("#phePlotTooltip").classed("hidden", false);

                        highlightTriangle(d.phenotype);

                    })
                    .on("mouseout", function() {

                        d3.select(this).attr('stroke','rgba(255,255,255,0.0)');
                        //Hide the tooltip

                        dimTriangle();

                        d3.select("#phePlotTooltip").classed("hidden", true);

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
                    .attr("x",-(y(0)))
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
                    .attr('fill','rgba(100,100,100,0.5)')
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

                        var tipValue = d.phenotype +"<br>"+ d.dataset +"<br>p-value: " + d.pvalue +"<br>sample: "+ d.sample+"<br>odds-ratio: "+ d.oddsRatio+"<br>MAF: "+ d.maf;

                        $("#phePlotTooltip").find("#value").html(tipValue).css("font-size: 10px !important");

                        //Show the tooltip
                        d3.select("#phePlotTooltip").classed("hidden", false);

                        highlightTriangle(d.phenotype);

                    })
                    .on("mouseout", function() {

                        d3.select(this).attr('stroke','rgba(255,0,0,0.0)');
                        dimTriangle();
                        //Hide the tooltip
                        d3.select("#phePlotTooltip").classed("hidden", true);


                    });

                // add phenotype name to the triangles

/*
                group.select(".triangle-group").append("text")
                    .attr("x","0")
                    .attr("y","15")
                    .attr("class","")
                    .append('tspan')
                    .attr('x', "0")
                    .attr('dy', 5)
                    .text(function(d, i) {
                        var textRenderMin = (pvalueMin == 0)? 8 : pvalueMin;
                        //var phenotypeName = (d.logValue > textRenderMin )? d.phenotype : "";
                        var phenotypeName = (i < 10 )? d.phenotype : "";
                        return phenotypeName;
                    })
                    .attr("style","fill: #666; font-size: 10px; text-anchor: middle;");
                    */


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