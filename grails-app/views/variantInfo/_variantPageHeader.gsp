<style>
    #transcriptTable th {
        font-weight: bold;
    }

    #transcriptTable > * {
        font-size: 14px;
    }

</style>


<div>
    <p id="variantSummaryText"><g:message code="variant.summaryText.summary" /></p>
    <h4 id="transcriptHeader"><g:message code="variant.summaryText.transcriptHeader" default="Transcripts" /></h4>
    <script id="transcriptTableTemplate" type="x-tmpl-mustache">
        <table id=transcriptTable class="table table-striped table-condensed">
            <thead>
                <tr>
                    <th>Transcript</th> {{ #transcriptName }}<th>{{ transcriptNameText }}</th> {{ /transcriptName }}
                </tr>
            </thead>
            <tbody>
                <tr>
                    <th>Protein change</th> {{ #proteinChange }} <td> {{ . }} </td> {{ /proteinChange }}
                </tr>
                <tr>
                    <th>PolyPhen prediction</th> {{ #polyphen }} <td> {{ . }} </td> {{ /polyphen }}
                </tr>
                <tr>
                    <th>SIFT prediction</th> {{ #sift }} <td> {{ . }} </td> {{ /sift }}
                </tr>
                <tr>
                    <th>Consequence</th> {{ #consequence }} <td> {{ . }} </td> {{ /consequence }}
                </tr>
            </tbody>
        </table>
    </script>
</div>