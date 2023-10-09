const dbConfig = require('./db.config');
const mysql = require('mysql')

module.exports = {
    query: function(sql, params,res, callback) {
        //每次使用的时候需要创建链接，数据操作完成之后要关闭连接
        const connection = mysql.createConnection(dbConfig)
        connection.connect(function(err) {
            if (err) {
              console.log(res,'err',err)

              res?.status(500).send('服务器错误');

            }
            //开始数据操作
            connection.query(sql, params, function(err, results, fields) {
                console.log(results,fields,'111 result fields',sql)
                if (err) {
                  console.log(res,'errxxxxxxxxxxxx',err)
                  res?.status(404).send(err);

                }else{
                   //将查询出来的数据返回给回调函数
                callback &&
                    callback(
                        JSON.parse(JSON.stringify(results)),
                        JSON.parse(JSON.stringify(fields||{}))
                    )
                    //停止链接数据库，必须在查询语句后，要不然一调用这个方法，就直接停止链接，数据操作就会失败
                }
               
                connection.end(function(err) {
                    if (err) {
                        console.log('关闭数据库连接失败！')
                        // res?.status(500).send('关闭数据库连接失败！');

                    }
                })
            })
        })
    },
}