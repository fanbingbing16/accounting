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
  db.query('insert into budget(time,money,id,userid,typeid,update_time) values(?,?,?,?,?,?)', {  time, money, id: getId(), userid, typeid, updateTime: new Date()}, res, function (results, fields,) {

    res.send({ status: 1, msg: '添加成功', data: null })

  }, true)

})
router.post('/edit', (req, res) => {
  let { money, userid, typeid } = req.body;
  db.query('update budget ', { money, id: Date.now(), userid, typeid, updateTime: new Date(), description: req.body.description }, res, function (results, fields,) {
    res.send({ status: 1, msg: '添加成功', data: null })
  }, true)

})
router.get('/', (req, res) => {
  let sql = 'select *,(SELECT `name` from category WHERE category.id=typeid) as `name`,(SELECT `icon` from category WHERE category.id=typeid) as icon from budget where  '
  let data = {}
  const query = req.query
  
  sql += ' delete_time is NULL and userid=?'
  data.userid = query.userid
  if (query.time) {
    const date = transformSE(query.time)
    sql += ` and time BETWEEN '${date.start}' and '${date.end}' `

  }
  sql += ' ORDER BY time DESC'
  db2.query(sql, data, res, function (results, fields) {

    res.send({ status: 1, msg: '查询成功', data: results })

  }, true)
})
router.get('/dayTimes', (req, res) => {
  let { userid } = req.query;
  db2.query('select count(*) from budget where userid=? AND delete_time is NULL  GROUP BY time', { userid }, res, function (results, fields,) {
    db3.query('select count(*) as count from budget where delete_time is NULL AND  userid=' + userid, {}, res, function (results2, fields2,) {
      res.send({ status: 1, msg: '', data: { day: results.length, times: results2[0].count } })
    })

  }, true)

})

module.exports = router;

