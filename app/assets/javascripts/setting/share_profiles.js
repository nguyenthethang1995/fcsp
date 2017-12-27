$(document).ready(function(){
  $('#search').keyup(function(){
    var id, arr, search_value;
    arr = $('.li-users');
    search_value = $('#search').val();
    for (var i = 0; i < arr.length; i++){
      id = arr[i].id;
      $('#' + id).show();
      if (!arr[i].innerText.includes(search_value)){
        $('#' + id).hide();
      }
    };
  });

  $('#select_all').click(function(){
    if(this.checked){
      $('.li-users :checkbox').each(function(){
        this.checked = true;
      });
    }
    else {
      $('.li-users :checkbox').each(function(){
        this.checked = false;
      });
    }
  });

  $('#cancel_share_profile').click(function(){
    $('.li-users :checkbox').each(function(){
      this.checked = !!$(this).attr('checked');
    });
  });

  $('.toggle-info').click(function(){
    $('#toggle-info-contact').toggle('slow');
  });
});
