$(document).ready(function() {
    window.CANCER_TYPES = [];
    window.FULL_NAMES = {
        "CA": "California",
        "PA": "Pennsylvania"
    };
    window.LOCATIONS = {};
    

    var default_zero = function(x) {
        if (x == "") {return 0}
        return x
    };

    CsvToHtmlTable.init({
        csv_path: '2019-11-12_for_DataTables_Surgeries_Totals_Years_Combined.csv',
        element: 'example', 
        allow_download: false,
        csv_options: {separator: ',', delimiter: '"'},
        datatables_options: {
            paging: false,
            initComplete: function() {
                $("thead th").each(function(i, v) {
                    if (i >= 3) { // first column of cancer
                        window.CANCER_TYPES.push([
                            $(v).html().toLowerCase(),
                            $(v).html(),
                            i + 2
                        ]);
                    }
                });
                $("tbody tr").each(function(i) {
                    var state = $(this).find("td:nth-child(2)").html();
                    var county = $(this).find("td:nth-child(3)").html();
                    if (!_.has(window.LOCATIONS, state)) {
                        window.LOCATIONS[state] = {};
                    }
                    window.LOCATIONS[state][county] = true;
                });
            },
            dom: "tr",
            columns: [
                null,
                null,
                null,
                {visible: false},
                {visible: false},
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null,
                null
            ],
            autoWidth: false
        },
        custom_formatting: [
            [5, default_zero],
            [6, default_zero],
            [7, default_zero],
            [8, default_zero],
            [9, default_zero],
            [10, default_zero],
            [11, default_zero],
            [12, default_zero],
            [13, default_zero],
            [14, default_zero],
            [15, default_zero]
        ]
    });
    
    $("#cancer_type").autocomplete({
        source: function(req, resp) {
          var term = req.term.toLowerCase();
          var result = [];
          for (var i = 0; i < window.CANCER_TYPES.length; i++) {
            if (window.CANCER_TYPES[i][0].startsWith(term)) {
              result.push(window.CANCER_TYPES[i][1]);
            }
          }
          resp(result);
        },
        select: function(event, ui) {
            for (var i = 0; i < window.CANCER_TYPES.length; i++) {
                if (window.CANCER_TYPES[i][1] == ui.item.value) {
                    $("table").DataTable().order(
                        [window.CANCER_TYPES[i][2], 'desc']
                    ).draw();
                }
            }
        },
        minLength: 0
    }).focus(function(){            
        $(this).data("uiAutocomplete").search("");
    });

    $("#location").autocomplete({
        source: function(req, resp) {
            var state;
            var term = req.term.toLowerCase();
            term = term.split(/\s+/);
            if (term.length > 1) {
                state = term[0];
                term = _.rest(term).join(" ");
            } else {
                term = term[0];
            }
            var result = [];
            if (state) {
                var states = _.filter(_.keys(window.LOCATIONS), function(x) {
                    if (x.toLowerCase().startsWith(state)) {
                        return true;
                    }
                    if (window.FULL_NAMES[x].toLowerCase().startsWith(state)) {
                        return true;
                    }
                });
                if (states.length == 1) {
                    result = _.map(_.filter(_.keys(window.LOCATIONS[states[0]]), function(x) {
                        return x.toLowerCase().startsWith(term);
                    }), function(x) {
                        return {
                            type: "county",
                            state: states[0],
                            value: x
                        };
                    });
                }
            } else {
                result = _.map(_.filter(_.keys(window.LOCATIONS), function(x) {
                    if (x.toLowerCase().startsWith(term)) {
                        return true;
                    }
                    if (window.FULL_NAMES[x].toLowerCase().startsWith(term)) {
                        return true;
                    }
                }), function(x) {
                    return {
                        type: "state",
                        value: x
                    }
                });
                _.each(window.LOCATIONS, function(v, k) {
                    result = result.concat(_.map(_.filter(_.keys(v), function(x) {
                        if (x.toLowerCase().startsWith(term)) {
                            return true;
                        }
                    }), function(x) {
                        return {
                            type: "county",
                            state: k,
                            value: x
                        }
                    }));
                });
            }

            result = _.sortBy(result, "value");
            resp(result);
        },
        select: function(event, ui) {
            var value = ui.item.value;
            if (ui.item.type == "county") {
                value = ui.item.state + " " + value;

                $("table").DataTable()
                    .column(1)
                    .search(ui.item.state)
                    .column(2)
                    .search(ui.item.value)
                    .draw();
            } else {
                $("table").DataTable()
                    .column(1)
                    .search(ui.item.value)
                    .column(2)
                    .search("")
                    .draw();
            }
            $("#location").val(value);
            $("#location_status b").html(value);
            $("#location_status").show();

            return false;
        }
    });

    $("#location").autocomplete( "instance" )._renderItem = function(ul, item) {
        return $( "<li>" )
            .append( "<div>" + item.value + " <i>" + (item.state || "") + "</i></div>" )
            .appendTo( ul );
    };

    $("#location_status .btn").click(function() {
        $("table").DataTable()
            .column(1)
            .search("")
            .column(2)
            .search("")
            .draw();
        $("#location_status").hide();
        $("#location").val("");
        return false;
    });

    $("#cancer_type+.btn").click(function() {
        $("#cancer_type").focus();
    });
});
