## Redis Desktop Manager on Windows

### Requirements:
- Install [Docker](https://docs.docker.com/docker-for-windows/install/): 
- Install [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/files/latest/download)
- Run `XLaunch` and follow the wizard. Make sure `disable access control` is checked.
- Build the docker image:
    ```
    docker build -t rdm . 
    ```
- Get your IP address:
    ```
    ipconfig
    ```
- Run the container:
    ```
    docker run --rm -it -v %cd%/data:/root/.rdm -e DISPLAY=<ipaddress>:0.0 rdm
    ```
- Enjoy