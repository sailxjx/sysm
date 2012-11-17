#!/usr/bin/env coffee
# init project publish configs in redis
redis = require 'redis'
db = require "../lib/db"

# 项目
projects =
    fun:
        pname: 'fun'
        vcs: 'svn'
        url: 'svn://192.168.0.178/fun'
        dir: '/usr/local/webdata/fun'
    passport:
        pname: 'passport'
        vcs: 'svn'
        url: 'svn://192.168.0.178/passport'
        dir: '/usr/local/webdata/passport'
    sysd:
        pname: 'sysd'
        vcs: 'git'
        url: 'git@192.168.100.54:sysd.git'
        dir: '/usr/local/webdata/sysd'

# 研发, 外测1, 外测2, 预发布, 生产, rbac, passport
targets =
    dev:
        name: '研发'
        ssh:
            '192.168.100.60': [22]
            'tristan@192.168.1.109': [22]
        gbr: null
        sbr: null
    alpha1:
        name: '外测1'
        ssh:
            '116.213.143.3': [15222]
        gbr: 'beta'
        sbr: 'trunk'
    alpha2:
        name: '外测2'
        ssh: 
            '116.213.143.3': [22222]
        gbr: 'beta'
        sbr: 'trunk'
    beta:
        name: '预发布'
        ssh: 
            '116.213.143.3': [15122, 15522, 15322, 15422, 15622, 15722]
        gbr: 'product'
        sbr: 'release'
    product:
        name: '生产'
        ssh: 
            '116.213.143.3': [15122, 15522, 15322, 15422, 15622, 15722]
        gbr: 'product'
        sbr: 'release'
    rbac:
        name: 'rbac'
        ssh:
            '116.213.143.3': [15922]
        gbr: 'product'
        sbr: 'release'
    passport:
        name: 'passport'
        ssh:
            '116.213.143.3': [19222, 19322, 19422, 19522]
        gbr: 'product'
        sbr: 'release'

console.log 'begin';
console.log projects
console.log targets
rc = db.loadRedis 'redisPub'
rm = rc.multi()
for pname of projects
    rm.hset 'publish:projects', pname, JSON.stringify projects[pname]
for tar of targets
    rm.hset 'publish:targets', tar, JSON.stringify targets[tar]
rm.exec (err, reply)->
    console.log err
    console.log 'finish'
    rc.quit()
