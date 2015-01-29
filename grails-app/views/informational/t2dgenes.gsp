<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>
<style>
#about-t2dgenes {
    margin-left: 0px;
    margin-right: 0px;
    width: 100%;
}

.myPills {
    background: #588fd3;
    padding: 15px 0 15px 0;
}

.myPills a {
    color: white;
}
</style>

<div id="main">

    <div class="container">
        <h1>T2D Genes (icon)</h1>
        %{--<h4><g:message code="t2dgenes.mainPage.subtitle" default="t2dgenes" /></h4>--}%
        <p>
            <g:message code="t2dgenes.mainPage.descr" default="t2dgenes description"/>

        </p>

        <div class="row">
            <div id="about-t2dgenes" class="tabbed-about-page">

                <ul class="nav nav-pills">
                    <div class="row">
                        <div class="col-md-2 text-center">
                            <li role="presentation" id="aboutt2d_cohorts" class="myPills active"><a
                                    style="text-decoration:underline;color:yellow" href="#">Cohorts</a></li>
                        </div>

                        <div class="col-md-2 text-center">
                            <li role="presentation" id="aboutt2d_papers" class="myPills"><a href="#">Papers</a></li>
                        </div>

                        <div class="col-md-2 text-center">
                            <li role="presentation" id="aboutt2d_people" class="myPills"><a href="#">People</a></li>
                        </div>

                        <div class="col-md-2 text-center">
                            <li role="presentation" id="aboutt2d_project1" class="myPills"><a href="#">Project 1</a>
                            </li>
                        </div>

                        <div class="col-md-2 text-center">
                            <li role="presentation" id="aboutt2d_project2" class="myPills"><a href="#">Project 2</a>
                            </li>
                        </div>

                        <div class="col-md-2 text-center">
                            <li role="presentation" id="aboutt2d_project3" class="myPills"><a href="#">Project 3</a>
                            </li>
                        </div>
                    </div>

                </ul>

                <div class="content">
                    <div id="t2dgeneContent">
                        <g:render template="t2dsection/${specifics}"/>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
<script type="text/javascript">
    $(function () {
        $('#about-t2dgenes .nav li').on('click', function (e) {
            var activeNav = $(e.target.parentNode);
            var activeNavName = activeNav.attr('id').split('_')[1];
            $('.nav-pills  li').removeClass('active');
            $('.nav-pills  li').children().css('color', '#fff');
            $('.nav-pills  li').children().css('text-decoration', 'none');
            activeNav.addClass('active');
            activeNav.children().css('color', 'yellow');
            activeNav.children().css('text-decoration', 'underline');
            $.ajax({
                cache: false,
                type: "get",
                url: "${createLink(controller:'informational',action:'t2dgenesection')}" + "/" + activeNavName,
                async: true,
                success: function (data) {
                    $("#t2dgeneContent").empty().html(data);
                },
                error: function (jqXHR, exception) {
                    core.errorReporter(jqXHR, exception);
                }
            });
        });
    });
</script>



</div>

</body>
</html>
