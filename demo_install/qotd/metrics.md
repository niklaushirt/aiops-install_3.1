# Service Metrics

Each service in QotD provides Prometheus compatible metrics.  The node module [`prom-client`](https://www.npmjs.com/package/prom-client/v/11.0.0) provides this functionality.  This module also provide actual node.js metrics of the underlying Node.js engine.  These metrics have been augmented with several custom metrics that are used in the process of simulating failures and anomalies.  Two of the metrics are completely simulated; cpu and memory usage.  They are represented with the metrics; `qotd_web_memory_usage_bytes`, `qotd_web_memory_limit_bytes`, `qotd_web_cpu_seconds_total`, `qotd_web_cpu_user_seconds_total` and `qotd_web_cpu_idle_seconds_total`.

The API response time metric however is an actual reflection of the time the API takes to complete. These metrics are `qotd_web_request_duration_seconds_sum` and `qotd_web_request_duration_seconds_count`. While this is a real measurement, the QotD inserts a controllable delay in the response time.  This delay is changed when executing anomalies.

Example metrics scrape:
```
# HELP qotd_web_request_duration_seconds_sum Response time in seconds of an API call that this application provides
# TYPE qotd_web_request_duration_seconds_sum counter
qotd_web_request_duration_seconds_sum 309519.7650000004

# HELP qotd_web_request_duration_seconds_count Number of API calls that contribute to this metric
# TYPE qotd_web_request_duration_seconds_count counter
qotd_web_request_duration_seconds_count 174021

# HELP qotd_web_memory_usage_bytes Current amount of memory in use (simulated)
# TYPE qotd_web_memory_usage_bytes gauge
qotd_web_memory_usage_bytes 2680585

# HELP qotd_web_memory_limit_bytes Memory limit
# TYPE qotd_web_memory_limit_bytes gauge
qotd_web_memory_limit_bytes 4718592

# HELP qotd_web_cpu_seconds_total Current sum of cpu seconds (simulated)
# TYPE qotd_web_cpu_seconds_total counter
qotd_web_cpu_seconds_total 95580

# HELP qotd_web_cpu_user_seconds_total Current sum of cpu seconds (simulated)
# TYPE qotd_web_cpu_user_seconds_total counter
qotd_web_cpu_user_seconds_total 47770.846424796815

# HELP qotd_web_cpu_idle_seconds_total Current sum of idle cpu seconds (simulated)
# TYPE qotd_web_cpu_idle_seconds_total counter
qotd_web_cpu_idle_seconds_total 47809.153575203185
```
