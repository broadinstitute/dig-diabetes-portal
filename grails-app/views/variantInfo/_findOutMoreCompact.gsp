<div class="dk-t2d-blue dk-right-column-buttons-compact btn dk-linkout-btn">
    <div class="tooltip-text"><g:message code="findoutmore.gwascatalog.descr" default="GWAS Catalog"/></div>
    <a target="_blank" href="https://www.ebi.ac.uk/gwas/search?query=<%=variantToSearch%>">GWAS Catalog</a>
</div>

<div class="dk-t2d-blue dk-right-column-buttons-compact btn dk-linkout-btn">
    <div class="tooltip-text"><g:message code="findoutmore.variantgtex.descr" default="GTEx"/></div>
    <a target="_blank" href="http://www.gtexportal.org/home/eqtls/bySnp?snpId=<%=variantToSearch%>&tissueName=All">GTEx</a>
</div>

<div class="dk-t2d-blue dk-right-column-buttons-compact btn dk-linkout-btn dk-amp-funded">
    <div class="tooltip-text"><g:message code="findoutmore.variantpheweb.descr" default="PheWeb"/></div>
    <span>AMP</span>
    <a target="_blank" id="PheWebLink">PheWeb</a>
</div>

<div class="dk-t2d-blue dk-right-column-buttons-compact btn dk-linkout-btn">
    <div class="tooltip-text"><g:message code="findoutmore.snpedia.descr" default="SNPedia"/></div>
    <a target="_blank" href="http://www.snpedia.com/index.php/<%=variantToSearch%>">SNPedia</a>
</div>


<div class="dk-t2d-blue dk-right-column-buttons-compact btn dk-linkout-btn dk-amp-funded">
    <div class="tooltip-text"><g:message code="findoutmore.variantt2dream.descr" default="T2DREAM"/></div>
    <span>AMP</span>
    <a target="_blank" href="https://www.t2depigenome.org/region-search/?region=<%=variantToSearch%>&genome=GRCh37">T2DREAM</a>
</div>

<div class="dk-t2d-blue dk-right-column-buttons-compact btn dk-linkout-btn">
    <div class="tooltip-text"><g:message code="findoutmore.variantUCSC.descr" default="UCSC"/></div>
    <a target="_blank" href="https://genome.ucsc.edu/cgi-bin/hgTracks?db=hg19&lastVirtModeType=default&lastVirtModeExtraState=&virtModeType=default&virtMode=0&nonVirtPosition=&position=<%=chromosomeNumber%>%3A<%=positionNumber%>-<%=positionNumber%>">UCSC Genome Browser</a>
</div>
