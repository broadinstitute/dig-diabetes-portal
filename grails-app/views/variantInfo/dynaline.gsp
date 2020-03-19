<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core,dynaline"/>
    <r:layoutResources/>

</head>
<body>

%{--<g:javascript src="bootstrap.min.js" />--}%
<div class="container">

    <div class="starter-template">
        <h1 style="font-weight: bold">Gene analysis page</h1>
    </div>

    <div>
        <label style="font-size:16px" for="geneName">Gene:</label>
        <input type="text" id="geneName" name="geneName" value="SLC30A8">
    </div>
    <div>
        <label style="font-size:16px" for="priorAllelicVariance">Prior allelic variance:</label>
        <input type="text" id="priorAllelicVariance" name="priorAllelicVariance"  value="0.0462">
        <span  class="pull-right"><button onclick="drawPic()">Launch</button></span>
    </div>


</div>



<div class="jumbotron">
%{--    <div class="container">--}%

%{--        <div class="btn-toolbar">--}%
%{--            <div class="pull-left"></div>--}%

%{--            <div class="pull-right">--}%
%{--                <div class="btn-group">--}%
%{--                    <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">--}%
%{--                        JavaScript--}%
%{--                        <span class="caret"></span>--}%
%{--                    </a>--}%
%{--                    <ul class="dropdown-menu">--}%
%{--                        <li class="btn"--}%
%{--                            onclick="UTILS.openTheWindow('<g:createLink controller='qqPlot' action ='index'/>', 'js/baget/sharedMethods.js')">sharedMethods.js</li>--}%
%{--                        <li class="btn"--}%
%{--                            onclick="UTILS.openTheWindow('<g:createLink controller='qqPlot' action ='index'/>', 'js/baget/manhattan.js')">manhattan.js</li>--}%
%{--                    </ul>--}%
%{--                </div>--}%

%{--                <div class="btn-group">--}%
%{--                    <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">--}%
%{--                        Stylesheets--}%
%{--                        <span class="caret"></span>--}%
%{--                    </a>--}%
%{--                    <ul class="dropdown-menu">--}%
%{--                        <li class="btn"--}%
%{--                            onclick="UTILS.openTheWindow('<g:createLink controller='qqPlot' action ='index'/>', 'css/baget/manhattan.css')">manhattan.css</li>--}%
%{--                    </ul>--}%
%{--                </div>--}%
%{--            </div>--}%
%{--        </div>--}%

%{--    </div>--}%



    <div class="row">

        <div class="col-md-2"></div>

        <div class="col-md-8">
            <div id="dynamicLine"></div>
            <div id="chart"></div>
            %{--<svg class="chart"></svg>--}%



        </div>
        <div class="col-md-2"></div>
    </div>
    <div class="row">

        <div class="col-md-2"></div>

        <div class="col-md-8"><div id="confidenceInterval"></div>



        </div>
        <div class="col-md-2"></div>
    </div>

</div>
<script>
    $('#geneName').typeahead({
        source: function (query, process) {
            $.get('<g:createLink controller="gene" action="index"/>', {query: query}, function (data) {
                process(data);
            })
        },
        afterSelect: function(selection) {
            goToSelectedItem(selection);
        }
    });
     function drawPic(){
        const geneName = $('#geneName').val() || 'SLC30A8';
        const stringPriorAllelicVarianceVar  = $('#priorAllelicVariance').val() || '0.14';
        const priorAllelicVarianceVar  = parseFloat(stringPriorAllelicVarianceVar);
        mpgSoftware.dynaLineLauncher.prepareDisplay("${createLink(controller: 'variantInfo', action:'bestGeneBurdenResultsForGene')}",
                                                    geneName,
                                                    priorAllelicVarianceVar,
                                                    window);
    }
</script>

</body>
