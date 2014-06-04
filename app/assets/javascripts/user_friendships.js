window.userFriendships = [];

$(document).ready(function() {
  $.ajax({
    url: Routes.user_friendships_path({format: 'json'}),
    dataType: 'json',
    type: 'GET',
    success: function(data) {
      window.userFriendships = data;
    }
  });

  $(document).on('click', '#add-friendship', function(event) {
    event.preventDefault();
    var addFriendshipBtn = $(this);
    $.ajax({
      url: Routes.user_friendships_path({user_friendship: { friend_id: addFriendshipBtn.data('friendId') }}),
      dataType: 'json',
      type: 'POST',
      success: function(e) {
        addFriendshipBtn.hide();
        $('#friend-status' + addFriendshipBtn.data('friendId')).prepend("<a href='#' class='btn btn-info'>Awaiting Friend's Approval</a>");
      }
    });
  });

});
