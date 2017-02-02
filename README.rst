========
DataNode
========

A python 2 container runtime for processing data science tasks and workloads. This repository builds a large (``~3.4 gb``) docker container hosting a virtual environment with a large number of data science pips installed. It is a no-ui backend processing workhorse for my https://github.com/jay-johnson/sci-pype analysis and tasks.

I use this repository as a python 2 runtime with docker-compose to mount source, data, binaries, and third party libraries into known, pre-configured locations. I also mount my AWS + ssh keys and gitconfig so I can develop from inside the container (email me if you want that compose file).

Build
=====

This repository can run in a container or by installing the virtual environment locally (it will take some time and there are a lot of dependencies).

Build the Local Virtual Environment
-----------------------------------

Here's how to run this locally inside a virtual environment:

#.  Start Setup

    ::

        datanode $ ./setup-venv.sh 
        2017-02-01 20:59:16 Creating VirtualEnv(./dn-dev)
        New python executable in ./dn-dev/bin/python
        Installing setuptools, pip, wheel...done.
        2017-02-01 20:59:17 Activating ./dn-dev/bin/activate
        2017-02-01 20:59:17 Done Activating VirtualEnv
        2017-02-01 20:59:17 Install Python 2 Pips into VirtualEnv
        Installing newest pip

        logs and lots of waiting for many minutes...

        more logs


        ---------------------------------------------------------
        Activate the new DataNode virtualenv with:

        source ./local-venv.sh
        datanode $ 

#.  Load the Virtual Environment

    ::

        datanode $ source ./local-venv.sh 
        (dn-dev) datanode$ 

Build the Docker Container
--------------------------

Here's how to build, start, and stop the Docker container:

#.  Build

    ::

        datanode $ ./build.sh

#.  Start

    ::

        datanode $ ./start.sh

#.  SSH

    ::

        datanode $ ./ssh.sh

#.  Stop 

    ::

        datanode $ ./stop.sh

Action Hooks
------------

This repository is used with a volume-based deployment methodology at runtime. To keep this generic, it allows the developer to extend the following actions to control the container's initialization events. The `start-container.sh`_ (which logs to ``/tmp/container.log``) controls how these events fire in the following order:

#.  Custom Script 

    This script runs before anything else starts inside the container and is intended for registering with services and running smoke tests prior to starting to process work off a Redis key.

    The: https://github.com/jay-johnson/datanode/blob/master/docker/custom-pre-start.sh is installed in the container to this default location:
    
    ``/opt/tools/custom-pre-start.sh`` 

    This script logs output to this file inside the container: ``/tmp/custom-pre-start.log``. This hook can be extended with your own script by mounting the script into the container and setting this environment variable: **ENV_CUSTOM_SCRIPT** as the absolute path to your script in the container.

#.  Pre-start

    The: https://github.com/jay-johnson/datanode/blob/master/docker/pre-start.sh is installed in the container to this default location:
    
    ``/opt/tools/pre-start.sh``

    This script logs output to this file inside the container: ``/tmp/pre-start.log``. This hook can be extended with your own script by mounting the script into the container and setting this environment variable: **ENV_PRESTART_SCRIPT** as the absolute path to your script in the container.

#.  Start Services

    The: https://github.com/jay-johnson/datanode/blob/master/docker/start-services.sh is installed in the container to this default location:
    
    ``/opt/tools/start-services.sh``

    This script logs output to this file inside the container: ``/tmp/start-services.log``. This hook can be extended with your own script by mounting the script into the container and setting this environment variable: **ENV_START_SCRIPT** as the absolute path to your script in the container.

#.  Post-start

    The: https://github.com/jay-johnson/datanode/blob/master/docker/start-services.sh is installed in the container to this default location:
    
    ``/opt/tools/post-start.sh``

    This script logs output to this file inside the container: ``/tmp/post-start.log``. This hook can be extended with your own script by mounting the script into the container and setting this environment variable: **ENV_POSTSTART_SCRIPT** as the absolute path to your script in the container.

.. _start-container.sh: https://github.com/jay-johnson/datanode/blob/master/docker/custom-pre-start.sh

License
=======

This repo is Apache 2.0 License: https://github.com/jay-johnson/datanode/blob/master/LICENSE

Redis - https://redis.io/topics/license

Please refer to the Conda Licenses for individual Python libraries: https://docs.continuum.io/anaconda/pkg-docs

