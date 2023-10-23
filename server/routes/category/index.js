const postRefe = require('../../conf/postRefe')
var express = require('express');
var router = express.Router();
router.get('/', (req, res) => {
  postRefe.query('select * from category where  delete_time is NULL and userid=?'+(req.query.type?' and type=?':''), {  userid:req.query.userid,type:req.query.type}, res, function (results, fields,) {

    res.send({ status: 1, msg: '查询成功', data: results })

  },true)
})
module.exports = router;
