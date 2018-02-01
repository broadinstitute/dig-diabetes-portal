var mpgSoftware = mpgSoftware || {};

(function () {
    "use strict";

    mpgSoftware.homePage = (function () {

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


        return {
            retrieveAllPortalsInfo:retrieveAllPortalsInfo,
            loadNewsFeed: loadNewsFeed,
            setSlideWindows: setSlideWindows
        }
    })();
})();