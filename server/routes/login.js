var express = require('express');
var router = express.Router();
const db = require('../conf/db');
const db2 = require('../conf/postRefe')
const getId = require('../public/typescript/getId.ts');
const transformDate = require('../public/typescript/transormDate.ts')
/* GET users listing. */

router.get('/', (req, res) => {
  db.query('select * from user where  delete_time is NULL and username=? and password=?', [req.query.username, req.query.password], res, function (results, fields,) {
    // 以json的形式返回
    res.json({
      status: 1,
      message: '',
      results
    })
  })

})

router.post('/', (req, res) => {
  db.query('select * from user where  delete_time is NULL and username=? and password=?', [req.body.username, req.body.password], res, function (results, fields,) {
    if (results.length > 0) {
      // 以json的形式返回
      res.json({
        status: 1,
        message: '',
        results
      })
    } else {
      const id = getId()
      db.query('insert into user(id,username,password,update_time) values(?,?,?,?)', [id, req.body.username, req.body.password, new Date()], res, function (results2, fields) {
        db.query('select * from base_category', [], res, function (results3) {
          let sql = 'insert into category(icon,type,name,sort,update_time,userid) values '
          results3.map((item, index, arr) => {
            sql += `( '', '${item.type}', '${item.name}', 0, '${transformDate(new Date())}', ${id})`
            if (index < arr.length - 1) {
              sql += ','
            }
            console.log(sql,'sql')
          })
          sql += ' ON DUPLICATE KEY UPDATE id=VALUES(id), icon=VALUES(icon), type=VALUES(type),name=VALUES(name), sort=VALUES(sort), update_time=VALUES(update_time), userid=VALUES(userid)'
          db.query(sql, [], res, function () {
            res.json({
              status: 1,
              message: '',
              results: [{ id, username: req.body.username }]
            })
          })
        })

      })
    }

  })

})

router.post('/edit', (req, res) => {
  db2.query(`update user set username=?${req.body.avter?',avter=?':''} where id=?`, { username: req.body.username, avter: req.body.avter, userid: req.body.userid }, res, function (results) {
    res.json({
      status: 1,
      message: '修改成功',
      results: [{ id:req.body.userid, username: req.body.username,avter:req.body.avter }]
    })
  }, true)


})

module.exports = router;
