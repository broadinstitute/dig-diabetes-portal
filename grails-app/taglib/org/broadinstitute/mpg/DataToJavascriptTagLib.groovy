package org.broadinstitute.mpg

import org.broadinstitute.mpg.datapasser.GspToJavascript

class DataToJavascriptTagLib {

    def renderRowValues = { attrs,body ->
        if (attrs.data){
            GspToJavascript gspToJavascript = new GspToJavascript(attrs.data, GspToJavascript.TRANSTYPE_V_AND_A_ROW )
            out << gspToJavascript.printValuesAsJavascriptStrings()
            out << body()
        }

    }

    def renderRowMaps = { attrs,body ->
        if (attrs.data){
            GspToJavascript gspToJavascript = new GspToJavascript(attrs.data, GspToJavascript.TRANSTYPE_V_AND_A_ROW )
            out << gspToJavascript.printValuesAsJavascriptMaps()
            out << body()
        }

    }


    def renderColValues = { attrs,body ->
        if (attrs.data){
            GspToJavascript gspToJavascript = new GspToJavascript(attrs.data, GspToJavascript.TRANSTYPE_V_AND_A_COLUMN )
            out << gspToJavascript.printValuesAsJavascriptStrings()
            out << body()
        }

    }

    def renderColMaps = { attrs,body ->
        if (attrs.data){
            GspToJavascript gspToJavascript = new GspToJavascript(attrs.data, GspToJavascript.TRANSTYPE_V_AND_A_COLUMN )
            out << gspToJavascript.printValuesAsJavascriptMaps()
            out << body()
        }

    }


    def renderPassBackColumns = { attrs,body ->
        if (attrs.data){
            GspToJavascript gspToJavascript = new GspToJavascript(attrs.data, GspToJavascript.TRANSTYPE_V_AND_A_COLUMN )
            List <String> passBackValues = gspToJavascript.codeValuesForPassBack()
            for ( int  i = 0 ; i < passBackValues.size() ; i++ ){
                out << "<input type=\"hidden\" name=\"savedCol${i}\" class=\"form-control\" id=\"savedCol${i}\" value=\"${passBackValues[i]}\">\n"
            }
            out << body()
        }

    }


    def renderColumnCheckboxes = { attrs,body ->
        if (attrs.data){
            GspToJavascript gspToJavascript = new GspToJavascript(attrs.data, GspToJavascript.TRANSTYPE_V_AND_A_COLUMN )
            LinkedHashMap<String,LinkedHashMap<String,String>> namesAndValues = gspToJavascript.namesAndValues()
            int counter = 0
            namesAndValues.each {String name,LinkedHashMap<String,String> value->
                out << "<div class=\"checkbox\">\n"
                out << "<label><input type=\"checkbox\" name=\"savedCol${counter}\" id=\"savedCol${counter}\" value=\"${name}^${value.value}^0\" checked>${name}&nbsp;(p&nbsp&lt;&nbsp;${value.value})</label>\n"
                out << "</div>\n"
                counter++
            }
            out << body()
        }

    }

    def renderRowCheckboxes = { attrs,body ->
        if (attrs.data){
            GspToJavascript gspToJavascript = new GspToJavascript(attrs.data, GspToJavascript.TRANSTYPE_V_AND_A_ROW )
            LinkedHashMap<String,LinkedHashMap<String,String>> namesAndValues = gspToJavascript.namesAndValues()
            int counter = 0
            namesAndValues.each {String name,LinkedHashMap<String,String> value->
                out << "<div class=\"checkbox\">\n"
                out << "<label><input type=\"checkbox\" name=\"savedRow${counter}\" id=\"savedRow${counter}\" value=\"${name}^${value.value}^47^${value.pvalue}\" checked>${name}</label>\n"
                out << "</div>\n"
                counter++
            }
            out << body()
        }

    }

    def renderSampleGroupDropDown = { attrs,body ->
        if (attrs.data){
            GspToJavascript gspToJavascript = new GspToJavascript(attrs.data, GspToJavascript.TRANSTYPE_V_AND_A_ROW )
            LinkedHashMap<String,LinkedHashMap<String,String>> namesAndValues = gspToJavascript.namesAndValues()
            int counter = 0
            out << "<div class=\"dropdown\">"
            out << "<button class=\"btn btn-default dropdown-toggle\" type=\"button\" data-toggle=\"dropdown\">Dropdown Example<span class=\"caret\"></span></button>"
            out << "<ul class=\"dropdown-menu\" aria-labelledby=\"dropdownMenu1\">\n"
            namesAndValues.each {String name,LinkedHashMap<String,String> value->
                out << "<li><a onclick=\"insertVandARow('${name}','${value.value}')\">${name}</a></li>\n"
                counter++
            }
            out << "</ul>\n"
            out << "</div>\n"
            out << body()
        }

    }





}
