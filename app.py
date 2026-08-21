from flask import Flask, Response, request
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time

app = Flask(__name__)

# Tracks the total number of HTTP requests handled by the application
REQUEST_COUNT = Counter(
    "app_http_requests_total",
    "Total number of HTTP requests",
    ["method", "endpoint", "status"]
)

# Tracks request processing latency in seconds
REQUEST_LATENCY = Histogram(
    "app_http_request_duration_seconds",
    "HTTP request latency in seconds",
    ["method", "endpoint"]
)


@app.before_request
def start_timer():
    request.start_time = time.time()


@app.after_request
def record_metrics(response):
    latency = time.time() - request.start_time

    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=request.path,
        status=response.status_code
    ).inc()

    REQUEST_LATENCY.labels(
        method=request.method,
        endpoint=request.path
    ).observe(latency)

    return response


@app.route("/")
def home():
    return "Hello from EKS!"


# Exposes Prometheus-formatted application metrics
@app.route("/metrics")
def metrics():
    return Response(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)