<g:render template="../widgets/datasetsPageTemplate"/>

<script>
    $(document).ready(function(){
        var filterDatatype = "Show all";
        mpgSoftware.datasetsPage.displaySelectedTechnology(filterDatatype,undefined,"${createLink(controller:'informational',action: 'aboutTheDataAjax')}");
    });

</script>



<div class="row" style="padding-top: 50px; display: inline-block">
    <div>
        <div class="datasets-filter row">
            <h4>Filter Dataset Table<small> (Click one to start)</small></h4>

            <div id="datatypeFilterDisplay" class="form-inline"></div>
            <div id="phenotypeFilterLevel1Display" class="form-inline"></div>
            <div id="phenotypeFilterLevel2Display" class="form-inline"></div>
        </div>
        <div  id ="metaDataDisplay" class="form-inline"></div>
    </div>
</div>














