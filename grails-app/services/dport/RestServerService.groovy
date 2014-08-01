package dport

import grails.transaction.Transactional
import  grails.plugins.rest.client.RestBuilder
import grails.plugins.rest.client.RestResponse
import org.codehaus.groovy.grails.commons.GrailsApplication
import org.codehaus.groovy.grails.web.json.JSONObject

@Transactional
class RestServerService {
    GrailsApplication grailsApplication


    private  String BASE_URL = 'http://t2dgenetics.org/dev/rest/server/'
    private  String GENE_INFO_URL = BASE_URL + "gene-info"
    private  String VARIANT_INFO_URL = BASE_URL + "variant-info"
    private  String VARIANT_SEARCH_URL = BASE_URL + "variant-search"

    static List <String> VARIANT_SEARCH_COLUMNS = [
    'ID',
    'CHROM',
    'POS',
    'DBSNP_ID',
    'CLOSEST_GENE',
    'MOST_DEL_SCORE',
    'Consequence',
    'IN_GENE',
    '_13k_T2D_TRANSCRIPT_ANNOT',
    ]


    static List <String> EXSEQ_VARIANT_SEARCH_COLUMNS = [
    'IN_EXSEQ',
    '_13k_T2D_P_EMMAX_FE_IV',
    '_13k_T2D_EU_MAF',
    '_13k_T2D_HS_MAF',
    '_13k_T2D_AA_MAF',
    '_13k_T2D_EA_MAF',
    '_13k_T2D_SA_MAF',
    '_13k_T2D_MINA',
    '_13k_T2D_MINU',
    '_13k_T2D_OR_WALD_DOS_FE_IV',
    ]


    static List <String> EXCHP_VARIANT_SEARCH_COLUMNS = [
    'IN_EXCHP',
    'EXCHP_T2D_P_value',
    'EXCHP_T2D_MAF',
    'EXCHP_T2D_BETA',
    ]


    static List <String> GWAS_VARIANT_SEARCH_COLUMNS = [
    'IN_GWAS',
    'GWAS_T2D_PVALUE',
    'GWAS_T2D_OR',
    ]


    static List <String> SIGMA_VARIANT_SEARCH_COLUMNS = [
    'SIGMA_T2D_P',
    'SIGMA_T2D_OR',
    'SIGMA_T2D_MINA',
    'SIGMA_T2D_MINU',
    'SIGMA_T2D_MAF',
    'SIGMA_SOURCE',
    'IN_SIGMA',
    ]





    static List <String> EXSEQ_VARIANT_COLUMNS = EXSEQ_VARIANT_SEARCH_COLUMNS + [
    '_13k_T2D_HET_ETHNICITIES',
    '_13k_T2D_HET_CARRIERS',
    '_13k_T2D_HETA',
    '_13k_T2D_HETU',
    '_13k_T2D_HOM_ETHNICITIES',
    '_13k_T2D_HOM_CARRIERS',
    '_13k_T2D_HOMA',
    '_13k_T2D_HOMU',
    ]

    static List <String> SIGMA_VARIANT_COLUMNS = SIGMA_VARIANT_SEARCH_COLUMNS + [
    'SIGMA_T2D_N',
    'SIGMA_T2D_MAC',
    'SIGMA_T2D_OBSA',
    'SIGMA_T2D_OBSU',
    'SIGMA_T2D_HETA',
    'SIGMA_T2D_HETU',
    'SIGMA_T2D_HOMA',
    'SIGMA_T2D_HOMU',
    'SIGMA_T2D_SE',
    ]


    static List <String> GENE_COLUMNS = [
    'ID',
    'CHROM',
    'BEG',
    'END',
    'Function_description',
    ]


    static List <String> EXSEQ_GENE_COLUMNS = [
    '_13k_T2D_VAR_TOTAL',
    '_13k_T2D_ORIGIN_VAR_TOTALS',
    '_13k_T2D_lof_NVAR',
    '_13k_T2D_lof_MINA_MINU_RET',
    '_13k_T2D_lof_METABURDEN',
    '_13k_T2D_GWS_TOTAL',
    '_13k_T2D_NOM_TOTAL',
    '_13k_T2D_lof_OBSA',
    '_13k_T2D_lof_OBSU'
    ]


    static List <String> EXCHP_GENE_COLUMNS = [
    'EXCHP_T2D_VAR_TOTALS',
    'EXCHP_T2D_GWS_TOTAL',
    'EXCHP_T2D_NOM_TOTAL',
    ]


    static List <String> GWAS_GENE_COLUMNS = [
    'GWS_TRAITS',
    'GWAS_T2D_GWS_TOTAL',
    'GWAS_T2D_NOM_TOTAL',
    'GWAS_T2D_VAR_TOTAL',
    ]


