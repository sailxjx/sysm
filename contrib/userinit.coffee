rc = require('lib/db').loadRedis()
func = require 'lib/func'

users = [
    {
        name: 'sailxjx'
        pwd: '123456'
        role: 'admin'
        index: 'mail'
    }
    {
        name: 'dev'
        pwd: '123456'
    }
    {
        name: 'admin'
        pwd: '123456'
    }
]

console.log 'begin'
for user in users
    user.salt = func.genSalt()
    user.pwd = func.genPwd user.pwd, user.salt
    rc.hmset "user:#{user.name}", user
console.log 'finish'