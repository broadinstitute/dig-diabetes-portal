package org.broadinstitute.mpg

class EthnicityCyclingTagLib {
    //static defaultEncodeAs = [taglib: 'html']
    //static encodeAsForTags = [tagName: [taglib:'html'], otherTagName: [taglib:'none']]
    List <List <String>> ethnicities = [["AA", "African-Americans"],
                                        ["EA", "East Asians"],
                                        ["SA", "South Asians"],
                                        ["EU", "Europeans"],
                                        ["HS", "Hispanics"]]

    /**
     * Renders all ethnicities
     *
     * @attr ethnicity
     *
     */
    def alleleFrequencyRange = {attrs, body ->


        ethnicities.eachWithIndex() {  ethnicity, index ->
            out << """<div class="checkbox">
            <div class="row">
            <div class="col-xs-5">
            <label>
            in <strong>${ethnicity[1]}</strong>:
                            </label>
            </div>
                        <div class="col-xs-2">
                            <input type="text" class="form-control" id="ethnicity_af_${ethnicity[0]}-min" style="width: 60%; display: inline-block"/>
                            <span width:40%></span>
            </div>
                        <div class="col-xs-1">
                            to
                        </div>
            <div class="col-xs-2">
            <input type="text" class="form-control" id="ethnicity_af_${ethnicity[0]}-max"  style="width: 60%; display: inline-block"/>""".toString()
            out << g.helpText(title:"variantSearch.setAlleleFrequencies.freqSpec.${ethnicity[0]}.help.header",
                    qplacer:"2px 0 0 6px", placement:"right",
                    body:"variantSearch.setAlleleFrequencies.freqSpec.${ethnicity[0]}.help.text")
           out << """</div>
                        </div>
            </div>""".toString()
        }
    }


    def alleleFrequencyRangeAbbreviated = {attrs, body ->


        ethnicities.eachWithIndex() {  ethnicity, index ->
            out << """<div class="checkbox smallish">
            <div class="row">
            <div class="col-xs-6">
            <label>
            <strong>${ethnicity[1]}</strong>:
                            </label>
            </div>
                        <div class="col-xs-6">
                            <input type="text" class="form-control" id="ethnicity_af_${ethnicity[0]}-min" style="width: 40%; display: inline-block"/>
            to <input type="text" class="form-control" id="ethnicity_af_${ethnicity[0]}-max"  style="width: 40%; display: inline-block"/>""".toString()
            out << """</div>
                        </div>
            </div>""".toString()
        }
    }






}
