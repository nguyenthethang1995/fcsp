$(document).ready(function() {
  $('.cancel-edit').on('click', function() {
    var class_col_full = $(this).closest('.col_full');
    class_col_full.find('.current-info').toggle('slow');
    class_col_full.find('.form-edit-profile').toggle('slow');
  });

  $('.submit-edit-ajax').on('click', function(e) {
    e.preventDefault();
    var url, class_col_full, format_data, form_data;
    class_col_full = $(this).closest('.col_full');
    url = class_col_full.find('form').attr('action');
    form_data = new FormData(class_col_full.find('form')[0]);
    $.ajax({
      url: url,
      method: 'PATCH',
      dataType: 'JSON',
      processData: false,
      contentType: false,
      data: form_data
    }).done(function(data) {
      if (data.info_status == 'success') {
        format_data = data.html.trim();

        if(checkDateTime(data.html)){
          class_col_full.find('.current-info').html(new Date(format_data).toDateString());
          format_data = $.datepicker.formatDate('yy-mm-dd', new Date(format_data));
        } else {
          class_col_full.find('.current-info').html(format_data);
        }
        class_col_full.find('.form-control')[0].defaultValue = format_data;
        class_col_full.find('option').removeAttr('selected');
        class_col_full.find('.select-form > option[value="' + format_data + '"]').prop('selected', function(){
          this.defaultSelected = true;
        });

        class_col_full.find('.form-edit-profile').toggle('slow');
        class_col_full.find('.current-info').toggle();
        if (data.type == 'name') {
          $('.site-name').html(format_data);
        }

        $.growl.notice({message: I18n.t('setting.profiles.update_success')});
      } else {
        class_col_full.find('.form-edit-profile').toggle('slow');
        class_col_full.find('.current-info').toggle();
        $.growl.error({message: data.message});
      }
    });
    return false;
  });

  function checkDateTime(date) {
    return ((new Date(date)).toString() !== I18n.t('setting.profiles.invalid_date'));
  }

  $('body').on('click', '.edit-toggle', function(){
    var edit_value, form_edit, current_info;

    edit_value = $(this).closest('.container').find('.edit_info_user, .edit_user, .new_skill');
    for (var i = 0; i < edit_value.length; i++) {
      edit_value[i].reset();
    }
    form_edit = $(this).closest('.col_full').find('.form-edit-profile, .create-form');
    $(this).closest('.container').find('.form-edit-profile, .create-form').not(form_edit).hide();

    current_info = $(this).closest('.col_full').find('.current-info');
    $(this).closest('.container').find('.current-info').not(current_info).show();

    $(this).closest('.col_full');
    form_edit.toggle('slow');
    $(this).closest('.col_full').find('.current-info').toggle();
  });
});
