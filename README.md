

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
