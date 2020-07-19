const Pool = require('pg').Pool
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'GoStyle',
  password: 'Pa$$w0rd',
  port: 5432,
})

const getDiscountByContent = (request, response) => {
    const content = request.params.content
  
    pool.query('SELECT "discount", "date" FROM "QrCode" WHERE "content" = $1',[content], (error, results) => {

      if (results.rowCount === 0) {
        response.status(404).send('Cette remise n\' existe pas dans notre boutique')
      }
      else{
        var date_today = new Date()
        var date_discount  = new Date(results.rows[0].date)

        if (date_today > date_discount) {
          response.status(500).send('La remise est périmée')
        }
        else{
          response.status(200).json(results.rows)
        }
      }
    })
  }

  module.exports = {
    getDiscountByContent
  }