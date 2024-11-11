.DEFAULT_GOAL := start

generate_env:
	docker compose --env-file .env.default --profile env run --rm generateconfig-env

start: generate_env
	docker compose --profile setup up --detach --remove-orphans
	docker compose --profile initialsetup up --detach --remove-orphans
	docker compose --profile main up --detach --remove-orphans
	@echo "Done! Upload your self-hosted network configuration file ${CURDIR}/etc/client.yml into the client app"
	@echo "See: https://doc.anytype.io/anytype-docs/data-and-security/self-hosting#switching-between-networks"

stop:
	docker compose --profile setup --profile initialsetup --profile main --profile env stop

clean:
	docker system prune --all --volumes

pull:
	docker compose --profile setup --profile main --profile env pull

down:
	docker compose --profile setup --profile initialsetup --profile main --profile env down --remove-orphans
logs:
	docker compose --profile setup --profile main --profile env logs --follow

restart: down start
update: pull down start
upgrade: down start

cleanEtcStorage:
	rm -rf etc/ storage/
