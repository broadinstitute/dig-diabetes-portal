<script id="credibleSetTableTemplate"  type="x-tmpl-mustache">
<div class='dataTable'>
<h5>Variants in the credible set</h5>
<table class="table table-striped dk-search-result dataTable no-footer" style="border-collapse: collapse; width: 100%;">
    <thead>
        <tr>
            <th></th>
            <th></th>
            {{#variants}}
                <th class="niceHeaders">
                    {{name}}
                </th>
            {{/variants}}
        </tr>
    </thead>
    <tbody>
    {{#const}}

        <tr>
            <td></td>
            <td>Coding</td>
        {{#coding}}
            <td class="{{descr}}">{{val}}</td>
        {{/coding}}
        </tr>

        <tr>
            <td></td>
            <td class="{{descr}}">Splice site</td>
            {{#spliceSite}}
            <td class="{{descr}}">{{val}}</td>
            {{/spliceSite}}
        </tr>

        <tr>
            <td></td>
            <td>UTR</td>
            {{#utr}}
            <td class="{{descr}}">{{val}}</td>
            {{/utr}}
        </tr>

        <tr>
            <td></td>
            <td class="{{descr}}">Promoter</td>
            {{#promoter}}
            <td class="{{descr}}">{{val}}</td>
            {{/promoter}}
        </tr>

    {{/const}}

    {{#cellTypeSpecs}}

        <tr>
            <td></td>
            <td>{{name}} DHS</td>
            {{#DHS}}
            <td>{{val}}</td>
            {{/DHS}}
        </tr>
        <tr>
            <td></td>
            <td>{{name}} H3K27AC</td>
            {{#K27}}
            <td>{{val}}</td>
            {{/K27}}
        </tr>

    {{/cellTypeSpecs}}
    </tbody>
</table>
</div>
</script>
%{--<g:render template="../templates/variantSearchResultsTemplate" />--}%
<div class="credibleSetTableGoesHere">

</div>
<script>

$(document).ready(function () {

    var setToRecall = {chromosome: "${regionDescription.chromosomeNumber}",
        start: ${regionDescription.startExtent},
        end: ${regionDescription.endExtent},
        phenotype: 'T2D',
            propertyName: 'P_VALUE',
        dataSet: 'GWAS_DIAGRAM_eu_onlyMetaboChip_CrdSet_mdv27',
        fillCredibleSetTableUrl:"${g.createLink(controller: 'RegionInfo', action: 'fillCredibleSetTable')}"
    };
    mpgSoftware.regionInfo.fillRegionInfoTable(setToRecall);

});
</script>

