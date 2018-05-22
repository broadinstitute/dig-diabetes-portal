var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.traitsFilter = (function () {



        var setTraitsFilter = function (traitsJson,PLACE) {

            var PAGE = PLACE || "default";

            var traitsGroups = traitsJson.datasetOrder;

            if(PAGE == "home") {
                $(".traits-filter-wrapper").append('<div class="traits-search-close-btn" onclick="mpgSoftware.traitsFilter.filterOutFocus()" onmouseover="mpgSoftware.traitsFilter.setBtnOver(this)" onmouseout="mpgSoftware.traitsFilter.setBtnOut(this)" style="font-size:23px; position: absolute; top:-20px; right:-20px;display:none; color: #666;"><span class="glyphicon glyphicon-remove-circle" aria-hidden="true"></span></div>');
                $(".traits-filter-wrapper").append("<div class='related-words' style='position:absolute; z-index: 100; top:104px; background-color: #fff; padding: 5px; display:none; width: 93%; box-shadow: 0 3px 5px rgba(0,0,0,.5); border-radius: 5px;'></div><div class='traits-list-table-wrapper' style='display:none; width:93%; overflow-y:auto;overflow-x:hidden; height:auto; max-height:280px; position:absolute; top: 110px;'><table id='traits-list-table' style='border: solid 1px #ddd; width: 100%; font-size: 14px; '><tbody></tbody></table></div>")}

                $.each(traitsGroups, function(index,value) {

                var traitsGroup = value;
                var eachTraits = traitsJson.dataset[value];

                $.each(eachTraits, function(TraitsIndex,Traitsvalue) {
                    $("#traits-list-table").find("tbody").append("<tr class='hidden-traits-row1' style='border-bottom: solid 1px #ddd; ' phenotype='"+Traitsvalue[1]+","+traitsGroup+"'><td style='width:50%;padding:5px 10px;'><a href='javascript:;' style='color:#fff; text-decoration: underline;' onclick='mpgSoftware.traitsFilter.launchTraitSearch(event)' phenotype='"+Traitsvalue[0]+"'>"+Traitsvalue[1]+"</a></td><td style='width:50%;border-left: solid 1px #ddd; padding:5px 10px;'>"+ traitsGroup+"</td></tr>");
                })
            })

            $("#home_spinner").css("display","none");
        }

        function setBtnOver(x) {
            $(x).css("color","#000");
        }

        function setBtnOut(x) {
            $(x).css("color","#666");
        }

        var launchTraitSearch = function (event) {
            var TRAIT = $(event.target).attr("phenotype");
            var homePageVars = mpgSoftware.homePage.getHomePageVariables();

            var trait_val = mpgSoftware.traitsFilter.filterOutIllegalCharacters(TRAIT);
            console.log(TRAIT);

            var significance = 0.0005;
            if (trait_val == "" || significance == 0) {
                alert('Please choose a trait and enter a valid significance!')
            } else {
                window.location.href = homePageVars.traitSearchUrl + "?trait=" + trait_val + "&significance=" + significance;
            }
        };

        var filterOutIllegalCharacters = function (rawString){
            var returnValue = "";
            if ((typeof rawString !== 'undefined') &&
                (rawString !==  null )){
                var substitutedSlash = rawString.replace("/","_");
                returnValue = substitutedSlash.replace(/^\s+|\s+$/g, "").replace(/,/g, "").match(/^[a-zA-Z0-9_\-:]+$/gi,'');
            }
            return returnValue;
        }

        var filterTraitsTable = function (TARGETTABLE) {
            //console.log($("#traits-filter").val());


                $(TARGETTABLE).find("tr").removeClass("hidden-traits-row");


                var searchWords = $("#traits-filter").val();

                var fstChr = searchWords.charAt(0);


                if (searchWords == "") {
                    $(".related-words").hide("fast");
                } else {

                    searchWords = searchWords.toLowerCase().split(",");


                var phenotypesArray = [];

                var hasEql = false;

                $.each(searchWords, function(index,value){

                    $(TARGETTABLE).find("tr").each(function() {

                        if($(this).hasClass("hidden-traits-row")) {

                        } else {


                            var phenotypeString = $(this).attr("phenotype").toLowerCase();

                            var searchWord = value.trim();


                            if(searchWord.indexOf("=") >= 0) {

                                hasEql = true;

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

                    (hasEql == true)? $(".related-words").hide("fast"):  $(".related-words").show("fast");

                }


                var relatedWords = mpgSoftware.traitsFilter.showRelatedWords();

                ( $("#traits-filter").val() != "" )? $(".related-words").html("").append(relatedWords) : $(".related-words").html("");

            var  visibleTr = 0;

            $(TARGETTABLE).find("tr").each(function() {

                if ($(this).hasClass("hidden-traits-row")) {

                } else {
                    visibleTr ++;
                }
            });

            if(visibleTr < 7) $(".related-words").hide("slow");

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

            var searchWords = $("#traits-filter").val().toLowerCase().split(",");

            for (var x = 0; x < wordsByWeight.length; x++) {

                var comparingWord = wordsByWeight[x].word.toLowerCase();
                var wordMatch = "";

                $.each(searchWords, function(index,value) {
                    var searchWord = value.trim().toLowerCase();

                    if( searchWord != "" && wordsByWeight[x].word.length > 1 ){
                        if (comparingWord.indexOf(searchWord) >= 0) {
                            wordMatch = "<a class='related-word-red' href='javascript:;' onclick='mpgSoftware.traitsFilter.addToPhenotypeFilter(event)'>" + wordsByWeight[x].word + "</a>";
                        } else {
                            wordMatch = "<a class='related-word' href='javascript:;' onclick='mpgSoftware.traitsFilter.addToPhenotypeFilter(event)'>" + wordsByWeight[x].word + "</a>";
                        }
                    }
                });

                returnText += wordMatch;
            }

            returnText += '<a href="#javascript:;" onclick="mpgSoftware.traitsFilter.hideRelatedWords()" style="position:absolute; bottom:-2px; right:3px; font-size: 16px; color: #666;"><span class="glyphicon glyphicon-resize-small" aria-hidden="true"></span></a>';

            return returnText;

        }

        var addToPhenotypeFilter = function (event) {
            var wordToAdd = $(event.target).text();
            var currentVal = $("#traits-filter").val().trim();

            var newKeyword = (currentVal[currentVal.length -1] == ",")? true : false;

            currentVal = currentVal.split(",");

            if(currentVal[currentVal.length -1] == "") currentVal.splice(currentVal.length -1,1);


            if(newKeyword) {

                $("#traits-filter").val(currentVal + ", " + wordToAdd);

            } else {

                currentVal[currentVal.length -1] = wordToAdd;

                $("#traits-filter").val(currentVal+", ");

            }

            mpgSoftware.traitsFilter.filterTraitsTable("#traits-list-table");

        }

        var filterOnFocus = function () {

            $("#traits-filter").attr("placeholder","");

            $(".gene-search-wrapper").hide("slow");
            $(".variant-finder-wrapper").hide("slow");
            //$(".related-words").show("slow");
            $(".traits-list-table-wrapper").show("slow");
            $(".traits-search-close-btn").fadeIn("slow");
            mpgSoftware.traitsFilter.filterTraitsTable("#traits-list-table");
        }

        var hideRelatedWords = function() {
            $(".related-words").hide("fast");
        }

        var filterOutFocus = function () {

            $("#traits-filter").val("").attr("placeholder","Search for phenotypes");

            $(".gene-search-wrapper").show("slow");
            $(".variant-finder-wrapper").show("slow");
            $(".related-words").hide("slow");
            $(".traits-list-table-wrapper").hide("slow");
            $(".traits-search-close-btn").fadeOut("slow");

        }

        var clearTraitsSearch = function() {
            $("#traits-filter").val("");
            mpgSoftware.traitsFilter.filterTraitsTable("#traits-list-table");
        }

        return{
            setTraitsFilter:setTraitsFilter,
            filterOnFocus:filterOnFocus,
            filterTraitsTable:filterTraitsTable,
            showRelatedWords:showRelatedWords,
            addToPhenotypeFilter:addToPhenotypeFilter,
            filterOutIllegalCharacters:filterOutIllegalCharacters,
            launchTraitSearch:launchTraitSearch,
            filterOutFocus:filterOutFocus,
            setBtnOver:setBtnOver,
            setBtnOut:setBtnOut,
            clearTraitsSearch:clearTraitsSearch,
            hideRelatedWords:hideRelatedWords
        }
    }());
})();
