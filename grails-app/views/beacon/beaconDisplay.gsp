<%--
  Created by IntelliJ IDEA.
  User: kyuksel
  Date: 1/12/15
  Time: 12:07
--%>

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
        <h1>Broad Institute GA4GH Beacon</h1>

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
                            <a class="boldlink" href="http://genomicsandhealth.org">Reference: 2&nbsp;Position: 20038741&nbsp;Allele: A&nbsp;Project: PRJEB7898</a>
                        </span>
                    </p>
                    <p>
                        <span>
                            <a class="boldlink" href="http://genomicsandhealth.org">Reference: 14&nbsp;Position: 54317231&nbsp;Allele: D&nbsp;Project: PRJEB7898</a>
                        </span>
                    </p>
                    <p>
                        <span>
                            <a class="boldlink" href="http://genomicsandhealth.org">Reference: X&nbsp;Position: 20038741&nbsp;Allele: ATG&nbsp;Project: PRJEB7898</a>
                        </span>
                    </p>
                </div>
            </div>

            <br>
            <div class="input-group input-group-lg">
                <select name="" id="dataset-input" class="form-control" style="width:38%;">
                    <option value=""><g:message code="beacon.select.dataset"/></option>
                    <option value="PRJEB7898">PRJEB7898 -- The Exome Aggregation Consortium (ExAC) v0.2</option>
                </select>
            </div>
            <br>
            <div class="input-group input-group-lg">
                <select name="" id="reference-input" class="form-control" style="width:100%;">
                    <option value=""><g:message code="beacon.select.reference"/></option>
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
            <div>
                <form>
                    <br>
                    Start:
                    <input type="text" name="position">
                    <br>
                    <br>
                    Allele:
                    <input type="text" name="allele">
                </form>
            </div>
            <br>
            <div>
                <fieldset class="buttons">
                    <g:actionSubmit class="save btn btn-lg btn-primary pull-left"   action="update"
                                    value="Submit"/>
                </fieldset>
            </div>
        </div>
    </div>

</div>

</body>
</html>