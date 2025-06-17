# crunchy-postgres-vectorchord

Container images for [Crunchy Postgres for Kubernetes](https://access.crunchydata.com/documentation/postgres-operator) with [VectorChord](https://github.com/tensorchord/VectorChord) extension installed.

> [!IMPORTANT]
> The postgres configuration needs to be altered to enable the extension.
> You can do this by setting shared_preload_libraries in your PostgresCluster spec:
>
> ```yaml
> apiVersion: postgres-operator.crunchydata.com/v1beta1
> kind: PostgresCluster
> spec:
>   (...)
>   config:
>     parameters:
>       shared_preload_libraries: "vchord.so"
> ```
>
> Or if you're still using the operator version older than `5.8.0`:
>
> ```yaml
> apiVersion: postgres-operator.crunchydata.com/v1beta1
> kind: PostgresCluster
> spec:
>   (...)
>   patroni:
>     dynamicConfiguration:
>       postgresql:
>         parameters:
>           shared_preload_libraries: "vchord.so"
> ```

> [!IMPORTANT]
> The "VectorChord" extension is not enabled by default.
> You need to enable it and set the search path when initializing the database.
> You can configure it in your PostgresCluster spec:
>
> ```yaml
> apiVersion: v1
> kind: ConfigMap
> metadata:
>   name: enable-vchord
> data:
>   init.sql: |-
>     /c mydatabasename\\
>     CREATE EXTENSION IF NOT EXISTS vchord CASCADE;
> ---
> apiVersion: postgres-operator.crunchydata.com/v1beta1
> kind: PostgresCluster
> spec:
>   (...)
>   databaseInitSQL:
>     name: enable-vchord
>     key: init.sql
> ```

## Building

To build the Dockerfile locally, you need to pass the `CNPG_TAG` and `VECTORCHORD_TAG` args.
For example:

```sh
docker build . --build-arg="CDPG_TAG=ubi9-17.5-2520" --build-arg="VECTORCHORD_TAG=0.4.2"
```

## Thanks

I shamelessly took a lot of code from [cloudnative-vectorchord](https://github.com/tensorchord/cloudnative-vectorchord).
