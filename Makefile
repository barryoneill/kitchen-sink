IMAGE:=barryoneill/kitchen-sink

default-goal: build

build:
	docker build -t $(IMAGE):latest .

run: build
	docker run -it $(IMAGE):latest bash

publish: guard-VERSION build
	docker tag $(IMAGE):latest $(IMAGE):$(RELEASE)
	docker push $(IMAGE):latest
	docker push $(IMAGE):$(RELEASE)


# thank you to https://stackoverflow.com/a/7367903 for a much more flexible solution than ifndef
guard-%:
	@ if [ -z '${${*}}' ]; then \
		echo "Missing param '${*}'.  Please pass $*={whatever} to the make call"; \
		exit 1; \
	fi
