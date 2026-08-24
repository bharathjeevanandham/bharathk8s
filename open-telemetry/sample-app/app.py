from flask import Flask
import time
import os

from opentelemetry import trace
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter

from opentelemetry.instrumentation.flask import FlaskInstrumentor


resource = Resource.create({
    "service.name": "sample-python-app",
    "service.version": "1.0.0",
    "deployment.environment": "homelab",
})

provider = TracerProvider(resource=resource)

otlp_exporter = OTLPSpanExporter(
    endpoint="otel-collector.observability.svc.cluster.local:4317",
    insecure=True,
)

processor = BatchSpanProcessor(otlp_exporter)

provider.add_span_processor(processor)

trace.set_tracer_provider(provider)

app = Flask(__name__)

FlaskInstrumentor().instrument_app(app)

tracer = trace.get_tracer(__name__)


@app.route("/")
def home():
    return "OpenTelemetry Homelab App\n"


@app.route("/hello")
def hello():
    with tracer.start_as_current_span("hello-business-operation"):
        return "Hello from OpenTelemetry!\n"


@app.route("/slow")
def slow():
    with tracer.start_as_current_span("slow-operation"):
        time.sleep(2)

    return "Slow request completed\n"


@app.route("/error")
def error():
    with tracer.start_as_current_span("error-operation") as span:
        span.set_attribute("demo.error", True)
        span.record_exception(Exception("Intentional demo error"))

    return "Intentional error generated\n", 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