    static List <String> SIGMA_GENE_COLUMNS = [
    'SIGMA_T2D_VAR_TOTAL',
    'SIGMA_T2D_VAR_TOTALS',
    'SIGMA_T2D_NOM_TOTAL',
    'SIGMA_T2D_GWS_TOTAL',
    'SIGMA_T2D_lof_NVAR',
    'SIGMA_T2D_lof_MAC',
    'SIGMA_T2D_lof_MINA',
    'SIGMA_T2D_lof_MINU',
    'SIGMA_T2D_lof_P',
    'SIGMA_T2D_lof_OBSA',
    'SIGMA_T2D_lof_OBSU',
    ]

    // Did these old lines of Python do anything? Not that I can tell so far
    static List <String> VARIANT_COLUMNS = VARIANT_SEARCH_COLUMNS
    static List <String> EXCHP_VARIANT_COLUMNS = EXCHP_VARIANT_SEARCH_COLUMNS
    static List <String> GWAS_VARIANT_COLUMNS = GWAS_VARIANT_SEARCH_COLUMNS


    public void initialize (){
        if (grailsApplication.config.site.version == 't2dgenes') {
            VARIANT_SEARCH_COLUMNS += EXSEQ_VARIANT_SEARCH_COLUMNS + EXCHP_VARIANT_SEARCH_COLUMNS + GWAS_VARIANT_SEARCH_COLUMNS
            VARIANT_COLUMNS += EXSEQ_VARIANT_COLUMNS + EXCHP_VARIANT_COLUMNS + GWAS_VARIANT_COLUMNS
            GENE_COLUMNS += EXSEQ_GENE_COLUMNS + EXCHP_GENE_COLUMNS + GWAS_GENE_COLUMNS
        }

        if (grailsApplication.config.site.version ==  'sigma') {
            VARIANT_SEARCH_COLUMNS += SIGMA_VARIANT_SEARCH_COLUMNS + GWAS_VARIANT_SEARCH_COLUMNS
            VARIANT_COLUMNS += SIGMA_VARIANT_COLUMNS + GWAS_VARIANT_COLUMNS
            GENE_COLUMNS += SIGMA_GENE_COLUMNS + GWAS_GENE_COLUMNS
        }
    }

    /***
     * The point is to extract the relevant numbers from a string that looks something like this:
     *      String s="chr19:21,940,000-22,190,000"
     * @param incoming
     * @return
     */
    private LinkedHashMap<String, Integer> extractNumbersWeNeed (String incoming)  {
        LinkedHashMap<String, Integer> returnValue = [:]

        String commasRemoved=incoming.replace(/,/,"")
        java.util.regex.Matcher chromosome = commasRemoved =~ /chr\d*/
        if ( chromosome) {
            java.util.regex.Matcher chromosomeNumberString = chromosome[0] =~ /\d+/
            if (chromosomeNumberString) {
                int  chromosomeNumber = Integer.parseInt(chromosomeNumberString[0])
                returnValue ["chromosomeNumber"]  = chromosomeNumber
            }
        }
        java.util.regex.Matcher  startExtent = commasRemoved =~ /:\d*/
        if (startExtent){
            java.util.regex.Matcher startExtentString = startExtent[0] =~ /\d+/
            if (startExtentString)  {
                int startExtentNumber = Integer.parseInt(startExtentString[0])
                returnValue ["startExtent"]  = startExtentNumber
            }
        }
        java.util.regex.Matcher  endExtent = commasRemoved =~ /-\d*/
        if (endExtent){
            java.util.regex.Matcher endExtentString = endExtent[0] =~ /\d+/
            if (endExtentString)  {
                int endExtentNumber = Integer.parseInt(endExtentString[0])
                returnValue ["endExtent"]  = endExtentNumber
            }
        }
        return  returnValue
    }



    def hitService() {
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        def resp = rest.get("http://grails.org/api/v1.0/plugin/acegi/")
       println resp.toString ()
    }

   String getServiceBody (String url) {
       String returnValue = ""
       RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
       RestResponse response = rest.get(url)
       if (response.getStatus () == 200)  {
           returnValue =  response.getBody()
       }
       return returnValue
   }


