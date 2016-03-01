
%{--Why I am forced to include style directives explicitly in this page and no other I do not know. There must be--}%
%{--something funny about IGV's use of CSS that is different than everything else in the application.  //TODO -- fix this--}%
<g:set var="restServer" bean="restServerService"/>
<script>
        function  igvSearch(searchString) {
                igv.browser.search(searchString);
                return true;
            }
</script>

<div id="myDiv">
<p>

    <g:message code="gene.igv.intro1" default="Use the browser"/>
    <g:renderT2dGenesSection>
        <g:message code="gene.igv.intro2" default="(non-Sigma databases)"/>
    </g:renderT2dGenesSection>
       <g:message code="gene.igv.intro3" default="or the traits"/>
    <g:renderT2dGenesSection>
       <g:message code="gene.igv.intro4" default="(GWAS)"/>
    </g:renderT2dGenesSection>
     .
</p>

<br/>
<script>
</script>
<nav class="navbar" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse"
                        data-target="#bs-example-navbar-collapse-1"><span class="sr-only"><g:message code="controls.shared.igv.toggle_nav" /></span><span
                        class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button>
                <a class="navbar-brand">IGV</a></div>
            <div id="bs-example-navbar-collapse-1" class="collapse navbar-collapse">
                <ul class="nav navbar-nav navbar-left">
                    <li class="dropdown" id="tracks-menu-dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown"><g:message code="controls.shared.igv.tracks" /><b class="caret"></b></a>
                        <ul id="trackList" class="dropdown-menu">
                        <li>
                            <a onclick="igv.browser.loadTrack({ type: 't2d',
                                url: '${createLink(controller:'trait', action:'getData')}',
                                trait: 'T2D',
                                dataset: 'ExSeq_17k_mdv2',
                                pvalue: 'P_EMMAX_FE_IV_17k',
                                name: 'T2D (exome sequencing)',
                                variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                            })">T2D (<g:message code="variant.variantAssociations.source.exomeSequenceQ.help.header" />)</a>
                        </li>
                        <li>
                            <a onclick="igv.browser.loadTrack({ type: 't2d',
                                url: '${createLink(controller:'trait', action:'getData')}',
                                trait: 'T2D',
                                dataset: 'ExChip_82k_mdv2',
                                pvalue: 'P_VALUE',
                                name: 'T2D (exome chip)',
                                variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                            })">T2D (<g:message code="variant.variantAssociations.source.exomeChipQ.help.header" />)</a>
                        </li>
                        <li>
                            <a onclick="igv.browser.loadTrack({ type: 't2d',
                                url: '${createLink(controller:'trait', action:'getData')}',
                                trait: 'FG',
                                dataset: 'GWAS_MAGIC_mdv2',
                                pvalue: 'P_VALUE',
                                name: 'fasting glucose',
                                variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                            })"><g:message code="informational.shared.traits.fasting_glucose" /></a>
                        </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: '2hrG',
                                    dataset: 'GWAS_MAGIC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: '2-hour glucose',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.two_hour_glucose" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: '2hrI',
                                    dataset: 'GWAS_MAGIC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: '2-hour insulin',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.two_hour_insulin" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'FI',
                                    dataset: 'GWAS_MAGIC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'fasting insulin',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.fasting_insulin" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'PI',
                                    dataset: 'GWAS_MAGIC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'fasting proinsulin',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.fasting_proinsulin" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'HBA1C',
                                    dataset: 'GWAS_MAGIC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'HBA1C',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.HbA1c" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'HOMAIR',
                                    dataset: 'GWAS_MAGIC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'HOMA-IR',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.HOMA-IR" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'HOMAB',
                                    dataset: 'GWAS_MAGIC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'HOMA-B',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.HOMA-B" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'BMI',
                                    dataset: 'GWAS_GIANT_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'BMI',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.BMI" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'WHR',
                                    dataset: 'GWAS_GIANT_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'waist-hip ratio',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.waist_hip_ratio" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'HEIGHT',
                                    dataset: 'GWAS_GIANT_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'height',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.height" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'HDL',
                                    dataset: 'GWAS_GLGC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'HDL',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.HDL_cholesterol" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'LDL',
                                    dataset: 'GWAS_GLGC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'LDL',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.LDL_cholesterol" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'TG',
                                    dataset: 'GWAS_GLGC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'triglycerides',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.triglycerides" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'CAD',
                                    dataset: 'GWAS_CARDIoGRAM_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'coronary artery disease',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.coronary_artery_disease" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'CKD',
                                    dataset: 'GWAS_CKDGenConsortium_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'coronary kidney disease',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.chronic_kidney_disease" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'eGFRcrea',
                                    dataset: 'GWAS_CKDGenConsortium_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'eGFR-creat (serum creatinine)',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.eGFR-creat" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'eGFRcys',
                                    dataset: 'GWAS_CKDGenConsortium_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'eGFR-creat (serum creatinine)',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.eGFR-cys" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'MA',
                                    dataset: 'GWAS_MAGIC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'microalbuminuria',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.microalbuminuria" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'UACR',
                                    dataset: 'GWAS_CKDGenConsortium_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'urinary albumin-to-creatinine ratio',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.urinary_atc_ratio" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'SCZ',
                                    dataset: 'GWAS_PGC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'schizophrenia',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.schizophrenia" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'MDD',
                                    dataset: 'GWAS_PGC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'major depressive disorder',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.depression" /></a>
                            </li>
                            <li>
                                <a onclick="igv.browser.loadTrack({ type: 't2d',
                                    url: '${createLink(controller:'trait', action:'getData')}',
                                    trait: 'BIP',
                                    dataset: 'GWAS_PGC_mdv2',
                                    pvalue: 'P_VALUE',
                                    name: 'bipolar disorder',
                                    variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
                                    traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
                                })"><g:message code="informational.shared.traits.bipolar" /></a>
                            </li>
