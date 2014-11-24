<!DOCTYPE html>
<html>
<head>

    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:require modules="geneInfo"/>
    <r:layoutResources/>

</head>

<body>

<div id="main">

    <div class="container">


        <div class="dynamicBurdenTest">
            <div class="row">
                <div class="accordion" id="accordionDbt">
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a  class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionDbt"
                                href="#collapseOne">
                                <h2><strong>Genes</strong></h2>
                            </a>
                        </div>
                        <div id="collapseOne" class="accordion-body collapse in">
                            <div class="accordion-inner">
                                <g:render template="geneFilters"/>
                            </div>
                        </div>
                    </div>
                    <div class="accordion-group">
                        <div class="accordion-heading">
                            <a  class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordionDbt"
                                href="#collapseTwo">
                                <h2><strong>Variant filters</strong></h2>
                            </a>
                        </div>
                        <div id="collapseTwo" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <g:render template="variantFilters"/>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <div class="row">

            </div>
         </div>
    </div>

</div>
<script>
    $('#accordionDbt').on('show.bs.collapse', function (e) {
        if (e.target.id === "collapseOne") {
//            if ((typeof delayedDataPresentation !== 'undefined') &&
//                    (typeof delayedDataPresentation.launch !== 'undefined')) {
//                delayedDataPresentation.launch();
//            }
            console.log('collapseOne caught');
        }
    });
    $('#accordionDbt').on('hide.bs.collapse', function (e) {
        if (e.target.id === "collapseTwo") {
//            if ((typeof delayedDataPresentation !== 'undefined') &&
//                    (typeof delayedDataPresentation.launch !== 'undefined')) {
//                delayedDataPresentation.removeBarchart();
//            }
            console.log('collapseTo caught');
        }
    });
    $( document ).ready(function() {
      //  console.log('prepping the document');
        $('#collapseOne').collapse('hide');
       $('#collapseTwo').collapse('hide');
    });

</script>

</body>

</html>

