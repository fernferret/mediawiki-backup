all: container

docs:
	# Uses external dependency helm-docs
	helm-docs

VER := $(shell git describe --always --tags)

container:
	# Uses external dependency helm-docs
	docker build . -t ghcr.io/fernferret/mediawiki-backup:$(VER)

push: container
	# Uses external dependency helm-docs
	docker push ghcr.io/fernferret/mediawiki-backup:$(VER)

chart: docs
	helm package chart
	helm repo index --merge index.yaml --url https://fernferret.github.io/mediawiki-backup/ .

.PHONY: docs container push chart
