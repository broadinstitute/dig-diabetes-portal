<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>
</head>

<body>
<script>
    var variant;
    $.ajax({
        cache:false,
        type:"post",
        url:"../ajaxTraitsPerVariant",
        data:{variantIdentifier:'<%=variantIdentifier%>'},
        async:true,
        success: function (data) {
            fillTheTraitsPerVariantFields(data) ;
            console.log('Finish processing information retrieved from traits per variant')
        }
    });



    function fillTheTraitsPerVariantFields (data)  {
        var variant =  data['traitInfo'];
        $('#traitsPerVariantTableBody').append(UTILS.fillTraitsPerVariantTable(variant, ${show_gene}, ${show_sigma}, ${show_exseq}, ${show_exchp} ));
        $('#traitsPerVariantTable').dataTable({
            iDisplayLength: 20,
            bFilter: false,
            aaSorting: [[ 1, "asc" ]],
            aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 1, 3, 4 ] } ]
        });
        console.log('fill The phenotypeTraits table');


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

