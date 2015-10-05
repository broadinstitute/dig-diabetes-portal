<%@ page import="org.broadinstitute.mpg.diabetes.util.PortalConstants" %>
<script>
    function chgRadioButton(buttonLabel){
        if (buttonLabel ==='${PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE}')  {
            $('#missense-options').show();
        }  else {
            $('#missense-options').hide();
        }
    }
</script>

<div class="row clearfix">
    <div class="col-md-12">
        <div id="biology-form">
            <div class="radio">
                <div class="row clearfix">
                   <div class="col-md-10"> <span class="text-left searchBuilderPrompt"><g:message code="variantSearch.proteinEffectRestrictions.allEffects" default="all effects" /></span></div>
                    %{--<div class="col-md-2"><input type="radio" name="predictedEffects" value="all-effects"  id="all_functions_checkbox" onClick="chgRadioButton('all-effects')" checked="checked"/></div>--}%
                    <div class="col-md-2"><input type="radio" name="predictedEffects" value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_CODE}"  id="all_functions_checkbox" onClick="chgRadioButton('${PortalConstants.PROTEIN_PREDICTION_EFFECT_ALL_CODE}')" checked="checked"/></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-10"><span class="text-left searchBuilderPrompt"><g:message code="variantSearch.proteinEffectRestrictions.proteinTruncating" default="protein-truncating" /></span></div>
                    %{--<div class="col-md-2"><input type="radio" name="predictedEffects" value="protein-truncating"  id="protein_truncating_checkbox" onClick="chgRadioButton('protein-truncating')"/></div>--}%
                    <div class="col-md-2"><input type="radio" name="predictedEffects" value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_PTV_CODE}"  id="protein_truncating_checkbox" onClick="chgRadioButton('${PortalConstants.PROTEIN_PREDICTION_EFFECT_PTV_CODE}')"/></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-10"><span class="text-left searchBuilderPrompt"><g:message code="variantSearch.proteinEffectRestrictions.missense" default="missense" /></span></div>
                    %{--<div class="col-md-2"><input type="radio" name="predictedEffects" value="missense"  id="missense_checkbox" onClick="chgRadioButton('missense')"/></div>--}%
                    <div class="col-md-2"><input type="radio" name="predictedEffects" value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE}"  id="missense_checkbox" onClick="chgRadioButton('${PortalConstants.PROTEIN_PREDICTION_EFFECT_MISSENSE_CODE}')"/></div>
                </div>



            <div  class="radio" id="missense-options" style="display:none;">
                <div class="checkbox">
                    <g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen" default="PolyPhen-2 prediction" />
                    <select name="polyphen" id="polyphenSelect">
                        <option value="">${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_NONE_NAME}</option>
                    %{--<option value="probably_damaging"><g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen.probablyDamaging" default="probably damaging" /></option>--}%
                    %{--<option value="possibly_damaging"><g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen.possiblyDamaging" default="possibly damaging" /></option>--}%
                    %{--<option value="benign"><g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen.benign" default="benign" /></option>--}%
                    <option value="${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_PROBABLYDAMAGING_STRING_CODE}"><g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen.probablyDamaging" default="probably damaging" /></option>
                    <option value="${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_POSSIBLYDAMAGING_STRING_CODE}"><g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen.possiblyDamaging" default="possibly damaging" /></option>
                    <option value="${PortalConstants.PROTEIN_PREDICTION_POLYPHEN_BENIGN_STRING_CODE}"><g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen.benign" default="benign" /></option>
                    </select>
                </div>
                <div class="checkbox">
                    <g:message code="variantSearch.proteinEffectRestrictions.missense.sift" default="SIFT prediction" />
                    <select name="sift" id="siftSelect">
                        <option value="">${PortalConstants.PROTEIN_PREDICTION_SIFT_NONE_NAME}</option>
                    %{--<option value="deleterious"><g:message code="variantSearch.proteinEffectRestrictions.missense.sift.deleterious" default="deleterious" /></option>--}%
                    %{--<option value="tolerated"><g:message code="variantSearch.proteinEffectRestrictions.missense.sift.tolerated" default="tolerated" /></option>--}%
                    <option value="${PortalConstants.PROTEIN_PREDICTION_SIFT_DELETERIOUS_STRING_CODE}"><g:message code="variantSearch.proteinEffectRestrictions.missense.sift.deleterious" default="deleterious" /></option>
                    <option value="${PortalConstants.PROTEIN_PREDICTION_SIFT_TOLERATED_STRING_CODE}"><g:message code="variantSearch.proteinEffectRestrictions.missense.sift.tolerated" default="tolerated" /></option>
                    </select>
                </div>
                <div class="checkbox">
                    <g:message code="variantSearch.proteinEffectRestrictions.missense.condel" default="CONDEL prediction" />
                    <select name="condel" id="condelSelect">
                        <option value="">---</option>
                    %{--<option value="deleterious"><g:message code="variantSearch.proteinEffectRestrictions.missense.condel.deleterious" default="deleterious" /></option>--}%
                    %{--<option value="benign"><g:message code="variantSearch.proteinEffectRestrictions.missense.condel.benign" default="benign" /></option>--}%
                    <option value="${PortalConstants.PROTEIN_PREDICTION_CONDEL_DELETERIOUS_STRING_CODE}"><g:message code="variantSearch.proteinEffectRestrictions.missense.condel.deleterious" default="deleterious" /></option>
                    <option value="${PortalConstants.PROTEIN_PREDICTION_CONDEL_BENIGN_STRING_CODE}"><g:message code="variantSearch.proteinEffectRestrictions.missense.condel.benign" default="benign" /></option>
                    </select>
                </div>
            </div>


                <div class="row clearfix">
                    <div class="col-md-10"><span class="text-left  searchBuilderPrompt"><g:message code="variantSearch.proteinEffectRestrictions.synonymousCoding" default="no effect (synonymous coding)" /></span></div>
                    %{--<div class="col-md-2"><input type="radio" name="predictedEffects" value="noEffectSynonymous"    id="synonymous_checkbox" onClick="chgRadioButton('noEffectSynonymous')"/></div>--}%
                    <div class="col-md-2"><input type="radio" name="predictedEffects" value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_CODE}"    id="synonymous_checkbox" onClick="chgRadioButton('${PortalConstants.PROTEIN_PREDICTION_EFFECT_SYNONYMOUS_CODE}')"/></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-10"><span class="text-left searchBuilderPrompt"><g:message code="variantSearch.proteinEffectRestrictions.noncoding" default="no effect (non-coding)" /></span></div>
                    %{--<div class="col-md-2"><input type="radio" name="predictedEffects" value="noEffectNoncoding"   id="noncoding_checkbox" onClick="chgRadioButton('noEffectNoncoding')"/></div>--}%
                    <div class="col-md-2"><input type="radio" name="predictedEffects" value="${PortalConstants.PROTEIN_PREDICTION_EFFECT_NONCODING_CODE}"   id="noncoding_checkbox" onClick="chgRadioButton('${PortalConstants.PROTEIN_PREDICTION_EFFECT_NONCODING_CODE}')"/></div>
                </div>

            </div>


        </div>
    </div>
</div>

