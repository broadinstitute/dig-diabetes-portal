%{--this will go inside grails-app/views/template(new folder created by BenA)--}%
%{--this will have all the mustache templates--}%

<script id="metaData2" type="x-tmpl-mustache">

    <div class="row" style="padding-top:30px; cursor: pointer">
        <h3>Datasets</h3>
        <table id="datasets" class="table table-condensed">
            <thead>
            <tr>
                <th>Dataset</th>
                <th>Access</th>
                <th>Samples</th>
                <th>Ancestry</th>
                <th>Data type</th>
            </tr>
            </thead>
        <tbody>
        <div class="accordion" id="accordion">
        {{#parents}}
        <tr>
            <td class="dataset">
                    <div class="accordion-group">
                        <div class="accordion-heading">
                                <a class="accordion-toggle collapsed" data-toggle="collapse" data-parent="#accordion"
                                   href="#{{name}}_myTarget" aria-expanded="true" aria-controls="{{name}}_myTarget">
                                   {{label}}
                                </a>
                        </div>
                        <div id="{{name}}_myTarget" class="accordion-body collapse">
                            <div class="accordion-inner">
                                <div id="{{name}}_script_holder"></div>
                            </div>
                        </div>
                    </div>
            </td>

            <td class="access" style="color:{{accessColor}}">{{access}} </td>
            <td class="samples">{{size}}</td>
            <td class="ethnicity">{{ancestry}}</td>
            <td class="datatype">{{technology}}</td>
        </tr>
        </div>
        {{/parents}}
        </tbody>
    </table>
</div>
</script>

<script id="datatypeFilter" type="x-tmpl-mustache">
    <h5>Data type</h5>
    <div class='' style='display:table-row' >
            {{#datatype}}
            <div class='datatype-option'  onclick='onClickdatatype("{{.}}")' style='cursor: pointer; float: left; text-align: center; background-color:#ffc; padding: 3px 30px; border: solid 1px #fc4; margin: 0 3px 3px 0; border-radius: 3px;'>{{.}}</div>
            {{/datatype}}
            <div class='datatype-option' onclick='onClickdatatype("Show all")' style='cursor: pointer; float: left; text-align: center; background-color:#f94; padding: 3px 30px; border: solid 1px #fc4; margin: 0 3px 3px 0; border-radius: 3px; color:#fff'>Show all</div>
    </div>
</script>

<script id="phenotypeFilter" type="x-tmpl-mustache">
  <h5>Phenotype</h5>
  <div class='' style='display:table-row'>
    {{#groups}}
    <div class='phenotype-option' onclick='onClickPhenotypeGroup("{{.}}")' style='cursor: pointer; float: left; text-align: center; background-color:#cef; padding: 3px 30px; border: solid 1px #9cf; margin: 0 3px 3px 0; border-radius: 3px;'>{{.}}</div>
    {{/groups}}
    <div class='phenotype-option' onclick='onClickPhenotypeGroup("Show all")' style='cursor: pointer; float: left; text-align: center; background-color:#39f; padding: 3px 30px; border: solid 1px #9cf; margin: 0 3px 3px 0; border-radius: 3px;color:#fff' >Show all</div>
  </div>
</script>

<!--this panel would display only when phenotype Filter is clicked -->
<script id="phenotypeFilterLevel2" type="x-tmpl-mustache">
  <div class='' style='display:table-row '>

    <div class="phenotype-level2-row" style='margin-top:10px' cursor: pointer>
    {{#phenotype}}
    <div class='phenotype-level2-option' style='cursor: pointer; width:auto; float: left; text-align: center; background-color:#cef; padding: 3px 30px; border: solid 1px #9cf; margin-right: 3px; margin-bottom: 3px; border-radius: 3px;' onclick='onClickPhenotypelevel2("{{.}}")'>{{.}}</div>
    {{/phenotype}}
    </div>
    </div>
</script>