<h4><g:message code="variantSearch.proteinEffectRestrictions.title" default="Display only variants with the following predicted effects on encoded proteins:" /></h4>
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
    <div class="col-md-5">
        <div id="biology-form">
            <div class="radio">
                <input type="radio" name="predictedEffects" value="all-effects" id="all_functions_checkbox" onClick="chgRadioButton('all-effects')" checked="checked"/>
                <g:message code="variantSearch.proteinEffectRestrictions.allEffects" default="all effects" />
                <g:helpText title="variantSearch.proteinEffectRestrictions.allEffectsQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variantSearch.proteinEffectRestrictions.allEffectsQ.help.text"/>
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="protein-truncating" id="protein_truncating_checkbox" onClick="chgRadioButton('protein-truncating')"/>
                <g:message code="variantSearch.proteinEffectRestrictions.proteinTruncating" default="protein-truncating" />
                <g:helpText title="variantSearch.proteinEffectRestrictions.proteinTruncatingQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variantSearch.proteinEffectRestrictions.proteinTruncatingQ.help.text"/>
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="missense"  id="missense_checkbox" onClick="chgRadioButton('missense')"/>
                <g:message code="variantSearch.proteinEffectRestrictions.missense" default="missense" />
                <g:helpText title="variantSearch.proteinEffectRestrictions.missenseQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variantSearch.proteinEffectRestrictions.missenseQ.help.text"/>
            </div>
            <div id="missense-options" style="display:none;">
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
            <div class="radio">
                <input type="radio" name="predictedEffects" value="noEffectSynonymous"  id="synonymous_checkbox" onClick="chgRadioButton('noEffectSynonymous')"/>
                <g:message code="variantSearch.proteinEffectRestrictions.synonymousCoding" default="no effect (synonymous coding)" />
                <g:helpText title="variantSearch.proteinEffectRestrictions.synonymousCodingQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variantSearch.proteinEffectRestrictions.synonymousCodingQ.help.text"/>
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="noEffectNoncoding"  id="noncoding_checkbox" onClick="chgRadioButton('noEffectNoncoding')"/>
                <g:message code="variantSearch.proteinEffectRestrictions.noncoding" default="no effect (non-coding)" />
                <g:helpText title="variantSearch.proteinEffectRestrictions.noncodingQ.help.header"  qplacer="2px 0 0 6px" placement="right" body="variantSearch.proteinEffectRestrictions.noncodingQ.help.text"/>
            </div>
        </div>
    </div>
    <div class="col-md-7">
        <g:message code="variantSearch.proteinEffectRestrictions.helpText" default="help text" />

    </div>
</div>

