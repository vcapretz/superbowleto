import Sequelize from 'sequelize'
import * as Promise from 'bluebird'
import getConfig from '../config/database'
import * as rawModels from './models'
import { getDatabasePassword } from '../lib/credentials'

const config = getConfig()

const defaults = {
  define: {
    underscored: true
  }
}

let database = null

export function getDatabase () {
  console.log("dentro do getDatabase", database)
  if (database) {
    return Promise.resolve(database)
  }

  return getDatabasePassword().then((password) => {
    console.log("after getDatabasePassword", password)
    console.log("before new Sequelize", Object.assign({}, defaults, config, { password }))

    database = new Sequelize(Object.assign({}, defaults, config, {
      password
    }))

    console.log("after new Sequelize")

    const createInstance = model => ({
      model,
      instance: model.create(database)
    })

    const associateModels = ({ model, instance }) => {
      if (model.associate) {
        model.associate(instance, database.models)
      }
    }

    Object.values(rawModels)
      .map(createInstance)
      .map(associateModels)


    console.log("before getDatabase return", database)

    return database
  })
  .catch(err => {
    console.log("Erro no getDatabasePassword()", err)
  })
}

export function getModel (modelName) {
  return getDatabase()
    .then(returnedDatabase => returnedDatabase.models[modelName])
}
