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




}
