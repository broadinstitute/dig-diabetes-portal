<g:if test="${show_exseq}">



    <a name="populations"></a>

    <p>
        Variants are defined as common (found in 5 percent of the population or more), low-frequency (.5 percent to 5 percent), rare (below .5 percent), or private (seen in only one individual or family).
    </p>

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
            <th>common<br/><span class='headersubtext'>&gt;5%</span></th>
            <th>low-frequency<br/><span class='headersubtext'>&gt;0.05%</span></th>
            <th>rare<br/><span class='headersubtext'>&lt;0.05%</span></th>
        </tr>
        </thead>
        <tbody id="continentalVariationTableBody">
        </tbody>
        </table>

</g:if>