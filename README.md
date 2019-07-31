## Redis Desktop Manager on Windows

### Requirements:
- Install [Docker](https://docs.docker.com/docker-for-windows/install/): 
- Install [VcXsrv Windows X Server](https://sourceforge.net/projects/vcxsrv/files/latest/download)
- Run `XLaunch` and follow the wizard. Make sure `disable access control` is checked.
- Clone repo: `git clone https://github.com/nitzzzu/RedisDesktopManager.git`
- Build the docker image: `docker build -t rdm .`
- Get your IP address: `ipconfig`
- Run the container: `docker run --rm -v %cd%/data:/root/.rdm -e DISPLAY=<ipaddress>:0.0 rdm`
- Enjoy

### Run on Linux (not tested)

```
xhost +local:docker
docker run --rm -v $(pwd)/data:/root/.rdm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY rdm
```