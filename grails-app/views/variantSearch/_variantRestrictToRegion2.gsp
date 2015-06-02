
<div class="row clearfix">
    <div class="col-md-12">
        <div id="datatypes-form">
            <div class="row" style="margin: 30px 0 10px 0">
                <div class="col-xs-3" style="text-align: right;"><g:message code="variantSearch.restrictToRegion.gene" default="Gene" /></div>
                <div class="col-xs-9 text-center smallish">
                    <input type="text" class="form-control" id="region_gene_input" style="width: 90%; display: inline-block"/>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-3" style="text-align: right;"><g:message code="variantSearch.restrictToRegion.region" default="Region" /></div>
                <div class="col-xs-9 smallish">
                    <input class="form-control" type="text" id="region_chrom_input" style="width: 30%; display: inline-block" placeholder="chrom"/>

                    <input class="form-control" type="text" id="region_start_input" style="width: 30%; display: inline-block" placeholder="start"/>

                    <input class="form-control" type="text" id="region_stop_input" style="width: 30%; display: inline-block" placeholder="stop"/>
                    <g:helpText title="variantSearch.restrictToRegion.region.regionStopQ.help.header" placement="right" body="variantSearch.restrictToRegion.region.regionStopQ.help.header"/>
                </div>
            </div>
        </div>
    </div>
</div>
