

<br/>

<g:if test="${show_exseq}">

    <div id="howCommonIsExists" style="display: block">

        <p>
            <strong>Frequencies</strong>
            from exome sequence and exome chip data
        </p>


        <p>
            <div id="howCommonIsChart"></div>
        </p>
    </div>

     <div id="howCommonIsNoExists" style="display: none">

        <p>
           <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/></h4>
        </p>

    </div>


</g:if>



