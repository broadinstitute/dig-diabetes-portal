<g:if test="${g.portalTypeString()?.equals('t2d')}">
    <h2>Contact the portal team</h2>
</g:if>
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

<g:if test="${g.portalTypeString()?.equals('stroke')}">
    <div class="row sectionBuffer">
        <div class="col-md-3">
            <p>
                <strong>Steering Committee</strong><br/>
                Brad Worrall (chair)<br/>
                Devin Brown<br/>
                Martin Dichgans<br/>
                Jemma Hopewell<br/>
                Steven Kittner<br/>
                Chris Levi<br/>
                Arne Lindgren<br/>
                Jennifer Majersik<br/>
                Hugh Markus<br/>
                James Meschia<br/>
                Joan Montaner<br/>
            </p>
        </div>
        <div class="col-md-3">
            <p>
                &nbsp;<br/>
                Alex Reiner<br/>
                Jaume Roquer<br/>
                Jonathan Rosand<br/>
                Magdy Selim<br/>
                Sudha Seshadri<br/>
                Pankaj Sharma<br/>
                Scott Silliman<br/>
                Agnieszka Slowik<br/>
                David Tirschwell<br/>
                Dan Woo<br/>
            </p>
        </div>
        <div class="col-md-6">
        </div>
    </div>
    <div class="row sectionBuffer">
        <div class="col-md-5">
            <p>
                <strong>Portal Developers</strong><br/>
                Jonathan Rosand<br/>
                Jason Flannick<br/>
                Noel Burtt<br/>
                Ben Alexander<br/>
                Marcin von Grotthuss<br/>
                Marc Duby<br/>
                Michael Sanders<br/>
                Ryan Koesterer<br/>
                Scott Sutherland<br/>
                David Siedzik<br/>
                Guido Falcone<br/>
                Rainer Malik<br/>
                Christina Kourkoulis<br/>
                Neil Vaishnav<br/>
                Katherine Crawford<br/>
            </p>
        </div>
        <div class="col-md-4">
            <div class="emphasize-block">
                <g:message code="portal.contact.message" />:<br/>
                <a href="mailto:cerebrovascularportal@gmail.com">cerebrovascularportal@gmail.com</a>
            </div>
        </div>
        <div class="col-md-3">
        </div>
    </div>
</g:if>

<g:else>
    <div class="row sectionBuffer">
        <div class="col-md-5">
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
        </div>
        <div class="col-md-4">
            <div class="emphasize-block">
                <g:message code="portal.contact.message" />:<br/>
                <a href="mailto:help@type2diabetesgenetics.org">help@type2diabetesgenetics.org</a>
            </div>
        </div>
        <div class="col-md-3">
        </div>
    </div>
</g:else>

