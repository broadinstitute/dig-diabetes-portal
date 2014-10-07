<g:if test="${show_exseq}">



    <a name="populations"></a>

    <p>
        Click on a number to view variants.
    </p>

    <table id="continentalVariation" class="table table-striped  distinctivetable distinctive">
        <thead>
        <tr>
            <th>ancestry</th>
            <th>data type</th>
            <th>participants</th>
            <th>total variants</th>
            <th>common<br/><span class='headersubtext'>&gt;&nbsp;5%</span></th>
            <th>low-frequency<br/><span class='headersubtext'>0.05%&nbsp;-&nbsp;5%</span></th>
            <th>rare<br/><span class='headersubtext'>&lt;&nbsp;0.05%</span></th>
        </tr>
        </thead>
        <tbody id="continentalVariationTableBody">
        </tbody>
        </table>

</g:if>