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
                    if (map.dataSet) {
                        out << """
                    <span class="dataset filterElement">${map.dataSet},</span>
                    """.toString()
                    }
                    if (map.phenotype) {
                        out << """
                                <span class="phenotype filterElement">${map.phenotype},</span>
                    """.toString()

                    }
                    if ( map.orValue  ||
                            map.pValue  ||
                            map.esValue  ||
                            map.regionChromosomeInput  ||
                            map.regionStartInput  ||
                            map.regionStopInput  ||
                            map.gene  ||
                            map.predictedEffects  ||
                            map.polyphenSelect ) {


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
                                <span class="dd filterElement">chromosome=&nbsp;&nbsp; ${map.regionChromosomeInput},</span>
                                """.toString()
                            }// a single line for the P value

                            // a line to describe the polyphen value
                            if (map.regionStartInput) {
                                out << """
                                <span class="dd filterElement">start position:&nbsp;&nbsp; ${map.regionStartInput},</span>
                                """.toString()
                            }// a single line for the P value

                            // a line to describe the polyphen value
                            if (map.regionStopInput) {
                                out << """
                                <span class="dd filterElement">end position:&nbsp;&nbsp; ${map.regionStopInput},</span>
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
                                out << """
                                <span class="dd filterElement">predicted effects &nbsp;&nbsp; ${map.predictedEffects},</span>
                                """.toString()
                            }// a single line for the P value


                            // a line to describe the P value
                            if (map.polyphenSelect) {
                                out << """
                                <span class="dd filterElement">polyphen &lt&nbsp;&nbsp; ${map.polyphenSelect},</span>
                                """.toString()
                            }// a single line for the P value


                    }  // the section containing all filters
                        out << """
                        </div>

                    <div class="col-md-2">
                       <span class="pull-right developingQueryComponentsFilterIcons" style="margin: 4px 10px 0 auto;">
                       <span class="glyphicon glyphicon-pencil filterEditor filterActivator" aria-hidden="true" id="editer${blockCount}"></span>
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
                                 predictedEffects: map.predictedEffects])
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
