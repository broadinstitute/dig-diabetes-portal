<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="t2dGenesCore"/>
    <r:require modules="core"/>
    <r:require modules="informational"/>
    <r:layoutResources/>

    <style>
        #t2dImageHolder {
            display: flex;
            justify-content: space-around;
            height: 60px;
            width: 100%;
        }

        #t2dImageHolder a, #t2dImageHolder a img {
            height: 100%;
        }

    </style>
</head>


<body>

<div id="main">

    <div class="container">
        <g:if test="${g.portalTypeString()?.equals('t2d')}">
        </g:if>
        <g:else>
            <h1><g:message code="contact.title.plural" default="Contact"/></h1>
        </g:else>

        <div class="row">
            <g:if test="${g.portalTypeString()?.equals('t2d')}">
                <div style="width: 70%;">
                    <h2><g:message code="contact.header" /></h2>

                    <p><g:message code="contact.summary" /></p>

                    <p><g:message code="contact.getInTouch" />
                        <ul>
                            <li><g:message code="contact.option.contactTeam" /></li>
                            <li><g:message code="contact.option.forum" /></li>
                            <li><g:message code="contact.option.emailList" /></li>
                            <li><g:message code="contact.option.contribute" /></li>
                        </ul>
                    </p>
                    <h3>Accelerating Medicines Partnership (AMP) Type 2 Diabetes Knowledge Portal (T2DKP) and Data Coordinating Center (DCC) Team</h3>
                    <p>Jose Florez (Principal Investigator)<br>
                        Jason Flannick (Senior Group Leader)<br>
                        Noël Burtt (Associate Director, Operations)<br></p>
                        
                    <h4>Manager of content and community</h4>

                    <p>Maria Costanzo</p>
                    <h4>Software engineers</h4>

                    <p>Benjamin Alexander<br>
                        Marc Duby<br>
                        Clint Gilbert<br>
                        Todd Green<br>
                        Dong-Keun Jang<br>
                        Oliver Ruebenacker<br>
                        Michael Sanders<br>
                        David Siedzik<br>
                        Kaan Yuksel</p>
                    <h4>Computational biologists</h4>

                    <p>Marcin von Grotthuss<br>
                        Ryan Koesterer</p>
                    <h4>Project manager</h4>

                    <p>Lizz Caulkins</p>

                    <h3>Methods and Tool Development Teams</h3>
                    <h4>AMP Type 2 Diabetes Knowledge (T2DK)</h4>

                    <p>Daniel MacArthur (Principal Investigator)<br>
                        Benjamin Neale (Principal Investigator)<br>
                        Jonathan Bloom<br>
                        Konrad Karczewski<br>
                        Cotton Seed</p>
                    <h4>AMP Enhanced Diabetes Portal</h4>

                    <p>Michael Boehnke (Principal Investigator)<br>
                        Gonçalo Abecasis (Principal Investigator)<br>
                        Christopher Clark<br>
                        Matthew Flickinger<br>
                        Daniel Taliun<br>
                        Ryan Welch</p>
                    <h4>AMP Federated Nodes</h4>

                    <p>Paul Flicek (Principal Investigator)<br>
                        Mark McCarthy (Principal Investigator)<br>
                        Gil McVean (Principal Investigator)<br>
                        Helen Parkinson<br>
                        Dylan Spalding</p>

                    <div id="t2dImageHolder">
                        <a href="https://broadinstitute.org" target="_blank">
                            <img src="${resource(dir: 'images', file:'BroadInstLogoforDigitalRGB.png')}" />
                        </a>
                        <a href="https://sph.umich.edu" target="_blank">
                            <img src="${resource(dir: 'images/organizations', file:'UM-SPH.png')}" />
                        </a>
                        <a href="https://www.ebi.ac.uk" target="_blank">
                            <img src="${resource(dir: 'images/organizations', file:'EBI.png')}" />
                        </a>
                    </div>
                </div>
            </g:if>
            <g:else>
                <div class="buttonHolder tabbed-about-page">

                    <ul class="nav nav-pills">
                        <div class="row">

                            <div class="col-md-3 text-center">
                                <li role="presentation" id="contact_consortium" class="myPills activated">
                                    <a href="#">
                                        <g:message code="contact.consortium" default="Consortium"/>
                                    </a>
                                </li>
                            </div>
                            <div class="col-md-3 text-center">
                                <li role="presentation" id="contact_cohort" class="myPills">
                                    <a href="#">
                                        <g:message code="contact.cohort" default="Studies"/>
                                    </a>
                                </li>
                            </div>
                            <div class="col-md-3 text-center">
                                <li role="presentation" id="contact_portal" class="myPills active">
                                    <a href="#">
                                        <g:message code="contact.portal" default="Portal"/>
                                    </a>
                                </li>
                            </div>


                            <div class="col-md-3 text-center">
                            </div>

                        </div>

                    </ul>

                    <div class="content">
                        <div id="contactContent">
                            <g:render template="contact/${specifics}"/>
                        </div>
                    </div>
                </div>
            </g:else>
        </div>


    </div>
    <script>
        mpgSoftware.informational.buttonManager (".buttonHolder .nav li",
                "${createLink(controller:'informational',action:'contactsection')}",
                "#contactContent");
    </script>

</div>

</body>
</html>

