
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

<button id="opener"  class="pull-right btn btn-default">Revise table properties</button>
<table id="variantsAndAssociationsTable" class="table table-striped distinctivetable distinctive">
    <thead id="variantsAndAssociationsHead">
    </thead>
    <tbody id="variantsAndAssociationsTableBody">
    </tbody>
</table>


<g:javascript>
$( document ).ready(function() {
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

var popUpVAndAExtender = function() {
      $( "#dialog" ).dialog( "open" );
    };
$( "#opener" ).click(popUpVAndAExtender);
}
);
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

