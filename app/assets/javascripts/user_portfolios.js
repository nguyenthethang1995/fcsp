function delete_portfolio(id) {
  $.ajax({
    type: 'DELETE',
    url: '/user_portfolios/' + id,
    dataType: 'json',
    success: function(data) {
      if(data['status'] === 200) {
        $('#portfolio-' + id).remove();
        $.growl.notice({title: '', message: data['flash']});
      }
    },
    error: function(error_message) {
      $.growl.error({message: error_message});
      location.reload();
    }
  });
}

$(document).ready(function() {
  $('.datepicker').datepicker({
    format: 'dd-mm-yyyy'
  });

  $('.hover-button-portfolio').hide();
  $('.hover-portfolio').mouseenter(function(){
    $(this).find('.hover-button-portfolio').show();
  }).mouseleave(function() {
    $(this).find('.hover-button-portfolio').hide();
  });

  $('.delete-portfolio').on('click', function() {
    var id = this.dataset.id;
    var status_alert = I18n.t('javascripts.user_portfolio_alert');
    if(confirm(status_alert)) {
      delete_portfolio(id);
    }
  });

  $('body').on('cocoon:after-insert', function(e, addedPartial) {
    return $('input[type=file]', addedPartial).change(onAddFile);
  });
  $('a.add_fields').data('association-insertion-method', 'append');

  $('form.portfolio-form').bind('ajax:success', function(event, xhr) {
    if(xhr['errors']) {
      $('.form-group').removeClass('has-error');
      $('span').remove('.help-block');
      var $form = $(this);
      if(xhr['errors']) {
        $.map(xhr['errors'], function(v, k) {
          var element_id = '#user_portfolio_' + k;
          var $divFormGroup = $form.find(element_id).parent();
          $divFormGroup.addClass('has-error');
          $divFormGroup.append('<span class="help-block">' + v + '</span>');
        });
      }
    }else {
      $(this).closest('.modal').modal('hide');
      $('.form-group').removeClass('has-error');
      $('span').remove('.help-block');
    }
  });
});
