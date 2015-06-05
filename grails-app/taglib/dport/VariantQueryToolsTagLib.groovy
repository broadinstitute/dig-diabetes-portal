package dport

import dport.SharedToolsService

class VariantQueryToolsTagLib {

    SharedToolsService sharedToolsService


    def renderPhenotypeOptions = { attrs,body ->
        LinkedHashMap<String,List<LinkedHashMap>> map = sharedToolsService.composePhenotypeOptions()
        if (map){
            out <<  "<optgroup label='Cardiometabolic'>"
            List <Map> cardioList = map["cardio"]
            for (Map cardio in cardioList){
               String selectionIndicator = (cardio.mkey == 'T2D')?"  selected":""
               out <<  "<option value='${cardio.mkey}' ${selectionIndicator}>${cardio.name}</option>"
            }
            out <<  "</optgroup>"
            out << "<optgroup label='Other'>"
            List <Map> otherList = map["other"]
            for (Map other in otherList){
                out <<  "<option value='${other.mkey}'>${other.name}</option>"
            }
            out <<  "</optgroup>"
            out << body()
        }

    }


    def renderDatasetOptions = { attrs,body ->
        LinkedHashMap<String,List<LinkedHashMap>> map = sharedToolsService.composeDatasetOptions()
        if (map){
            out <<  "<optgroup label='Continental ancestry'>"
            List <Map> continentalAncestry = map["ancestry"]
            for (Map ancestry in continentalAncestry){
                out <<  "<option value='${ancestry.mkey}'>${ancestry.name}</option>"
            }
            out <<  "</optgroup>"
            out << body()
        }

    }

