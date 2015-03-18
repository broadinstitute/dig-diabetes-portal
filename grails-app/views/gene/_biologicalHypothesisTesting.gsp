
<g:if test="${show_exseq || show_sigma}">


    <a name="biology"></a>

    <div class="translational-research-box">
        <p style="font-weight: 600"><g:message code="gene.biologicalhypothesis.question1" default="question 1" />
        <g:helpText title="gene.biologicalhypothesis.title.help.header" placement="left"
                    body="gene.biologicalhypothesis.title.help.text"/>
        </p>
    </div>
    <p></p>
    <p class="standardFont"  id="possibleCarrierVariantsLink">
    </p>
    <div class="row clearfix">
         <div class="col-md-10">
            <div class="barchartFormatter">
                <div id="chart">

                </div>
            </div>
         </div>
         <div  class="col-md-2">
                <div class="significanceDescriptorFormatter" id="significanceDescriptorFormatter">

                </div>
         </div>
    </div>

</g:if>
