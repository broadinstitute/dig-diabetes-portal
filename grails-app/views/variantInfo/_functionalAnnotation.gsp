<style>
#functionalDataTableGoesHere_wrapper table.dataTable tbody td {
    padding: 0 0 0 5px;
}
div.graphicsDisplay {
    display: -webkit-inline-box;
}
</style>
<g:if test="${!g.portalTypeString()?.equals('mi')}">
    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle collapsed" data-toggle="collapse"
               data-parent="#accordionVariant"
               href="#collapseFunctionalData">
                <h2><strong>Epigenomic annotations</strong></h2>
            </a>
        </div>
        <div id="collapseFunctionalData" class="accordion-body collapse" style="padding: 0 20px;">
            <div class="accordion-inner"><p><g:message code="variant.epigenomic.text1"></g:message></p>
                <p><g:message code="variant.epigenomic.text2"></g:message></p>
                <p><g:message code="variant.epigenomic.text3"></g:message></p>
                <div class="row">
                    <div class="xs-col-12">
                        <div id="functionalDateGoesHere"></div>
                        <table id="functionalDataTableGoesHere" class="dk-t2d-general-table"></table>
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

                <!--<img src="${resource(dir:'images', file:'epigenomic_color_key.png')}" style="width: 1100px;">-->
                <style>
                .epigenomic-annotations2 td{
                    display: block;
                    float: left;
                    font-size: 14px;
                    line-height: 12px;
                    padding: 1px 8px 0 5px;
                    margin-bottom:5px;
                }
                </style>
                <div class="row">
                    <div class="col-md-12">
                        <h5>Color key:</h5>
                        <table class="epigenomic-annotations2" style="min-width:900px;">
                            <tr>
                                <td style="border-left:solid  12px #ff0000;">Active transcription start site</td>
                                <td style="border-left:solid  12px #ff4500;">Weak/flanking transcription start site</td>
                                <td style="border-left:solid  12px #cd5c5c;">Bivalent/poised transcription start site</td>
                                <td style="border-left:solid  12px #ffc34d;">Active enhancer 1/2</td>
                                <td style="border-left:solid  12px #ffff00;">Weak enhancer</td>
                            </tr>
                            <tr>
                                <td style="border-left:solid  12px #c2e105;">Genic enhancer</td>
                                <td style="border-left:solid  12px #008000;">Strong transcription</td>
                                <td style="border-left:solid  12px #006400;">Weak transcription</td>
                                <td style="border-left:solid  12px #808080;">Repressed polycomb</td>
                                <td style="border-left:solid  12px #c0c0c0;">Weak repressed polycomb</td>
                                <td style="border-left:solid  12px #dddddd;">Quiescent/low signal</td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div>


        </div>
    </div>
    <div class="separator"></div>
</g:if>