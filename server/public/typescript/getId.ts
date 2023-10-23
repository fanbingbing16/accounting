
function getId() {
  const date = Math.floor(new Date().getTime() )
  return Math.floor(Math.random() * 10 + 1) * date * Math.floor(Math.random() * 10 + 1)+Math.floor(Math.random()*70)
}
module.exports = getId