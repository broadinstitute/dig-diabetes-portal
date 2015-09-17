<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="tableViewer,traitInfo"/>
    <r:layoutResources/>
</head>

<body>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >

                <g:render template="/widgets/associatedStatisticsTraitsPerVariant" model="['variantIdentifier': variantIdentifier]"/>

            </div>

        </div>
    </div>

</div>

</body>
</html>

