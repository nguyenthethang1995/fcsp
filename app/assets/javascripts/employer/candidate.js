$(document).ready(function(){
  $('.select-job').change(function(){
    var job_id, company_id, employer_type, language_id;

    job_id = $(this).val();
    company_id = $('#company-id').val();
    employer_type = $('#employer-type').val();
    language_id = $('.select-language').val();
    $.ajax({
      dataType: 'json',
      url: '/employer/companies/' + company_id + '/' + employer_type,
      method: 'get',
      data: {select: job_id, select_language: language_id},
      success: function(data) {
        $('#list-' + employer_type).html(data.html_job);
        $('.pagination-bar').html(data.pagination_candidate);
        if (employer_type == 'trainees') {
          $('.filter-traineename').html(data.filter_name);
          $('.filter-dob').html(data.filter_birthday);
        }
      },
      error: function(){
        alert(I18n.t('employer.candidates.not_found'));
      }
    });
  });

  $('.select-language').change(function(){
    var language_id, company_id, job_id;

    language_id = $(this).val();
    company_id = $('#company-id').val();
    job_id = $('.select-job').val();
    $.ajax({
      dataType: 'json',
      url: '/employer/companies/' + company_id + '/trainees',
      method: 'get',
      data: {select: job_id, select_language: language_id},
      success: function(data){
        $('#list-trainees').html(data.html_job);
        $('.filter-traineename').html(data.filter_name);
        $('.filter-dob').html(data.filter_birthday);
      },
      error: function(){
        alert(I18n.t('employer.candidates.not_found'));
      }
    });
  });

  $('body').on('change', '#checkbox-check-all', function() {
    var checkboxes = $(this).parents('table')
      .find('tbody input[type = "checkbox"]');
    if($(this).is(':checked')) {
      checkboxes.prop('checked', true);
    } else {
      checkboxes.prop('checked', false);
    }
  });

  $('body').on('change', function() {
    var checkboxes = $('#checkbox-check-all').parents('table')
      .find('tbody input[type = "checkbox"]');
    var count_checked = 0;
    for (var i = 0; i < checkboxes.length; i++) {
      if (checkboxes[i].checked == false) {
        $('#checkbox-check-all').prop('checked', false);
      } else {
        count_checked ++;
      }
    }
    if (count_checked == checkboxes.length) {
      $('#checkbox-check-all').prop('checked', true);
    }
  });

  $('.button-direct .btn-cancel').click(function(){
    if ($('.btn-filter').hasClass('open')) {
      $('.btn-filter').removeClass('open');
    }
  });

  $('.btn-filter').each(function(){
    if ($(this).parent().position().left > 600) {
      $(this).children().eq(1).css('left','-232px');
    }
  });

  $('.filter .checkall').click(function() {
    var checkboxes = $(this).parent().siblings('.list-item-value').children().children('input[type = "checkbox"]');
    checkboxes.prop('checked', true);
  });

  $('.filter .delete').click(function() {
    var checkboxes = $(this).parent().siblings('.list-item-value').children().children('input[type = "checkbox"]');
    checkboxes.prop('checked', false);
  });

  $('body').on('click', '.dropdown-toggle', function(){
    $('.dropdown-toggle').dropdown();
  });

  $('body').on('click', '.sortAlpha, .btn-ok', function(e){
    e.preventDefault();
    var typefilter, sort_by, listcheckbox, arrchecked, company_id, filter_mode,
      params, tbody, url_request, job_id, language_id, data_table;

    job_id = $('.select-job').val();
    language_id = $('.select-language').val();
    typefilter = $(this).parents('div').attr('data-filter');
    sort_by = $(this).attr('data-sort-by');
    listcheckbox = $(this).parents('ul').children().find('.checkboxitem');
    arrchecked = [];
    company_id = $('#company-id').val();
    filter_mode = $(this).parents('div').attr('data-model');
    data_table = $(this).parents('div').attr('data-table');

    listcheckbox.each(function(){
      if ($(this).is(':checked')){
        arrchecked.push($(this).attr('data-list-id'));
      }
    });

    params = {type: typefilter, sort: sort_by, array_id: arrchecked, select: job_id,
      select_language: language_id, data_table: data_table};
    tbody = '';
    url_request = '';

    switch (filter_mode) {

      case 'candidate':
        url_request = '/employer/companies/' + company_id + '/candidates';
        tbody = $('#list-candidates');
        break;

      case 'job':
        url_request = '/employer/companies/' + company_id + '/jobs';
        tbody = $('.jobs-list');
        break;

      case 'trainee':
        url_request = '/employer/companies/' + company_id + '/trainees';
        tbody = $('#list-trainees');
        break;
    }

    $.ajax({
      dataType: 'json',
      url: url_request,
      method: 'GET',
      data: params,
      success: function(data){
        tbody.html(data.html_job);
        switch (filter_mode){

          case 'candidate':
            $('.pagination-bar').html(data.pagination_candidate);
            break;

          case 'job':
            $('.pagination-job').html(data.pagination_job);
            break;

          case 'trainee':
            $('.pagination-bar').html(data.pagination_candidate);
            $('.filter-traineename').html(data.filter_name);
            $('.filter-dob').html(data.filter_birthday);
            break;
        }

        if ($('.btn-filter').hasClass('open')){
          $('.btn-filter').removeClass('open');
        }
      },
      error: function(){
        swal({
          type: 'danger',
          title: I18n.t('employer.team_introductions.danger'),
          text: I18n.t('employer.team_introductions.danger')
        });
      }
    });
  });

  $('.search-user-filter').keyup(function(){
    var value, object_checkbox;
    value = $(this).val();
    object_checkbox = $(this).parents('.value-sort')
      .children('.list-item-value').find('.checkbox');
    if (value == ''){
      object_checkbox.show();
      object_checkbox.children('input').prop('checked', true);
    }
    else{
      object_checkbox.each(function(){
        if ($(this).children('label').html().toLowerCase().search(value.toLowerCase()) >= 0){
          if ($(this).children('label').html() == ''){
            $(this).children('input').prop('checked', false);
          }
          else{
            $(this).show();
            $(this).children('input').prop('checked', true);
          }
        }
        else{
          $(this).hide();
          $(this).children('input').prop('checked', false);
        }
      });
    }
  });
  $('.table-candidates').on('mouseover', '.col-process .process', function(){
    $(this).find('.popup-change-status').show();
  });
  $('.table-candidates').on('mouseout', '.col-process .process', function(){
    $(this).find('.popup-change-status').hide();
  });

  $('.table-candidates').on('click', '.btn-change-process', function(){
    var type_change = $(this).attr('data-change'),
      candidate_id = $(this).parent().attr('data-candidate-id'),
      company_id = $('#company-id').val(),
      url_request = '/employer/companies/' + company_id + '/candidates/'
        + candidate_id,
      button_process = $(this).closest('.process').find('strong'),
      box_process = $(this).closest('.popup-change-status'),
      candidate_name = $(this).closest('tr')
        .find('.col-username .title b').text(),
      type_to = $(this).text(),
      type_from = button_process.text(),
      message = '<p> ' + I18n.t('employer.candidates.from') + ' <b>'
        + type_from + ' </b> ' + I18n.t('employer.candidates.to') + ' <b>'
        + type_to + ' </b></p><b>'
        + candidate_name + '</b>';

    swal({
      title: I18n.t('employer.candidates.are_you_sure'),
      html: message,
      showCloseButton: true,
      showCancelButton: true
    }).then(
      function() {
        $.ajax({
          url: url_request,
          method: 'PUT',
          dataType: 'json',
          data: {type: type_change},
        })
        .done(function(data) {
          swal({
            type: 'success',
            title: I18n.t('employer.candidates.changed'),
            html: I18n.t('employer.candidates.process_has_been'),
            timer: 2000
          }).catch(swal.noop);

          button_process.html(data.type);
          button_process.attr('class', data.class_button);
          box_process.html(data.box_process);
        });
      },
      function () {
      });
  });

  $('.table-candidates').on('click', '.pagination-bar .page-link', function(e){
    var url_request, tbody;
    e.preventDefault();
    url_request = $(this).attr('href');
    tbody = '#' + $('tbody').attr('id');

    $.ajax({
      dataType: 'json',
      url: url_request,
      method: 'GET',
      success: function(data) {
        $(tbody).html(data.html_job);
        $('.pagination-bar').html(data.pagination_candidate);
      }
    });
  });
  action_candidate.initialize();

  $('#trainee-data-table').DataTable( {
    'order': [[1, 'asc']],
    'columnDefs': [
      {
        'targets': 0,
        'orderable': false
      },
      {
        'targets': 5,
        'orderable': false
      }
    ]
  });
});

