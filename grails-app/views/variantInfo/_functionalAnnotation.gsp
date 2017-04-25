<style>
#functionalDataTableGoesHere_wrapper table.dataTable tbody td {
    padding: 0 0 0 5px;
}
div.graphicsDisplay {
    display: -webkit-inline-box;
}
</style>
<div class="accordion-group">
    <div class="accordion-heading">
        <a class="accordion-toggle" data-toggle="collapse"
           data-parent="#accordionVariant"
           href="#collapseFunctionalData">
            <h2><strong>Functional annotations</strong></h2>
        </a>
    </div>

    <div id="collapseFunctionalData" class="accordion-body collapse">
        <div class="accordion-inner">
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
                            <h4>Tissue summary</h4>
                        </div>
                    </div>
                    <div class="row">
                        <div class="md-col-12">
                            <div id="chart1"></div>
                        </div>
                    </div>
                </div>
                <div class="md-col-6" style="margin-left: 80px">
                    <div class="row">
                        <div class="xs-col-6"></div>
                        <div class="xs-col-6" style="margin-left: 250px">
                            <h4>Element positions</h4>
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
