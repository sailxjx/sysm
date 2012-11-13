#!/usr/bin/env coffee
# init project publish configs in redis
redis = require 'redis'

rConf =
    port: '6380'
    host: '127.0.0.1'

# 项目
projects =
    fun:
        vcs: 'svn'
        url: 'svn://192.168.0.178/fun'
        dir: '/usr/local/webdata/fun'
    passport:
        vcs: 'svn'
        url: 'svn://192.168.0.178/passport'
        dir: '/usr/local/webdata/passport'


# 研发, 测试, 外测1, 外测2, 预发布, 生产
targets = ['dev','test', 'alpha1', 'alpha2', 'beta', 'product']

console.log 'begin';
rc = redis.createClient rConf.port, rConf.host
rc.multi()
    .set('publish:projects', JSON.stringify(projects))
    .set('publish:targets', JSON.stringify(targets))
    .exec (err, reply)->
        console.log 'finish';
        rc.quit()