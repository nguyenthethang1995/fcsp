$(document).ready(function() {
  var album_image, default_image;
  album_image = $('.album-image');
  album_image.hide();

  $('.modal-image').on('shown.bs.modal', function() {
    default_image = $(this).find('.img-upload').attr('src');
  });

  $('.album-for-user').click(function() {
    $('.change-image').val('');
    $(this).parents('.modal-body').find('.img-upload').attr('src', default_image);
    $(this).parents('.modal-body').find('.user-old-image').val('');
    if (album_image.css('display') == 'none') {
      album_image.show();
      album_image.parents('.modal-content').find('.btn-create-image')
        .addClass('btn-update-image').removeClass('btn-create-image');
    } else {
      album_image.hide();
      album_image.parents('.modal-content').find('.btn-update-image')
        .addClass('btn-create-image').removeClass('btn-update-image');
    }
  });

  $('.user-image-img').on('click', function() {
    var img_id = this.dataset.id;
    var img_src = $('#user-image-' + img_id).attr('src');
    $(this).parents('.modal-body').find('.img-upload').attr('src', img_src);
    $('.change-image').val('');
    $(this).parents('.modal-body').find('.user-old-image').val(img_id);
  });

  $('.modal-image').on('hidden.bs.modal', function () {
    $(this).find('.img-upload').attr('src', default_image);
    $('.change-image').val('');
    $('.album-image').css('display', 'none');
    $('.user-old-image').val('');
  });

  $('.change-image').on('change', function() {
    read_url(this);
    album_image.hide();
    album_image.parents('.modal-content').find('.btn-update-image')
      .addClass('btn-create-image').removeClass('btn-update-image');
    $('.user-old-image').val('');
  });

  $('.modal-image').on('click', '.btn-create-image', function() {
    if ($(this).parents('.modal-content').find('.change-image').val() == '') {
      alert(I18n.t('user_avatars.if_you_dont_want'));
    } else {
      $(this).parents('.modal-content').find('#new_image').submit();
    }
  });

  $('.modal-image').on('click', '.btn-update-image', function() {
    if ($(this).parents('.modal-content').find('.user-old-image').val() == '') {
      alert(I18n.t('user_avatars.if_you_dont_want'));
    } else {
      $(this).parents('.modal-content').find('#edit_image').submit();
    }
  });
});

function read_url(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function(e) {
      $(input).parents('.modal-body').find('.img-upload').attr('src', e.target.result);
    };
    reader.readAsDataURL(input.files[0]);
  }
}
