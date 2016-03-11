<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'FG',
        dataset: 'GWAS_MAGIC_mdv5',
        pvalue: 'P_VALUE',
        name: 'fasting glucose',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.fasting_glucose" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: '2hrG',
        dataset: 'GWAS_MAGIC_mdv5',
        pvalue: 'P_VALUE',
        name: '2-hour glucose',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.two_hour_glucose" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: '2hrI',
        dataset: 'GWAS_MAGIC_mdv5',
        pvalue: 'P_VALUE',
        name: '2-hour insulin',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.two_hour_insulin" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'FI',
        dataset: 'GWAS_MAGIC_mdv5',
        pvalue: 'P_VALUE',
        name: 'fasting insulin',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.fasting_insulin" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'PI',
        dataset: 'GWAS_MAGIC_mdv5',
        pvalue: 'P_VALUE',
        name: 'fasting proinsulin',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.fasting_proinsulin" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'HBA1C',
        dataset: 'GWAS_MAGIC_mdv5',
        pvalue: 'P_VALUE',
        name: 'HBA1C',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.HbA1c" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'HOMAIR',
        dataset: 'GWAS_MAGIC_mdv5',
        pvalue: 'P_VALUE',
        name: 'HOMA-IR',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.HOMA-IR" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'HOMAB',
        dataset: 'GWAS_MAGIC_mdv5',
        pvalue: 'P_VALUE',
        name: 'HOMA-B',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.HOMA-B" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'BMI',
        dataset: 'GWAS_GIANT_mdv5',
        pvalue: 'P_VALUE',
        name: 'BMI',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.BMI" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'WHR',
        dataset: 'GWAS_GIANT_mdv5',
        pvalue: 'P_VALUE',
        name: 'waist-hip ratio',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.waist_hip_ratio" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'HEIGHT',
        dataset: 'GWAS_GIANT_mdv5',
        pvalue: 'P_VALUE',
        name: 'height',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.height" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'HDL',
        dataset: 'GWAS_GLGC_mdv5',
        pvalue: 'P_VALUE',
        name: 'HDL',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.HDL_cholesterol" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'LDL',
        dataset: 'GWAS_GLGC_mdv5',
        pvalue: 'P_VALUE',
        name: 'LDL',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.LDL_cholesterol" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'TG',
        dataset: 'GWAS_GLGC_mdv5',
        pvalue: 'P_VALUE',
        name: 'triglycerides',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.triglycerides" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'CAD',
        dataset: 'GWAS_CARDIoGRAM_mdv5',
        pvalue: 'P_VALUE',
        name: 'coronary artery disease',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.coronary_artery_disease" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'CKD',
        dataset: 'GWAS_CKDGenConsortium_mdv5',
        pvalue: 'P_VALUE',
        name: 'coronary kidney disease',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.chronic_kidney_disease" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'eGFRcrea',
        dataset: 'GWAS_CKDGenConsortium_mdv5',
        pvalue: 'P_VALUE',
        name: 'eGFR-creat (serum creatinine)',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.eGFR-creat" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'eGFRcys',
        dataset: 'GWAS_CKDGenConsortium_mdv5',
        pvalue: 'P_VALUE',
        name: 'eGFR-creat (serum creatinine)',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.eGFR-cys" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'MA',
        dataset: 'GWAS_MAGIC_mdv5',
        pvalue: 'P_VALUE',
        name: 'microalbuminuria',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.microalbuminuria" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'UACR',
        dataset: 'GWAS_CKDGenConsortium_mdv5',
        pvalue: 'P_VALUE',
        name: 'urinary albumin-to-creatinine ratio',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.urinary_atc_ratio" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'SCZ',
        dataset: 'GWAS_PGC_mdv5',
        pvalue: 'P_VALUE',
        name: 'schizophrenia',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.schizophrenia" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'MDD',
        dataset: 'GWAS_PGC_mdv5',
        pvalue: 'P_VALUE',
        name: 'major depressive disorder',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.depression" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'BIP',
        dataset: 'GWAS_PGC_mdv5',
        pvalue: 'P_VALUE',
        name: 'bipolar disorder',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.bipolar" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'Stroke_all',
        dataset: 'GWAS_Stroke_mdv5',
        pvalue: 'P_VALUE',
        name: 'stroke',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.stroke" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'Stroke_deep',
        dataset: 'GWAS_Stroke_mdv5',
        pvalue: 'P_VALUE',
        name: 'stroke deep',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.stroke_deep" /></a>
</li>
<li>
    <a onclick="igv.browser.loadTrack({ type: 't2d',
        url: '${createLink(controller:'trait', action:'getData')}',
        trait: 'Stroke_lobar',
        dataset: 'GWAS_Stroke_mdv5',
        pvalue: 'P_VALUE',
        name: 'stroke lobar',
        variantURL: '${g.createLink(absolute:true, uri:'/variantInfo/variantInfo/')}',
        traitURL: '${g.createLink(absolute:true, uri:'/trait/traitInfo/')}'
    })"><g:message code="informational.shared.traits.stroke_lobar" /></a>
</li>
