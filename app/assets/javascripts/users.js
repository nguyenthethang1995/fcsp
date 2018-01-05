$(document).ready(function(){
  userLanguageHiddenToggle(null);
  setupLinkedDatePicker(null,null);

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