<g:if test="${session?.getAttribute('portalType')?.equals('stroke')}">
    <li>
        <a onclick="igv.browser.loadTrack({ type: 't2d',
            url: '${createLink(controller:'trait', action:'getData')}',
            trait: 'Stroke_all',
            dataset: 'GWAS_Stroke_mdv5',
            pvalue: 'P_VALUE',
            name: 'stroke',
            variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
            traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
        })"><g:message code="informational.shared.traits.stroke" /></a>
    </li>
    <li>
        <a onclick="igv.browser.loadTrack({ type: 't2d',
            url: '${createLink(controller:'trait', action:'getData')}',
            trait: 'Stroke_deep',
            dataset: 'GWAS_Stroke_mdv5',
            pvalue: 'P_VALUE',
            name: 'stroke deep',
            variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
            traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
        })"><g:message code="informational.shared.traits.stroke_deep" /></a>
    </li>
    <li>
        <a onclick="igv.browser.loadTrack({ type: 't2d',
            url: '${createLink(controller:'trait', action:'getData')}',
            trait: 'Stroke_lobar',
            dataset: 'GWAS_Stroke_mdv5',
            pvalue: 'P_VALUE',
            name: 'stroke lobar',
            variantURL: 'http://www.type2diabetesgenetics.org/variantInfo/variantInfo/',
            traitURL: 'http://www.type2diabetesgenetics.org/trait/traitInfo/'
        })"><g:message code="informational.shared.traits.stroke_lobar" /></a>
    </li>
</g:if>
                        </ul>
                    </li>
                </ul>
                <div class="nav navbar-nav navbar-left">
                    <div class="well-sm">
                        <input id="goBoxInput" class="form-control" placeholder="Locus Search" type="text"
                               onchange="igvSearch($('#goBoxInput')[0].value)">
                    </div>
                </div>
                <div class="nav navbar-nav navbar-left">
                    <div class="well-sm">
                        <button id="goBox" class="btn btn-default" onclick="igvSearch($('#goBoxInput')[0].value)">
                            <g:message code="controls.shared.igv.search" />
                        </button>
                    </div>
                </div>
                <div class="nav navbar-nav navbar-right">
                    <div class="well-sm">
                        <div class="btn-group-sm"></div>
                        <button id="zoomOut" type="button" class="btn btn-default btn-sm"
                                onclick="igv.browser.zoomOut()">
                            <span class="glyphicon glyphicon-minus"></span></button>
                        <button id="zoomIn" type="button" class="btn btn-default btn-sm" onclick="igv.browser.zoomIn()">
                            <span class="glyphicon glyphicon-plus"></span></button>
                    </div>
                </div>
            </div>
        </div>
    </nav>

