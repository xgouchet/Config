function docker_clean() {
    docker stop $(docker ps -aq)
    docker system prune
}
