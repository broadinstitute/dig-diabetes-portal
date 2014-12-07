<div class="row">
    <div class="col-sm-12">
      <em>Current list of variants.</em>
    </div>
</div>
<div class="row">
    <div class="col-sm-12">
        <div class="dbtBoundingBox">

            <div class="row">
                <div class="col-sm-12">
                    <table id="btVariantTable" class="table table-striped basictable">
                        <thead>
                        <tr>
                            <th>nearest gene</th>
                            <th>variant</th>
                            <th>rsid</th>
                            <th>protein change</th>
                            <th>effect on protein</th>
                            <th>highest frequency</th>
                            <th>population with highest frequency</th>
                        </tr>
                        </thead>
                        <tbody id="btVariantTableBody">
                        </tbody>
                    </table>
                </div>

            </div>


        </div>
    </div>
</div>
<div id="doSomethingWithExistingList">
    <div class="row">

        <div class="col-sm-2">
            <span>Options</span>
        </div>
        <div class="col-sm-10">
            <ul>
                <li>Add variants to existing list</li>
                <li>Remove variants from existing list</li>
                <li>Execute burden search
                    <button class="btn btn-lg btn-primary" onclick="launchDynamicBurdenTest()">Execute</button>
                </li>
            </ul>


        </div>
    </div>
</div>
