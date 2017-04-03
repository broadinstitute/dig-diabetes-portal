
<style>
    /* only applies to tables for cohort information */
    .cohortDetail th {
        width: 50%;
    }
</style>

<script>
    var displaySelectedDataTypes = function() {
        var selectedDataType = $('#dataTypeSelector').val();

        if(selectedDataType == 'all') {
            $('.sampleGroup').show();
        } else {
            $('.sampleGroup[data-datatype="' + selectedDataType + '"]').show();
            $('.sampleGroup:not([data-datatype="' + selectedDataType + '"]').hide();
        }
    };
    // used for showing/hiding cohort information
    function showSection(event) {
        $(event.target.nextElementSibling).toggle();
    }

    $(document).ready(function() {
        // gather all the known data types
        var knownDataTypes = _.chain($('.sampleGroup')).map(function(sgPanel) {
            return $(sgPanel).attr('data-datatype');
        }).uniq().value();

        _.forEach(knownDataTypes, function(dataType) {
            var newOption = $('<option>').append(dataType).attr({value: dataType});
            $('#dataTypeSelector').append(newOption);
        });
    });

</script>

<script>

    $(document).ready(function() {
        var data = {
            dataType: "Data type:",
            all: "all"
        };
        var template = $("#selectDataType")[0].innerHTML;
        var dynamic_html = Mustache.to_html(template,data);
        $("#DataTypeList").append(dynamic_html);
    })

</script>

<script id="selectDataType" type="x-tmpl-mustache">
    <div class="form-inline">
        <label>{{dataType}}</label>
        <select id="dataTypeSelector" class="form-control" onchange=displaySelectedDataTypes()>
            <option value="all">Show all</option>
            <option value="ExSeq">Exome Sequencing</option>
            <option value="WGS">Whole genome Sequencing</option>
            <option value="GWAS">GWAS</option>
            <option value="ExChip">Exome chip</option>
            <option value="1kg">1000 Genome</option>
            <option value="ExAC">ExAC</option>
        </select>
    </div>
</script>

<script>
    $(document).ready(function() {
        var jsonData = {
            "experiments":[{
                "samplegroupname":"sample1",
                "samplegroupid":"samplea"
            },{
                "samplegroupname":"sample2",
                "samplegroupid":"sampleb"
            }]
        }
        var template = $("#ExperimentList")[0].innerHTML;
        var dynamic_html = Mustache.to_html(template,jsonData);
        $("#ExperimentSample").append(dynamic_html);
    });
</script>

