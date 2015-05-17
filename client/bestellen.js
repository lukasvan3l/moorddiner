
var amountOfPlayers = new ReactiveVar(0);
var success = new ReactiveVar(false);

Template.bestellen.helpers({
  'players': function() {
    return amountOfPlayers.get();
  },
  'story': function() {
    var story = Stories.findOne();
    return story ? story._id : null;
  },
  'success': function() {
    return success.get();
  },
  'price': function() {
    return (amountOfPlayers.get() * pricePerPerson).toFixed(2);
  },
  'pricePerPerson': function() {
    return pricePerPerson.toFixed(2);
  }
});

Template.bestellen.events({
  'change input[name=amountOfParticipants]': function(el) {
    amountOfPlayers.set($(el.target).val());
  },
  'blur input[name=amountOfParticipants]': function(el) {
    var amount = $(el.target).val() || 0;
    amountOfPlayers.set(amount);
  }
});

AutoForm.addHooks('customerForm', {
  // Called when any submit operation succeeds
  onSuccess: function(formType, result) {
    success.set(true);
    $("html, body").animate({ scrollTop: "0px" });
  },

  // Called when any submit operation fails
  onError: function(formType, error) {
    console.error('onError', formType, error);
  }
});