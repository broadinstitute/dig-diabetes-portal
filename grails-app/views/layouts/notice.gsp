<style>
.notice  {
    font-weight: bold;
    line-height: 20px;
    text-decoration: none;
    margin: 0 auto 0 auto;
    color: #588fd3;
    margin: 0;
}
.notice .messageText {
    font-weight: bold;
    font-style: italic;
    color: black;
    margin: 0 auto 0 auto;
    font-size: 20px;
}

.notice  hr {
    width: 100%;
    color: black;
}

</style>

<g:if test="${(ticker)}">
    <div id="notice" class="notice">
        <div class = "messageText text-center">
            <ul id="ticker01">
                <li><span id="tickerText">${(ticker)}</span></li>
            </ul>
            <script>
                $(function(){
                    $("ul#ticker01").liScroll();
                });
            </script>

        </div>
    </div>
</g:if>
