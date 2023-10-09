
function getId() {
  const date = Math.floor(new Date().getTime() / 10)
  return Math.floor(Math.random() * 10 + 1) * date * Math.floor(Math.random() * 10 + 1)
}
module.exports = getId