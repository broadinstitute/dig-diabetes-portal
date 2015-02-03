var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";


    mpgSoftware.informational = (function () {


        var buttonManager = function ( buttonIdentifiers,
                                       baseUrlForCallbacks,
                                       returningDataGoesHere ){
            $(buttonIdentifiers).on('click', function (e) {
                var activeNav = $(e.target.parentNode);
                if (typeof activeNav.attr('id') !== 'undefined') {
                    var activeNavName = activeNav.attr('id').split('_')[1];
                    $('.nav-pills  li').removeClass('active');
                    $('.nav-pills  li').removeClass('activated');
                    activeNav.addClass('active');
                    activeNav.addClass('activated');
                    $('.nav-pills  li').removeClass('active');
                    activeNav.addClass('active');
                    $.ajax({
                        cache: false,
                        type: "get",
                        url: baseUrlForCallbacks + "/" + activeNavName,
                        async: true,
                        success: function (data) {
                            $(returningDataGoesHere).empty().html(data);
                        },
                        error: function (jqXHR, exception) {
                            core.errorReporter(jqXHR, exception);
                        }
                    });
                }
            });

        };

        return {
            buttonManager: buttonManager
        }


    }());

})();