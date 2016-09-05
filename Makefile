REPOSITORY = 165162103257.dkr.ecr.eu-west-1.amazonaws.com
IMAGE = ecs-cloudwatch-logs

ECS_CLUSTER = ci
ECS_APP_NAME = ECSCloudwatchLogs
AWS_REGION = eu-west-1
VERSION=0.1.$(GO_PIPELINE_COUNTER)

login_fragment:
	aws ecr get-login --region eu-west-1 > $@
include login_fragment

build:
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

push: build
	docker tag $(IMAGE):latest $(REPOSITORY)/$(IMAGE):latest
	docker push $(REPOSITORY)/$(IMAGE):latest
	docker rmi $(IMAGE):latest
	docker tag $(IMAGE):$(VERSION) $(REPOSITORY)/$(IMAGE):$(VERSION)
	docker push $(REPOSITORY)/$(IMAGE):$(VERSION)
	docker rmi $(IMAGE):$(VERSION)