<a name="associations"></a>

%{--<h2><strong>Variants and associations</strong></h2>--}%

<h3>
    Explore all variants within 100kb of <em>${geneName}</em>
</h3>
<p></p>
<p>
    Click on a number below to generate a table of variance in a category of interest.
</p>
<br/>


<table id="variantsAndAssociationsTable" class="table table-striped distinctivetable distinctive">
    <thead id="variantsAndAssociationsHead">
    </thead>
    <tbody id="variantsAndAssociationsTableBody">
    </tbody>
</table>


<g:if test="${show_gwas}">
    <span id="gwasTraits"></span>
</g:if>

%{--<p><a class="boldlink"  id="linkToVariantTraitCross">--}%
    %{--See p-values and other statistics across 25 traits for all GWAS variants included in this portal</a>--}%

%{--</p>--}%
%{--<p><a class="boldlink" href="<g:createLink controller='trait' action='genomeBrowser'/>?id=${geneName}">--}%
    %{--Browse p-values for disease-associated variance within 100kb of <em><strong>${geneName}</strong></em>--}%
%{--</a>--}%

%{--<p>--}%
    %{--T2D data are shown by default. Use the checkboxes below the browser to add data from GWAS of related traits (e.g. BMI)--}%
%{--</p>--}%
