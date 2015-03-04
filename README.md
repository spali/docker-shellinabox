# docker-shellinabox

Docker container serving [shellinabox](https://code.google.com/p/shellinabox/) a Web based AJAX terminal emulator.
It could be primarly used to have access to a docker host and its container to manage them.

Be aware that using such an container on a prodution host could have a security risk impact on your docker host and containers.

## How To
You can take control of the predefined configuration with the follwing environment variables which could be provided to the container.

If you want to define your own services, fork this repo and add them to the [shellinabox_services](shellinabox_services).
The scripts of the container do the rest of the work and also parse the new variable names.

###Services

#####SHELLINABOX_SERVICE_HOST
enables and defines the url path where docker host service is available.

#####SHELLINABOX_SERVICE_LOCAL
enables and defines the url path where local container service is available.

#####SHELLINABOX_SERVICE_WHO
enables and defines the url path where "who" service is available.

###Misc. confiugrations

#####SHELLINABOX_USER
if this is set, an user is automatically created.

#####SHELLINABOX_PASSWORD
you should set this to your password for the user. if you define a user but omit the password, the default linux behaviour of a login deny occur.

#####SHELLINABOX_ALLOW_SUDO
set this variable to anything non empty to automatically add the user defined by SHELLINABOX_USER to the sudo group which can switch to root.
Use this with caution, most won't need this, because they access any way to some other container or host. But it can be useful for example to install utilities in the container.

#####SHELLINABOX_INSTALL_PKGS
set this variable to a comma delimited list of debian package names to be installed at first start of the container. Useful to install some basic tools like vi etc. in container to provide it to the users in the local service.

#####SHELLINABOX_DEFAULT
set the default service to be used. This service will be available at the root of the web server. Set this to the same value as one of the service environment variables above.

#####SHELLINABOX_DISABLE_SSL
disables ssl on the shellinabox service. Useful if you anyway put this container behind a proxy.

### Examples

Dummy shell in a box to test if it works, but without a real service defined.
```
docker run -d --name shellinabox -p 4200:4200 -e SHELLINABOX_DISABLE_SSL=1 spali/shellinabox
```
#####Full example
This example contains all possible options you can define. It starts a container without ssl, and all predefined services (accesing docker host, accessing container itself and a who is connected implementation).
```
docker run -d --name shellinabox -p 4200:4200 -e SHELLINABOX_SERVICE_HOST=host -e SHELLINABOX_SERVICE_WHO=who -e SHELLINABOX_SERVICE_LOCAL=local -e SHELLINABOX_ALLOW_SUDO=1 -e SHELLINABOX_USER=myuser -e SHELLINABOX_PASSWORD=mypassword -e SHELLINABOX_DISABLE_SSL=1 SHELLINABOX_DEFAULT=host spali/shellinabox
```

