<%--
  Created by IntelliJ IDEA.
  User: kyuksel
  Date: 1/12/15
  Time: 12:07
--%>

<!DOCTYPE html>
<html>
<head>

    <meta name="layout" content="beaconCore"/>
    <r:require modules="core"/>
    <r:require modules="geneInfo"/>
    <r:layoutResources/>

</head>

<body>

<script>
    /***
     * Make a variant search request to back-end.
     */
    var queryVariants = function () {
        var dataset     = document.getElementById("dataset-input").value;
        var chromosome  = document.getElementById("chromosome-input").value;
        var position    = document.getElementById("position-input").value;
        var allele      = document.getElementById("allele-input").value;
        var params      = {"dataset"  : dataset,
                           "chromosome": chromosome,
                           "position" : position,
                           "allele"   : allele};

        var displayError = $('#displayError');
        displayError.empty(); // clear previously displayed error message, if any

        if (userInputIsValid(params, displayError)) {
            var loading = $('#spinner').show();
            loading.show();

            var resultTable = $('#resultTable');
            var resultJson = $('#resultJson');

            $.ajax({
                type: 'POST',
                cache: false,
                data: JSON.stringify(params),
                contentType: "application/json; charset=utf-8",
                url: "./beaconVariantQueryAjax",
                async: true,
                success: function (data) {
                    loading.hide();

                    // clear previously created table content, if any
                    resultTable.empty();
                    // regenerate table content with updated data
                    resultTable.append('<thead><tr><th style=\"text-align:left\" colspan=\"2\">Result</th></tr></thead>');
                    resultTable.append('<tbody><tr><td style=\"text-align:left\">Project</td><td style=\"text-align:left\">' + dataset + '</td></tr>');
                    resultTable.append('<tr><td style=\"text-align:left\">Chromosome</td><td style=\"text-align:left\">' + chromosome + '</td></tr>');
                    resultTable.append('<tr><td style=\"text-align:left\">Position</td><td style=\"text-align:left\">' + position + '</td></tr>');
                    resultTable.append('<tr><td style=\"text-align:left\">Allele</td><td style=\"text-align:left\">' + allele + '</td></tr>');
                    if (data === 'YES') { // display query answer in bold; in green if positive and in red if negative
                        resultTable.append('<tr><td style=\"font-weight:bold;text-align:left\">Exist</td><td style=\"color:green;font-weight:bold;text-align:left\">' + data + '</td></tr></tbody>');
                    } else {
                        resultTable.append('<tr><td style=\"font-weight:bold;text-align: left\">Exist</td><td style=\"color:red;font-weight:bold;text-align:left\">' + data + '</td></tr></tbody>');
                    }

                    // clear previously created json content, if any
                    resultJson.empty();
                    // regenerate json content with updated data
                    var obj = {'Query': {'Project': dataset, 'Chromosome': chromosome, 'Position': position, 'Allele': allele}, 'Exist': data};
                    var str = JSON.stringify(obj, undefined, 2); // indentation level = 2
                    resultJson.append('<code>' + str + '</code>');

                    // display only the selected format (table or json)
                    switchDisplay();
                },
                error: function () {
                    loading.hide("error");
                }
            });
        }
    };

    /***
     * Check if a user entered valid input and if not, display a message accordingly.
     */
    var userInputIsValid = function (params, displayError) {
        var missingParams = [];
        for (var key in params) {
            if (params.hasOwnProperty(key) && !params[key]) {
                missingParams.push(key);
            }
        }
        if (missingParams.length > 0) {
            displayError.append("Please enter values for the following fields: " + missingParams.join(", "));
            return false;
        }

        return true;
    }

    /***
     * Toggle between displaying result as table and JSON upon click of radio button.
     */
    var switchDisplay = function () {
        var formatIsText = document.getElementById("textRadio").checked;

        if (formatIsText) {
            $('#resultTable').show();
            $('#resultJson').hide();
        } else {
            $('#resultJson').show();
            $('#resultTable').hide();
        }
    }

    /***
     * Re-set form values.
     */
    var resetForm = function (dataset, chromosome, position, allele) {
        var form_dataset   = document.getElementById("dataset-input");
        var form_chromosome = document.getElementById("chromosome-input");
        var form_position  = document.getElementById("position-input");
        var form_allele    = document.getElementById("allele-input");

        form_dataset.value   = dataset;
        form_chromosome.value = chromosome;
        form_position.value  = position;
        form_allele.value    = allele;

        $('#resultTable').empty(); // clear previously created table content, if any
    }
