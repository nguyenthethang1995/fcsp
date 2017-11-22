$(document).ready(function() {
  var sectionIds = {};
  $('.row-edit').each(function(){
    sectionIds[$(this).attr('id')] = $(this).first().offset().top - 140;
  });

  $(window).scroll(function(event){
    var scrolled, row;
    scrolled = $(this).scrollTop();
    for (key in sectionIds){
      if (scrolled >= sectionIds[key]){
        $('.nav-btn').removeClass('orange-text');
        row = $('[data-row-id=' + key + ']');
        row.addClass('orange-text');
      }
    }
  });

  $('.nav-btn').click(function(){
    var name, id, top;
    $(this).addClass('orange-text');
    name = $(this).attr('data-row-id');
    id = '#' + name;
    top = $(id).first().offset().top - 100;
    $('html, body').animate({scrollTop: top + 'px'}, 300);
  });

  var previous_id, previous_value, value;

  $('.edit-toggle').on('click', function(e) {
    var id, black_text;
    $('.collapse').removeClass('in');
    $('.black-text').removeClass('hidden');
    black_text = $(this).parent().children('.black-text');
    black_text.addClass('hidden');
    value = black_text.html();
    id = black_text.attr('id');
    $('#' + previous_id).parent().find('.form-control').val(previous_value);
    previous_value = value;
    previous_id = id;
  });

  $('.cancel-edit').on('click', function() {
    $('.collapse').removeClass('in');
    $('.black-text').removeClass('hidden');
    $(this).closest('.collapse').find('.form-control').val(value);
  });

  $('.submit-edit-ajax').on('click', function(e) {
    e.preventDefault();
    var input_info_user, type, url;
    type = $(this).closest('.collapse').attr('id').replace('edit-', '');
    url = $(this).closest('form').attr('action');
    input_info_user = $(this).closest('.collapse').find('.form-control').val();
    $.ajax({
      url: url,
      method: 'PATCH',
      dataType: 'JSON',
      data: {type, input_info_user}
    })
    .done(function(data) {
      if (data.info_status == 'success') {
        $('#' + type).html(data.html);
        $('.collapse').removeClass('in');
        $('.black-text').removeClass('hidden');
        $.growl.notice({message: I18n.t('setting.profiles.update_success')});
        previous_value = $('#' + type).html();
      } else {
        $.growl.error({message: data.message});
        $('.collapse').removeClass('in');
        $('.black-text').removeClass('hidden');
        previous_value = $('#' + type).html();
      }
    })
    return false;
  });
});
