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
            <div class="row">
                <div class="xs-col-12">
                    <div id="functionalDateGoesHere"></div>
                        <table id="functionalDataTableGoesHere"></table>
                </div>
            </div>
            <div style="margin-top:80px">
            <table><tr >
                <td>
                    <g:message code="variant.variantAssociations.legend.colorkey" default="Color key"/>:
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #ff0000; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="metadata.1_Active_TSS"
                                                                                default="Active TSS" />  </span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #ff4500; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="informational.epigenomic.weak-flanking_TSS"
                                                                                default="Weak or flanking TSS" />  </span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #cd5c5c; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="metadata.14_Bivalent/poised_TSS"
                                                                                default="Bivalent or poised TSS" />  </span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #FFC34D; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #000000; font-size: 12px;"><g:message code="informational.epigenomic.active_enhancer_1-2"
                                                                                default="Active enhancer 1 or 2" />  </span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #FFFF00; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #000000; font-size: 12px;"><g:message code="metadata.11_Weak_enhancer"
                                                                                default="Weak enhancer" />  </span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #c2e105; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #000000; font-size: 12px;"><g:message code="metadata.8_Genic_enhancer"
                                                                                default="Genic enhancer" />  </span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div style= "height:60px;">&nbsp;</div></td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #008000; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="metadata.5_Strong_transcription"
                                                                                default="Strong transcription" />  </span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #006400; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #FFFFFF; font-size: 12px;"><g:message code="metadata.6_Weak_transcription"
                                                                                default="Weak transcription" />  </span>
                </div>
                </td></tr>
                <tr>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                </tr>
                <tr>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>


                <td style="padding-right: 20px;"><div
                        style="background-color: #808080; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #000000; font-size: 12px;"><g:message code="metadata.16_Repressed_polycomb"
                                                                                default="Repressed polycomb" />  </span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #c0c0c0; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #000000; font-size: 12px;"><g:message code="metadata.17_Weak_repressed_polycomb"
                                                                                default="Weak repressed polycomb" />  </span>
                </div>
                </td>
                <td style="padding-right: 20px;"><div
                        style="background-color: #dddddd; color: #fff; width:95px; height:60px; margin-left: 5px; float: left; padding: 0 5px;"><span
                            style="color: #000000; font-size: 12px;"><g:message code="metadata.18_Quiescent/low_signal"
                                                                                default="Quiescent or low signal" />  </span>
                </div>
                </td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
                    <td style="padding-right: 20px;"><div style= "height:20px;">&nbsp;</div></td>
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