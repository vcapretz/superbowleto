import * as Umzug from 'umzug'
import * as Promise from 'bluebird'
import { resolve } from 'path'

import { getDatabase } from '../../database'

console.log(process.cwd())

const getMigrationsPath = () => {
  if (process.env.NODE_ENV === 'production') {
    return resolve(__dirname, 'migrations')

  }

  return './build/database/migrations'
}

export const migrate = (event, context, callback) => {
  console.log('MIGRATION STARTED XXX19')

  return Promise.resolve()
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