</script>

<div id="main">
    <div class="container">
<!--        <h1>Broad Institute GA4GH Beacon</h1> -->

        <div class="beaconDisplay">
            <p>
                Learn more about the Global Alliance for Genomics and Health (GA4GH) <a class="boldlink" href="http://genomicsandhealth.org">here</a>,
                and about the GA4GH Beacon project <a class="boldlink" href="http://genomicsandhealth.org">here</a>.
            </p>

            <div>
                <p>
                    <b>Example queries:</b>
                </p>

                <div>
                    <p>
                        <span>
                            <a class="boldlink" onclick="resetForm('PRJEB7898', 1, 13417, 'CGAGA');">Chromosome: 1&nbsp;Position: 13417&nbsp;Allele: CGAGA&nbsp;Project: PRJEB7898</a>
                        </span>
                    </p>
                    <p>
                        <span>
                            <a class="boldlink" onclick="resetForm('PRJEB7898', 14, 5431731, 'D');">Chromosome: 14&nbsp;Position: 5431731&nbsp;Allele: D&nbsp;Project: PRJEB7898</a>
                        </span>
                    </p>
                    <p>
                        <span>
                            <a class="boldlink" onclick="resetForm('PRJEB7898', 'X', 20038741, 'G');">Chromosome: X&nbsp;Position: 20038741&nbsp;Allele: G&nbsp;Project: PRJEB7898</a>
                        </span>
                    </p>
                </div>
            </div>

            <br>
            <div class="input-group input-group-lg">
                <select name="" id="dataset-input" class="form-control" style="width:100%;">
                    <option value=""><g:message code="beacon.select.dataset"/></option>
                    <option value="PRJEB7898" selected="selected">PRJEB7898 -- The Exome Aggregation Consortium (ExAC) v0.3</option>
                </select>
            </div>
            <br>
            <div class="input-group input-group-lg">
                <select name="" id="chromosome-input" class="form-control" style="width:100%;">
                    <option value=""><g:message code="beacon.select.chromosome"/></option>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                    <option value="13">13</option>
                    <option value="14">14</option>
                    <option value="15">15</option>
                    <option value="16">16</option>
                    <option value="17">17</option>
                    <option value="18">18</option>
                    <option value="19">19</option>
                    <option value="20">20</option>
                    <option value="21">21</option>
                    <option value="22">22</option>
                    <option value="X">X</option>
                    <option value="Y">Y</option>
                </select>
            </div>
            <div class="input-group input-group-lg">
                <form style="width:90%;">
                    <br>
                    Position:
                    <input type="text" name="position" id="position-input">
                    <br>
                    <br>
                    Allele:
                    <input type="text" name="allele" id="allele-input">
                    <br>
                    <br>
                    Format Type:&nbsp;&nbsp;&nbsp;
                    <span>
                    <label>
                        <input id="textRadio" type="radio" name="resultFormat" value="text" onclick="switchDisplay()" style="margin-right:2px" checked/>
                        Text&nbsp;
                        <input id="jsonRadio" type="radio" name="resultFormat" value="text" onclick="switchDisplay()" style="margin-right:2px"/>
                        JSON
                    </label>
                    </span>
                </form>
            </div>
            <div>
                <table id="resultTable" class="table table-striped basictable" style="width:53%">
                </table>
            </div>
            <div>
                <table id="resultJson" class="table table-striped basictable" style="width:53%">
                </table>
            </div>
            <div>
                <table id="displayError" class="table table-striped basictable" style="color:red;font-weight:bold;width:53%">
                </table>
            </div>
            <div class="save btn btn-lg btn-primary pull-left" onclick="queryVariants()">Submit</div>
        </div>
    </div>

</div>

</body>
</html>