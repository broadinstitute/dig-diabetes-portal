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
        <div class="tab-pane fade in active" id="developingQuery">
            <g:renderEncodedFilters filterSet='${encodedFilterSets}'/>
        </div>

        <div class="tab-pane fade" id="variantList">
            <p>RS123</p>

            <p>This is the variant you seek</p>
            <hr>

            <p>RS123</p>

            <p>This is the variant you seek</p>
            <hr>
        </div>

        <div class="tab-pane fade" id="variantTable">
            <p></p>
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