</div>
<script type="text/javascript">

   var setUpIgv = function (locusName, serverName){

        var div,
                options,
                browser;

        div = $("#myDiv")[0];
        options = {
            showKaryo: false,
            showCommandBar: false,
            fastaURL: "//dn7ywbm9isq8j.cloudfront.net/genomes/seq/hg19/hg19.fasta",
            cytobandURL: "//dn7ywbm9isq8j.cloudfront.net/genomes/seq/hg19/cytoBand.txt",
            locus: locusName,
            flanking: 100000,
            tracks: [
<g:if test="${session?.getAttribute('portalType')?.equals('stroke')}">
                {
                    type: "t2d",
                    url: "${createLink(controller:'trait', action:'getData')}",
                    trait: "Stroke_all",
                    dataset: "GWAS_Stroke_mdv5",
                    pvalue: "P_VALUE",
                    name: "<g:message code='informational.shared.traits.stroke' />",
                    variantURL: "http://www.type2diabetesgenetics.org/variantInfo/variantInfo/",
                    traitURL: "http://www.type2diabetesgenetics.org/trait/traitInfo/"
                },
                {
                    type: "t2d",
                    url: "${createLink(controller:'trait', action:'getData')}",
                    trait: "Stroke_deep",
                    dataset: "GWAS_Stroke_mdv5",
                    pvalue: "P_VALUE",
                    name: "<g:message code='informational.shared.traits.stroke_deep' />",
                    variantURL: "http://www.type2diabetesgenetics.org/variantInfo/variantInfo/",
                    traitURL: "http://www.type2diabetesgenetics.org/trait/traitInfo/"
                },
                {
                    type: "t2d",
                    url: "${createLink(controller:'trait', action:'getData')}",
                    trait: "Stroke_lobar",
                    dataset: "GWAS_Stroke_mdv5",
                    pvalue: "P_VALUE",
                    name: "<g:message code='informational.shared.traits.stroke_lobar' />",
                    variantURL: "http://www.type2diabetesgenetics.org/variantInfo/variantInfo/",
                    traitURL: "http://www.type2diabetesgenetics.org/trait/traitInfo/"
                },
</g:if>
<g:else>
                {
                    type: "t2d",
                    %{--url: "${restServer.currentRestServer()}getData",--}%
                    url: "${createLink(controller:'trait', action:'getData')}",
                    trait: "T2D",
                    dataset: "GWAS_DIAGRAM_mdv2",
                    pvalue: "P_VALUE",
                    name: "<g:message code='portal.header.title.short' />",
                    variantURL: "http://www.type2diabetesgenetics.org/variantInfo/variantInfo/",
                    traitURL: "http://www.type2diabetesgenetics.org/trait/traitInfo/"
                },
                {
                    type: "t2d",
                    url: "${createLink(controller:'trait', action:'getData')}",
                    trait: "FG",
                    dataset: "GWAS_MAGIC_mdv2",
                    pvalue: "P_VALUE",
                    name: "<g:message code='informational.shared.traits.fasting_glucose' />",
                    variantURL: "http://www.type2diabetesgenetics.org/variantInfo/variantInfo/",
                    traitURL: "http://www.type2diabetesgenetics.org/trait/traitInfo/"
                },
                {
                    type: "t2d",
                    url: "${createLink(controller:'trait', action:'getData')}",
                    trait: "FI",
                    dataset: "GWAS_MAGIC_mdv2",
                    pvalue: "P_VALUE",
                    name: "<g:message code='informational.shared.traits.fasting_insulin' />",
                    variantURL: "http://www.type2diabetesgenetics.org/variantInfo/variantInfo/",
                    traitURL: "http://www.type2diabetesgenetics.org/trait/traitInfo/"
                },
</g:else>
                {
                    url: "http://data.broadinstitute.org/igvdata/t2d/recomb_decode.bedgraph",
                    min: 0,
                    max: 7,
                    name: "<g:message code='controls.shared.igv.tracks.recomb_rate' />",
                    order: 9998
                },
                {
                    type: "sequence",
                    order: -9999
                },
                {
                    url: "//dn7ywbm9isq8j.cloudfront.net/annotations/hg19/genes/gencode.v18.collapsed.bed",
                    name: "<g:message code='controls.shared.igv.tracks.genes' />",
                    order: 10000
                }
            ]
        };

        browser = igv.createBrowser(div, options);
    };

</script>

