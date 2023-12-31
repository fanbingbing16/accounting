const db = require('./db.config')
const mysql = require('mysql')

module.exports = {
  query: function (sql, data, res, callback, hasUser, notConn) {
    //每次使用的时候需要创建链接，数据操作完成之后要关闭连接
    const connection = mysql.createConnection(db)
    connection.connect(function (err) {
      if (err) {
        console.log( 'err', err)

        res?.status(500).send('服务器错误');

      }
      //开始数据操作
      if (hasUser) {
        connection.query('select * from user where id = ? and  delete_time is NULL', [data.userid], function (err, results, fields) {
          if (err || results.length === 0) {
            console.log('errxxxxxxxxxxxx', err,data.userid)
            res?.status(404).send({ status: 0, msg: err || '用户不存在', data: null });
            return
          } else if (results.length > 0) {
            if (!notConn)
              conn(connection, sql, data, callback, res)
            else {
              callback &&
                callback(
                  JSON.parse(JSON.stringify(results)),
                  JSON.parse(JSON.stringify(fields || {}))
                )
            }
          }
        })
      } else {
        if (!notConn)
          conn(connection, sql, data, callback, res)
          else {
            callback &&
              callback(
                JSON.parse(JSON.stringify({})),
                JSON.parse(JSON.stringify( {}))
              )
          }
      }


    })
  },
}
function conn(connection, sql, data, callback, res) {
  const arr = []
  for (let key in data) {
    if (data[key])
      arr.push(data[key])
  }
  connection.query(sql, arr, function (err, results2, fields2) {
    if (err) {
      console.log( 'errxxxxxxxxxxxx34', err)
      res?.status(404).send({ status: 0, msg: err, data: null })

    } else {
      //将查询出来的数据返回给回调函数
      callback &&
        callback(
          JSON.parse(JSON.stringify(results2)),
          JSON.parse(JSON.stringify(fields2 || {}))
        )
      //停止链接数据库，必须在查询语句后，要不然一调用这个方法，就直接停止链接，数据操作就会失败
    }

    
  })
  connection.end(function (err) {
      if (err) {
        console.log('关闭数据库连接失败！')
        res?.status(404).send({ status: 0, msg: '关闭数据库连接失败！', data: null })

        // res?.status(500).send('关闭数据库连接失败！');

      }
    })
}