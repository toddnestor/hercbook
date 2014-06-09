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
    switch (addFriendshipBtn.data('action')) {
    case 'add':
      $.ajax({
        url: Routes.user_friendships_path({user_friendship: { friend_id: addFriendshipBtn.data('friendId') }}),
        dataType: 'json',
        type: 'POST',
        success: function(e) {
          $('#friend-status' + addFriendshipBtn.data('friendId')).html("<a id='add-friendship' data-action='cancel' data-friend-id='" + addFriendshipBtn.data('friendId') + "' data-friendship-id='" + e.id + "' href='" + Routes.destroy_user_friendship_path(e.id) + "' class='btn btn-info'>Cancel Friend Request</a>");
        }
      });
    break;

    case 'cancel':
      $.ajax({
        url: Routes.destroy_user_friendship_path(addFriendshipBtn.data('friendshipId')),
        dataType: 'json',
        type: 'POST',
        success: function(e) {
          $('#friend-status' + addFriendshipBtn.data('friendId')).html("<a id='add-friendship' data-action='add' data-friend-id='" + addFriendshipBtn.data('friendId') + "' href='" + Routes.new_user_friendship_path({friend_id: addFriendshipBtn.data('friendId')}) + "' class='btn btn-primary'>Add Friend</a>");
        }
      });
    break;

    case 'accept':
      $.ajax({
        url: Routes.accept_user_friendship_path(addFriendshipBtn.data('friendshipId')),
        dataType: 'json',
        type: 'POST',
        success: function(e) {
          $('#friend-status' + addFriendshipBtn.data('friendId')).html("<a id='add-friendship' data-action='cancel' data-friend-id='" + addFriendshipBtn.data('friendId') + "' data-friendship-id='" + addFriendshipBtn.data('friendshipId') + "' href='" + Routes.destroy_user_friendship_path(addFriendshipBtn.data('friendshipId')) + "' class='btn btn-danger'>Destroy Friendship</a>");
        }
      });
    break;

    case 'block':
      
    break;
    }
  });

});
