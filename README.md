# Prometheus Pushgateway Uploader for Minetest

Written by [rubenwardy](https://rubenwardy.com).  
License: MIT

## Settings

* `prometheus.pushgateway_url` - url including domain and port, default: `http://localhost:9091`.
* `prometheus.job_name` - job label, default: `minetest`.
* `prometheus.default_stats_interval` - interval in seconds to collect stats
     such as player numbers, default: 15.
* `prometheus.upload_interval` - interval to upload metrics, default: 15.
     Should be less or equal to `prometheus.default_stats_interval`.
* `prometheus.players_metric` - name of player metric, default: `minetest_players`.
