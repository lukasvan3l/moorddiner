Template.doel.events({
  'submit #mc-embedded-subscribe-form': function(evt) {
    evt.preventDefault();
    if ($('#mce-EMAIL').val().length < 2)
      throw new Meteor.Error(400, 'Je bent een mailadres vergeten in te vullen.');
    Meteor.call('sendDemoMail', $('#mce-EMAIL').val(), $('#mce-FNAME').val(), function(error, result) {
      if (error) console.error(error);
      console.log(result);
      $('#mc-embedded-subscribe-form').html('<h2>Verstuurd</h2>Dank voor je interesse. De email is succesvol verstuurd.');
    });
    return false;
  }
});
