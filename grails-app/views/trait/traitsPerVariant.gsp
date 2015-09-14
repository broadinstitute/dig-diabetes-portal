<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="tableViewer,traitInfo"/>
    <r:layoutResources/>
</head>

<body>
<script>
    var variant;
    var loading = $('#spinner').show();
    $.ajax({
        cache:false,
        type:"post",
        url:"../ajaxTraitsPerVariant",
        data:{variantIdentifier:'<%=variantIdentifier%>'},
        async:true,
        success: function (data) {
            mpgSoftware.trait.fillTheTraitsPerVariantFields(data,
                    '#traitsPerVariantTableBody',
                    '#traitsPerVariantTable',
                    ${show_gene},
                    ${show_exseq},
                    ${show_exchp},
                    '<g:createLink controller="trait" action="traitSearch" />');
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception) ;
        }
    });
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >

                <g:render template="traitsPerVariantTable" />

            </div>

        </div>
    </div>

</div>

</body>
</html>

