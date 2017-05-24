<style>
#functionalDataTableGoesHere_wrapper table.dataTable tbody td {
    padding: 0 0 0 5px;
}
div.graphicsDisplay {
    display: -webkit-inline-box;
}
</style>
<g:if test="${g.portalTypeString()?.equals('t2d')}">
<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle collapsed" data-toggle="collapse"
           data-parent="#accordionVariant"
           href="#collapseFunctionalData">
            <h2><strong>Epigenomic annotations</strong></h2>
        </a>
    </div>
    <div id="collapseFunctionalData" class="accordion-body collapse">
        <div class="accordion-inner"><p><g:message code="variant.epigenomic.text1"></g:message></p>
            <p><g:message code="variant.epigenomic.text2"></g:message></p>
            <p><g:message code="variant.epigenomic.text3"></g:message></p>
            <div class="row">
                <div class="xs-col-12">
                    <div id="functionalDateGoesHere"></div>
                        <table id="functionalDataTableGoesHere"></table>
                </div>
            </div>

            <div style="margin-top:80px" class="row graphicsDisplay">
                <div class="md-col-6">
                    <div class="row">
                        <div class="md-col-12"  style="margin-left: 150px">
                            <h4>Tissue summary <g:helpText title="variant.epigenomic.tissue_summary.help.header" placement="right" body="variant.epigenomic.tissue_summary.help.text"/></h4>

                        </div>
                    </div>
                    <div class="row">
                        <div class="md-col-12">
                            <div id="chart1"></div>
                        </div>
                    </div>
                </div>
                <div class="md-col-6" style="margin-left: 50px">
                    <div class="row">
                        <div class="xs-col-6"></div>
                        <div class="xs-col-6" style="margin-left: 290px">
                            <h4>Chromatin state positions <g:helpText title="variant.epigenomic.chromatin_states.help.header" placement="top" body="variant.epigenomic.chromatin_states.help.text"/></h4>
                        </div>
                    </div>
                    <div class="row">
                        <div class="md-col-12">
                            <div id="chart2"></div>
                        </div>
                    </div>
                </div>
            </div>
<hr>

            <img src="${resource(dir:'images', file:'epigenomic_color_key.png')}">


            </div>


        </div>
    </div>
    <div class="separator"></div>
</g:if>