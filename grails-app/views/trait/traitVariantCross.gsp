<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="core"/>
    <r:require modules="core"/>
    <r:layoutResources/>
</head>

<body>
<script>
    var loading = $('#spinner').show();
    $.ajax({
        cache:false,
        type:"get",
        url:"../traitVariantCrossAjax/"+"${regionSpecification}",
        async:true,
        success: function (data) {
            fillTraitVariantCross(data) ;
            loading.hide();
        },
        error: function(jqXHR, exception) {
            loading.hide();
            errorReporter(jqXHR, exception) ;
        }
    });
    var phenotypeListString  = decodeURIComponent("${phenotypeList}");
    function phenotypeListConstructor (inString) {
        var keyValue = {} ;
        var arrayHolder = [];
        var listOfPhenotypes =  inString.split(",");
        for ( var i = 0 ; i < listOfPhenotypes.length ; i++ ) {
            var phenotypeAndKey =  listOfPhenotypes[i].split (":") ;
            var reclaimedKey  =  phenotypeAndKey [0];
            var reclaimedLabel  =  phenotypeAndKey [1].replace(/\+/g,' ');
            keyValue  [reclaimedKey]  = reclaimedLabel;
            arrayHolder.push  ({key:reclaimedKey,
                                val:reclaimedLabel});
        }
        this.phenotypeMap = keyValue;
        this.phenotypeArray  = arrayHolder;
    }

    var  phenotypeMap =  new phenotypeListConstructor (phenotypeListString) ;
    function fillTraitVariantCross (data)  {
        console.log('fill The traitVariantCross');

        draw_vis(data,phenotypeMap.phenotypeArray);
    }
    var draw_vis = function(data,allTraits) {
        var that = data,
                traits =  allTraits;

        var total_width = 1080;

        var margin = { top: 250, right: 100, bottom: 100, left: 100 };
        var width = total_width - margin.left - margin.right;
        var grid_size = Math.floor(width / 25);
        var height = that.variants.length*grid_size;
        var total_height = height + margin.top + margin.bottom;

        //var svg = d3.select(that.$("#vis")[0]).append("svg")
        var svg = d3.select("#vis").append("svg")
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
        window.vis = svg;

        var xaxis = svg.append('line')
                .attr('x1', '15')
                .attr('y1', '-15')
                .attr('x2', width)
                .attr('y2', '-15')
                .attr('stroke', '#bbb')
                .attr('stroke-width', '1');

        var yaxis = svg.append('line')
                .attr('x1', '15')
                .attr('y1', '-15')
                .attr('x2', '15')
                .attr('y2', height)
                .attr('stroke', '#bbb')
                .attr('stroke-width', '1');
        ///dport/variant/variantInfo/'+ d.DBSNP_ID})
        var variant_labels = svg.append('g')
                .selectAll(".row-g")
                .data(that.variants)
                .enter()
                .append('a')
                .attr('class', 'boldlink')
                .attr('xlink:href', function(d) {
                    var rootUrl='<g:createLink controller="variant" action="variantInfo" />';
                    return rootUrl+'/'+d.DBSNP_ID
                })
                .append('text')
                .attr("class", function (d,i) { return "variantlabel r"+i;} )
                .text(function (d) { return d.DBSNP_ID; })
                .attr("x", 0)
                .attr("y", function (d, i) { return i * grid_size + 5; })
                .style("text-anchor", "end");

        var trait_labels = svg.append('g')
                .selectAll(".col-g")
                .data(traits)
                .enter()
                .append('text')
                .attr("class", function (d,i) { return "traitlabel r"+i;} )
                .text(function(d) { return d.val })
                .attr('y', 30)
                .attr('x', 30)
                .attr("transform", function(d, i) {
                    return 'translate(' + i * grid_size + ',-20) rotate(-60)';
                });

        var assocs = [];
        var trait_indices = {};
        _.each(traits, function(t, i) {
            trait_indices[t.key] = i;
        });
        var variantIndices = {};
        var  variantCount = 0;
        for ( var i = 0 ; i < that.variants.length ; i++ ) {
            var currentVariant =   that.variants[i];
            var variantToAdd = currentVariant['DBSNP_ID'];
            if (!variantIndices[variantToAdd]){
                variantIndices[variantToAdd] =  variantCount++;
            }
        }
        // now we have counted the total number of unique variants
        $('#displayCountOfIdentifiedTraits').append(variantCount);

        for ( var i = 0 ; i < that.variants.length  ; i++ ) {
            for (var j = 0; j < traits.length; j++) {
                var currentVariant =   that.variants[i];
                var a = {var_index :variantIndices[currentVariant['DBSNP_ID']],
                    trait_index: trait_indices[currentVariant['TRAIT']],
                    val:currentVariant};
                 assocs.push(a)  ;
            }
        }
//        _.each(that.variants, function(variant, i) {
//            _.each(variant.assocs, function(a) {
//                a.var_index = i;
//                a.trait_index = trait_indices[a.TRAIT];
//                assocs.push(a);
//            });
//        });

        var circle_size = function(assoc) {
            if (assoc.val.PVALUE > .05) return 3;
            else if (assoc.val.PVALUE > .0001) return 5;
            else if (assoc.val.PVALUE > 5e-8) return 8;
            else return 16;
        };

        var circle_color = function(assoc) {
            if (assoc.val.PVALUE > .05) return '#ddd';
            else if (assoc.val.DIR == 'down') return 'red';
            else if (assoc.val.DIR == 'up') return 'rgb(104, 216, 104)';
            else return 'black';
        };

        var circle_class = function(assoc) {

            var c = '';
            if (assoc.val.DIR == 'down') c += 'assoc-down';
            else if (assoc.val.DIR == 'up') c += 'assoc-up';
            else c += 'assoc-none';

            if (assoc.val.PVALUE > .05) c += ' assoc-none';
            else if (assoc.val.PVALUE > .0001) c += ' assoc-sm';
            else if (assoc.val.PVALUE > 5e-8) c += ' assoc-med';
            else c += ' assoc-lg';

            return c;
        }

        var assoc_g = svg.selectAll('g.cellg')
                .data(assocs)
                .enter()
                .append('g')
                .attr('class', 'cellg')

        assoc_g.append("circle")
                .attr("cx", function(d, i) { return d.trait_index * grid_size + 40 })
                .attr("cy", function(d, i) { return d.var_index * grid_size })
                .attr('r', circle_size)
            //.attr('fill', circle_color)
                .attr('class', circle_class)
                .on("mouseover", function(d){

                    d3.selectAll(".traitlabel").classed("text-highlight",function(r,ri){ return ri==(d.trait_index);});
                    d3.selectAll(".variantlabel").classed("text-highlight",function(r,ri){ return ri==(d.var_index);});
                    var text = '<div class="header">' + traits[d.trait_index].val + '</div>';
                    text += d.val.DBSNP_ID + '<br/>';
                    text += 'chr' + d.val.CHROM + ':' + d.val.POS + '<br/>';
                    text += 'p-value: <strong>' + d.val.PVALUE.toPrecision(3) + '</strong><br/>';
                    if (d.val.ODDS_RATIO) text += 'odds ratio: <strong>' + d.val.ODDS_RATIO.toPrecision(3) + '</strong><br/>';
                    if (d.val.BETA) text += 'beta: <strong>' + d.val.BETA.toPrecision(3) + '</strong><br/>';
                    if (d.val.ZSCORE) text += 'z-score: <strong>' + d.val.ZSCORE.toPrecision(3) + '</strong><br/>';
                    d3.select("#tooltip")
                            .style("left", (d3.event.pageX+10) + "px")
                            .style("top", (d3.event.pageY-10) + "px")
                            .select("#value")
                            .html(text);
                    d3.select("#tooltip").classed("hidden", false);
                })
                .on("mouseout", function(d){
                    d3.select("#tooltip").classed("hidden", true);
                    d3.selectAll(".traitlabel").classed("text-highlight",false);
                    d3.selectAll(".variantlabel").classed("text-highlight",false);
                });

    }
