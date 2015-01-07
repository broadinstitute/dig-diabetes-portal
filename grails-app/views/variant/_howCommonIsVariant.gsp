

<br/>

<g:if test="${show_exseq}">

    <div id="howCommonIsExists" style="display: block">

        <p>
             <g:message code="variant.alleleFrequency.subtitle" default="Relative allele frequencies" />
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



