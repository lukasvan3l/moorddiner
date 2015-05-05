
Router.configure({
  layoutTemplate: 'layout',
  loadingTemplate: 'loading'
});

Router.route('/', function () {
  this.render('home');
});

Router.route('/:_template', function () {
  this.render(this.params._template);
});

Router.route('/moorddiners/:_diner', function () {
  this.render(this.params._diner);
});
