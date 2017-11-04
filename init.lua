local http = minetest.request_http_api()
assert(http, "Please add 'prometheus' to secure.http_mods")

prometheus = {}
prometheus.buffer = ""


--
-- Posts a metric to prometheus
-- Metrics may be buffered up to 1 second before sending
--
function prometheus.post(metric, value)
	print("Queuing metric=" .. metric .. ", value=" .. value)

	prometheus.buffer = prometheus.buffer .. metric .. " " .. value .. "\n"
end


--
-- Uploads any queued metrics
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

function default_stats()
	prometheus.post(minetest.settings:get("prometheus.players_metric") or "minetest_players",
			#minetest.get_connected_players())

	minetest.after(default_stats_interval, default_stats)
end
minetest.after(default_stats_interval, default_stats)

function upload_step()
	prometheus.upload()
	minetest.after(upload_interval, upload_step)
end
minetest.after(upload_interval, upload_step)
