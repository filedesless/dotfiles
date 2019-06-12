# RHEL 8 et Red Hat Universal Base Image

par Michael Lessard, Red Hat

## Cycle de vie

- 3 ans; version majeure
- 6 mois; version mineure
- 2 phases; support de cycle de vie

## Applications streams

différents channels, aux release asynchrones a la base

	# show application streams
	yum module list postgresql
	# install package from application stream
	yum module install postgresql:9.6
	# remove package installed from application stream
	yum module reset postgresql
	# install default app stream
	yum module install postgresql

différents logiciels consolidés dans le channel `upstream`

## nouvelle version de yum

yum est maintenant un symlink vers dnf, package manager par défault

## cockpit -> redhat web console

tool de cliqueux pour faire la gestion des serveur RHEL 8

	systemctl enable --now cockpit.service

## hybrid et multicloud

Red Hat "Access Insights", inclut dans la license RHEL 8

- identifie les problèmes potentiels
- offre un bulletin et un playbook ansible pour la résolution

## Blueprints

requires `cockpit-composer`, likely from appstream

tool de cliqueux pour faire des images de vm

## System roles

Playbooks ansible livrés par RedHat

Pour config communes genre bonding/teaming de NICs

## Containers

Nouveux outils dans RHEL 8

- Podman
- Buildah
- Skopeo

new registry; Quay

### Buildah

container image builder

	buildah from scratch
	buildah mount working-container-1
	buildah unmount
	buildah commit
	podman run
	buildah bud

### Podman

no daemon

retro-compatible with docker cli

try to enhance:

- integration with kubernetes?
- increased security?

images are isolated by user

SELinux enforcing filesystem access restriction

container can't read host's `/etc/shadow`

### Skopeo

inspection d'images a distance

image signature

publication et transfert d'image entre différents registres

	sokpeo inspect
	podman images
	docker images
	skopeo copy docker-daemon:... containers-storage:...

## tlog

tlog integré dans RHEL 8

install tlog and chsh to /usr/bin/tlog-rec-session

tool de cliqueux pour rejouer des sessions tlog dans cockpit

## nftables

remplace le frontend iptables

## images de base universelles

### minimal

ubi8/ubi-minimal

90mb

for self-contained app (golang, dotnet, etc...)

simpler, no suid, microdnf

### platform

ubi8/ubi

minimal + yum

### multi-service

ubi8/ubi-init

platform + systemd
