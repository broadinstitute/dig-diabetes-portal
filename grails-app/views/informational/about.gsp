<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

    <style>
    #main > div {
        width: 90%;
        margin: auto;
    }
    </style>
</head>


<body>

<div id="main">
    <div>
        <h1>About the Accelerating Medicines Partnership and the Type 2 Diabetes Knowledge Portal project</h1>

        <p>The Type 2 Diabetes Knowledge Portal is being developed as part of the <a
                href="https://www.nih.gov/research-training/accelerating-medicines-partnership-amp">Accelerating Medicines Partnership (AMP)</a>, a public-private partnership between the National Institutes of Health (NIH), the U.S. Food and Drug Administration (FDA), 10 biopharmaceutical companies, and multiple non-profit organizations that is managed through the <a
                href="http://www.fnih.org/">Foundation for the NIH (FNIH)</a>. AMP seeks to harness collective capabilities, scale, and resources toward improving current efforts to develop new therapies for complex, heterogeneous diseases. The ultimate goal is to increase the number of new diagnostics and therapies for patients while reducing the time and cost of developing them, by jointly identifying and validating promising biological targets for several diseases, including type 2 diabetes.
        </p>

        <h2>AMP T2D</h2>

        <p>The AMP type 2 diabetes (AMP T2D) consortium is a collaboration of a number of AMP funded investigators from around the world, including the Broad Institute, University of Michigan, University of Oxford, and the European Biomedical Institute.  AMP T2D focuses on type 2 diabetes genetics, seeking to use and supplement the substantial amount of human genetic data available from people with type 2 diabetes, or at risk of developing it, to identify and validate novel molecules and pathways as targets for therapeutic development. Genetic data combined with information on gene expression and epigenomics in relevant tissues, and clinical information, can provide clues about the effects of genetic changes within an individual’s genome that increase or decrease one’s risk of developing type 2 diabetes and its complications, including heart and kidney disease.
        </p>

        <p>After identifying DNA regions that might be critical for the development or progression of type 2 diabetes, researchers will intensively analyze variations in DNA sequence in targeted populations. Among other things, they will be looking for rare individuals whose genetic inheritance may provide a model of what a targeted drug might achieve. This research will add to the foundational understanding of type 2 diabetes and has the potential to lead to new drug targets and better targeting of drugs.</p>

        <p>In addition to generating data, an important goal of the AMP T2D consortium is to make these data accessible via a knowledge portal, using genetic and phenotypic data generated from type 2 diabetics and controls across multiple populations in order to bring forth discoveries in the genetic architecture of type 2 diabetes and to facilitate the development of new therapeutic targets for treating this disease.</p>

        <h2>The T2D Knowledge Portal</h2>

        <p>Researchers are building a database of DNA sequence, functional and epigenomic information, and clinical data from studies on type 2 diabetes and its macro- and microvascular complications, and creating analytic tools to analyze these data. The data and analytical tools are accessible to academic and industry researchers, and all interested users, to identify and validate changes in DNA that influence onset of type 2 diabetes, disease severity, or disease progression.</p>

        <p>The Knowledge Portal is intended to serve three key functions:</p>
        <ol>
            <li>To be a central repository for large datasets of human genetic information linked to type 2 diabetes and related traits.</li>
            <li>To function as a scientific discovery engine that can be harnessed by the community at large, and assist in the selection of new targets for diabetic drug design.</li>
            <li>Eventually, to facilitate the conduct of customized analyses by any interested user around the world, doing so in a secure manner that provides high quality results while protecting the integrity of the data.</li>
        </ol>

        <p>If successful, this model of making human genomic data accessible to the world might become a paradigm for other diseases, as a way to catalyze scientific advances throughout all fields of human biology.</p>

        <p>The Knowledge Portal is intended to be <i>secure</i>, <i>compliant</i> with pertinent ethical regulations, <i>accessible</i> to a wide user base, <i>inviting</i> to researchers who may want to contribute data and participate in analyses, <i>organic</i> in the continuous incorporation of scientific advances, <i>modular</i> in its analytical capabilities and user interfaces, <i>automated</i>, <i>rigorous</i> in the quality of data aggregation and returned results, <i>versatile</i>, and <i>sustainable</i>.
        </p>

        <h2>History</h2>

        <p>Sparked from the efforts of the T2D-GENES Consortium (Type 2 Diabetes Genetic Exploration by Next-generation sequencing in multi-Ethnic Samples; T2D-GENES) to aggregate and share results from large-scale T2D sequence and genotype datasets, the prototype T2D KP was built with seed funding from the NIDDK via the T2D-GENES Consortium and the Slim Initiative for Genomic Medicine in the Americas for T2D (SIGMA T2D).</p>

        <h2>Funding</h2>

        <p>Development of the T2D Knowledge Portal is currently supported by three grants from AMP: AMP-DCC and T2DK at the Broad Institute, and AMP-EDP to the University of Michigan. The Broad Institute serves as the Data Coordinating Center (DCC) of AMP T2D. On behalf of AMP T2D, the DCC aggregates data, automates analysis, and communicates results relevant to the genetics of type 2 diabetes and related traits, and supports collaboration within the AMP T2D Project. T2DK creates the infrastructure to support the data, instantiates automatic quality control filters for data processing, and develops the analytical modules that will carry out customized analyses <i>in situ</i>. The AMP-EDP team will develop additional software tools that will be integrated into the Portal to allow a wider range of supported analyses. Recently, a fourth development grant was awarded to the European Biomedical Institute to build a sister infrastructure to the DCC for data aggregation and analysis, in order to allow federated access via the Portal to data that may not leave Europe. AMP T2D aims to make pre-competitive data, analyses, and research resources accessible and useful to the biomedical community, and to conduct studies to determine the functions of relevant variants and the mechanisms by which they may contribute to disease.
        </p>

        <p>The Knowledge Portal is also funded by the <a
                href="http://www.broadinstitute.org/news/1405">Slim Initiative for Genomic Medicine in the Americas (SIGMA)</a>, which supports research on the genetics of T2D in Hispanic populations as well as a Spanish-language version of the Portal.
        </p>

        <div style="text-align: center; max-width: 352px;">
            <table>
                <tr>
                    <td>
                        <a href="http://www.niddk.nih.gov/Pages/default.aspx"><img
                                src="${resource(dir: 'images/organizations', file: 'NIH_NIDDK.png')}"
                                style="width: 132px;"></a>
                    </td>
                    <td>
                        <a href="http://www.fnih.org"><img
                                src="${resource(dir: 'images/organizations', file: 'FNIH.jpg')}" style="width: 110px;">
                        </a>
                    </td>
                    <td>
                        <a href="http://www.janssen.com"><img
                                src="${resource(dir: 'images/organizations', file: 'janssen.jpg')}"
                                style="width: 110px;"></a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="https://www.lilly.com/home.aspx"><img
                                src="${resource(dir: 'images/organizations', file: 'lilly.jpg')}" style="width: 110px;">
                        </a>
                    </td>
                    <td>
                        <a href="http://www.merck.com/index.html"><img
                                src="${resource(dir: 'images/organizations', file: 'merck.jpg')}" style="width: 110px;">
                        </a>
                    </td>
                    <td>
                        <a href="http://www.pfizer.com"><img
                                src="${resource(dir: 'images/organizations', file: 'pfizer.jpg')}"
                                style="width: 110px;"></a>
                    </td>
                </tr>
                <tr>
                    <td>
                        <a href="http://en.sanofi.com"><img
                                src="${resource(dir: 'images/organizations', file: 'sanofi.jpg')}"
                                style="width: 110px;"></a>
                    </td>
                    <td>
                        <a href="http://jdrf.org"><img src="${resource(dir: 'images/organizations', file: 'jdrf.jpg')}"
                                                       style="width: 110px;"></a>
                    </td>
                    <td>
                        <a href="http://www.diabetes.org"><img
                                src="${resource(dir: 'images/organizations', file: 'ADA.jpg')}" style="width: 110px;">
                        </a>
                    </td>
                </tr>
            </table>

            <p style="margin: auto;"><a href="http://www.fundacioncarlosslim.org/en/"><img
                    src="${resource(dir: 'images/organizations', file: 'slim.png')}"></a></p>
        </div>

        <h2>People</h2>

        <h3>NIH and FNIH funded investigators</h3>

        <p>Gonçalo Abecasis<br>
            John Blangero<br>
            Michael Boehnke<br>
            Noël Burtt<br>
            Erwin Bottinger<br>
            Nancy Cox<br>
            Ralph DeFronzo<br>
            Ravi Duggirala<br>
            Jason Flannick<br>
            Paul Flicek<br>
            Jose Florez<br>
            Timothy Frayling<br>
            Kelly Frazer<br>
            Andrew Hattersley<br>
            Frederick Karpe<br>
            Markku Laakso<br>
            Donna Lehman<br>
            Ruth Loos<br>
            Daniel MacArthur<br>
            Mark McCarthy<br>
            Gil McVean<br>
            Karen Mohlke<br>
            Benjamin Neale<br>
            Maggie Ng<br>
            Bing Ren<br>
            Maike Sander<br>
            Farook Thameem<br>
            Xueling Sim<br>
            Ching Yu Cheng <br>
            Yoon Shin Cho<br>
            Ronald Ma<br>
            Colin Palmer <br>
            Ewan Pearson</p>

        <h3>AMP T2D Steering Committee</h3>
        <h4>Co-chairs:</h4>

        <p>Peter Stein, Merck<br>
            Philip Smith, NIDDK</p>

        <h4>Members:</h4>

        <p>Hartmut Ruetten, Sanofi<br>
            Clarence Wang, Sanofi<br>
            Jim Lenhard, Janssen<br>
            Tony Parrado, Janssen<br>
            Keith Demarest, Janssen<br>
            Melissa Thomas, Lilly<br>
            Tao Wei, Lilly<br>
            Julia Brosnan, Pfizer<br>
            Eric Fauman, Pfizer<br>
            Jeffery Pfefferkorn, Pfizer<br>
            Martin Brenner, Merck<br>
            Dermot Reilly, Merck<br>
            Dan Rader, University of Pennsylvania<br>
            Ellen Gadbois, NIH OD<br>
            Beena Alkokar, NIDDK<br>
            Olivier Blondel, NIDDK</p>

        <h3>Foundation for the National Institutes of Health</h3>

        <p>David Wholley, FNIH<br>
            Sanya Fanous Whitaker, FNIH<br>
            Nicole Spear, FNIH<br>
            Jon Greene, FNIH Consultant</p>

    </div>
</div>

</body>
</html>

