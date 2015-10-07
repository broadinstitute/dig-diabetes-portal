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
                <h1><g:message code="blog.title" default="blog" /></h1>
                <h2><g:message code="blog.subtitle" default="this is the blog" /></h2>
                <iframe id="blog_embed"
                        src="javascript:void(0)"
                        scrolling="yes"
                        frameborder="0"
                        width="1200"
                        height="2500">
                </iframe>
                <script type="text/javascript">
                    document.getElementById('blog_embed').src = 'http://t2d-genetics-portal.blogspot.com/';
                </script>
            </div>
        </div>
    </div>
</div>

</body>
</html>
