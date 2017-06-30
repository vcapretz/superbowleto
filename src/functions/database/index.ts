import * as Umzug from 'umzug'
import * as Promise from 'bluebird'

import { getDatabase } from '../../database'

const getMigrationsPath = () => {
  if (process.env.NODE_ENV === 'production') {
    return './dist/migrations'
  }

  return './build/database/migrations'
}

export const migrate = (event, context, callback) => {
  console.log('MIGRATION STARTED XXX19')

  return Promise
    .timeout(10000)
    .then(() => {
      console.log("dentro do then")
      return getDatabase().then((database) => {
        console.log("start getDatabase")

        const umzug = new Umzug({
          storage: 'sequelize',
          storageOptions: {
            sequelize: database
          },
          migrations: {
            params: [
              database.getQueryInterface(),
              database.constructor
            ],
            path: getMigrationsPath(),
            pattern: /\.js$/
          }
        })

        console.log("before umzug.up")

        return umzug.up()
        .then(() => callback(null))
      })
    })
    .catch(err => {
      console.log(err)
      callback(err)
    })
}
