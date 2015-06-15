
Router.configure({
  layoutTemplate: 'layout',
  loadingTemplate: 'loading'
});

Router.route('/', {
  action: function () {
    this.render('home');
  },
  onAfterAction: function() {
    GAnalytics.pageview();
    setSeo('home');
  }
});

Router.route('/:_template', {
  action: function () {
    this.render(this.params._template);
  },
  onAfterAction: function() {
    GAnalytics.pageview();
    setSeo(this.params._template);
  }
});

Router.route('/moorddiners/:_diner', {
  action: function () {
    this.render(this.params._diner);
  },
  onAfterAction: function() {
    GAnalytics.pageview();
    setSeo('doel');
  }
});


function setSeo(template) {
  var title = 'Moorddiner thuis met jouw vrienden';
  var desc = 'Een moorddiner om thuis te spelen met jouw vrienden - door Hester van Deutekom';
  var img = 'http://www.jouwmoorddinerthuis.nl/fluisteren.jpg';

  SEO.set({
    title: title,
    meta: {
      'description': desc
    },
    og: {
      'title': title,
      'description': desc,
      'image': img
    }
  });
}


Meteor.startup(function() {
  SEO.config({
    auto: {
      og: true,
      set: ['description', 'url', 'title']
    }
  });
});


Template.registerHelper('formatDate', function(context, format) {
    if (!format || typeof(format) != 'string')
        format = 'D MMM YYYY';
    if (context)
        return moment(context).format(format);
});

Template.registerHelper('ibanHester', function(context, format) {
    return ibanHester;
});

