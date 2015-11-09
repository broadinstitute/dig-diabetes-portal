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
//                out << "<g:hiddenField name=\"savedCol${i}\"  value=\"${passBackValues[i]}\"/>\n"
            }
            out << body()
        }

    }





}
