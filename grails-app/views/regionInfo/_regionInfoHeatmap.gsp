<script id="credibleSetTableTemplate"  type="x-tmpl-mustache">
<table>
    <thead>
        <th></th>
        <th></th>
        {{#variants}}
            <th>
                {{name}}
            </th>
        {{/variants}}
    </thead>
    <tbody>
    {{#const}}

        <tr>
            <td></td>
            <td>Coding</td>
        {{#coding}}
            <td>{{val}}</td>
        {{/coding}}
        </tr>

        <tr>
            <td></td>
            <td>Splice site</td>
            {{#spliceSite}}
            <td>{{val}}</td>
            {{/spliceSite}}
        </tr>

        <tr>
            <td></td>
            <td>UTR</td>
            {{#utr}}
            <td>{{val}}</td>
            {{/utr}}
        </tr>

        <tr>
            <td></td>
            <td>Promoter</td>
            {{#promoter}}
            <td>{{val}}</td>
            {{/promoter}}
        </tr>

    {{/const}}

    {{#cellTypeSpecs}}

        <tr>
            <td></td>
            <td>{{name}}</td>
            {{#DHS}}
            <td>{{val}}</td>
            {{/DHS}}
        </tr>
        <tr>
            <td></td>
            <td>{{name}} (H3K27AC)</td>
            {{#K27}}
            <td>{{val}}</td>
            {{/K27}}
        </tr>

    {{/cellTypeSpecs}}
    </tbody>
</table>

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

