# VS Code Dockerized Setup

## Prerequisites:
- Docker.
- Docker Compose.
- VS Code

## Install:
- Clone the repo to your local.
- In the root directory of the project, run:
    ```bash
    > docker-compose up -d
    > code .
    ```
- Once VS Code is up:
    - Click on the green button at the bottom left corrner,  and choose `Reopen in Container`
    - This will reload VS Code in the container

## Install new python dependencies:
While the container is up:
```bash
> docker exec -it -u 0 api bash
```
Then inside the container:
```bash
> pipenv install <library name> --system
```