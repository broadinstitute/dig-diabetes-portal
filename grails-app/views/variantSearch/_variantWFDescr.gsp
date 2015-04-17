<div style="">
    <ul id="myTab" class="nav nav-tabs">
        <li class="active"><a href="#developingQuery" data-toggle="tab">Developing query</a></li>
        <li><a href="#variantList" data-toggle="tab">Variant List</a></li>
        <li><a href="#variantTable" data-toggle="tab">Variant Table</a></li>
        <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">List summaries <b class="caret"></b></a>
            <ul class="dropdown-menu">
                <li><a href="#listSummary1" data-toggle="tab">Histogram</a></li>
                <li><a href="#listSummary2" data-toggle="tab">Summary statistics</a></li>
            </ul>
        </li>

    </ul>


    <div id="myTabContent" class="tab-content variantWFdescriptionBox">
        <div class="tab-pane fade in active developingQueryHolder" id="developingQuery">
            <g:renderEncodedFilters filterSet='${encodedFilterSets}'/>
        </div>

        <div class="tab-pane fade" id="variantList">

            <div class="panel panel-default">

                <div class="panel-body">
                    <p><strong>RS123</strong></p>

                    <p>This is the variant you wanted</p>
                    <p>Here is lots of useful information describing this variant in more detail</p>
                    <hr>

                    <p><strong>RS123</strong></p>

                    <p>This is the variant you wanted</p>
                    <p>Here is lots of useful information describing this variant in more detail</p>

                    <hr>
                    <p><strong>RS123</strong></p>

                    <p>This is the variant you wanted</p>
                    <p>Here is lots of useful information describing this variant in more detail</p>

                    <hr>
                </div>
            </div>

        </div>

        <div class="tab-pane fade" id="variantTable">



        </div>

        <div class="tab-pane fade" id="listSummary1">
            <h2>I am a histogram</h2>
        </div>

        <div class="tab-pane fade" id="listSummary2">
            <h2>I contain important statistics</h2>
        </div>
    </div>
</div>
</div>
<script type="text/javascript">
    $('#myTab a').click(function (e) {
        if ($(this).parent('li').hasClass('active')) {
            $($(this).attr('href')).hide();
        }
        else {
            e.preventDefault();
            $(this).tab('show');
        }
    });
</script>