package dport

class HomeController {
    def index = {
        java.util.LinkedHashMap variableStrings = [:]
        String siteVersion =   't2dgenes'   // 'sigma'
        if (siteVersion == 't2dgenes') {
            variableStrings["siteVersion"]  = 't2dgenes'
            variableStrings["siteTitle"]  = 'Type 2 Diabetes Genetics'
            variableStrings["fromEmail"]  = '"type2diabetesgenetics.org" <noreply@type2diabetesgenetics.org>'
            variableStrings["languageCode"]  = 'en'
        }   else if (siteVersion == 'sigma') {
            variableStrings["siteVersion"]  = 'sigma'
            variableStrings["siteTitle"]  = 'SIGMA T2D'
            variableStrings["fromEmail"]  = '"type2diabetesgenetics.org" <noreply@type2diabetesgenetics.org>'
            variableStrings["titleString"]  = 'es'
        }  else {
            assert('bad SITE_VERSION')
        }
        ["vars": variableStrings]
    }

}
