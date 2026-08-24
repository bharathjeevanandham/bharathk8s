import time
import random

from opentelemetry import trace, metrics

from opentelemetry.sdk.resources import Resource

from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter

from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.exporter.otlp.proto.http.metric_exporter import OTLPMetricExporter


# ============================================================
# Configuration
# ============================================================

OTEL_ENDPOINT = "http://localhost:4318"


# ============================================================
# Resource
# Identifies our application
# ============================================================

resource = Resource.create({
    "service.name": "homelab-python-app",
    "service.version": "1.0.0",
    "deployment.environment": "homelab"
})


# ============================================================
# TRACING
# ============================================================

trace_provider = TracerProvider(
    resource=resource
)

trace_exporter = OTLPSpanExporter(
    endpoint=f"{OTEL_ENDPOINT}/v1/traces"
)

trace_provider.add_span_processor(
    BatchSpanProcessor(trace_exporter)
)

trace.set_tracer_provider(trace_provider)

tracer = trace.get_tracer(
    "homelab-python-app"
)


# ============================================================
# METRICS
# ============================================================

metric_exporter = OTLPMetricExporter(
    endpoint=f"{OTEL_ENDPOINT}/v1/metrics"
)

metric_reader = PeriodicExportingMetricReader(
    metric_exporter,
    export_interval_millis=5000
)

meter_provider = MeterProvider(
    resource=resource,
    metric_readers=[metric_reader]
)

metrics.set_meter_provider(
    meter_provider
)

meter = metrics.get_meter(
    "homelab-python-app"
)


request_counter = meter.create_counter(
    "app_requests_total",
    description="Total number of application requests"
)


request_latency = meter.create_histogram(
    "app_request_duration_ms",
    description="Application request latency",
    unit="ms"
)


# ============================================================
# APPLICATION LOGIC
# ============================================================

def process_request(request_id):

    # Parent span
    with tracer.start_as_current_span(
        "process_request"
    ) as span:

        span.set_attribute(
            "request.id",
            request_id
        )

        span.set_attribute(
            "app.component",
            "python-demo"
        )


        # Increment metric

        request_counter.add(
            1,
            {
                "service": "homelab-python-app",
                "environment": "homelab"
            }
        )


        start = time.time()


        # ----------------------------------------------------
        # Simulate database operation
        # ----------------------------------------------------

        with tracer.start_as_current_span(
            "database_query"
        ) as db_span:

            db_span.set_attribute(
                "db.system",
                "postgresql"
            )

            db_span.set_attribute(
                "db.operation",
                "SELECT"
            )

            time.sleep(
                random.uniform(0.05, 0.2)
            )


        # ----------------------------------------------------
        # Simulate external API call
        # ----------------------------------------------------

        with tracer.start_as_current_span(
            "external_api_call"
        ) as api_span:

            api_span.set_attribute(
                "http.method",
                "GET"
            )

            api_span.set_attribute(
                "http.url",
                "https://example.com/api"
            )

            time.sleep(
                random.uniform(0.05, 0.3)
            )


        # ----------------------------------------------------
        # Calculate request duration
        # ----------------------------------------------------

        duration = (
            time.time() - start
        ) * 1000


        request_latency.record(
            duration,
            {
                "service": "homelab-python-app"
            }
        )


        span.set_attribute(
            "request.duration_ms",
            duration
        )


        print(
            f"request={request_id} "
            f"duration={duration:.2f}ms"
        )


# ============================================================
# MAIN
# ============================================================

if __name__ == "__main__":

    print(
        "Starting OpenTelemetry Python test application"
    )

    request_id = 1

    while True:

        process_request(request_id)

        request_id += 1

        time.sleep(2)
