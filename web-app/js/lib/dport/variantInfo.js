function fillTheFields (data,variantToSearch,traitsStudiedUrlRoot)  {
    var cariantRec = {
        _13k_T2D_HET_CARRIERS : 1,
        _13k_T2D_HOM_CARRIERS : 2,
        IN_EXSEQ : 3,
        _13k_T2D_SA_MAF : 4,
        MOST_DEL_SCORE : 5,
        CLOSEST_GENE : 6,
        CHROM : 7,
        Consequence : 8,
        ID : 9,
        _13k_T2D_MINA : 10,
        _13k_T2D_HS_MAF : 11,
        DBSNP_ID : 12,
        _13k_T2D_EA_MAF : 13,
        _13k_T2D_AA_MAF : 14,
        POS : 15,
        _13k_T2D_TRANSCRIPT_ANNOT : 16,
        IN_GWAS : 17,
        GWAS_T2D_PVALUE: 18,
        EXCHP_T2D_P_value: 19,
        _13k_T2D_P_EMMAX_FE_IV: 20,
        GWAS_T2D_OR: 21,
        EXCHP_T2D_BETA: 22,
        _13k_T2D_OR_WALD_DOS_FE_IV: 23
    }
    variant =  data['variant'];
    variantTitle =  UTILS.get_variant_title(variant,variantToSearch);
    $('#variantTitleInAssociationStatistics').append(variantTitle);
    $('#variantCharacterization').append(UTILS.getSimpleVariantsEffect(variant.MOST_DEL_SCORE));
    $('#describingVariantAssociation').append(UTILS.variantInfoHeaderSentence(variant));
    var pVal= UTILS.get_lowest_p_value(variant);
    $('#variantPValue').append((parseFloat (pVal[0])).toPrecision(4));
    $('#variantInfoGeneratingDataSet').append(pVal[1]);


    $('#gwasAssociationStatisticsBox').append(UTILS.describeAssociationsStatistics(variant,
        cariantRec,
        cariantRec.IN_GWAS,
        cariantRec.GWAS_T2D_PVALUE,
        cariantRec.GWAS_T2D_OR,
        5e-8,
        5e-4,
        5e-2,
        variantTitle,
        "GWAS",
        false));
    $('#exomeChipAssociationStatisticsBox').append(UTILS.describeAssociationsStatistics(variant,
        cariantRec,
        cariantRec.EXCHP_T2D_P_value,
        cariantRec.EXCHP_T2D_P_value,
        cariantRec.EXCHP_T2D_BETA,
        5e-8,
        5e-4,
        5e-2,
        variantTitle,
        "exome chip",
        false));
    $('#exomeSequenceAssociationStatisticsBox').append(UTILS.describeAssociationsStatistics(variant,
        cariantRec,
        cariantRec._13k_T2D_P_EMMAX_FE_IV,
        cariantRec._13k_T2D_P_EMMAX_FE_IV,
        cariantRec._13k_T2D_OR_WALD_DOS_FE_IV,
        5e-8,
        5e-4,
        5e-2,
        variantTitle,
        "exome sequence",
        false));


    $('#variantInfoAssociationStatisticsLinkToTraitTable').append(UTILS.fillAssociationStatisticsLinkToTraitTable(variant,
        cariantRec,
        cariantRec.IN_GWAS,
        cariantRec.DBSNP_ID,
        cariantRec.ID,
        traitsStudiedUrlRoot));
    $('#variantTitle').append(variantTitle);
    $('#exomeDataExistsTheMinorAlleleFrequency').append(variantTitle);
    $('#populationsHowCommonIs').append(variantTitle);
    $('#biologicalImpactOfMysteryVariant').append(variantTitle);
    $('#howCommonInExomeSequencing').append(UTILS.showPercentageAcrossEthnicities(variant));
    $('#howCommonInHeterozygousCarriers').append(UTILS.showPercentagesAcrossHeterozygousCarriers(variant, variantTitle));
    $('#howCommonInHomozygousCarriers').append(UTILS.showPercentagesAcrossHomozygousCarriers(variant, variantTitle));
    $('#eurocentricVariantCharacterization').append(UTILS.eurocentricVariantCharacterization(variant, variantTitle));
    var weHaveEnoughDataToCharacterize = ((variant["_13k_T2D_TRANSCRIPT_ANNOT"]) && (variant["_13k_T2D_AA_MAF"]) && (variant["_13k_T2D_AA_MAF"]));
    UTILS.verifyThatDisplayIsWarranted(weHaveEnoughDataToCharacterize,$('#exomeDataExists'),$('#exomeDataDoesNotExist'));
    $('#sigmaVariantCharacterization').append(UTILS.sigmaVariantCharacterization(variant, variantTitle));
    $('#effectOfVariantOnProtein').append(UTILS.variantGenerateProteinsChooser(variant,variantTitle));
    UTILS.verifyThatDisplayIsWarranted(variant["_13k_T2D_TRANSCRIPT_ANNOT"],$('#variationInfoEncodedProtein'),$('#puntOnNoncodingVariant'));

}
