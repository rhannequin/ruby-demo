(function (win) {

  var $form = $('form');

  $form.on('submit', function(e) {
    e.preventDefault();
    var name      = $form.find("input[name='pokemon[name]']").val(),
        t         = $form.find("input[name='pokemon[types]']").val(),
        a         = $form.find("input[name='pokemon[abilities]']").val(),
        img       = $form.find("input[name='pokemon[img]']").val(),
        id        = $form.find("input[name='pokemon[id]']").val(),
        types     = [],
        abilities = [];

    $.each(t.split(','), function() {
      types.push($.trim(this));
    });
    $.each(a.split(','), function() {
      abilities.push(this.trim());
    });

    var data = {
      pokemon: {
        name: name,
        types: types,
        abilities: abilities,
        img: img
      }
    };

    var req = $.ajax({
      url: '/pokedex/' + id,
      type: 'PUT',
      data: data
    });
    req.done(function (res) {
      win.location = '/pokedex/' + res.pokemon['_id'];
    });
  });

})(window);