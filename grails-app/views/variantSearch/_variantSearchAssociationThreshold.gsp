<h4>Set type 2 diabetes association threshold</h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="significance-form">
            <div class="radio">
                <label>
                    <input id="id_significance_genomewide" type="radio" name="significance" value="genomewide" />
                    genome-wide significance  |  &le; 5 x 10<sup>-8</sup>
                </label>
            </div>
            <div class="radio">
                <label for="id_significance_nominal">
                    <input id="id_significance_nominal" type="radio" name="significance" value="nominal" />
                    nominal significance | &le; .05
                </label>
            </div>
            <div class="radio">
                <label for="id_significance_custom">
                    <input id="id_significance_custom" type="radio" name="significance" value="custom" />
                    custom
                </label>
                <input type="text" id="custom_significance_input"/>
                or stronger
            </div>
        </div>
    </div>
    <div class="col-md-6">
        The genome-wide significance threshold  is high so as to eliminate
        false positives that naturally arise from testing millions of variants at once. Variants that fall short of genome-wide significance in one study may exceed it in another, and may still play a role in disease.
    </div>
</div>

