$(document).ready(function(){
  userLanguageHiddenToggle(null);
  setupLinkedDatePicker(null,null);
  $('.change-image').on('change', function(){
    read_url(this);
    $('.user-old-image').val('');
    $('.btn-submit-avatar').addClass('btn-create-avatar');
    $('.btn-submit-avatar').removeClass('btn-update-avatar');
    $('.btn-submit-cover').addClass('btn-create-cover');
    $('.btn-submit-cover').removeClass('btn-update-cover');
    $('#form-create-cover img').remove();
    $('#form-create-avatar img').remove();
  });

  $('.album-image').hide();

  $('.album-for-user').on('click', function(){
    $('.album-image').show();
  });

  $('.user-image-img').on('click', function(){
    var image_id = this.dataset.id;
    var image_src = $('#user-image-' + image_id).attr('src');
    $('.img-upload').attr('src', image_src);
    $('.user-old-image').val(image_id);
    $('.change-image').val('');
    $('.btn-submit-avatar').addClass('btn-update-avatar');
    $('.btn-submit-avatar').removeClass('btn-create-avatar');
    $('.btn-submit-cover').addClass('btn-update-cover');
    $('.btn-submit-cover').removeClass('btn-create-cover');
  });

  $('#changeAvatarModal').on('click', '.btn-create-avatar', function(){
    $('#form-create-avatar').submit();
  });

  $('#changeAvatarModal').on('click', '.btn-update-avatar', function(){
    $('#form-update-avatar').submit();
  });

  $('#changeCoverModal').on('click', '.btn-create-cover', function(){
    $('#form-create-cover').submit();
  });

  $('#changeCoverModal').on('click', '.btn-update-cover', function(){
    $('#form-update-cover').submit();
  });

  $('.hide-tab').hide();
  $('.hide-tab.active').show();
  $('.user-show a').click(function(){
    $('.user-show li.active').removeClass('active');
    $(this).parent().addClass('active');
    var target = '#' + $(this).data('target');
    $('.hide-tab').not(target).hide();
    $(target).show();
  });

  js_hover('.education-info', '.edit-education');
  js_hover('.certificate-info', '.edit-certificate');
  js_hover('.link-info', '.edit-link');
  js_hover('.award-hover', '.hover-button-award');
  js_hover('.link-info', '.edit-link');
  js_hover('.skill-info', '.edit-skill');

  $(document).ajaxComplete(function(){
    js_hover('.education-info', '.edit-education');
    js_hover('.certificate-info', '.edit-certificate');
    js_hover('.link-info', '.edit-link');
    js_hover('.award-hover', '.hover-button-award');
    js_hover('.link-info', '.edit-link');
  });


  $('form#edit-about-me-form,' + 'form#edit-ambition-form,' +
    'form#edit-introduction-form,' + 'form#edit-quote-form'
  ).bind('ajax:success', function(event, xhr) {
    if(xhr['errors']) {
      $('.form-group').removeClass('has-error');
      $('span').remove('.help-block');
      var $form = $(this);
      if(xhr['errors']) {
        $.map(xhr['errors'], function(v, k) {
          var element_id = '#info_user_' + k;
          var $divFormGroup = $form.find(element_id).parent();
          $divFormGroup.addClass('has-error');
          $divFormGroup.append('<span class="help-block">' + v + '</span>');
        });
      }
    } else {
      $(this).closest('.modal').modal('hide');
      $('.form-group').removeClass('has-error');
      $('span').remove('.help-block');
    }
  });

  $('.edit-info-status').on('click', function(){
    var id = this.dataset.id;
    var info = this.dataset.info;
    var status = this.dataset.status;
    var data = {};
    data[info] = status;
    $.ajax({
      type: 'patch',
      url: '/info_users/' + id,
      dataType: 'json',
      data: {info_statuses: data},
      success: function(data){
        if(data.status === 200) {
          $.growl.notice({message: data.flash});
          if(status === '0') {
            $('.' + info + '-status').addClass('icon-lock').removeClass('icon-globe');
          } else {
            $('.' + info + '-status').addClass('icon-globe').removeClass('icon-lock');
          }
        } else {
          $.growl.error({message: data.flash});
        }
      },
      error: function(error){
        $.growl.error({message: error});
        location.reload();
      }
    });
  });

  $('.container').on('click', '#user-follow', function(){
    var url, data_method, user_id;
    url =  $(this).attr('href');
    data_method = $(this).attr('data-method');
    user_id = $(this).parent().attr('id');
    $.ajax({
      url: url,
      method: data_method,
      dataType: 'JSON'
    })
    .done(function(data){
      $('.follow-user').html(data.html);
      $('#' + user_id).html(data.html);
    })
    return false;
  });
});

function read_url(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function (e) {
      $('.img-upload').attr('src', e.target.result);
    };
    reader.readAsDataURL(input.files[0]);
  }
}

function js_hover(object_hover, object_hiden_show) {
  $(object_hiden_show).hide();
  $(object_hover).mouseenter(function(){
    $(this).find(object_hiden_show).show();
  }).mouseleave(function() {
    $(this).find(object_hiden_show).hide();
  });
}

function userLanguageHiddenToggle(is_hidden) {
  if(is_hidden) {
    $('.user-language-hidden-toggle').addClass('hidden');
  }else {
    $('.user-language-hidden-toggle').removeClass('hidden');
  }
  return false;
}

function setupLinkedDatePicker(start, end) {
  $(start).datepicker();
  $(end).datepicker({
    useCurrent: false
  });

  $(document).on('changeDate', start, {}, function (e) {
    $(end).datepicker('setStartDate', e.date);
  });

  $(document).on('changeDate', end, {}, function (e) {
    $(start).datepicker('setEndDate', e.date);
  });
}
