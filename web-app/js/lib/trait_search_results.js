

var TraitSearchResultsView = Backbone.View.extend({

    initialize: function(options) {
        this.trait = options.trait;
        this.variants = options.variants;
        this.phenotypes = options.phenotypes;
        this.effect_type = 'ODDS_RATIO';
        if (this.variants.length > 0) {
            if (this.variants[0].BETA) {
                this.effect_type = 'BETA';
            }
            else if (this.variants[0].ZSCORE) {
                this.effect_type = 'ZSCORE';
            }
        }
    },

    className: "trait-search-results-view",

    template: _.template($('#tpl-trait-search-results').html()),

    render: function() {
        $(this.el).html(this.template({
            trait: this.trait,
            variants: this.variants,
            effect_type: this.effect_type,
            phenotypes: this.phenotypes,
        }));
        this.$('table').dataTable({
            bFilter: false,
            iDisplayLength: 20,
            aaSorting: [[ 2, "asc" ]],
            aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 2 ] } ],
        });
        return this;
    },

});


$(function() {

    var view = new TraitSearchResultsView({
        trait: TRAIT,
        variants: VARIANTS,
        phenotypes: CONSTANTS.gwas_phenotypes,
    });
    $('#trait-search-results-container').html(view.render().el);

});