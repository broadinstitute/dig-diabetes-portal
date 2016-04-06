<h2>Contact the portal team</h2>
<style>
.emphasize-block {
    background: #052090;
    color: white;
    padding: 25px;
    margin: 5px;
}
.emphasize-block a {
    color: #6fb7f7;
}
</style>

<div class="row">
   <div class="col-xs-12">
       <h3>
           <g:message code="contact.portal.broadAttribution" default="portal built at the Broad"/>
       </h3>

   </div>
</div>
<div class="row sectionBuffer">
    <div class="col-md-5">

        <g:if test="${g.portalTypeString()?.equals('stroke')}">
            <p>
                Jonathan Rosand<br/>
                Jason Flannick<br/>
                Noel Burtt<br/>
                Ben Alexander<br/>
                Marcin von Grotthuss<br/>
                Marc Duby<br/>
                Michael Sanders<br/>
                Ryan Koesterer<br/>
                Christina Kourkoulis<br/>
                Neil Vaishnav<br/>
                Katherine Crawford<br/>
            </p>
        </g:if>
        <g:else>
            <p>
                Jose Florez<br/>
                Jason Flannick<br/>
                Noel Burtt<br/>
                Ben Alexander<br/>
                Kaan Yuksel<br/>
                Marcin von Grotthuss<br/>
                Marc Duby<br/>
                Oliver Ruebenacker<br/>
                Todd Green<br/>
                Tad Jordan<br/>
                Michael Sanders<br/>
                Clint Gilbert<br/>
                Ryan Koesterer<br/>
            </p>
        </g:else>

    </div>
    <div class="col-md-4">
        <div class="emphasize-block">
            <g:message code="portal.contact.message" />:<br/>
        <g:if test="${g.portalTypeString()?.equals('stroke')}">
            <a href="mailto:cerebrovascularportal@gmail.com">cerebrovascularportal@gmail.com</a>
        </g:if>
        <g:else>
            <a href="mailto:help@type2diabetesgenetics.org">help@type2diabetesgenetics.org</a>
        </g:else>
        </div>

    </div>
    <div class="col-md-3">
    </div>
</div>
