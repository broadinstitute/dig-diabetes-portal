package dport

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
                            <input type="text" class="form-control" id="ethnicity_af_${ethnicity[0]}-min" />
            </div>
                        <div class="col-xs-1">
                            to
                        </div>
            <div class="col-xs-2">
            <input type="text" class="form-control" id="ethnicity_af_${ethnicity[0]}-max"/>
            </div>
                        </div>
            </div>""".toString()
        }
    }
}
