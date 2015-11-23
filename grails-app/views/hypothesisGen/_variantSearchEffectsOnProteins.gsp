<h4><g:message code='hypothesisGen.variantSearchEffectsOnProtiens.title'/>:</h4>
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
                <g:message code='hypothesisGen.variantSearchEffectsOnProtiens.radio.all_effects'/>
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="protein-truncating" id="protein_truncating_checkbox" onClick="chgRadioButton('protein-truncating')"/>
                <g:message code='hypothesisGen.variantSearchEffectsOnProtiens.radio.protein-truncating'/>
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="missense"  id="missense_checkbox" onClick="chgRadioButton('missense')"/>
                <g:message code='hypothesisGen.variantSearchEffectsOnProtiens.radio.missense'/>
            </div>
            <div id="missense-options" style="display:none;">
                <div class="checkbox">
                    <g:message code='hypothesisGen.variantSearchEffectsOnProtiens.check.PolyPhen-2'/>
                    <select name="polyphen" id="polyphenSelect">
                        <option value="">---</option>
                        <option value="probably_damaging"><g:message code='hypothesisGen.variantSearchEffectsOnProtiens.select.probably_damaging'/></option>
                        <option value="possibly_damaging"><g:message code='hypothesisGen.variantSearchEffectsOnProtiens.select.possibly_damaging'/></option>
                        <option value="benign"><g:message code='hypothesisGen.variantSearchEffectsOnProtiens.select.benign'/></option>
                    </select>
                </div>
                <div class="checkbox">
                    <g:message code='hypothesisGen.variantSearchEffectsOnProtiens.check.SIFT'/>
                    <select name="sift" id="siftSelect">
                        <option value="">---</option>
                        <option value="deleterious"><g:message code='hypothesisGen.variantSearchEffectsOnProtiens.select.deleterious'/></option>
                        <option value="tolerated"><g:message code='hypothesisGen.variantSearchEffectsOnProtiens.select.tolerated'/></option>
                    </select>
                </div>
                <div class="checkbox">
                    <g:message code='hypothesisGen.variantSearchEffectsOnProtiens.check.CONDEL'/>
                    <select name="condel" id="condelSelect">
                        <option value="">---</option>
                        <option value="deleterious"><g:message code='hypothesisGen.variantSearchEffectsOnProtiens.select.deleterious'/></option>
                        <option value="benign"><g:message code='hypothesisGen.variantSearchEffectsOnProtiens.select.benign'/></option>
                    </select>
                </div>
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="noEffectSynonymous"  id="synonymous_checkbox" onClick="chgRadioButton('noEffectSynonymous')"/>
                <g:message code='hypothesisGen.variantSearchEffectsOnProtiens.radio.no_effect_syn_code'/>
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="noEffectNoncoding"  id="noncoding_checkbox" onClick="chgRadioButton('noEffectNoncoding')"/>
                <g:message code='hypothesisGen.variantSearchEffectsOnProtiens.radio.no_effect_non_code'/>
            </div>
        </div>
    </div>
    <div class="col-md-7" style="display: none">
        <g:message code='hypothesisGen.variantSearchEffectsOnProtiens.desc'/>
    </div>
</div>