    def renderEncodedFilters = { attrs, body ->
        if ((attrs.filterSet) &&
                (attrs.filterSet.size() > 0)) {
            int blockCount = 0
            for (LinkedHashMap map in attrs.filterSet) {
                if (map.size()>0) {
                    out << """<div id="filterBlock${blockCount}" class="developingQueryComponentsBlockOfFilters">
                    <div class="variantWFsingleFilter">
                    <div class="row clearfix">
                    <div class="col-md-10">""".toString()

                    // write out all the custom filters, identifiable in the map with a prefix
                    LinkedHashMap customFilters = map.findAll{ it.key =~ /^filter/ }
                    customFilters.each {String key, String value->
                        out << """
                                <div class="phenotype filterElement">${sharedToolsService.makeFiltersPrettier(value)}</div>
                    """.toString()
                    }
                    if ( map ) {


                            // a line to describe the odds ratio
                            if (map.orValue) {
                                String inequality = "&gt;"
                                if (map.orValueInequality == "lessThan"){
                                    inequality = "&lt;"
                                }
                                out << """
                        <span class="cc filterElement">OR ${inequality}&nbsp; ${map.orValue},</span>
                                            """.toString()
                            }  // a single line for the odds ratio

                            // a line to describe the P value
                            if (map.pValue) {
                                String inequality = "&lt;"
                                if (map.pValueInequality == "greaterThan"){
                                    inequality = "&gt;"
                                }
                                out << """
                            <span class="dd filterElement">p-value ${inequality}&nbsp; ${map.pValue},</span>
                            """.toString()
                            }// a single line for the P value

                                // a line to describe the P value
                            if (map.esValue) {
                                String inequality = "&lt;"
                                if (map.esValueInequality == "greaterThan"){
                                    inequality = "&gt;"
                                }
                                out << """
                        <span class="dd filterElement">effect size ${inequality}&nbsp; ${map.esValue},</span>
                        """.toString()
                            }// a single line for the effect value

                            // a line to describe the polyphen value
                            if (map.regionChromosomeInput) {
                                out << """
                                <span class="dd filterElement">chromosome: ${map.regionChromosomeInput},</span>
                                """.toString()
                            }// a single line for the P value

                            // a line to describe the polyphen value
                            if (map.regionStartInput) {
                                out << """
                                <span class="dd filterElement">start position:&nbsp; ${map.regionStartInput},</span>
                                """.toString()
                            }// a single line for the P value

                            // a line to describe the polyphen value
                            if (map.regionStopInput) {
                                out << """
                                <span class="dd filterElement">end position:&nbsp; ${map.regionStopInput},</span>
                                """.toString()
                            }// a single line for the P value

                            // a line to describe the polyphen value
                            if (map.gene) {
                                out << """
                                <span class="dd filterElement">gene=&nbsp;&nbsp; ${map.gene},</span>
                                """.toString()
                            }// a single line for the P value

                            // a line to describe the polyphen value
                            if (map.predictedEffects) {
                                if (map.predictedEffects != "all-effects")  {  // don't display the default
                                    out << """
                                <span class="dd filterElement">predicted effects: ${map.predictedEffects},</span>
                                """.toString()
                                }
                             }// a single line for the P value

                        if (map.polyphenSelect) {
                            out << """
                                <span class="dd filterElement">polyphen prediction: ${map.polyphenSelect},</span>
                                """.toString()
                        }// a single line for the P value
                        if (map.siftSelect) {
                            out << """
                                <span class="dd filterElement">sift prediction: ${map.siftSelect},</span>
                                """.toString()
                        }// a single line for the P value
                        if (map.condelSelect) {
                            out << """
                                <span class="dd filterElement">condel prediction: ${map.condelSelect},</span>
                                """.toString()
                        }// a single line for the P value


                    }  // the section containing all filters
                        out << """
                        </div>

                    <div class="col-md-2">
                       <span class="pull-right developingQueryComponentsFilterIcons" style="margin: 4px 10px 0 auto;">
                       <span class="glyphicon glyphicon-pencil filterEditor filterActivator" aria-hidden="true" onclick="mpgSoftware.variantWF.editThisClause(this)" id="editor${blockCount}"></span>
                       <span class="glyphicon glyphicon-plus-sign filterAdder filterActivator" aria-hidden="true" id="adder${blockCount}"></span>
                       <span class="glyphicon glyphicon-remove-circle filterCanceler filterActivator" aria-hidden="true" onclick="mpgSoftware.variantWF.removeThisClause(this)" id="remover${blockCount}"></span>
                    </span>
                    </div>
                    </div>
                    </div>

            </div>""".toString()
                            blockCount++;
                        }
                    }

                } else {
                    out << ""
                }
    }

    def renderHiddenFields = { attrs, body ->
        if ((attrs.filterSet) &&
                (attrs.filterSet.size() > 0)) {
            int blockCount = 0
            for (LinkedHashMap map in attrs.filterSet) {
                    if (map.size()>0){
                        LinkedHashMap customFilters = map.findAll{ it.key =~ /^filter/ }
                        String encodedFilterList = sharedToolsService.encodeAFilterList(
                                [phenotype:map.phenotype,
                                 dataSet:map.dataSet,
                                 orValue: map.orValue,
                                 orValueInequality: map.orValueInequality,
                                 pValue: map.pValue,
                                 pValueInequality: map.pValueInequality,
                                 esValue: map.esValue,
                                 esValueInequality: map.esValueInequality,
                                 regionStopInput: map.regionStopInput,
                                 regionStartInput: map.regionStartInput,
                                 regionChromosomeInput: map.regionChromosomeInput,
                                 gene: map.gene,
                                 predictedEffects: map.predictedEffects,
                                 polyphenSelect: map.polyphenSelect,
                                 siftSelect: map.siftSelect,
                                 condelSelect: map.condelSelect], customFilters
                        )
                        out << """<input type="text" class="form-control" id="savedValue${blockCount}" value="${
                            encodedFilterList
                        }" style="height:0px">""".toString()
                        blockCount++;
                    }
             }
            out << """<input type="text" class="form-control" id="totalFilterCount" value="${
                blockCount
            }" style="height:0px"></div>""".toString()
        }
    }



}
