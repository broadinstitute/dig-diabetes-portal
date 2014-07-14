

var VariantGWASView = Backbone.View.extend({

    initialize: function(options) {
        this.variant_id = options.variant_id;
        this.variant_gwas_info = options.variant_gwas_info;
        this.gwas_traits = options.gwas_traits;
    },

    className: "variant-gwas-view",

    template: _.template($('#tpl-variant-gwas').html()),

    render: function() {
        var that = this;
        $(this.el).html(this.template({
            variant_id: this.variant_id,
            variant_gwas_info: this.variant_gwas_info,
            gwas_traits: this.gwas_traits,
        }));
        this.$('table').dataTable({
            bFilter: false,
            bPaginate: false,
            aaSorting: [[ 1, "asc" ]],
            aoColumnDefs: [{ sType: "allnumeric", aTargets: [ 1 ] } ]
        });
        return this;
    },

});


$(function() {

    var view = new VariantGWASView({
        variant_id: VARIANT_ID,
        variant_gwas_info: VARIANT_GWAS_INFO,
        gwas_traits: CONSTANTS.gwas_phenotypes,
    });
    $('#variant-info-container').html(view.render().el);

});