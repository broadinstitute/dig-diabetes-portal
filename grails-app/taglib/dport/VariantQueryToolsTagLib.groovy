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

    def renderEncodedFilters = { attrs,body ->
        if ((attrs.filterSet) &&
                (attrs.filterSet.size()>0)) {
            int blockCount = 0
            for(LinkedHashMap map in attrs.filterSet){
                if (map.encoded){
               out << """<div id="filterBlock${blockCount}" class="developingQueryComponentsBlockOfFilters">
                    <div style="height: 25px; background-color: #ffffff">
                    <span class="text-left developingQueryComponentsFilterTitle">Filter number ${blockCount+1}</span>
                    <span class="pull-right developingQueryComponentsFilterIcons" style="margin: 4px 10px 0 auto;">
                        <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                    <span class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
                        <span class="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
                    </span>
                </div>

                    <div class="variantWFsingleFilter">
                    <div class="row clearfix">
                    <div class="col-md-10">""".toString()
                    if (map.phenotype){
                        out << """<div class="row clearfix developingQueryComponents">
                    <div class="col-md-3 text-right">Phenotype:</div>

                                <div class="col-md-9">${map.phenotype}</div>
                    </div>""".toString()

                    }
                    if  (map.phenotype) {
                        out << """<div class="row clearfix developingQueryComponents">
                                <div class="col-md-3 text-right">Data set:</div>

                    <div class="col-md-9">ExSeq_t2d_es_es</div>
                            </div>""".toString()
                    }
                    out << """<div class="row clearfix developingQueryComponents">
                    <div class="col-md-3 text-right">Filters:</div>

                                <div class="col-md-6">
                                    <div class="developingQueryComponentsFilters">
                                        <div class="row clearfix">
                                            <div class="col-md-6 text-right">odds ratio</div>

                    <div class="col-md-6">&gt;&nbsp;&nbsp; 2</div>
                                        </div>

                    <div class="row clearfix">
                    <div class="col-md-6 text-right">p-value</div>

                                            <div class="col-md-6">&lt&nbsp;&nbsp; .0005</div>
                    </div>
                                    </div>

                    <div class="col-md-3"></div>

                                </div>
                    </div>
                        </div>

                    <div class="col-md-2">

                    </div>
                    </div>

                    </div>
            </div>""".toString()

                }
            }

        } else {
            out << ""
        }
    }



    }
