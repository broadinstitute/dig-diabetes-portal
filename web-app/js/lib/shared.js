/*
Contains JS that is shared across pages
 */

jQuery.fn.dataTableExt.oSort['allnumeric-asc']  = function(a,b) {
          var x = parseFloat(a);
          var y = parseFloat(b);
          if (!x) { x = 1; }
          if (!y) { y = 1; }
          return ((x < y) ? -1 : ((x > y) ?  1 : 0));
        };

jQuery.fn.dataTableExt.oSort['allnumeric-desc']  = function(a,b) {
          var x = parseFloat(a);
          var y = parseFloat(b);
          if (!x) { x = 1; }
          if (!y) { y = 1; }
          return ((x < y) ? 1 : ((x > y) ?  -1 : 0));
        };

var get_operator_display = function(operator) {
    if (operator == 'EQ') {
        return 'equal to';
    }
    else if (operator == 'GT') {
        return 'greater than';
    }
    else if (operator == 'GTE') {
        return 'greater than or equal to';
    }
    else if (operator == 'LT') {
        return 'less than';
    }
    if (operator == 'LTE') {
        return 'less than or equal to';
    }
    else {
        return operator;
    }
};

var VariantFilter = Backbone.Model.extend({

    summary_string: function() {
        if (this.get('operand') == 'IN_GENE') {
            return "In the gene " + this.get('value');
        }
        else if (this.get('operand') == 'IN_EXSEQ') {
            return "Is observed in exome sequencing";
        }
        else if (this.get('operand') == 'IN_EXCHP') {
            return "Is observed in exome chip";
        }
        else {
            return CONSTANTS.variant_columns[this.get('operand')] + ' is ' + get_operator_display(this.get('operator')) + ' ' + this.get('value');
        }
    },

});

var VariantFilterList = Backbone.Collection.extend({

    model: VariantFilter,

    // TODO: undefined (or at least unexpected) if multiple filters
    // TODO: IN_GWAS doesn't actually exist
    get_datatype: function() {
        var datatype = "";
        this.each(function(f) {
            if (f.get('operand') == 'IN_EXSEQ') {
                datatype = 'exseq';
            }
            if (f.get('operand') == 'IN_EXCHP') {
                datatype = 'exchp';
            }
            if (f.get('operand') == 'IN_GWAS') {
                datatype = 'gwas';
            }
        });
        return datatype;
    },

    // map of operand -> value for all keys
    // note that behavior undefined for keys with multiple frequencies, ie. if frequnecy needs to be between two bounds
    get_values_map: function() {
        var values = {};
        this.each(function(f) {
            values[f.get('operand')] = f.get('value');
        });
        return values;
    },

});

var VariantTableView = Backbone.View.extend({

    initialize: function(options) {
        this.variants = options.variants;
        this.show_gene = options.show_gene || false;
        this.show_exseq = options.show_exseq || false;
        this.show_exchp = options.show_exchp || false;
        this.show_gwas = options.show_gwas || false;
        this.show_sigma = options.show_sigma || false;
    },

    className: "variant-table",

    template: _.template($('#tpl-variant-table').html()),

    render: function() {
        $(this.el).html(this.template({
            variants: this.variants,
            show_gene: this.show_gene,
            show_exseq: this.show_exseq,
            show_exchp: this.show_exchp,
            show_gwas: this.show_gwas,
            show_sigma: this.show_sigma, 
        }));
        var pvalue_col = this.show_gene ? 5 : 4;
        if (this.show_sigma) pvalue_col += 2; 
        // this.$('table').dataTable({
        //     bFilter: false,
        //     iDisplayLength: 20,
        //     aaSorting: [[ pvalue_col, "asc" ]],
        //     aoColumnDefs: [{ sType: "allnumeric", aTargets: [ pvalue_col, pvalue_col + 5, pvalue_col + 7 ] } ],
        // });
        return this;
    },

});