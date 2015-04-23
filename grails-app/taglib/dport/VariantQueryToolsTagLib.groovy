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
               out <<  "<option value='${cardio.mkey}'>${cardio.name}</option>"
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
                    <div style="height: 25px; background-color: #ffffff">
                    <span class="text-left developingQueryComponentsFilterTitle">Filter number ${blockCount + 1}</span>
                    <span class="pull-right developingQueryComponentsFilterIcons" style="margin: 4px 10px 0 auto;">
                    <span class="glyphicon glyphicon-pencil" aria-hidden="true" id="editer${blockCount}"></span>
                    <span class="glyphicon glyphicon-plus-sign" aria-hidden="true" id="adder${blockCount}"></span>
                    <span class="glyphicon glyphicon-remove-circle" aria-hidden="true" onclick="mpgSoftware.variantWF.removeThisFilterSet(this)" id="remover${blockCount}"></span>
                    </span>
                </div>

                    <div class="variantWFsingleFilter">
                    <div class="row clearfix">
                    <div class="col-md-10">""".toString()
                    if (map.phenotype) {
                        out << """<div class="row clearfix developingQueryComponents">
                    <div class="col-md-3 text-right">Phenotype:</div>

                                <div class="col-md-9">${map.phenotype}</div>
                    </div>""".toString()

                    }
                    if (map.dataSet) {
                        out << """<div class="row clearfix developingQueryComponents">
                                <div class="col-md-3 text-right">Data set:</div>

                    <div class="col-md-9">${map.dataSet}</div>
                            </div>""".toString()
                    }
                    out << """<div class="row clearfix developingQueryComponents">""".toString()
                    if (map.orValue  || map.pValue) {
                        out << """<div class="col-md-3 text-right">Filters:</div>
                    <div class="col-md-6">
                                    <div class="developingQueryComponentsFilters">
                                    """.toString()

                            // a line to describe the odds ratio
                            if (map.orValue) {
                                out << """<div class="row clearfix">
                                                <div class="col-md-6 text-right">odds ratio</div>

                        <div class="col-md-6">&gt;&nbsp;&nbsp; ${map.orValue}</div>
                                            </div>""".toString()
                            }  // a single line for the odds ratio

                            // a line to describe the P value
                            if (map.pValue) {
                                out << """<div class="row clearfix">
                            <div class="col-md-6 text-right">p-value</div>

                                                    <div class="col-md-6">&lt&nbsp;&nbsp; ${map.pValue}</div>
                            </div>""".toString()
                            }// a single line for the P value

                            out << """</div>
                                <div class="col-md-3"></div>

                                </div>""".toString()
                    }  // the section containing all filters
                        out << """</div>
                        </div>

                    <div class="col-md-2">

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
                                 pValueInequality: map.pValueInequality])
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
