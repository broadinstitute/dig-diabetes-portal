<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>

<div id="main">



    <h1>
        <em><%=gene_info.ID%></em>
        <a class="page-nav-link" href="#associations">Associations</a>
        <a class="page-nav-link" href="#populations">Populations</a>
        <a class="page-nav-link" href="#biology">Biology</a>
    </h1>

    <g:if test="(gene_info.GENE_SUMMARY_TOP)">
        <div class="gene-summary">
            <div class="title">Curated Summary</div>

            <div class="top">
                <%=gene_info.GENE_SUMMARY_TOP%>
            </div>

            <div class="bottom ishidden" style="display: none;">
                <%=gene_info.GENE_SUMMARY_BOTTOM%>
            </div>
            <a class="boldlink" id="gene-summary-expand">click to expand</a>
        </div>
    </g:if>



    <p><strong>Uniprot Summary:</strong> <%=gene_info.Function_description%></p>

    <div class="separator"></div>



    <g:render template="variantsAndAssociations" />



</div>

</body>
</html>

