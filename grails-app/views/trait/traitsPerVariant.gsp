<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="tableViewer"/>
    <r:layoutResources/>
</head>

<body>
<script>
    var variant;
    var loading = $('#spinner').show();
    var  phenotypeMap =  new UTILS.phenotypeListConstructor (decodeURIComponent("${phenotypeList}")) ;
    $.ajax({
        cache:false,
        type:"post",
        url:"../ajaxTraitsPerVariant",
        data:{variantIdentifier:'<%=variantIdentifier%>'},
        async:true,
        success: function (data) {
            fillTheTraitsPerVariantFields(data) ;
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception) ;
        }
    });



    function fillTheTraitsPerVariantFields (data)  {
        var variant =  data['traitInfo'];
        $('#traitsPerVariantTableBody').append(variantProcessing.fillTraitsPerVariantTable(variant,
                ${show_gene},
                ${show_sigma},
                ${show_exseq},
                ${show_exchp},
                phenotypeMap,
                '<g:createLink controller="trait" action="traitSearch" />'));
        $('#traitsPerVariantTable').dataTable({
            iDisplayLength: 20,
            bFilter: false,
            aaSorting: [[ 1, "asc" ]],
            aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 1, 3, 4 ] } ]
        });
    }
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

