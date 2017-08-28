// https://datatables.net/reference
// DataTable report for the Answers of the provided Survey
var answers;

// Wait for the DOM to be ready
$(document).ready(function() {
  
  // Start DataTable if the answer columns exist.
  if (typeof answers_columns !== 'undefined') {
    answers = $('#answers').DataTable( {
      
      // https://datatables.net/reference/option/serverSide
      // => data come from the server, i.e. not pre-loaded in the DOM
      serverSide: true,
      
      // https://editor.datatables.net/reference/option/ajax
      // => XHR to grab data for the provided survey
      ajax: '/answers?survey_id=' + survey_id,
  
      // https://datatables.net/reference/option/ajax.dataSrc
      // => no custom manipulation of the data returned from the server
      dataSrc: '',
  
      // https://datatables.net/reference/option/columns
      // => columns for our report
      columns: answers_columns,
      
      // https://datatables.net/reference/option/order
      // => default ordering on column 3, DESC (which is the answer +created_at+, cf. Answer::COLUMNS)
      order: [[ 3, "desc" ]],
      
      // https://datatables.net/reference/option/drawCallback
      // Extra custom actions on every draw event of the table/report
      drawCallback: function(settings) {
        
        // Some cosmetic design adjustments:
        $('#answers_wrapper').removeClass('form-inline');                            // Bootstrap v3 => v4 adj.
        $('#answers_paginate').addClass('pull-right');                               // Pagination to the right.
        $('#answers_filter input').attr('placeholder', 'respondent name');           // Search input placeholder.
        $('.paginate_button').addClass('page-item').find('a').addClass('page-link'); // Bootstrap v3 => v4 adj.
        
      }
    } );
  }
  
  // Auto-refresh each minute the answer page if the option is checked.
  // TODO: leverage websockets instead of polling (ActionCable shipped with Rails 5, with Redis PubSub).
  setInterval( function () {
    if ($('#survey_refresh').is(':checked')) {
      window.location.replace(
        window.location.href + (
          // Using the URL querystring to save the refresh option when checked.
          // Appending the attribute refresh (true)
          window.location.search.match(/refresh/) ? '' : ((window.location.search == '' ? '?' : '&') + 'refresh=true')
        )
      );
    }
  }, 60000); // TODO: customized value per user?
  
  // Auto-refresh option: from the querystring to the related checkbox.
  if(window.location.search.match(/refresh/)){
    $('#survey_refresh').prop('checked', true);
  }
  
} );
