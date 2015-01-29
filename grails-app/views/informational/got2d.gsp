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
<h1>GoT2D</h1>

<p>
    The GoT2D consortium uses genome sequencing, exome sequencing, and exome chip genotyping to
    identify and investigate low-frequency variants that influence risk of type 2 diabetes.
    Results from the exome chip study (n=86,209) are currently available on this portal.
</p>

<div class="separator"></div>

<div id="about-got2d" class="tabbed-about-page">
<div class="sidebar">
    <div class="tab active" data-section="cohorts">Cohorts</div>

    <div class="tab" data-section="exomechip">Exome chip results</div>

    <div class="tab" data-section="papers">Papers</div>

    <div class="tab" data-section="people">People</div>
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
