(function (win) {

  var $deleteButtons = $('.delete-pokemon');

  $deleteButtons.on('click', function(e) {
    e.preventDefault();

    var id = $(e.currentTarget).data('id');

    var req = $.ajax({
      url: '/pokedex/' + id,
      type: 'DELETE'
    });
    req.done(function (res) {
      win.location = '/pokedex';
    });
  });

})(window);