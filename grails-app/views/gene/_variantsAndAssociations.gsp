<a name="associations"></a>

<h3>
    <g:message code="gene.variantassociations.mainDirective" default="Explore" args="[geneName]"/>
</h3>

<p></p>

<p>
    <g:message code="gene.variantassociations.subDirective"
               default="Click on a number below to generate a table of variants associated with type 2 diabetes in the following categories:"/></p>
<br/>

<g:render template="variantsAndAssociationsTableChanger"/>


<div class="row clearfix">

    <div class="col-md-6" style="text-align: left; font-size: 18px; font-weight: bold">
        <div class="form-horizontal">
            <div class="form-group">
                <label for="phenotypeTableChooser"><g:message code="gene.variantassociations.change.phenotype"
                                                              default="Change phenotype choice"/></label>
                &nbsp;
                <select id="phenotypeTableChooser" name="phenotypeTableChooser"
                        onchange="refreshVAndAByPhenotype(this)">
                </select>
            </div>
        </div>

    </div>

    <div class="col-md-6">
        <button id="opener" class="btn btn-primary pull-right">
            <g:message code="gene.variantassociations.change.columns" default="Revise columns"/>
        </button>
    </div>
</div>

<table id="variantsAndAssociationsTable" class="table table-striped distinctivetable distinctive"
       style="border-bottom: 0">

    <thead id="variantsAndAssociationsHead">
    </thead>
    <tbody id="variantsAndAssociationsTableBody">
    </tbody>
</table>

<div class="row clearfix">

    <div class="col-md-2">
        <button id="reviser" class="btn btn-primary pull-left" onclick="reviseRows()">
            <g:message code="gene.variantassociations.change.rows" default="Revise rows"/>
        </button>
    </div>

    <div class="col-md-8">

    </div>

    <div class="col-md-2">

    </div>
</div>


<script>
    function reviseRows() {
        var phenotype = $('#phenotypeTableChooser option:selected').val();
        var clickedBoxes = $('#variantsAndAssociationsTable .jstree-clicked');
        var dataSetMaps = [];
        for (var i = 0; i < clickedBoxes.length; i++) {
            var comboName = $(clickedBoxes[i]).attr('id');
            var partsOfCombo = comboName.split("-");
            var dataSetWithoutAnchor = partsOfCombo[0];
            var dataSetMap = {
                "name": dataSetWithoutAnchor,
                "value": dataSetWithoutAnchor,
                "pvalue": partsOfCombo[1],
                "count": partsOfCombo[2].substring(0, partsOfCombo[2].length - 7)
            };
            dataSetMaps.push(dataSetMap);
        }
        variantsAndAssociationTable(phenotype, dataSetMaps);
    }

    $(document).ready(function () {
        mpgSoftware.geneInfo.prepVAndADisplay ("#dialog","#opener");
        mpgSoftware.geneInfo.fillPhenotypeDropDown('#phenotypeTableChooser',
                '${g.defaultPhenotype()}',
                "${createLink(controller: 'VariantSearch', action: 'retrievePhenotypesAjax')}",
                refreshVAndAByPhenotype );
    });



    var insertVandARow = function (name, value) {
        var counter = 100;
        $('#vandaRowHolder').add("<label><input type='checkbox' class='checkbox checkbox-primary' name='savedRow" + counter + "' class='form-control' id='savedRow" + counter + "' value='" + name + "^" + value + "^47' checked>" + name + "</label>");
        return false;
    };
</script>




<g:if test="${show_gwas}">
    <span id="gwasTraits"></span>
</g:if>
