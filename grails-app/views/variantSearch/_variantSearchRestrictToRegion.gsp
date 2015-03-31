
<h4><g:message code="variantSearch.restrictToRegion.title" default="Restrict to a region" /></h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="datatypes-form">
            <div class="row" style="margin-bottom: 20px;">
                <div class="col-xs-3" style="text-align: right;"><g:message code="variantSearch.restrictToRegion.gene" default="Gene" /></div>
                <div class="col-xs-6">
                    <input type="text" class="form-control" id="region_gene_input" style="width: 90%; display: inline-block"/>
                    <g:helpText title="variantSearch.restrictToRegion.region.geneInputQ.help.header" placement="right" body="variantSearch.restrictToRegion.region.geneInputQ.help.text"/>
                </div>
            </div>
            <div class="row">
                <div class="col-xs-3" style="text-align: right;"><g:message code="variantSearch.restrictToRegion.region" default="Region" /></div>
                <div class="col-xs-2">
                    <input class="form-control" type="text" id="region_chrom_input" placeholder="chrom"/>
                </div>
                <div class="col-xs-3">
                    <input class="form-control" type="text" id="region_start_input" style="width: 80%; display: inline-block" placeholder="start"/>
                </div>
                <div class="col-xs-3">
                    <input class="form-control" type="text" id="region_stop_input" style="width: 80%; display: inline-block" placeholder="stop"/>
                    <g:helpText title="variantSearch.restrictToRegion.region.regionStopQ.help.header" placement="right" body="variantSearch.restrictToRegion.region.regionStopQ.help.header"/>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-6">
    </div>
</div>
