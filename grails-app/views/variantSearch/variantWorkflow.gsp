<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="variantWF"/>
    <r:layoutResources/>
</head>

<body>


<div id="main">

    <div class="container" >

        <div class="variantWF-container" >
            <div class="variant-view" >

                <div class="row clearfix">
                    <div class="col-md-6">
                        <h4>Specify a request</h4>
                        <g:render template="variantWFSpec" />
                    </div>
                    <div  class="col-md-6">

                        <g:render template="variantWFDescr" />

                    </div>
                </div>




           </div>

        </div>
    </div>

</div>
<script>
    initializeFields( encParams);
</script>

</body>
</html>

