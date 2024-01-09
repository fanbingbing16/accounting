var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var loginRouter = require('./routes/login');
var expenditureRouter = require('./routes/expenditure');
let categoryRouter = require('./routes/category/index')
let budgetRouter = require('./routes/budget/index')
let logsRouter = require('./routes/los')
var bodyParser = require('body-parser')
const cors = require('cors')

var app = express();


// view engine setup
app.use(cors())

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded( {limit:'50mb',extended:true} ))
app.use(bodyParser.json({limit:'50mb'}))

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/login', loginRouter);
app.use('/expenditure', expenditureRouter);
app.use('/category', categoryRouter);
app.use('/budget', budgetRouter);

app.use('/logs',logsRouter)
// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;


