Template.doel.events({
  'submit #mc-embedded-subscribe-form': function(evt) {
    evt.preventDefault();
    Meteor.call('sendDemoMail', $('#mce-EMAIL').val(), $('#mce-FNAME').val(), function(error, result) {
      if (error) console.error(error);
      console.log(result);
      $('#mc-embedded-subscribe-form').html('<h2>Verstuurd</h2>Dank voor je interesse. De email is succesvol verstuurd.');
    });
    return false;
  }
})
