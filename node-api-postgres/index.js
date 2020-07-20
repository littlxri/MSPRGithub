const express = require('express')
const bodyParser = require('body-parser')
const app = express()
const port = 3000

const db = require('./queries')

app.use(bodyParser.json())
app.use(
  bodyParser.urlencoded({
    extended: true,
  })
)

app.get('/', (request, response) => {
    response.json({ info: ' ExpressNode.js,, and Postgres API' })
  })

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})

app.get('/QrCode/:content', db.getDiscountByContent)

app.use(function(err, req, res, next) {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});