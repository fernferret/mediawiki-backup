all: container

docs:
	# Uses external dependency helm-docs
	helm-docs

container:
	# Uses external dependency helm-docs
	docker build . -t ghcr.io/fernferret/mediawiki-backup:latest

push: container
	# Uses external dependency helm-docs
	docker push ghcr.io/fernferret/mediawiki-backup:latest

chart: docs
	helm package chart
	helm repo index --merge index.yaml --url https://fernferret.github.io/mediawiki-backup/ .

.PHONY: docs container push chart
