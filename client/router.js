
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