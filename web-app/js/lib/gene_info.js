

var GeneInfoView = Backbone.View.extend({

    initialize: function(options) {
        this.gene_info = options.gene_info;
        this.ethnicities = options.ethnicities;
        this.phenotypes = options.phenotypes;

        // use all 4 params for consistency, but in practice we just use show_exseq as a proxy for all the sigma fields
        this.show_exseq = options.show_exseq;
        this.show_exchp = options.show_exchp;
        this.show_gwas = options.show_gwas;
        this.show_sigma = options.show_sigma;
    },

    className: "gene-info-view",

    template: _.template($('#tpl-gene-info').html()),

    render: function() {
        var that = this;
        $(this.el).html(this.template({
            gene_info: this.gene_info,
            ethnicities: this.ethnicities,
            phenotypes: this.phenotypes,

            show_exseq: this.show_exseq,
            show_exchp: this.show_exchp,
            show_gwas: this.show_gwas,
            show_sigma: this.show_sigma,
        }));
        this.$('#gene-summary-expand').on('click', function() {
            if (that.$('.gene-summary .bottom').hasClass('ishidden')) {
                that.$('.gene-summary .bottom').show(400);
                that.$('.gene-summary .bottom').removeClass('ishidden');
                that.$('#gene-summary-expand').text('show less');
            } else {
                that.$('.gene-summary .bottom').hide(400);
                that.$('.gene-summary .bottom').addClass('ishidden');
                that.$('#gene-summary-expand').text('click to expand');
            }
        });
        return this;
    },

});


$(function() {

    var view = new GeneInfoView({
        gene_info: GENE_INFO,
        ethnicities: CONSTANTS.ethnicities,
        phenotypes: CONSTANTS.gwas_phenotypes,

        show_exseq: SITE_VERSION == 't2dgenes',
        show_exchp: SITE_VERSION == 't2dgenes',
        show_gwas: true,
        show_sigma: SITE_VERSION == 'sigma',
    });
    $('#gene-info-container').html(view.render().el);

});