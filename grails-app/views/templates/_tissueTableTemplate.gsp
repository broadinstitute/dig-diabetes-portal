<g:render template="/templates/dynamicUi/EFF" />

<script id="mainTissueTableOrganizer"  type="x-tmpl-mustache">
    <div class="container">
        <div class="row">
            <div class="text-center">
                <h1 class="dk-page-title">Tissue table for <span class="phenotypeSpecifier">{{phenotype}}</span></h1>
            </div>
            <div class="col-md-12">
                <div class="row">
                    <div class="col-md-12">
                        <select class="phenotypePicker">
                        </select>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div id="tissueTableHolder" class="mainEffectorDiv">
                    <table class="tissueTableHolder">
                    </table>
                </div>
            </div>
        </div>
    </div>
</script>
