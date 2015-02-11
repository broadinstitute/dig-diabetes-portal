
<style>
    h1,h2,h3,h4,label{
        font-weight: 300;
    }
</style>
<br/>
<div id="VariantsAndAssociationsExist" style="display: block">
    <div class="row clearfix">

        <g:renderSigmaSection>
            <div class="col-md-1">
            </div>
            <div class="col-md-4">
                 <div id="gwasSigmaAssociationStatisticsBox"></div>
            </div>
            <div class="col-md-2"></div>
            <div class="col-md-4">
                <div id="sigmaAssociationStatisticsBox"></div>
            </div>
            <div class="col-md-1"></div>
        </g:renderSigmaSection>
        <g:renderNotSigmaSection>
            <div class="col-md-3">
                <div id="gwasAssociationStatisticsBox"></div>
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-3">
                <div id="exomeChipAssociationStatisticsBox"></div>
            </div>
            <div class="col-md-1"></div>
            <div class="col-md-3">
                <div id="exomeSequenceAssociationStatisticsBox"></div>
            </div>
        </g:renderNotSigmaSection>

    </div>
</div>

<div id="VariantsAndAssociationsNoExist"  style="display: none">
    <h4><g:message code="variant.insufficientdata" default="Insufficient data to draw conclusion"/></h4>
</div>

<br/>

<p>
    <span id="variantInfoAssociationStatisticsLinkToTraitTable"></span>

</p>


