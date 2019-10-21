<style>
    #variantSummaryText {
        margin-bottom: 25px;
    }

    #transcriptTable th, #transcriptTable td {
        padding: 3px 25px 3px 0;
        border: none;
    }

    #transcriptTable th {
        font-weight: bold;
    }

    #transcriptTable > * {
        font-size: 14px;
    }

</style>


<!--<div>-->
    <!--<p id="variantSummaryText"><g:message code="variant.summaryText.summary" /></p>-->
    <div class="variant-page-section-header">
        <h2><g:message code="variant.summaryText.transcriptHeader" default="Transcripts" /></h2>
    </div>
    <div id="transcriptHeader" class="well well-variant-page" style="overflow: auto;"></div>

    <script id="transcriptTableTemplate" type="x-tmpl-mustache">
        <table id=transcriptTable class="table table-striped table-condensed" style="margin-bottom: 0;">
            <thead>
                <tr>
                    <th><g:message code="variant.summaryText.transcript" default="Transcript" /></th> {{ #transcriptName }}<th>{{ transcriptNameText }}</th> {{ /transcriptName }}
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th><g:message code="variant.impactOnProtein.proteinChange" default="Protein change" /></th> {{ #proteinChange }} <td> {{ . }} </td> {{ /proteinChange }}
                </tr>
                <tr>
                    <th><g:message code="variant.summaryText.consequence" default="Consequence" /></th> {{ #consequence }} <td> {{ . }} </td> {{ /consequence }}
                </tr>
                <tr>
                    <th><g:message code="variant.impactOnProtein.polyphenPrediction" default="PolyPhen prediction" /></th> {{ #polyphen }} <td> {{ . }} </td> {{ /polyphen }}
                </tr>
                <tr>
                    <th><g:message code="variant.impactOnProtein.siftPrediction" default="SIFT prediction" /></th> {{ #sift }} <td> {{ . }} </td> {{ /sift }}
                </tr>
            </tbody>
        </table>

    </script>
<!--</div>-->