<script id="ExperimentList" type="x-tmpl-mustache">
    <table>
    <tbody id="userInfo">
    {{#experiments}}
    <tr>
    <td>{{samplegroupname}}</td>
    <td>{{samplegroupid}}</td>
    </tr>
    {{/experiments}}
    </tbody>
    </table>
</script>



<script>

$(document).ready(function() {
    var data = {"myVarList":
            [{name: "Preeti"}, {name: "foobar"},{name: "singh"}]};

    var template = $("#test2")[0].innerHTML;
    var dynamic_html = Mustache.to_html(template,data);
    $("#test").append(dynamic_html);
})
</script>

<script id="test2" type="x-tmpl-mustache">
    {{#myVarList}}
    <h1> hello {{name}}</h1>
    {{/myVarList}}
</script>


<script>
    $(document).ready(function () {
        $.ajax({
            cache: false,
            type: "get",
            url: "${createLink(controller:'informational',action: 'aboutTheDataAjax')}",
            data: {metadataVersion: 'mdv25',technology: 'GWAS'},
            async: true
        }).done(function (data, textStatus, jqXHR) {
            var x = [];
            _.forEach(data.children, function (k,v) {
                // make objects with just the level and count fields, then filter
                // out anything that's not MAF information

                //var arr = $.map(k, function(item) {return item});
                x.push(k);
                console.log(x);
            });
            var holder = {};
            holder["parents"] = x;
            console.log(holder);
            var template = $("#metaData")[0].innerHTML;
            var dynamic_html = Mustache.to_html(template,holder);
            $("#metaDataDisplay").append(dynamic_html);

        }).fail(function (jqXHR, textStatus, exception) {
            loading.hide();
            core.errorReporter(jqXHR, exception);
        });
    });

</script>

<script id="metaData" type="x-tmpl-mustache">
    <table>
    <tbody>
    {{#parents}}
    <tr>
    <td>{{ancestry}}</td>
    <td>{{descr}}</td>
    {{#children}}
    <td>{{ancestry}}<td>
    {{/children}}
    </tr>
    {{/parents}}
    </tbody>
    </table>
</script>



<div class="row" style="padding-top: 50px;">

    <div  id ="DataTypeList" class="form-inline"></div>

    <div  id ="metaDataDisplay" class="form-inline"></div>


    <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
        <g:each var="exp" in="${experiments}">
            <g:each var="sg" in="${exp.sampleGroups}">
                <div class="panel panel-default sampleGroup" data-datatype="${g.message(code: 'metadata.' + exp[0].technology)}">
                    <div class="panel-heading" role="tab" id="${sg[0].systemId}">
                        <p class="dataset-name">${ g.message(code: 'metadata.' + sg[0].getSystemId()) }
                            <span class="dataset-summary">

                            <g:if test="${sg[0]?.getSystemId()?.toString()?.contains('BioMe')}">
                                <span class="data-status-early-phase1-access">Early Access Phase 2</span> |  %{-- {{ sequencing }} |--}% ${g.formatNumber(number: sg[0].getSubjectsNumber(), format: "###,###" )} | ${sg[0].getAncestry()}
                                </span>
                            </g:if>

                            <g:elseif test="${sg[0]?.getSystemId()?.toString()?.contains('ForT2D')}">
                                <span class="data-status-early-phase1-access">Unpublished</span> |  %{-- {{ sequencing }} |--}% ${g.formatNumber(number: sg[0].getSubjectsNumber(), format: "###,###" )} | ${sg[0].getAncestry()}
                                </span>
                            </g:elseif>

                            <g:elseif test="${sg[0]?.getSystemId()?.toString()?.contains('CAMP')}">
                                <span class="data-status-early-phase1-access">Early Access Phase 2</span> |  %{-- {{ sequencing }} |--}% ${g.formatNumber(number: sg[0].getSubjectsNumber(), format: "###,###" )} | ${sg[0].getAncestry()}
                                </span>
                            </g:elseif>

                            <g:else>
                                <span class="data-status-open-access">Open access</span> | %{-- {{ sequencing }} |--}% ${g.formatNumber(number: sg[0].getSubjectsNumber(), format: "###,###" )} | ${sg[0].getAncestry()}
                                </span>
                            </g:else>
                        </p>

                        <p class="dataset-info">
                            %{--<strong>Data status:</strong> {{ Open access }},--}%
                            <strong>Data type:</strong> ${g.message(code: 'metadata.' + exp[0].technology)}
                            %{--, <strong>Experiment type:</strong> {{ exome sequencing }}--}%<br />
                            <strong>Total number of samples:</strong> ${g.formatNumber(number: sg[0].getSubjectsNumber(), format: "###,###" )},
                            %{-- sample groups for qualitative traits have # cases/# controls = -1, which we don't want to display--}%
                            <g:if test="${sg[0].getCasesNumber() != -1}" >
                                <strong>No. cases:</strong> ${g.formatNumber(number: sg[0].getCasesNumber(), format: "###,###" )},
                                <strong>No. controls:</strong> ${g.formatNumber(number: sg[0].getControlsNumber(), format: "###,###" )},
                            </g:if>
                            <strong>Ethnicity:</strong> ${sg[0].getAncestry()}
                        </p>
                        <h5 class="panel-title">
                            <a class="collapsed open-info" role="button" data-toggle="collapse" data-parent="#accordion" href="#${sg[0].systemId}Collapse" aria-expanded="true" aria-controls="${sg[0].systemId}Collapse">
                                Learn more >
                            </a>
                        </h5>
                    </div>
                    <div id="${sg[0].systemId}Collapse" class="panel-collapse collapse" role="tabpanel" aria-labelledby="${sg[0].systemId}">
                        <div class="panel-body">
                            <g:render template="data/${sg[0].systemId.replaceAll(/mdv\d+/,"mdv2")}" />
                        </div>
                    </div>
                </div>
            </g:each>
        </g:each>
    </div>
</div>
