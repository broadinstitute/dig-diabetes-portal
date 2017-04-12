<script id="functionalAnnotationTemplate"  type="x-tmpl-mustache">
    <div class="row">
        <div class="col-xs-5 text-left">
            <span class="elementTissueSelectorLabel">Display element</span><select class="elementTissueSelector uniqueElements" onchange="mpgSoftware.variantInfo.displayChosenElements()">
            {{#uniqueElements}}
                <option>{{element}}</option>
            {{/uniqueElements}}
            </select>
        </div>
        <div class="col-xs-5 text-left">
            <span class="elementTissueSelectorLabel">Display tissues</span><select class="elementTissueSelector uniqueTissues" onchange="mpgSoftware.variantInfo.displayChosenElements()">
            {{#uniqueTissues}}
                <option>{{source}}</option>
            {{/uniqueTissues}}
            </select>
        </div>
        <div class="col-xs-2"></div>
     </div>
    <div class="row">
        <div class="col-xs-12 text-left">
            <table class='functionDescrTable'>
                {{#recordsExist}}
                    <tr class='headers'>
                        <th class='elementSpec' width=35%>Element</th>
                        <th width=35%>Tissue</th>
                        <th width=15%>Start position</th>
                        <th width=15%>End position</th>
                    </tr>
                {{/recordsExist}}
                {{#indivRecords}}
                    <tr class="elementTissueRows {{element}}__{{source}} {{element}} {{source}}">
                        <td class='elementSpec'>{{element}}</td>
                        <td>{{source}}</td>
                        <td>{{START}}</td>
                        <td>{{STOP}}</td>
                    </tr>
                {{/indivRecords}}
                {{^indivRecords}}
                No functional data are available for this variant
                {{/indivRecords}}
            </table>
        </div>
    </div>
</script>
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
            <div id="functionalDateGoesHere"></div>
        </div>
    </div>
</div>
