
var mpgSoftware = mpgSoftware || {};


(function () {
    "use strict";
    mpgSoftware.moduleLaunch = (function () {

        var mySavedVariables = {};
        var setMySavedVariables = function(saveTheseVariables){
            mySavedVariables = saveTheseVariables;
        }

        var getMySavedVariables = function(){
            return mySavedVariables;
        }

        var launchLDClumping = function() {
            var rememVars = mpgSoftware.moduleLaunch.getMySavedVariables();
            var selectedVal = $('#phenotypeDropdown').val();
            var launchLDClumpURL = rememVars.traitSearchUrl + "?trait=" + selectedVal + "&significance=" + 0.0005;
            window.location.href = launchLDClumpURL;
        }

        var handleAjaxError = function() {
            var currentPage = window.location.href;
            var loginModal = '<div class="modal fade" id="mode3Modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">\n' +
                '  <div class="modal-dialog" role="document">\n' +
                '    <div class="modal-content">\n' +
                '      <div class="modal-body">\n' +
                '        <h3>There has been an error in loading data for the page. Please refresh the page.</h3>\n' +
                '      </div>\n' +
                '      <div class="modal-footer">\n' +
                '<a href="' + currentPage + '"><button type="button" class="btn btn-info">Refresh the page</button></a>\n' +
                '      </div>\n' +
                '    </div>\n' +
                '  </div>\n' +
                '</div>';
            $("body").append(loginModal);

            $('#mode3Modal').modal();
        }

        // called when page loads
        var fillPhenotypesDropdown = function (portaltype,WRAPPER,PHENOTYPELIST) {
            var rememVars = mpgSoftware.moduleLaunch.getMySavedVariables();
            var loading = $('#spinner').show();
            var rememberportaltype = portaltype;
            var wrapper = '#' + WRAPPER;

            $.ajax({
                cache: false,
                type: "post",
                url: rememVars.retrievePhenotypesAjaxUrl,
                data: {getNonePhenotype: false},
                async: true,
                success: function (data) {
                    if (( data !== null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !== null )) {

                        $(wrapper).append('<select class="'+ PHENOTYPELIST +' form-control selectpicker" data-live-search="true" id="'+ PHENOTYPELIST +'" name="'+ PHENOTYPELIST +'"></select>');

                        while ($("#"+ PHENOTYPELIST).length) {
                            UTILS.fillPhenotypeCompoundDropdown(data.datasets, "#" + PHENOTYPELIST, true, [], rememberportaltype);

                            break;
                        }
                    }

                    if (data.message == 'There is an error')
                    {
                        mpgSoftware.moduleLaunch.handleAjaxError();
                        return;
                    }

                    var startTime = new Date();

                    while ($("#"+ PHENOTYPELIST).find("option").length > 0) {
                        loading.hide();
                        console.log("phenotype list loaded");
                        break;
                    }

                    $('.'+PHENOTYPELIST+'.selectpicker').selectpicker('refresh');


                },
                error: function (jqXHR, exception) {

                    console.log(jqXHR);
                    console.log(exception);

                    mpgSoftware.moduleLaunch.handleAjaxError();

                    loading.hide();
                    core.errorReporter(jqXHR, exception);
                }
            });
        };

        return{
            fillPhenotypesDropdown: fillPhenotypesDropdown,
            setMySavedVariables:setMySavedVariables,
            getMySavedVariables:getMySavedVariables,
            launchLDClumping: launchLDClumping,
            handleAjaxError: handleAjaxError
        }
    }());


})();



