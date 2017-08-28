// https://datatables.net/reference
// DataTable report for the Surveys
var surveys;

// Wait for the DOM to be ready
$(document).ready(function() {
  
  // Start DataTable if the answer columns exist.
  if (typeof surveys_columns !== 'undefined') {
    surveys = $('#surveys').DataTable({
  
      // https://datatables.net/reference/option/serverSide
      // => data come from the server, i.e. not pre-loaded in the DOM
      serverSide: true,
  
      // https://editor.datatables.net/reference/option/ajax
      // => XHR to grab data (surveys)
      ajax: '/surveys',
  
      // https://datatables.net/reference/option/ajax.dataSrc
      // => no custom manipulation of the data returned from the server
      dataSrc: '',
  
      // https://datatables.net/reference/option/columns
      // => columns for our report
      columns: surveys_columns,
  
      // https://datatables.net/reference/option/order
      // => default ordering on column 2, DESC (which is the survey +created_at+, cf. Survey::COLUMNS)
      order: [[2, "desc"]],
  
      // https://datatables.net/reference/option/drawCallback
      // Extra custom actions on every draw event of the table/report
      drawCallback: function (settings) {
  
        // Some cosmetic design adjustments:
        $('#surveys_wrapper').removeClass('form-inline');                            // Bootstrap v3 => v4 adj.
        $('#surveys_paginate').addClass('pull-right');                               // Pagination to the right.
        $('#surveys_filter input').attr('placeholder', 'surveyor name or question'); // Search input placeholder.
        $('.paginate_button').addClass('page-item').find('a').addClass('page-link'); // Bootstrap v3 => v4 adj.
        
      }
    });
    
    // https://datatables.net/reference/api/ajax.reload()
    // Refresh the table/report of surveys each 10 seconds.
    // TODO: leverage websockets instead of polling (ActionCable shipped with Rails 5, with Redis PubSub).
    setInterval( function () {
      surveys.ajax.reload(null, false); // false => hold the current paging position
    }, 10000 ); // TODO: customized value per user ?
    
  }
} );

// To vote Yes or No
// +SPEC+: <em>The answer to the question is always Yes or No.</em>
//# +SPEC+: <em>A user can respond to a survey by clicking into it from the list discussed above.</em>
function vote(url){
  $.post(url, { authenticity_token: ajax_auth_token });
}

// To inform the user if his answer has been well saved by the server for the related survey
// Temporarily hide the Yes/No voting buttons
// Temporarily show the status of the request (saved successfully or an error occurred on server side)
// Restore the initial voting buttons after 2 seconds
// +SPEC+: <em>A user can respond to a survey by clicking into it from the list discussed above.</em>
// +SPEC+: <em>A survey can be answered multiple times with a yes/no response.</em>
function vote_result(survey_id, success, auth_token){
  // refresh the CSRF auth token
  ajax_auth_token = auth_token;
  
  // Hide the voting buttons
  $('#vote_'   + survey_id).hide();
  
  // Show the badge corresponding to the status of the request performed.
  $('#result_' + survey_id).fadeIn();
  if(success){
      $('#result_' + survey_id + ' .badge-success').fadeIn(); // on success
  } else {
      $('#result_' + survey_id + ' .badge-danger' ).fadeIn(); // on error
  }
  
  // Restore the UI, allowing the user to answer more (possibly on the same survey).
  setTimeout(function(){
    
    // Hide the status badges & their container.
    $('#result_' + survey_id).hide();
    $('#result_' + survey_id + ' .badge-danger' ).hide();
    $('#result_' + survey_id + ' .badge-success').hide();
  
    // Show the voting buttons
    $('#vote_'   + survey_id).fadeIn();
  
    // https://datatables.net/reference/api/ajax.reload()
    // Let's refresh the surveys
    // Take into account the latest answers (incl. the one performed by our user).
    surveys.ajax.reload(null, false); // false => hold the current paging position
    
  }, 2000); // TODO: customized value per user ?
}
