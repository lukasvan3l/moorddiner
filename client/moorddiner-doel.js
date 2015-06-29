Template.doel.events({
  'submit #mc-embedded-subscribe-form': function(evt) {
    evt.preventDefault();
    Meteor.call('sendDemoMail', $('#mce-EMAIL').val(), $('#mce-FNAME').val(), function(error, result) {
      if (error) console.error(error);
      console.log(result);
    });
    return false;
  }
})
