import { getEnv } from '../../config'

const Credstash = require('nodecredstash')

export function getDatabasePassword () {
  console.log("dentro do getDatabasePassword")
  console.log(process.env)
  const credstash = new Credstash({
    table: 'credential-store',
    awsOpts: { region: 'us-east-1' }
  })

  console.log("before getSecret")

  return credstash.getSecret({
    name: `${process.env.STAGE}/database/password`,
    version: 1,
    context: {}
  })
    .then(result => {
      console.log("after getSecret")
      console.log(result)
      return result
    })
    .catch(err => {
      console.log("erro no credstash", err)
    })
}