</script>


<div id="main">

    <div class="container" >

        <div class="variant-info-container" >
            <div class="variant-info-view" >


                <h1>GWAS Results Summary</h1>
                <h2>Region: <strong><%=regionSpecification%></strong></h2>

                <div class="separator"></div>

                <p>
                    The table below shows all GWAS variants in this region available in this portal.
                    Columns represent each of the <a class="boldlink" href="/about/hgat">25 traits</a> that were studied in meta-analyses included in this portal.
                Rows represent variants, in genomic order.
                All variants are shown, regardless of association.
                </p>

                <p>
                    Hover over a circle to see the details of that association.
                    Some cells won't have circles because no data is available,
                    because they were not genotyped as part of the study and could not be adequately imputed.
                </p>

                <p>
                    This portal contains studies that use different measures of effect on phenotype (odds ratio, beta, z-score), and currently displays only the statistics reported in the original papers.
                </p>

                <div class="row">
                    <div class="col-md-3">
                        <p>
                            Total variants: <strong><span id="displayCountOfIdentifiedTraits"></span></strong>
                        </p>
                    </div>


                </div>

                <div class="vis-container">

                    <div id="vis"></div>

                    <div id="tooltip" class="hidden">
                        <p><span id="value"></span></p>
                    </div>
                </div>

        </div>
    </div>

</div>

</body>
</html>
>