

var RegionGWASView = Backbone.View.extend({

    initialize: function(options) {
        this.traits = options.traits;
        this.variants = options.variants;
        this.region_str = options.region_str;
    },

    className: "region-gwas-view",

    template: _.template($('#tpl-region-gwas').html()),

    render: function() {
        $(this.el).html(this.template({
            traits: this.traits,
            variants: this.variants,
            region_str: this.region_str,
        }));
        console.log($(this.el).width());
        this.draw_vis();
        return this;
    },

    draw_vis: function() {
        var that = this;

        var total_width = 1080;

        var margin = { top: 250, right: 100, bottom: 100, left: 100 };
        var width = total_width - margin.left - margin.right;
        var grid_size = Math.floor(width / 25);
        var height = that.variants.length*grid_size;
        var total_height = height + margin.top + margin.bottom;

        var svg = d3.select(that.$("#vis")[0]).append("svg")
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

        var variant_labels = svg.append('g')
            .selectAll(".row-g")
            .data(that.variants)
            .enter()
            .append('a')
            .attr('class', 'boldlink')
            .attr('xlink:href', function(d) { return '/variant/'+ d.DBSNP_ID})
            .append('text')
            .attr("class", function (d,i) { return "variantlabel r"+i;} )
            .text(function (d) { return d.DBSNP_ID; })
            .attr("x", 0)
            .attr("y", function (d, i) { return i * grid_size + 5; })
            .style("text-anchor", "end");

        var trait_labels = svg.append('g')
            .selectAll(".col-g")
            .data(that.traits)
            .enter()
            .append('text')
            .attr("class", function (d,i) { return "traitlabel r"+i;} )
            .text(function(d) { return d.name })
            .attr('y', 30)
            .attr('x', 30)
            .attr("transform", function(d, i) {
                return 'translate(' + i * grid_size + ',-20) rotate(-60)';
            });

        var assocs = [];
        var trait_indices = {};
        _.each(that.traits, function(t, i) {
            trait_indices[t.db_key] = i;
        });
        _.each(that.variants, function(variant, i) {
            _.each(variant.assocs, function(a) {
                a.var_index = i;
                a.trait_index = trait_indices[a.TRAIT];
                assocs.push(a);
            });
        });

        var circle_size = function(assoc) {
            if (assoc.PVALUE > .05) return 3;
            else if (assoc.PVALUE > .0001) return 5;
            else if (assoc.PVALUE > 5e-8) return 8;
            else return 16;
        };

        var circle_color = function(assoc) {
            if (assoc.PVALUE > .05) return '#ddd';
            else if (assoc.DIR == 'down') return 'red';
            else if (assoc.DIR == 'up') return 'rgb(104, 216, 104)';
            else return 'black';
        };

        var circle_class = function(assoc) {

            var c = '';
            if (assoc.DIR == 'down') c += 'assoc-down';
            else if (assoc.DIR == 'up') c += 'assoc-up';
            else c += 'assoc-none';

            if (assoc.PVALUE > .05) c += ' assoc-none';
            else if (assoc.PVALUE > .0001) c += ' assoc-sm';
            else if (assoc.PVALUE > 5e-8) c += ' assoc-med';
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
                var text = '<div class="header">' + that.traits[d.trait_index].name + '</div>';
                text += d.DBSNP_ID + '<br/>';
                text += 'chr' + d.CHROM + ':' + d.POS + '<br/>';
                text += 'p-value: <strong>' + d.PVALUE.toPrecision(3) + '</strong><br/>';
                if (d.ODDS_RATIO) text += 'odds ratio: <strong>' + d.ODDS_RATIO.toPrecision(3) + '</strong><br/>';
                if (d.BETA) text += 'beta: <strong>' + d.BETA.toPrecision(3) + '</strong><br/>';
                if (d.ZSCORE) text += 'z-score: <strong>' + d.ZSCORE.toPrecision(3) + '</strong><br/>';
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

    },

});


$(function() {

    var view = new RegionGWASView({
        variants: VARIANTS,
        traits: CONSTANTS.gwas_phenotypes,
        region_str: REGION_STR,
    });
    $('#region-gwas-container').html(view.render().el);

});