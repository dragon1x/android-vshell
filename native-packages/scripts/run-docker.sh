#!/bin/sh
set -e -u

REPOROOT=$(dirname "$(readlink -f "${0}")")/../

VSHELL_BUILDENV_USER="builder"
VSHELL_BUILDENV_HOME="/home/builder"
: "${VSHELL_BUILDENV_IMAGE_NAME:="xeffyr/native-packages-buildenv"}"
: "${VSHELL_BUILDENV_CONTAINER_NAME:="vshell-buildenv"}"
: "${VSHELL_BUILDENV_RUN_WITH_SUDO:=false}"

if [ "${VSHELL_BUILDENV_RUN_WITH_SUDO}" = "true" ]; then
	SUDO="sudo"
else
	SUDO=
fi

if [ "${GITHUB_EVENT_PATH-x}" != "x" ]; then
	# On CI/CD tty may not be available.
	DOCKER_TTY=""
else
	DOCKER_TTY="--tty"
fi

echo "Running container '${VSHELL_BUILDENV_CONTAINER_NAME}' from image '${VSHELL_BUILDENV_IMAGE_NAME}'..."

$SUDO docker start "${VSHELL_BUILDENV_CONTAINER_NAME}" > /dev/null 2> /dev/null || {
	echo "Creating new container..."

	$SUDO docker run --detach --tty \
		--name "${VSHELL_BUILDENV_CONTAINER_NAME}" \
		--volume "${REPOROOT}:${VSHELL_BUILDENV_HOME}/native-packages" \
		"${VSHELL_BUILDENV_IMAGE_NAME}"

	if [ "$(id -u)" -ne 1000 ] && [ "$(id -u)" -ne 0 ]; then
		echo "Changed builder uid/gid... (this may take a while)"
		$SUDO docker exec ${DOCKER_TTY} "${VSHELL_BUILDENV_CONTAINER_NAME}" \
			sudo chown -Rh "$(id -u):$(id -g)" /data "${VSHELL_BUILDENV_HOME}"
		$SUDO docker exec ${DOCKER_TTY} "${VSHELL_BUILDENV_CONTAINER_NAME}" \
			sudo usermod -u "$(id -u)" "${VSHELL_BUILDENV_USER}"
		$SUDO docker exec ${DOCKER_TTY} "${VSHELL_BUILDENV_CONTAINER_NAME}" \
			sudo groupmod -g "$(id -g)" "${VSHELL_BUILDENV_USER}"
	fi
}

if [ "$#" -eq  "0" ]; then
	$SUDO docker exec --interactive ${DOCKER_TTY} \
		--user "${VSHELL_BUILDENV_USER}" \
		"${VSHELL_BUILDENV_CONTAINER_NAME}" /bin/bash
else
	$SUDO docker exec --interactive ${DOCKER_TTY} \
		--user "${VSHELL_BUILDENV_USER}" \
		"${VSHELL_BUILDENV_CONTAINER_NAME}" "${@}"
fi
