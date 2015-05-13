<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en" ng-app="ChooserApp" ng-controller="ChooserController">
<head>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/angular.js/1.3.15/angular.js"></script>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" media="all" rel="stylesheet"/>
    <script src="https://code.jquery.com/jquery-2.1.3.min.js"></script>
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>
    <link href="//fonts.googleapis.com/css?family=Lato:300,400,700,900,300italic,400italic,700italic,900italic" rel="stylesheet" type="text/css"/>
    <link href="/images/icons/dna-strands.ico" rel="shortcut icon"/>

    <g:javascript src="lib/dport/chooser/controllers.js"></g:javascript>
    <g:javascript src="lib/dport/chooser/datasets.js"></g:javascript>
    <g:javascript src="lib/dport/chooser/t.js"></g:javascript>
    <g:javascript src="lib/dport/chooser/tree2.js"></g:javascript>

    <r:require modules="resultsFilter"/>
    <r:layoutResources/>
</head>

<body>
<div class="container-fluid" style="padding:0;">
    <g:layoutBody/>
</div>
</body>
</html>