    JSONObject getServiceJson (String url) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        RestResponse response  = rest.get(url)
        returnValue =  response.json
        return returnValue
    }


    JSONObject postServiceJson (String url,
                                String jsonString) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        RestResponse response  = rest.post(url)   {
            contentType "application/json"
            json jsonString
        }
        if (response.responseEntity.statusCode.value == 200) {
            returnValue =  response.json
        }
        return returnValue
    }


    LinkedHashMap<String, String> convertJsonToMap (JSONObject jsonObject)  {
        LinkedHashMap returnValue = [:]
        for (String sequenceKey in jsonObject.keySet()){
            def intermediateObject = jsonObject[sequenceKey]
            if (intermediateObject) {
                returnValue[sequenceKey] = intermediateObject.toString ()
            } else {
                returnValue[sequenceKey] = null
            }

        }
        return  returnValue
    }

    JSONObject retrieveGeneInfoByName (String geneName) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        String drivingJson = """{
"gene_symbol": "${geneName}",
"user_group": "ui",
"columns": [${"\""+GENE_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        RestResponse response  = rest.post(GENE_INFO_URL)   {
            contentType "application/json"
            json drivingJson
        }
        if (response.responseEntity.statusCode.value == 200) {
            returnValue =  response.json
        }
        return returnValue
    }



    JSONObject retrieveVariantInfoByName (String variantId) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        String drivingJson = """{
"variant_id": "${variantId}",
"user_group": "ui",
"columns": [${"\""+VARIANT_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        RestResponse response  = rest.post(VARIANT_INFO_URL)   {
            contentType "application/json"
            json drivingJson
        }
        if (response.responseEntity.statusCode.value == 200) {
            returnValue =  response.json
        }
        return returnValue
    }




    JSONObject searchGenomicRegionBySpecifiedRegion (Integer chromosome,
                                                     Integer beginSearch,
                                                     Integer endSearch) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        String drivingJson = """{
"user_group": "ui",
"filters": [
{ "filter_type": "STRING", "operand": "CHROM",  "operator": "EQ","value": "${chromosome}"  },
{"filter_type": "FLOAT","operand": "POS","operator": "GTE","value": ${beginSearch} },
{"filter_type":  "FLOAT","operand": "POS","operator": "LTE","value": ${endSearch} }
],
"columns": [${"\""+VARIANT_SEARCH_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        RestResponse response  = rest.post(VARIANT_SEARCH_URL)   {
            contentType "application/json"
            json drivingJson
        }
        if (response.responseEntity.statusCode.value == 200) {
            returnValue =  response.json
        }
        return returnValue
    }

    //("chr9:21,940,000-22,190,000")
    JSONObject searchGenomicRegionAsSpecifiedByUsers(String userSpecifiedString) {
        JSONObject returnValue = null
        LinkedHashMap<String, Integer> ourNumbers = extractNumbersWeNeed(userSpecifiedString)
        if (ourNumbers.containsKey("chromosomeNumber") &&
                ourNumbers.containsKey("startExtent") &&
                ourNumbers.containsKey("endExtent")) {
            returnValue = searchGenomicRegionBySpecifiedRegion(ourNumbers["chromosomeNumber"],
                    ourNumbers["startExtent"],
                    ourNumbers["endExtent"])
        }
        return returnValue
    }



    JSONObject searchGenomicRegionByName (String genomicRegion) {
        JSONObject returnValue = null
        RestBuilder rest = new grails.plugins.rest.client.RestBuilder()
        String drivingJson = """{
"user_group": "ui",
"filters": [
{ "filter_type": "STRING", "operand": "CHROM",  "operator": "EQ","value": "9"  },
{"filter_type": "FLOAT","operand": "POS","operator": "GTE","value": 21940000},
{"filter_type":  "FLOAT","operand": "POS","operator": "LTE","value": 22190000 }
],
"columns": [${"\""+VARIANT_SEARCH_COLUMNS.join("\",\"")+"\""}]
}
""".toString()
        RestResponse response  = rest.post(VARIANT_SEARCH_URL)   {
            contentType "application/json"
            json drivingJson
        }
        if (response.responseEntity.statusCode.value == 200) {
            returnValue =  response.json
        }
        return returnValue
    }



    static List<LinkedHashMap< String, String>> staticMessages = [[
                      key: "transcript_ablation",
                      name: "transcript ablation",
                      description: "It deletes a region that includes a transcript feature."
                  ],
                  [
                      key: "transcript_ablation" ,
                      name: "transcript ablation" ,
                      description: "It deletes a region that includes a transcript feature."
                  ],
                  [
                      key: "splice_donor_variant",
                      name: "splice donor variant",
                      description: "It is a splice variant that changes the 2-base region at the 5' end of an intron."
                  ],
                  [
                      key: "splice_acceptor_variant",
                      name: "splice acceptor variant",
                      description: "It is a splice variant that changes the 2-base region at the 3' end of an intron."
                  ],
                  [
                      key: "stop_gained",
                      name: "stop gained",
                      description: "It is a sequence variant that introduces a stop codon, leading to a shortened transcript."
                  ],
                  [
                      key: "frameshift_variant",
                      name: "frameshift variant",
                      description: "It causes a frameshift, disrupting the translational reading frame because the number of nucleotides inserted or deleted is not a multiple of three."
                  ],
                  [
                      key: "stop_lost",
                      name: "stop lost",
                      description: "It is a sequence variant that changes a stop codon, resulting in an elongated transcript."
                  ],
                  [
                      key: "initiator_codon_variant",
                      name: "initiator codon variant",
                      description: "It changes the first codon of a transcript."
                  ],
                  [
                      key: "inframe_insertion",
                      name: "inframe insertion",
                      description: "It is an inframe non-synonymous variant that inserts bases into the coding sequence."
                  ],
                  [
                      key: "inframe_deletion",
                      name: "inframe deletion",
                      description: "It is an inframe non-synonymous variant that deletes bases from the coding sequence."
                  ],
                  [
                      key: "missense_variant",
                      name: "missense variant",
                      description: "It results in a different amino acid sequence but preserves length."
                  ],
                  [
                      key: "transcript_amplification",
                      name: "transript amplification",
                      description: "It amplifies a region containing a transcript."
                  ],
                  [
                      key: "splice_region_variant",
                      name: "splice region variant",
                      description: "It is a sequence variant in which a change has occurred within the region of a splice site, either within 1-3 bases of the exon or 3-8 bases of the intron."
                  ],
                  [
                      key: "incomplete_terminal_codon_variant",
                      name: "incomplete terminal codon variant",
                      description: "It is a sequence variant that changes at least one base of the final codon of an incompletely annotated transcript."
                  ],
                  [
                      key: "synonymous_variant",
                      name: "synonymous variant",
                      description: "It does not cause any change to the encoded amino acid."
                  ],
                  [
                      key: "stop_retained_variant",
                      name: "stop retained variant",
                      description: "It changes the set of bases in a stop codon, but the stop codon itself remains functional."
                  ],
                  [
                      key: "coding_sequence_variant",
                      name: "coding sequence variant",
                      description: "It changes the coding sequence."
                  ],
                  [
                      key: "mature_miRNA_variant",
                      name: "mature miRNA variant",
                      description: "It is a transcript variant located with the sequence of the mature miRNA."
                  ],
                  [
                      key: "5_prime_UTR_variant",
                      name: "5' UTR variant",
                      description: "It is found in the 5' untranslated region."
                  ],
                  [
                      key: "3_prime_UTR_variant",
                      name: "3' UTR variant",
                      description: "It is found in the 3' untranslated region."
                  ],
                  [
                      key: "non_coding_exon_variant",
                      name: "non coding exon variant",
                      description: "It changes the non-coding exon sequence."
                  ],
                  [
                      key: "nc_transcript_variant",
                      name: "nc transcript variant",
                      description: "It is a transcript variant of a non-coding RNA."
                  ],
                  [
                      key: "intron_variant",
                      name: "intron variant",
                      description: "It is a transcript variant occurring within an intron."
                  ],
                  [
                      key: "NMD_transcript_variant",
                      name: "nmd transcript variant",
                      description: "It falls in a transcript that is the target of nonsense-mediated decay."
                  ],
                  [
                      key: "upstream_gene_variant",
                      name: "upstream gene variant",
                      description: "It is located upstream (5') of the gene."
                  ],
                  [
                      key: "downstream_gene_variant",
                      name: "downstream gene variant",
                      description: "It is located downstream (3') of the gene."
                  ],
                  [
                      key: "TFBS_ablation",
                      name: "tfbs ablation",
                      description: "It deletes a region that includes a transcription factor binding site."
                  ],
                  [
                      key: "TFBS_amplification",
                      name: "tfbs amplification",
                      description: "It amplifies a region that includes a transcription factor binding site."
                  ],
                  [
                      key: "TF_binding_site_variant",
                      name: "tf binding site variant",
                      description: "It is located within a transcription factor binding site."
                  ],
                  [
                      key: "regulatory_region_variant",
                      name: "regulatory region variant",
                      description: "It is located within a regulatory region."
                  ],
                  [
                      key: "regulatory_region_ablation",
                      name: "regulatory region ablation",
                      description: "It deletes a regulatory region."
                  ],
                  [
                      key: "regulatory_region_amplification",
                      name: "regulatory region amplification",
                      description: "It amplifies a regulatory region."
                  ],
                  [
                      key: "feature_elongation",
                      name: "feature elongation",
                      description: "It causes the extension of a genomic feature with regard to the reference sequence."
                  ],
                  [
                      key: "feature_truncation",
                      name: "feature truncation",
                      description: "It causes the truncation of a genomic feature with regard to the reference sequence."
                  ],
                  [
                      key:"intergenic_variant",
                              name: "intergenic variant",
                              description:"It is located in the intergenic region(between genes)."
                  ]];



    public String retrieveStaticField(String keyToMatch) {
        LinkedHashMap< String, String> returnValue
        LinkedHashMap< String, String> lookUp =  staticMessages.find{it.key=="featre_elongation"}
        if (lookUp) {
            returnValue =  lookUp
        }
        return returnValue
    }


}
