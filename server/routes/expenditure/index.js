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
  db.query('insert into expenditure_income(type,time,money,id,userid,typeid,update_time' + (req.body.description ? ',description' : '') + ') values(?,?,?,?,?,?,?' + (req.body.description ? ',?' : '') + ')', { type: type || '1', time, money, id: getId(), userid, typeid, updateTime: new Date(), description: req.body.description }, res, function (results, fields,) {

    res.send({ status: 1, msg: '添加成功', data: null })

  }, true)

})
router.post('/edit', (req, res) => {
  let { money, userid, typeid } = req.body;
  db.query('update expenditure_income ', { money, id: Date.now(), userid, typeid, updateTime: new Date(), description: req.body.description }, res, function (results, fields,) {
    res.send({ status: 1, msg: '添加成功', data: null })
  }, true)

})
router.get('/', (req, res) => {
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
  if(query.startTime&&query.endTime){
    sql += ` and time BETWEEN '${query.startTime}' and '${query.endTime}' `
  }
  if (query.type) {
    sql += ' and type=?'
    data.type = query.type
  }
  sql += ' ORDER BY time DESC'
  db2.query(sql, data, res, function (results, fields) {

    res.send({ status: 1, msg: '查询成功', data: results })

  }, true)
})
router.get('/dayTimes', (req, res) => {
  let { userid } = req.query;
  db2.query('select count(*) from expenditure_income where userid=? AND delete_time is NULL  GROUP BY time', { userid }, res, function (results, fields,) {
    db3.query('select count(*) as count from expenditure_income where delete_time is NULL AND  userid=' + userid, {}, res, function (results2, fields2,) {
      res.send({ status: 1, msg: '', data: { day: results.length, times: results2[0].count } })
    })

  }, true)

})
router.get('/overview', (req, res) => {
  let { userid, startTime, endTime } = req.query;
  if (!startTime || !endTime) {
    res.send({ status: 0, msg: '没有起始或结束时间', data: null })
    return
  }
  //这个sql计算本月支出 sum每日总支出 avg平均每日支出 count每日支出笔数
  db2.query(`select SUM(money) as sum,time,AVG(money) as avg,COUNT(id) as count from expenditure_income where delete_time IS NULL and userid=? and type='2' and time BETWEEN ? and ?  GROUP BY time`, { userid, startTime, endTime }, res, function (results, fields,) {
    //这sql计算本月每个分类的支出总和 以及笔数
    db3.query(`select SUM(money) as sum,typeid,(select \`name\` from category WHERE category.id=typeid) as \`name\`,count(*) as count from expenditure_income where delete_time IS NULL and userid='${userid}' and type='2' and time BETWEEN '${startTime}' and '${endTime}'  GROUP BY typeid ORDER BY sum DESC`, {}, res, function (result2, fields2) {
      res.send({ status: 1, msg: '', data: { data1: results, data2: result2 } })

    })

  }, true)

})
router.post('/timeAdd', (req, res) => {
  let { money, userid, typeid, type, startTime, every } = req.body;
  const name = 'ding' + getId()
  db.query(`insert into schedule_tasks(every,${req.body.endTime ? 'end_time,' : ''} name,id,type,start_time,money,typeid,userid,update_time${req.body?.description ? ',description' : ''}) values(?,${req.body.endTime?'?,':''}?,?,?,'${startTime}',?,?,?,?${req.body?.description ? ',?' : ''})`, {every:every||'DAY',endTime:req.body.endTime,  name, id: getId(), type: type || '1', money, typeid, userid, updateTime: new Date(), description: req.body.description }, res, function (results, fields,) {
    db3.query(`create event ${name} on schedule EVERY '1' ${every || 'DAY'} STARTS '${startTime}' ${req.body.endTime?' ENDS ?':''} DO  insert into expenditure_income(type,time,money,userid,typeid,update_time,ding${req.body?.description ? ',description' : ''}) values(${type},date(CURRENT_DATE),${money},?,?,NOW(),'是'${req.body?.description ? ',?' : ''})`, req.body.endTime?[req.body.endTime,userid, typeid, req.body.description]:[userid, typeid, req.body.description], res, function (results, fields,) {

      res.send({ status: 1, msg: '添加成功', data: null })

    }, true)
  }, true)


})
module.exports = router;

