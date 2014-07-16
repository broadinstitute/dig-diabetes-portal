<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>

</head>

<body>

<div id="main">

    <div class="container">
        <h1>T2D-GENES</h1>
        <h4>Type 2 Diabetes Genetic Exploration by Next-generation sequencing in multi-Ethnic Samples</h4>
        <p>
            T2D-GENES is a large collaborative effort to find genetic variants that influence risk of type 2 diabetes.
            With funding from <a class="boldlink" href="http://www.niddk.nih.gov/Pages/default.aspx">NIDDK</a>, the group is conducting two sequencing studies and
        one GWAS-based fine-mapping study in five ethnicities.
        </p>
        <div class="separator"></div>
        <div id="about-t2dgenes" class="tabbed-about-page">
            <div class="sidebar">
                <div class="tab active" data-section="cohorts">Cohorts</div>
                <div class="tab" data-section="papers">Papers</div>
                <div class="sep"></div>
                <div class="tab" data-section="project1">Project 1</div>
                <div class="tab" data-section="project2">Project 2</div>
                <div class="tab" data-section="project3">Project 3</div>
                <div class="sep"></div>
                <div class="tab" data-section="people">People</div>
            </div>
            <div class="content">
                   <div id="t2dgeneContent">
                        <g:render template="t2dsection/${specifics}"/>
                   </div>
                </div>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        $(function() {
            $('#about-t2dgenes .sidebar .tab').on('click', function(e) {
                var section = $(e.target).data('section');
                console.log("section="+section);
                $('.tab').removeClass('active');
                $(e.target).addClass('active');
                $.ajax({
                    cache:false,
                    type:"get",
                    url:"./t2dgenesection/"+section,
                    async:true,
                    success: function (data) {
                       $("#t2dgeneContent").empty().html(data);
                    }
                });
            });
        });
    </script>



</div>

</body>
</html>