var action_candidate = {
  initialize: function() {
    $('body').on('click', '.delete-candidate', function() {
      var id = $(this).attr('id');
      var arrchecked = [];
      var params = {array_id: arrchecked};
      arrchecked.push(id);
      var count_delete = arrchecked.length;
      swal({
        title: I18n.t('employer.candidates.destroy.confirm_delete'),
        text: I18n.t('employer.candidates.destroy.mess_text'),
        type: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: I18n.t('employer.candidates.destroy.confirm_text')
      }).then(function() {
        action_candidate.delete_candidate(params, count_delete);
      });
    });

    $('.btn-delete-candidate').click(function() {
      swal({
        title: I18n.t('employer.candidates.destroy.confirm_delete'),
        text: I18n.t('employer.candidates.destroy.mess_text'),
        type: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: I18n.t('employer.candidates.destroy.confirm_text')
      }).then(function() {
        var list_checkbox_candidate = $('#list-candidates').find('.checkbox-candidate');
        var arrchecked = [];
        var params = {array_id: arrchecked};
        list_checkbox_candidate.each(function() {
          if ($(this).is(':checked')) {
            var id = $(this).attr('data-list-candidate-id');
            arrchecked.push(id);
          }
        });
        var count_delete = arrchecked.length;
        action_candidate.delete_candidate(params, count_delete);
      });
    });
  },

  delete_candidate: function(params, count_delete) {
    var company_id = $('#company-id').val();
    $.ajax({
      dataType: 'json',
      url: '/employer/companies/' + company_id + '/candidates',
      method: 'DELETE',
      data: params,
      success: function(data) {
        if (data.status === 200) {
          $('table tbody').html(data.html_candidate);
          $('.pagination-bar').html(data.pagination_candidate);
        }
        swal(data.flash, count_delete + I18n.t('employer.candidates.destroy.mess_count_deleted'), 'success');
        $('#checkbox-check-all').prop('checked', false);
      },
      error: function() {
        swal(I18n.t('employer.candidates.destroy.fail'));
      }
    });
  }
};

$(document).on('click.my', '.filter', function(e) {
  e.stopPropagation();
});
