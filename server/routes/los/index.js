const db = require('../../conf/db')
var express = require('express');
var router = express.Router();
const getId = require('../../public/typescript/getId.ts');

router.get('/', (req, res) => {
  let sql = 'select * from logs where delete_time IS NULL'
  const query = req.query
  if (query.startTime && query.endTime) {
    sql += ` and update_time BETWEEN '${query.startTime}' and '${query.endTime}' `
  }
  if (query.name) {
    sql += ` and name like '%${query.name}%'`
  }
  if (query.content) {
    sql += ` and content like '%${query.content}%'`
  }
  if (query.type1) {
    sql += ` and type1=${query.type1}`
  }
  if (query.type2) {
    sql += ` and type2=${query.type2}`
  }
  db.query(sql, {}, res, function (result, fields) {
    res.send({ status: 1, msg: '', data: result })

  })
})
router.get('/detail', (req, res) => {
  let sql = 'select * from logs where delete_time IS NULL'
  const query = req.query
  if (!query.id) {
    res.send({ status: 0, msg: '缺少id', data: null })
    return
  }
  sql += ` and id = ${query.id}`
  db.query(sql, {}, res, function (result, fields) {
    if (result.length === 0) {
      res.send({ status: 0, msg: '没有该条记录', data: null })
      return
    }
    res.send({ status: 1, msg: '', data: result })

  })
})
router.post('/delete', (req, res) => {
  const query = req.body
  if (!query.id) {
    res.send({ status: 0, msg: '缺少id', data: null })
    return
  }
  let sql = 'update logs set delete_time=? where id=?'
  db.query('select * from user where id=111111111111 and password=' + query.password, [], res, function (result, fields) {
    if (result.length === 1) {
      db.query(sql, [new Date(), query.id], res, function (result, fields) {
        res.send({ status: 1, msg: '删除成功', data: null })

      })
    }else {
      res.send({ status: 0, msg: '操作码不正确', data: null })

    }
  })
})
router.post('/addEdit', (req, res) => {
  // const data = req.body
  let { name, content, type1, type2, id, password } = req.body;
  if (!name || !content || !type1 || !type2) {
    res.send({ status: 0, msg: '请把所有字段填写完整', data: null })
    return
  }
  db.query('select * from user where id=111111111111 and password=' + password, [], res, function (result, fields) {
    if (result.length === 1) {
      if (!id) {
        db.query('insert into logs(name,id,content,update_time,type1,type2) values(?,?,?,?,?,?)', [name, getId(), content, new Date(), type1, type2], res, function (result, fields) {
          res.send({ status: 1, msg: '新增成功', data: null })

        })
      } else {
        db.query('update logs set name=?,content=?,update_time=?,type1=?,type2=? where id=?', [name, content, new Date(), type1, type2, id], res, function (result, fields) {
          res.send({ status: 1, msg: '编辑成功', data: null })

        })
      }
    } else {
      res.send({ status: 0, msg: '操作码不正确', data: null })

    }
  })


})
module.exports = router;
