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
        <a class="accordion-toggle" data-toggle="collapse"
           data-parent="#accordionVariant"
           href="#collapseFunctionalData">
            <h2><strong>Epigenomic annotations</strong></h2>
        </a>
    </div>
    <div id="collapseFunctionalData" class="accordion-body collapse">
        <div class="accordion-inner"><p><g:message code="variant.epigenomic.text1"></g:message></p>
            <p><g:message code="variant.epigenomic.text2"></g:message></p>
            <div class="row">
                <div class="xs-col-12">
                    <div id="functionalDateGoesHere"></div>
                        <table id="functionalDataTableGoesHere"></table>
                </div>
            </div>
            <div style="margin-top:80px">
            <table><tr>
                <td>
                    <g:message code="variant.variantAssociations.legend.colorkey" default="Color key"/>:
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #006633; color: #fff; width:auto; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="variant.variantAssociations.legend.colorkey.genomewide"
                                                                                default="p &lt; 5e-8" />  <g:helpText title="variant.variantAssociations.colorkeyGenomewide.help.header" placement="bottom" body="variant.variantAssociations.colorkeyGenomewide.help.text"/></span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #7AB317; color: #fff; width:auto; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="variant.variantAssociations.legend.colorkey.locuswide"
                                                                                default="p &lt; 5e-5" />  <g:helpText title="variant.variantAssociations.colorkeyLocuswide.help.header" placement="bottom" body="variant.variantAssociations.colorkeyLocuswide.help.text"/></span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #9ED54C; color: #fff; width:auto; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="variant.variantAssociations.legend.colorkey.nominal"
                                                                                default="p &lt; 0.05" />  <g:helpText title="variant.variantAssociations.colorkeyNominal.help.header" placement="bottom" body="variant.variantAssociations.colorkeyNominal.help.text"/></span>
                </div>
                </td>
            </tr></table>
            </div>

            <div style="margin-top:20px" class="row graphicsDisplay">
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

        </div>
    </div>
</div>
</g:if>