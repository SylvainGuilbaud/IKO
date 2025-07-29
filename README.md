# IKO
The InterSystems Kubernetes Operator (IKO) is a Kubernetes Operator designed to automate the deployment, management, and operation of InterSystems IRIS data platform instances within Kubernetes clusters.

## Goal
The primary goal of IKO is to simplify and standardize the lifecycle management of InterSystems IRIS deployments, including provisioning, scaling, upgrades, backups, and failover, by leveraging Kubernetes-native constructs.

## Features
- Declarative management of IRIS clusters using Kubernetes Custom Resource Definitions (CRDs)
- Automated provisioning and configuration of IRIS instances
- Support for high availability, sharding, and backup/restore operations
- Integration with Kubernetes secrets and persistent storage
- Monitoring and health checks for managed IRIS resources

## Sample Usage (from `iko-3.8.42.100` directory)
In this example, the IKO will create and manage a three-node IRIS cluster, using the specified image, license, and configuration.

Example: Deploying an IRIS instance using a custom resource:

```yaml
apiVersion: iris.intersystems.com/v1alpha1
kind: IrisCluster
metadata:
    name: sample-iris
spec:
    licenseSecret: iris-license
    configSource:
        configMapRef: iris-config
    storageDB:
        accessModes: [ "ReadWriteOnce" ]
        resources:
            requests:
                storage: 10Gi
    image: containers.intersystems.com/intersystems/iris:2023.1
    replicas: 3
```

For more samples and advanced configurations, refer to the `iko-3.8.42.100/samples` directory.
## Samples

Explore more configuration examples in the [samples directory](iko-3.8.42.100/samples).