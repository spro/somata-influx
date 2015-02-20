somata = require 'somata'
Influx = require 'influx'

influx = new Influx
    host: process.env.INFLUX_HOST || 'localhost'
    database: process.env.INFLUX_DB || 'main'

flatten = (_o, o={}, n=[]) ->
    for _k, _v of _o
        if typeof _v == 'object'
            flatten(_v, o, n.concat(_k))
        else
            o[n.concat(_k).join('.')] = _v
    o

new somata.Service 'influx',
    log: (type, data, cb) ->
        point = flatten data
        influx.writePoint type, point
        cb null, 'ok'

