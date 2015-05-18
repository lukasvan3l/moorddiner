
Router.configure({
  layoutTemplate: 'layout',
  loadingTemplate: 'loading'
});

Router.route('/', function () {
  GAnalytics.pageview();
  this.render('home');
});

Router.route('/:_template', function () {
  GAnalytics.pageview();
  this.render(this.params._template);
});

Router.route('/moorddiners/:_diner', function () {
  GAnalytics.pageview();
  this.render(this.params._diner);
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

