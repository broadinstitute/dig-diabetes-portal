<h2>Credible set information</h2>
<div class="row clearfix">
    <div class="row clearfix">
        <div class="col-md-3 col-lg-offset-2">
            <h4>Genome coordinates:</h4>
        </div>
        <div class="col-md-7 regionParams">
            <ul class="pull-left list-unstyled">
                <li>Chromosome ${regionDescription.chromosomeNumber}</li>
                <li>${regionDescription.startExtent} - ${regionDescription.endExtent}</li>
            </ul>
        </div>
    </div>
    <div class="row clearfix">
        <div class="col-md-3 col-lg-offset-2">
            <h4>Genes in window:</h4>
        </div>
        <div class="col-md-7 regionParams">
            <div class="matchedGenesGoHere"></div>
        </div>
    </div>
    <div class="row clearfix">
        <div class="col-md-3 col-lg-offset-2">
            <h4>Credible set:</h4>
        </div>
        <div class="col-md-7 regionParams" style="padding-top:10px">
            [credible set name]
        </div>
    </div>
</div>
<g:render template="../templates/variantSearchResultsTemplate" />
<script>
    $(document).ready(function () {
        var identifiedGenes = "${identifiedGenes}";
        var drivingVariables = {};
        drivingVariables["allGenes"] = identifiedGenes.replace("[","").replace(" ","").replace("]","").split(',');
        drivingVariables["namedGeneArray"] = [];
        drivingVariables["supressTitle"] = [1];
        if ((drivingVariables["allGenes"].length>0)&&
            (drivingVariables["allGenes"][0].length>0)) {
            drivingVariables["namedGeneArray"] = _.map(drivingVariables["allGenes"], function (o) {
                return {'name': o}
            });
        }
        $(".matchedGenesGoHere").empty().append(
            Mustache.render( $('#dataRegionTemplate')[0].innerHTML,drivingVariables)
        );


    });
</script>
