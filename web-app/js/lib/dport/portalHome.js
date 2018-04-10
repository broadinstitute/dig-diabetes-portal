var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.homePage = (function () {

        var homePageVariables;

        var setHomePageVariables = function(incomingHomePageVariables){
            homePageVariables = incomingHomePageVariables;
        };

        var getHomePageVariables = function(){
            return homePageVariables;
        };


        /**
         * Return the first numWords of text
         * @param text
         * @param numWords  defaults to 10
         */
        function getFirstWordsOfPost(text, numWords) {
            numWords = numWords || 10;
            // first clear out any line breaks
            text.replace(/\r?\n|\r/g, ' ');
            return _.split(text, ' ', numWords).join(' ');
        }

        function loadNewsFeed(arrayOfPosts) {
            // currently there are no stroke news items, so add a default
            if (arrayOfPosts.length == 0) {
                document.getElementById('newsFeedHolder').innerHTML =
                    '<li><b>Coming soon!</b></li>';
                return;
            }
            _.each(arrayOfPosts, function (post) {
                var postHtml = document.createElement('li');
                var text = document.createElement('span');
                text.innerHTML = '<b>' + post.title + '</b>: ' +
                    getFirstWordsOfPost(post.content, 15) + '... ' +
                    '<a href=' + post.url + ' target="_blank">Read more</a>';
                postHtml.appendChild(text);
                document.getElementById('newsFeedHolder').appendChild(postHtml);
            });
        }

        function setUpSlideDiv(e) {
            var liHeight = 0;
            var newHeight = 0;
            for (var l = 0; l < $("li", e).length; l++) {

                newHeight = $("li", e).eq(l).height();
                if (newHeight >= liHeight) {
                    liHeight = newHeight;
                }
            }

            $(e).css("height", liHeight + 5);
            $("li", e).css("position", "absolute");
            $("li", e).css("top", "50px");
            $("li", e).hide();
            $("li", e).first().show();
        }

        function setUpSlideNav(e) {
            $("<ul class='gallery-fade-nav'></ul>").insertBefore(e);

            for (var t = 0; t < $("li", e).length; t++) {
                var targetNav = $(e).parent().find(".gallery-fade-nav");
                if (t == 0) {
                    targetNav.append("<li class='current-box'>&nbsp;</li>");
                } else {
                    targetNav.append("<li>&nbsp;</li>");
                }

                if ($("li", e).eq(t).hasClass('reference-image')) {
                    $("li", targetNav).eq(t).css({"border": "solid 2px #ff9900", "background-color": "#f90"});
                }

                $("li", targetNav).eq(t).data("indexNum", t);
                targetNav.data("currentSlide", 0);
            }

        }

        function setSlideWindows() {
            if ($(".gallery-fade")) {
                $(".gallery-fade").each(function () {

                    setUpSlideDiv(this);
                    setUpSlideNav(this);

                });

                $(".gallery-fade-nav li").click(function () {
                    var nextImage = $(this).data("indexNum");
                    var currentSlide = $(this).parent().data("currentSlide");
                    $(this).parent().find("li").removeClass("current-box");
                    $(this).addClass("current-box");

                    var fadeSpeed = 300;

                    $("li", $(this).parent().parent().find(".gallery-fade")).eq(currentSlide).fadeOut(fadeSpeed);
                    $("li", $(this).parent().parent().find(".gallery-fade")).eq(nextImage).fadeIn(fadeSpeed);
                    $(this).parent().data("currentSlide", nextImage);
                });

                $(".gallery-fade li").click(function () {
                    var nextImage = $(this).parent().parent().find(".gallery-fade-nav").data("currentSlide") + 1;
                    if (nextImage == $(this).parent().find("li").length) {
                        nextImage = 0;
                    }

                    if ($(this).parent().parent().find("ul").hasClass('slow-fade')) {
                        var fadeSpeed = 600;

                    } else {
                        var fadeSpeed = 300;
                    }

                    $(this).fadeOut(fadeSpeed);
                    $("li", $(this).parent()).eq(nextImage).fadeIn(fadeSpeed);
                    $(this).parent().parent().find(".gallery-fade-nav").data("currentSlide", nextImage);
                    $(this).parent().parent().find(".gallery-fade-nav").children().removeClass("current-box");
                    $(this).parent().parent().find("li", ".gallery-fade-nav").eq(nextImage).addClass("current-box");
                });
            }

        }

        var retrieveAllPortalsInfo = function (parms) {
            $.ajax({
                cache: false,
                type: "post",
                url: parms.retrieveAllPortalsAjaxUrl,
                async: true
            }).done(function (data) {
                // var menuHeaderLine =
                //     "{{#.}}" +
                //     "<div class=\"container-fluid\" id=\"header-bottom\" style=\"background-image:url('{{menuHeader}}'); background-size: 100% 100%; font-size: 14px; font-weight:300; padding:0; margin:0; \">" +
                //     "{{/.}}";
                // var substitutedMenuHeaderLine = Mustache.render(menuHeaderLine, data);
                // $("#menuHeaderGoesHere").empty().append(substitutedMenuHeaderLine);
                //
                // var logoCodeLine =
                //     "{{#.}}" +
                //     "<div class=\"dk-logo-wrapper\" style=\"position:relative; z-index: 1001; float: left; width:350px; padding:12px 0 14px 0;\">" +
                //     "<a href=\"${createLink(controller:'home',action:'portalHome')}\">" +
                //     "<img src=\"{{logoCode}}\" style=\" width: 450px; margin-left: 10px;\" />" +
                //     "</a></div>" +
                //     "{{/.}}";
                // var substitutedLogoLine = Mustache.render(logoCodeLine, data);
                // $("#logoGoesHere").empty().append(substitutedMenuHeaderLine);
                var portal_typeSelector = $("#portal_typeSelector");
                _.forEach(data, function(eachPortal){
                    var option = new Option( eachPortal.portalDescription,eachPortal.portalType);
                    if  (parms.currentPortalType===eachPortal.portalType){
                        $(option).prop('selected', true);
                    }
                    portal_typeSelector.append(option);
                });

            });
        };

        var retrievePhenotypes = function () {
            var homePageVars = getHomePageVariables();
            $.ajax({
                cache: false,
                type: "post",
                url: homePageVars.retrieveGwasSpecificPhenotypesAjaxUrl,
                data: {},
                async: true,
                success: function (data) {
                    if (( data !== null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !== null )) {

                        UTILS.fillPhenotypeCompoundDropdown(data.datasets, '#trait-input', undefined, undefined, homePageVars.defaultPhenotype);
                        var availPhenotypes = [];
                        _.forEach($("select#trait-input option"), function (a) {
                            availPhenotypes.push($(a).val());
                        });
                        if (availPhenotypes.indexOf(homePageVars.defaultPhenotype) > -1) {
                            $('#trait-input').val(homePageVars.defaultPhenotype);
                        } else if (availPhenotypes.length > 0) {
                            $('#trait-input').val(availPhenotypes[0]);
                        }
                    }
                },
                error: function (jqXHR, exception) {
                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };


        var fillGenePhenotypeCompoundDropdown = function (dataSetJson,
                                                          phenotypeDropDownIdentifier,
                                                          includeDefault,
                                                          phenotypesToOmit) { // help text for each row
            if ((typeof dataSetJson !== 'undefined')  &&
                (typeof dataSetJson["is_error"] !== 'undefined')&&
                (dataSetJson["is_error"] === false)&&
                (typeof dataSetJson["pheotypeRecords"]  !== 'undefined' )&&
                ( dataSetJson["pheotypeRecords"].length > 0 ))
            {
                var options = $(phenotypeDropDownIdentifier);

                options.empty();

                var keys = dataSetJson.preferredGroups;

                // begin by retrieving the most desirable phenotype groups
                _.forEach(keys,function(key){
                    var groupObjectPointer;
                    var groupContents =  _.filter(dataSetJson.pheotypeRecords, function(oneGroup){
                        return oneGroup.group === key;

                    });
                    var groupObjectPointer = _.find(dataSetJson.pheotypeRecords, function(oneGroup){
                        return oneGroup.group === key;
                    });
                    var uniquePhenotypeIdentifier = "";
                    if (groupContents.length > 0){
                        options.append("<optgroup label='"+key+"'>");
                        _.forEach (groupContents, function (oneElement){
                            options.append($("<option />").val(oneElement.name)
                                .html("&nbsp;&nbsp;&nbsp;" + oneElement.translatedPhenotype));
                        });
                        options.append("</optgroup label='"+key+"'>");;
                    }
                });


                // enable the input
                options.prop('disabled', false);

            }
        }

        var retrieveGenePhenotypes = function () {
            var homePageVars = getHomePageVariables();
            $.ajax({
                cache: false,
                type: "get",
                url: homePageVars.getGeneLevelResultsUrl,
                data: {},
                async: true
            }).done(
                function (data) {
                    if (( data !==  null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.is_error !== 'undefined' ) &&
                        (  !data.is_error ) ) {

                        fillGenePhenotypeCompoundDropdown(data,homePageVars.geneTraitInput,undefined,undefined,homePageVars.defaultPhenotype);
                        var availPhenotypes = [];
                        _.forEach( $("select"+homePageVars.geneTraitInput+"  option"), function(a){
                            availPhenotypes.push($(a).val());
                        });
                        if (availPhenotypes.indexOf(homePageVars.defaultPhenotype)>-1){
                            $(homePageVars.geneTraitInput).val(homePageVars.defaultPhenotype);
                        } else if (availPhenotypes.length>0){
                            $(homePageVars.geneTraitInput).val(availPhenotypes[0]);
                        }
                    }
                }).fail(function (jqXHR, textStatus, errorThrown) {
                    loading.hide();
                    core.errorReporter(jqXHR, errorThrown)
                }
            );
        };

        var initializeInputFields = function (){
            var homePageVars = getHomePageVariables();

            /***
             * type ahead recognizing genes
             */
            $(homePageVars.generalizedVariantInput).typeahead({
                source: function (query, process) {
                    $.get(homePageVars.geneIndexUrl, {query: query}, function (data) {
                        process(data);
                    })
                },
                afterSelect: function(selection) {
                    window.location.href = homePageVars.findTheRightDataPageUrl +"/" + selection;
                }
            });

            /***
             * type ahead recognizing genes
             */
            $(homePageVars.generalizedGeneInput).typeahead({
                source: function (query, process) {
                    $.get(homePageVars.geneIndexUrl, {query: query}, function (data) {
                        process(data);
                    })
                },
                afterSelect: function(selection) {
                    window.location.href = homePageVars.findEveryVariantForAGeneUrl +"?gene=" + selection;
                }
            });


            /***
             * respond to end-of-search-line button
             */
            $(homePageVars.generalizedVariantGo).on('click', function () {
                var somethingSymbol = $(homePageVars.generalizedVariantInput).val().replace(/^[a-zA-Z0-9_:]+$/gi,'');
                if (somethingSymbol) {
                    window.location.href = homePageVars.findTheRightDataPageUrl +"/" +somethingSymbol;
                }
            });
            /***
             * respond to end-of-search-line button
             */
            $(homePageVars.generalizedGeneGo).on('click', function () {
                var somethingSymbol = $(homePageVars.generalizedGeneInput).val().replace(/^[a-zA-Z0-9_:]+$/gi,'');
                if (somethingSymbol) {
                    window.location.href = homePageVars.findTheRightGenePageUrl +"?symbol=" + somethingSymbol;
                }
            });



            /***
             * capture enter key, make it equivalent to clicking on end-of-search-line button
             */
            $(homePageVars.generalizedGeneInput).keypress(function (e) { // capture enter keypress
                var k = e.keyCode || e.which;
                if (k == 13) {
                    $(homePageVars.generalizedGeneGo).click();
                }
            });

            $(homePageVars.generalizedVariantInput).keypress(function (e) { // capture enter keypress
                var k = e.keyCode || e.which;
                if (k == 13) {
                    $(homePageVars.generalizedVariantGo).click();
                }
            });

            /***
             *  Launch find variants associated with other traits
             */
            $(homePageVars.traitSearchLaunch).on('click', function () {
                var trait_val = $(homePageVars.traitInput+' option:selected').val();
                var significance = 0.0005;
                if (trait_val == "" || significance == 0) {
                    alert('Please choose a trait and enter a valid significance!')
                } else {
                    window.location.href = homePageVars.traitSearchUrl + "?trait=" + trait_val + "&significance=" + significance;
                }
            });

            /***
             *  Launch find genes associated with other traits
             */
            $(homePageVars.geneTraitSearchLaunch).on('click', function () {
                var trait_val = $(homePageVars.geneTraitInput+ ' option:selected').val();
                var significance = 0.0005;
                if (trait_val == "" || significance == 0) {
                    alert('Please choose a trait and enter a valid significance!')
                } else {
                    window.location.href = homePageVars.genePrioritizationUrl + "?trait=" + trait_val + "&significance=" + significance;
                }
            });

        };


        return {
            initializeInputFields:initializeInputFields,
            retrieveAllPortalsInfo:retrieveAllPortalsInfo,
            loadNewsFeed: loadNewsFeed,
            setSlideWindows: setSlideWindows,
            setHomePageVariables:setHomePageVariables,
            retrieveGenePhenotypes:retrieveGenePhenotypes,
            retrievePhenotypes:retrievePhenotypes
        }
    })();
})();
