<script>
    function chgRadioButton(buttonLabel){
        if (buttonLabel ==='missense')  {
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
                   <div class="col-md-10"> <span class="text-left">all effects</span></div>
                   <div class="col-md-2"><input type="radio" name="predictedEffects" value="all-effects"  id="all_functions_checkbox" onClick="chgRadioButton('all-effects')" checked="checked"/></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-10"><span class="text-left">protein-truncating</span></div>
                    <div class="col-md-2"><input type="radio" name="predictedEffects" value="protein-truncating"  id="protein_truncating_checkbox" onClick="chgRadioButton('protein-truncating')"/></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-10"><span class="text-left">missense</span></div>
                    <div class="col-md-2"><input type="radio" name="predictedEffects" value="missense"  id="missense_checkbox" onClick="chgRadioButton('missense')"/></div>
                </div>



            <div  class="radio" id="missense-options" style="display:none;">
                <div class="checkbox">
                    <g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen" default="PolyPhen-2 prediction" />
                    <select name="polyphen" id="polyphenSelect">
                        <option value="">---</option>
                        <option value="probably_damaging"><g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen.probablyDamaging" default="probably damaging" /></option>
                        <option value="possibly_damaging"><g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen.possiblyDamaging" default="possibly damaging" /></option>
                        <option value="benign"><g:message code="variantSearch.proteinEffectRestrictions.missense.polyphen.benign" default="benign" /></option>
                    </select>
                </div>
                <div class="checkbox">
                    <g:message code="variantSearch.proteinEffectRestrictions.missense.sift" default="SIFT prediction" />
                    <select name="sift" id="siftSelect">
                        <option value="">---</option>
                        <option value="deleterious"><g:message code="variantSearch.proteinEffectRestrictions.missense.sift.deleterious" default="deleterious" /></option>
                        <option value="tolerated"><g:message code="variantSearch.proteinEffectRestrictions.missense.sift.tolerated" default="tolerated" /></option>
                    </select>
                </div>
                <div class="checkbox">
                    <g:message code="variantSearch.proteinEffectRestrictions.missense.condel" default="CONDEL prediction" />
                    <select name="condel" id="condelSelect">
                        <option value="">---</option>
                        <option value="deleterious"><g:message code="variantSearch.proteinEffectRestrictions.missense.condel.deleterious" default="deleterious" /></option>
                        <option value="benign"><g:message code="variantSearch.proteinEffectRestrictions.missense.condel.benign" default="benign" /></option>
                    </select>
                </div>
            </div>


                <div class="row clearfix">
                    <div class="col-md-10"><span class="text-left">no effect (synonymous coding)</span></div>
                    <div class="col-md-2"><input type="radio" name="predictedEffects" value="noEffectSynonymous"    id="synonymous_checkbox" onClick="chgRadioButton('noEffectSynonymous')"/></div>
                </div>
                <div class="row clearfix">
                    <div class="col-md-10"><span class="text-left">no effect (non-coding)</span></div>
                    <div class="col-md-2"><input type="radio" name="predictedEffects" value="noEffectNoncoding"   id="noncoding_checkbox" onClick="chgRadioButton('noEffectNoncoding')"/></div>
                </div>

            </div>


        </div>
    </div>
</div>

