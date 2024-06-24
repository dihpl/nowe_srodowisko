.PHONY: build start stop sync-db

build:
	docker-compose build

start:
	docker-compose up -d

stop:
	docker-compose down

sync-db:
	./scripts/sync_db.sh
