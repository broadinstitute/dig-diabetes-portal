




<g:if test="${show_exseq || show_sigma}">

                <div id="carrierStatusExist" style="display: block">


                    <p>
                    <div id="carrierStatusDiseaseRiskChart"></div>
                </p>

                </div>

                <div id="carrierStatusNoExist" style="display: none">

                    <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/></h4>

                </div>


</g:if>

<g:if test="${show_sigma}">


    <span id="sigmaVariantCharacterization"></span>

</g:if>



