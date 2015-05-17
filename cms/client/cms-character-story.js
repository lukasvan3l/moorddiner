
Template.cmsCharacterStory.helpers({
  storyname: function() {
    return Stories.findOne(this.doc.story).name;
  }
});