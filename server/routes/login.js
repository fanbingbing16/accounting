var express = require('express');
var router = express.Router();
const db = require('../conf/db');
/* GET users listing. */

router.get('/', (req, res) => {
  console.log(res, 'res', 'req',req,req.query)
  db.query('select * from user where  delete_time is NULL', [], res, function (results, fields,) {

    // 以json的形式返回
    res.json({
      status: 1,
      message: '',
      response: 200,
      results
    })
  })

})
module.exports = router;
