var express = require('express');
var router = express.Router();
const db = require('./type');
const db2 = require('../../conf/postRefe')
const db3 = require('../../conf/db')
const getId = require('../../public/typescript/getId.ts');
const transformSE = require('../../public/typescript/transform.ts');
// 添加
router.post('/add', (req, res) => {
  let { money, userid, typeid, time, type } = req.body;
  console.log(req.body, 'body', 'resxxxx')
  db.query('insert into expenditure_income(type,time,money,id,userid,typeid,update_time' + (req.body.description ? ',description' : '') + ') values(?,?,?,?,?,?,?' + (req.body.description ? ',?' : '') + ')', { type: type || '1', time, money, id: getId(), userid, typeid, updateTime: new Date(), description: req.body.description }, res, function (results, fields,) {

    res.send({ status: 1, msg: '添加成功', data: null })

  }, true)

})
router.post('/edit', (req, res) => {
  let { money, userid, typeid } = req.body;
  console.log(req.body, 'body', 'resxxxx')
  db.query('update expenditure_income ', { money, id: Date.now(), userid, typeid, updateTime: new Date(), description: req.body.description }, res, function (results, fields,) {
    res.send({ status: 1, msg: '添加成功', data: null })
  }, true)

})
router.get('/', (req, res) => {
  console.log('res', 'req', req.query)
  let sql = 'select *,(SELECT `name` from category WHERE category.id=typeid) as `name`,(SELECT `icon` from category WHERE category.id=typeid) as icon from expenditure_income where  '
  let data = {}
  const query = req.query
  if (query.search) {
    sql += ' (money like ? or description like ? or (select `name` from category where category.id=typeid) like ?) and'
    data.money = '%' + query.search + '%'
    data.description = '%' + query.search + '%'
    data.name = '%' + query.search + '%'
  }

  sql += ' delete_time is NULL and userid=?'
  data.userid = query.userid
  if (query.time) {
    const date = transformSE(query.time)
    sql += ` and time BETWEEN '${date.start}' and '${date.end}' `

  }
  if (query.type) {
    sql += ' and type=?'
    data.type = query.type
  }
  sql += ' ORDER BY time DESC'
  console.log(sql, 'sql')
  db2.query(sql, data, res, function (results, fields) {

    res.send({ status: 1, msg: '查询成功', data: results })

  }, true)
})
router.get('/dayTimes', (req, res) => {
  let { userid } = req.query;
  console.log(req.query, 'body', 'resxxxx')
  db2.query('select count(*) from expenditure_income where userid=? AND delete_time is NULL  GROUP BY time', { userid }, res, function (results, fields,) {
    db3.query('select count(*) as count from expenditure_income where delete_time is NULL AND  userid=' + userid, {}, res, function (results2, fields2,) {
      console.log(results2, results, 'result2', userid)
      res.send({ status: 1, msg: '', data: { day: results.length, times: results2[0].count } })
    })

  }, true)

})
router.get('/overview', (req, res) => {
  let { userid, startTime, endTime } = req.query;
  if(!startTime||!endTime){
    res.send({ status: 0, msg: '没有起始或结束时间', data: null })
    return
  }
  console.log(req.query, 'body', 'resxxxx')
  //这个sql计算本月支出 sum每日总支出 avg平均每日支出 count每日支出笔数
  db2.query(`select SUM(money) as sum,time,AVG(money) as avg,COUNT(id) as count from expenditure_income where delete_time IS NULL and userid=? and type='2' and time BETWEEN ? and ?  GROUP BY time`, { userid, startTime, endTime }, res, function (results, fields,) {
    //这sql计算本月每个分类的支出总和 以及笔数
    db3.query(`select SUM(money) as sum,typeid,(select \`name\` from category WHERE category.id=typeid) as \`name\`,count(*) as count from expenditure_income where delete_time IS NULL and userid='${userid}' and type='2' and time BETWEEN '${startTime}' and '${endTime}'  GROUP BY typeid ORDER BY sum DESC`, {  }, res, function (result2, fields2) {
      console.log(results, result2, 'result')
      res.send({ status: 1, msg: '', data: { data1: results, data2: result2 } })

    })

  }, true)

})
module.exports = router;

