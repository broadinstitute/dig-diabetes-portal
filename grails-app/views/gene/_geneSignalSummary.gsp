<style>
.trafficExplanations {
    margin: 8px 0 10px 0;
    font-family: "Times New Roman", Times, serif;
    font-style: normal;
    font-size: 24px;
    font-weight: 100;
}
.trafficExplanations.emphasize {
    font-weight: 900;
}
</style>


<div class="panel panel-default">%{--should hold the Choose data set panel--}%

    <div class="panel-heading" style = "background-color: #E0F3FD">
        <div class="row">
            <div class="col-md-2 col-xs-12">
                <g:if test="${signalLevel==1}">
                    <r:img uri="/images/redlight.png"/>
                </g:if>
                <g:elseif test="${signalLevel==2}">
                    <r:img uri="/images/yellowlight.png"/>
                </g:elseif>
                <g:elseif test="${signalLevel==3}">
                    <r:img uri="/images/greenlight.png"/>
                </g:elseif>
            </div>
            <div class="col-md-8 col-xs-12">
                <div class="row">
                    <div class="col-lg-12 trafficExplanations trafficExplanation1">
                        Evidence of no signal
                    </div>
                    <div class="col-lg-12 trafficExplanations trafficExplanation2">
                        Absence of strong evidence
                    </div>
                    <div class="col-lg-12 trafficExplanations trafficExplanation3">
                        Signal exists
                    </div>
                </div>
            </div>
            <div class="col-md-2 col-xs-12">
                <button name="singlebutton"
                        class="btn btn-secondary btn-lg burden-test-btn vcenter">Summary</button>
            </div>

        </div>
    </div>


</div>
<script>
    var mpgSoftware = mpgSoftware || {};


    (function () {
        "use strict";


        mpgSoftware.geneSignalSummary = (function () {

            var updateDisplayBasedOnSignificanceLevel = function (significanceLevel) {
                var significanceLevelDom = $('.trafficExplanation'+significanceLevel);
                if (typeof significanceLevelDom !== 'undefined') {
                    significanceLevelDom.addClass('emphasize');
                }
            };
            return {
                // private routines MADE PUBLIC FOR UNIT TESTING ONLY (find a way to do this in test mode only)
                updateDisplayBasedOnSignificanceLevel: updateDisplayBasedOnSignificanceLevel
            }
        }());
    })();

    $( document ).ready(function() {
        mpgSoftware.geneSignalSummary.updateDisplayBasedOnSignificanceLevel (${signalLevel});
    });
</script>

