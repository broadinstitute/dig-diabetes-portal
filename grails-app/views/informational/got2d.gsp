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
<h1><g:message code="got2d.title" default="GoT2D"/></h1>

<p>
    <g:message code="got2d.descr" default="GoT2D descr"/>
</p>

<div class="separator"></div>

<div id="about-got2d" class="tabbed-about-page">
<div class="sidebar">
    <div class="tab active" data-section="cohorts"><g:message code="got2d.subsection.cohorts" default="cohorts"/></div>

    <div class="tab" data-section="exomechip"><g:message code="got2d.subsection.exome" default="exome"/></div>

    <div class="tab" data-section="papers"><g:message code="got2d.subsection.papers" default="papers"/></div>

    <div class="tab" data-section="people"><g:message code="got2d.subsection.people" default="people"/></div>
</div>

<div class="content">
    <div id="got2dContent">
        <g:render template="got2dsection/${specifics}"/>
    </div>
</div>
</div>
</div>
<script type="text/javascript">
    $(function () {
        $('#about-got2d .sidebar .tab').on('click', function (e) {
            var section = $(e.target).data('section');
            $('.tab').removeClass('active');
            $(e.target).addClass('active');
            $.ajax({
                cache:false,
                type:"get",
                url:"./got2dsection/"+section,
                async:true,
                success: function (data) {
                    $("#got2dContent").empty().html(data);
                },
                error: function(jqXHR, exception) {
                    core.errorReporter(jqXHR, exception) ;
                }
            });

//            $('.section').hide();
//            $('.section[data-section="' + section + '"]').show();
        });
    });
</script>

</div>

</body>
</html>
