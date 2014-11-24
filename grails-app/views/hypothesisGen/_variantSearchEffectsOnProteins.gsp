<h4>Display only variants with the following predicted effects on encoded proteins:</h4>
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
                all effects
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="protein-truncating" id="protein_truncating_checkbox" onClick="chgRadioButton('protein-truncating')"/>
                protein-truncating
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="missense"  id="missense_checkbox" onClick="chgRadioButton('missense')"/>
                missense
            </div>
            <div id="missense-options" style="display:none;">
                <div class="checkbox">
                    PolyPhen-2 prediction
                    <select name="polyphen" id="polyphenSelect">
                        <option value="">---</option>
                        <option value="probably_damaging">probably damaging</option>
                        <option value="possibly_damaging">possibly damaging</option>
                        <option value="benign">benign</option>
                    </select>
                </div>
                <div class="checkbox">
                    SIFT prediction
                    <select name="sift" id="siftSelect">
                        <option value="">---</option>
                        <option value="deleterious">deleterious</option>
                        <option value="tolerated">tolerated</option>
                    </select>
                </div>
                <div class="checkbox">
                    CONDEL prediction
                    <select name="condel" id="condelSelect">
                        <option value="">---</option>
                        <option value="deleterious">deleterious</option>
                        <option value="benign">benign</option>
                    </select>
                </div>
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="noEffectSynonymous"  id="synonymous_checkbox" onClick="chgRadioButton('noEffectSynonymous')"/>
                no effect (synonymous coding)
            </div>
            <div class="radio">
                <input type="radio" name="predictedEffects" value="noEffectNoncoding"  id="noncoding_checkbox" onClick="chgRadioButton('noEffectNoncoding')"/>
                no effect (non-coding)
            </div>
        </div>
    </div>
    <div class="col-md-7">
        <p>
            Loss-of-function variants <a href="http://www.plengegen.com/wp-content/uploads/Plenge_NRDD_2013_geneticsTV.pdf">can be valuable models for drug development</a> because
        they naturally illustrate the phenotypic effects of deactivating a gene.
        Several types of variants may cause a loss of function;
        most obviously, variants that truncate a protein may prevent it from playing its normal biological role.
        Missense variants have a wider variety of effects on protein structure,
        which can be difficult to ascertain with annotation tools alone.
        Results obtained from such tools should therefore be treated with care.
        </p>
        <p>
            The tools at left take different information into account to predict the effects of SNPs on protein structure.
            <strong>PolyPhen-2</strong> predictions are based on whether a variant appears in a region that is highly conserved across species
        (and thus may serve critical biological functions),
        and whether the variant is in a location likely to affect the protein's 3D structure.
            <strong>SIFT</strong> also relies on sequence conservation across species to predict whether a protein will
        tolerate any given single amino acid substitution at any given position in its sequence.
            <strong>Condel</strong> combines the weighted averages for several such algorithms (including but not limited to PolyPhen-2 and SIFT)
        for a consensus prediction.
        </p>
    </div>
</div>

