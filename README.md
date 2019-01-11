# Prometheus Pushgateway Uploader for Minetest

Written by [rubenwardy](https://rubenwardy.com).  
License: MIT

## API

* `prometheus.push(metric, value)`
    * Calls to `push` will be queued and only uploaded every `prometheus.upload_interval`.
    * `metric` is the metric name, see the [metric naming guide](https://prometheus.io/docs/instrumenting/writing_exporters/#naming) for names to choose.
    * `value` is the actual value to push, for example number of players.
* `prometheus.upload()`
    * Uploads any queued metrics.
    * Automatically called every `prometheus.upload_interval` seconds.

## Settings

* `prometheus.pushgateway_url` - url including domain and port, default: `http://localhost:9091`.
* `prometheus.job_name` - job label, default: `minetest`.
* `prometheus.default_stats_interval` - interval in seconds to collect stats
     such as player numbers, default: 15.
* `prometheus.upload_interval` - interval to upload metrics, default: 15.
     Should be less or equal to `prometheus.default_stats_interval`.
* `prometheus.players_metric` - name of player metric, default: `minetest_players`.
* `prometheus.uptime_metric` - name of uptime metric, default: `minetest_uptime`.
* `prometheus.max_lag_metric` - name of uptime metric, default: `minetest_max_lag`.
* `prometheus.start_gametime_metric` - name of uptime metric, default: `minetest_start_gametime`.
