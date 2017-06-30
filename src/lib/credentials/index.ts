import { getEnv } from '../../config'

const Credstash = require('nodecredstash')

export function getDatabasePassword () {
  console.log("dentro do getDatabasePassword")
  const credstash = Credstash({
    table: 'credential-store',
    awsOpts: { region: 'us-east-1' }
  })

  if (getEnv() === 'test') {
    return Promise.resolve('touchdown1!')
  }

  return credstash.getSecret({
    name: `${process.env.STAGE}/database/password`,
    version: 1,
    context: {}
  })
    .catch(err => {
      console.log("erro no credstash", err)
    })
}
