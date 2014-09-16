<head>
    <meta name="layout" content="igvCore"/>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href=img/favicon.ico>

    <title>IGV - Integrative Genomics Viewer</title>

    %{--<r:require modules="brandingStyle"/>    DOES NOT WORK --}%
    %{--<link type="text/css" href="${resource(dir:'css/lib',file:'t2dBranding.css')}" /> AND THIS DOESN'T EITHER--}%


    <!-- Bootstrap core CSS -->
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">

    <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">

    <!-- IGV Bootstrap css -->
    <link href="//www.broadinstitute.org/igvdata/t2d/igv.css" type="text/css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="//oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="//oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

    <script src="//code.jquery.com/jquery-1.11.0.min.js"></script>

    <!-- Bootstrap -->
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    <script  src="../js/lib/igv/vendor/inflate.js"></script>
    <script  src="../js/lib/igv/vendor/zlib_and_gzip.min.js"></script>
    <!--   <script type="text/javascript" src="vendor/bootstrap/plugins/holder.js"></script>  -->

    <!-- IGV js code -->
    <script src="http://www.broadinstitute.org/igvdata/t2d/igv-all.min.js"></script>



</head>

<body>
<script>
    console.log('3');
</script>



<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >

                <g:render template="igvBrowser" />

            </div>

        </div>
    </div>

</div>

</body>
</html>

