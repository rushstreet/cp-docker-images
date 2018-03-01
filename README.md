Docker Images for Confluent Plaform
===

Docker images for deploying and running the Confluent Platform.  The images are currently available on [DockerHub](https://hub.docker.com/u/confluentinc/).  They are currently only available for Confluent Platform 3.0.1 and after.

Full documentation for using the images can be found [here](http://docs.confluent.io/current/cp-docker-images/docs/intro.html).

# Important Caveat - Images Not Tested for Docker for Mac or Windows
	
These images are not tested on Docker for Mac or Docker for Windows. These images will be updated in the near future to support these platforms. For more details on these known issues, you can refer to the following links:

* [Hostname Issue](https://forums.docker.com/t/docker-for-mac-does-not-add-docker-hostname-to-etc-hosts/8620/4)
* Host networking on Docker for Mac: [link 1](https://forums.docker.com/t/should-docker-run-net-host-work/14215), [link 2](https://forums.docker.com/t/net-host-does-not-work/17378/7), [link 3](https://forums.docker.com/t/explain-networking-known-limitations-explain-host/15205/4)

# Contribute

Start by reading our guidelines on contributing to this project found [here](http://docs.confluent.io/current/cp-docker-images/docs/contributing.html).

- Source Code: https://github.com/confluentinc/cp-docker-images
- Issue Tracker: https://github.com/confluentinc/cp-docker-images/issues


# License

The project is licensed under the Apache 2 license. For more information on the licenses for each of the individual Confluent Platform components packaged in the images, please refer to the respective [Confluent Platform documentation for each component](http://docs.confluent.io/current/platform.html).  

# Schema registry
1. Deployment
```
$ kubectl apply -f kubernetes/schema-registry/deployment.yml
```
Deploy schema registry container. This deployment uses secret that will be created in kafka connect stack. This deployment will be pending status until we deploy kafka connect.


2. Service
```
$ kubectl apply -f kubernetes/schema-registry/service.yml
```
Fixed IP address to make services talk each to each other transparently.


# Kafka Connect

1. Create secrets
```
apiVersion: v1
kind: Secret
metadata:
  name: kafka-connect-bootstrap
type: Opaque
data:
  connect-sasl-jaas-config: REPLACE_ME
  connect-producer-sasl-jaas-config: REPLACE_ME

```
Notice values that must be replaced and generate base64 for each.

```
$ export BROKER_API_KEY=XXX
$ export BROKER_API_SECRET=XXX
$ echo "org.apache.kafka.common.security.plain.PlainLoginModule required username=\"$BROKER_API_KEY\" password=\"$BROKER_API_SECRET\";" | base64
b3JnLmFwYWNoZS5rYWZrYS5jb21tb24uc2VjdXJpdHkucGxhaW4uUGxhaW5Mb2dpbk1vZHVsZSByZXF1aXJlZCB1c2VybmFtZT0iWFhYIiBwYXNzd29yZD0iWFhYIjsK
```
Set b3JnLmFwYWNoZS5rYWZrYS5jb21tb24uc2VjdXJpdHkucGxhaW4uUGxhaW5Mb2dpbk1vZHVsZSByZXF1aXJlZCB1c2VybmFtZT0iWFhYIiBwYXNzd29yZD0iWFhYIjsK for both jaas-config secrets

```
$ kubectl apply -f kubernetes/kafka-connect/secret.yml
```
Finally, create secrets.


2. Create config
```
$ kubectl apply -f kubernetes/kafka-connect/config.yml
```
This config will be used to bootstrap kafka-connect.


3. Deployment
```
$ kubectl apply -f kubernetes/kafka-connect/deployment.yml
```
This is the deployment itself (containers that runs application)


4. Service
```
$ kubectl apply -f kubernetes/kafka-connect/service.yml
```
This is the LB for talking to multiples containers.