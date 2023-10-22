

# Running locally

Check out this repository:

```
git clone https://github.com/cgascoig/fso-intersight-devnet
cd fso-intersight-devnet
```

Deploy the solution in FSO platform

```
fsoc solution validate --tag stable && fsoc solution push --tag stable --wait --subscribe --bump
```

Run the OpenTelemetry collector locally (these instructions assume MacOS/Arm64, for other OS/Arch choose the relevant archives from [here](https://github.com/open-telemetry/opentelemetry-collector-releases/releases/tag/v0.85.0) and adjust commands as appropriate)

```
cd example

curl -L https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.85.0/otelcol-contrib_0.85.0_darwin_arm64.tar.gz | tar xvzf - otelcol-contrib


# Start the otel collector

# Edit fso-otel-config.yaml to replace the <FSO_PLATFORM_*> placeholders with the client ID, secret and token URL for your FSO platform tenant
./otelcol-contrib --config=file:./fso-otel-config.yaml
```

Leave the OpenTelemetry collector running, in another terminal window, run the Intersight-otel agent (these instructions assume MacOS/Arm64, for other OS/Arch choose the relevant archives from [here](https://github.com/cgascoig/intersight-otel/releases/tag/v0.1.1-alpha01) and adjust commands as appropriate)

```
cd fso-intersight-devnet/example
curl -L https://github.com/cgascoig/intersight-otel/releases/download/v0.1.1-alpha01/intersight_otel-macos-arm64-v0.1.1-alpha01.zip | funzip > intersight_otel

# Start the intersight-otel agent
# replace the placeholders below with your own Intersight API key ID and secret

export intersight_otel_key_id="<INTERSIGHT_API_KEY_ID>" 
export intersight_otel_key_file="<PATH_TO_INTERSIGHT_SECRET_KEY_FILE>"
./intersight_otel -c fso_intersight_otel.toml
```
Leave the Intersight-otel agent running. 

# Running in Kubernetes

Check out this repository:

```
git clone https://github.com/cgascoig/fso-intersight-devnet
cd fso-intersight-devnet
```

Deploy the solution in FSO platform

```
fsoc solution validate --tag stable && fsoc solution push --tag stable --wait --subscribe --bump
```

```
cd example
```

First, create a new namespace for the demo:
```
$ kubectl create namespace intersight-otel
namespace/intersight-otel created
```

Add your Intersight API key as a Kubernetes secret. This assumes you have your Intersight Key ID in `/tmp/intersight.keyid.txt` and your Intersight Key in `/tmp/intersight.pem`:
```
$ kubectl -n intersight-otel create secret generic intersight-api-credentials --from-file=intersight-key-id=/tmp/intersight.keyid.txt --from-file=intersight-key=/tmp/intersight.pem
secret/intersight-api-credentials created
```

Edit fso-otel-config.yaml to replace the <FSO_PLATFORM_*> placeholders with the client ID, secret and token URL for your FSO platform tenant then create the OpenTelemetry collector config map:
```
$ kubectl -n intersight-otel create configmap otel-collector-config --from-file=otel-collector-config=fso-otel-config.yaml
configmap/otel-collector-config created
```

Finally, apply the example manifest:
```
$ kubectl -n intersight-otel apply -f k8s-all-in-one.yaml
deployment.apps/intersight-otel created
configmap/intersight-otel-config created
service/otel-collector created
```

Monitor the otel collector logs to validate what metrics are being sent to FSO:
```
$ kubectl -n intersight-otel logs intersight-otel-6d4c875648-wckr4 otel-collector -f
```