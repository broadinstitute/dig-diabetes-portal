
<g:if test="${show_sigma}">
<h4>Restrict to odds ratio</h4>
<div class="row clearfix">
    <div class="col-md-6">
        <div id="or-form">
            <div class="row">
                <div class="col-sm-2 col-sm-offset-1">
                    <select class="form-control" id="or-select">
                        <option value=""></option>
                        <option value="GTE"> > </option>
                        <option value="LTE"> < </option>
                    </select>
                </div>
                <div class="col-sm-3">
                    <input class="form-control" type="text" id="or-value"/>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-6">

    </div>
</div>
</g:if>
