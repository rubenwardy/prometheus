local http = minetest.request_http_api()
assert(http, "Please add 'prometheus' to secure.http_mods")

prometheus = {}

-- upload "queue"
prometheus.buffer = ""


--
-- Adds a metric datapoint to the upload buffer
--
-- Buffered metrics will then be pushed every prometheus.upload_interval seconds
--
function prometheus.post(metric, value)
	print("Queuing metric=" .. metric .. ", value=" .. value)

	prometheus.buffer = prometheus.buffer .. metric .. " " .. value .. "\n"
end


--
-- Uploads any buffered metrics
--
function prometheus.upload()
	if prometheus.buffer:trim() == "" then
		return
	end

	minetest.log("info", "Uploading metrics to prometheus")

	local version = minetest.get_version()
	local base_url = minetest.settings:get("prometheus.pushgateway_url") or "http://localhost:9091"
	local job_name = minetest.settings:get("prometheus.job_name") or "minetest"
	local request = {
		url = base_url .. "/metrics/job/" .. job_name,
		post_data = prometheus.buffer,
		user_agent = version.project .. " " ..version.string
	}

	prometheus.buffer = ""

	minetest.log("verbose", dump(request))

	http.fetch(request, function(res)
		print(dump(res))
	end)
end


local default_stats_interval = tonumber(minetest.settings:get("prometheus.default_stats_interval") or "15")
local upload_interval = tonumber(minetest.settings:get("prometheus.upload_interval") or "1")
local uptime = 0

function default_stats()
	uptime = uptime + default_stats_interval

	prometheus.post(minetest.settings:get("prometheus.players_metric") or "minetest_players",
			#minetest.get_connected_players())

	prometheus.post(minetest.settings:get("prometheus.uptime_metric") or "minetest_uptime", uptime)

	minetest.after(default_stats_interval, default_stats)
end
minetest.after(default_stats_interval, default_stats)

function upload_step()
	prometheus.upload()
	minetest.after(upload_interval, upload_step)
end
minetest.after(upload_interval, upload_step)
