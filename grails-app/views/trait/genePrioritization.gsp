<%--
  Created by IntelliJ IDEA.
  User: balexand
  Date: 2/5/2018
  Time: 11:34 AM
--%>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,phenotype,traitInfo, datatables"/>
    <r:layoutResources/>
    <%@ page import="org.broadinstitute.mpg.RestServerService" %>
</head>

<body>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >

                <g:render template="genePrioritizationContents" />

            </div>

        </div>
    </div>

</div>

</body>
</html>
