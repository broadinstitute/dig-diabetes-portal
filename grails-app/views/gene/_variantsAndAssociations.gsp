
%{--<g:set var="vAndARows" value="${new GspToJavascript(rowInformation as List)}" />--}%
<a name="associations"></a>

%{--<h2><strong>Variants and associations</strong></h2>--}%

<h3>
    %{--Explore variants within 100kb of <em>${geneName}</em>--}%
    <g:message code="gene.variantassociations.mainDirective" default="Explore" args="[geneName]"/>
</h3>
<p></p>
<p>
    %{--Click on a number below to generate a table of variants associated with type 2 diabetes in the following categories:--}%
    <g:message code="gene.variantassociations.subDirective" default="Click on a number below to generate a table of variants associated with type 2 diabetes in the following categories:"/></p>
<br/>

<g:render template="variantsAndAssociationsTableChanger"/>

<div class="row clearfix">
    <div class="col-md-3">
        <select class="form-control" id="phenotypeTableChooser" name="phenotypeTableChooser" onchange="refreshVAndAByPhenotype(this)">

        </select>
    </div>
    <div class="col-md-6">

    </div>
    <div class="col-md-3">
        <button id="opener"  class="pull-right btn btn-default">Revise columns</button>
    </div>
</div>

<table id="variantsAndAssociationsTable" class="table table-striped distinctivetable distinctive">
    <thead id="variantsAndAssociationsHead">
    </thead>
    <tbody id="variantsAndAssociationsTableBody">
    </tbody>
</table>

<div class="row clearfix">
    <div class="col-md-9">

    </div>
    <div class="col-md-3">
        <button id="reviser"  class="btn btn-primary" onclick="reviseRows()">Revise rows</button>
    </div>
</div>


<g:javascript>
function reviseRows(){
  var phenotype = $('#phenotypeTableChooser option:selected').val();
  var clickedBoxes =  $('.jstree-clicked');
  var dataSetNames  = [];
  var dataSetMaps  = [];
  for  ( var i = 0 ; i < clickedBoxes.length ; i++ )   {
      var  comboName  =  $(clickedBoxes[i]).attr('id');
      var partsOfCombo =   comboName.split("^");
      var  dataSetWithoutAnchor  =  partsOfCombo[0];
      dataSetNames.push(dataSetWithoutAnchor);
      var  dataSetMap = {"name":dataSetWithoutAnchor,
                          "value":dataSetWithoutAnchor,
                          "pvalue":partsOfCombo[1],
                          "count":partsOfCombo[2].substring(0, partsOfCombo[2].length-7)};
      dataSetMaps.push(dataSetMap);
  }
  variantsAndAssociationTable (phenotype,dataSetNames,dataSetMaps);
}
$( document ).ready(function() {
  // initialize the v and a adjuster widget
  $(function() {
    $( "#dialog" ).dialog({
      autoOpen: false,
      show: {
        effect: "fade",
        duration: 500
      },
      hide: {
        effect: "fade",
        duration: 500
      },
      width: 560,
      modal: true
    });
    $(".ui-dialog-titlebar").hide();
  });

  // initialize the main phenotype drop-down
  $(function() {
        $.ajax({
            cache: false,
            type: "post",
            url: "${createLink(controller: 'VariantSearch', action: 'retrievePhenotypesAjax')}",
            data: {},
            async: true,
            success: function (data) {
                if (( data !==  null ) &&
                        ( typeof data !== 'undefined') &&
                        ( typeof data.datasets !== 'undefined' ) &&
                        (  data.datasets !==  null ) ) {
                    UTILS.fillPhenotypeCompoundDropdown(data.datasets,'#phenotypeTableChooser',true);
                    // Can we set the default option on the phenotype list?
                    $('#phenotypeTableChooser').val('${phenotype}');
                    refreshVAndAByPhenotype({'value':'T2D'});
                    // resetting the phenotype clears all boxes except for the technology chooser
                }
            },
            error: function (jqXHR, exception) {
                core.errorReporter(jqXHR, exception);
            }
        });
  });

    // open the v and a adjuster widget
    var popUpVAndAExtender = function() {
          $( "#dialog" ).dialog( "open" );
        };

    // attach the opening function to a DOM ID
    $( "#opener" ).click(popUpVAndAExtender);
});
var insertVandARow  = function(name, value) {
      var counter = 100;
      $('#vandaRowHolder').add("<label><input type='checkbox' class='checkbox checkbox-primary' name='savedRow"+counter+"' class='form-control' id='savedRow"+counter+"' value='"+name+"^"+value+"^47' checked>"+name+"</label>");
      return false;
 };
//$( "#opener" ).click(popUpVAndAExtender());


</g:javascript>




<g:if test="${show_gwas}">
    <span id="gwasTraits"></span>
</g:if>

