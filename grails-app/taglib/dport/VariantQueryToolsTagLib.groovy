package dport

import org.broadinstitute.mpg.SearchBuilderService
import org.broadinstitute.mpg.SharedToolsService
import org.broadinstitute.mpg.diabetes.MetaDataService
import org.broadinstitute.mpg.diabetes.metadata.query.GetDataQueryHolder
import org.broadinstitute.mpg.diabetes.util.PortalConstants

class VariantQueryToolsTagLib {

    SharedToolsService sharedToolsService
    SearchBuilderService searchBuilderService
    MetaDataService metaDataService

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
            List filterList = attrs.filterSet
            GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(filterList,searchBuilderService,metaDataService)
            List<String> noncommonEncodedFilterList = getDataQueryHolder.listOfEncodedFilters(PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY)
            noncommonEncodedFilterList += getDataQueryHolder.listOfEncodedFilters(PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY)
            for (String filter in noncommonEncodedFilterList) {
                if (filter) {
                    out << """<div id="filterBlock${blockCount}" class="developingQueryComponentsBlockOfFilters">
                    <div class="variantWFsingleFilter">
                    <div class="row clearfix">
                    <div class="col-md-10">""".toString()


                    out << sharedToolsService.translatorFilter (searchBuilderService.writeOutFiltersAsHtml( out, filter ))

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
            List<String> commonEncodedFilterList = getDataQueryHolder.listOfEncodedFilters(PortalConstants.TYPE_COMMON_PROPERTY_KEY)
            if (commonEncodedFilterList?.size()>0){

                out << """<div id="filterBlock${blockCount}" class="developingQueryComponentsBlockOfFilters">
                    <div class="variantWFsingleFilter">
                    <div class="row clearfix">
                    <div class="col-md-10">""".toString()

                List<String> listOfFilters = []
                for (String filter in commonEncodedFilterList) {
                    if (filter) {
                        listOfFilters << sharedToolsService.translatorFilter (searchBuilderService.writeOutFiltersAsHtml( out, filter ))
                    }
                }
                out << listOfFilters.join(", ")

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

        } else {
            out << ""
        }
    }




    def renderUlFilters = { attrs, body ->
        if ((attrs.encodedFilters) &&
                (attrs.encodedFilters.size() > 0)) {
            int blockCount = 0
            List filterList = attrs.encodedFilters
            GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(filterList,searchBuilderService,metaDataService)
            List<String> noncommonEncodedFilterList = getDataQueryHolder.listOfEncodedFilters(PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY)
            noncommonEncodedFilterList += getDataQueryHolder.listOfEncodedFilters(PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY)
            out  << "<ul>"
            for (String filter in noncommonEncodedFilterList) {
                if (filter) {

                    out << """<li>""".toString()

                    out << sharedToolsService.translatorFilter (searchBuilderService.writeOutFiltersAsHtml( out, filter ))

                    out << """</li>""".toString()

                }
            }
            List<String> commonEncodedFilterList = getDataQueryHolder.listOfEncodedFilters(PortalConstants.TYPE_COMMON_PROPERTY_KEY)
            if (commonEncodedFilterList?.size()>0){

                out << """<li>""".toString()

                    List<String> listOfFilters = []
                    for (String filter in commonEncodedFilterList) {
                        if (filter) {
                            listOfFilters << searchBuilderService.writeOutFiltersAsHtml( out, filter )
                        }
                    }
                    out << listOfFilters.join(", ")

                out << """</li>""".toString()


            }
            out  << "</ul>"
        } else {
            out << ""
        }
    }

    def renderHiddenFields = { attrs, body ->
        if ((attrs.filterSet) &&
                (attrs.filterSet.size() > 0)) {
            int blockCount = 0
            List filterList = attrs.filterSet
            GetDataQueryHolder getDataQueryHolder = GetDataQueryHolder.createGetDataQueryHolder(filterList,searchBuilderService,metaDataService)
            List<String> noncommonEncodedFilterList = getDataQueryHolder.listOfEncodedFilters(PortalConstants.TYPE_PHENOTYPE_PROPERTY_KEY)
            noncommonEncodedFilterList += getDataQueryHolder.listOfEncodedFilters(PortalConstants.TYPE_SAMPLE_GROUP_PROPERTY_KEY)
            for (String filter in noncommonEncodedFilterList) {
                if (filter?.trim().length()>0){
                    out << """<input type="text" class="form-control" id="savedValue${blockCount}" value="${
                        filter
                    }" style="height:0px">""".toString()
                    blockCount++;

                }
            }
            List<String> commonEncodedFilterList = getDataQueryHolder.listOfEncodedFilters(PortalConstants.TYPE_COMMON_PROPERTY_KEY)
            if (commonEncodedFilterList?.size()>0) {
                List<String> commonFilterList = []
                for (String filter in commonEncodedFilterList) {
                    if (filter?.trim().length() > 0) {
                        commonFilterList << filter?.trim()
                    }
                }

                if (commonFilterList.size() > 0) {
                    out << """<input type="text" class="form-control" id="savedValue${blockCount}" value="${commonFilterList.join("^")}" style="height:0px">""".toString()
                    blockCount++;
                }
            }
            out << """<input type="text" class="form-control" id="totalFilterCount" value="${blockCount}" style="height:0px"></div>""".toString()
        }
    }



}
