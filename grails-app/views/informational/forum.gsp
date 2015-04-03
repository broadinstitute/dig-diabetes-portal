<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>

<div id="main">
    <div class="container">
        <div class="row">
            <div class="col-xs-12">
                <h1><g:message code="forum.title" default="forum" /></h1>
                <h2><g:message code="forum.subtitle" default="this is the forum" /></h2>
                <iframe id="forum_embed"
                        src="javascript:void(0)"
                        scrolling="no"
                        frameborder="0"
                        width="900"
                        height="700">
                </iframe>
                <script type="text/javascript">
                    document.getElementById('forum_embed').src =
                            'https://groups.google.com/a/broadinstitute.org/forum/embed/?place=forum/t2d-genetics-portal-forum'
                            + '&showsearch=true&showpopout=true&showtabs=false'
                            + '&parenturl=' + encodeURIComponent(window.location.href);
                </script>
            </div>
        </div>
    </div>
</div>

</body>
</html>
