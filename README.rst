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

#.  Start the DataNode Container

    ::

        datanode $ ./start.sh 
        Starting new Docker Compose(./compose-local.yml)
        Creating datanode
        datanode $ 

#.  SSH into the DataNode Container

    ::

        datanode $ ./ssh.sh
        SSH-ing into Docker image(datanode)
        (venv)root:/opt/work# 

#.  Examine the DataNode Container Startup Sequence

    ::

        (venv)root:/opt/work# cat /tmp/container.log 
        2017-02-02 07:07:38 Starting Container
        Thu Feb  2 07:07:38 UTC 2017
        2017-02-02 07:07:38 
        2017-02-02 07:07:38 Activating Virtual Env
        2017-02-02 07:07:38 Starting Services
        2017-02-02 07:07:38 Starting Custom Script(/opt/tools/custom-pre-start.sh)
        2017-02-02 07:07:38 Running Custom Pre-Start
        2017-02-02 07:07:38 Done Custom Pre-Start
        2017-02-02 07:07:38 Done Custom Script(/opt/tools/custom-pre-start.sh)
        2017-02-02 07:07:38 Running PreStart(/opt/tools/pre-start.sh)
        2017-02-02 07:07:38 Running Pre-Start
        2017-02-02 07:07:38 Done Pre-Start
        2017-02-02 07:07:38 Done Running PreStart(/opt/tools/pre-start.sh)
        2017-02-02 07:07:38 Running Start(/opt/tools/start-services.sh)
        2017-02-02 07:07:38 Starting Sevices
        2017-02-02 07:07:38 Done Starting Services
        2017-02-02 07:07:38 Done Running Start(/opt/tools/start-services.sh)
        2017-02-02 07:07:38 Running PostStart(/opt/tools/post-start.sh)
        2017-02-02 07:07:38 Running Post-Start
        2017-02-02 07:07:38 Done Post-Start
        2017-02-02 07:07:38 Done Running PostStart(/opt/tools/post-start.sh)
        2017-02-02 07:07:38 Done Starting Services
        2017-02-02 07:07:38 Preventing the container from exiting
        (venv)root:/opt/work# 

#.  Checkout the Empty Images Directory

    ::

        (venv)root:/opt/work# ls data/src/
        iris.csv  spy.csv
        (venv)root:/opt/work# 

#.  Run an IRIS XGB Regression Analysis and Cache it in the Redis Labs Cloud

    ::

        (venv)root:/opt/work# ./bins/ml/demo-rl-regressor-iris.py
        Processing ML Predictions for CSV(/opt/work/data/src/iris.csv)
        Loading CSV(/opt/work/data/src/iris.csv)
        ds: 2017-02-02 08:12:13 BuildModels for TargetColumns(5)
        ds: 2017-02-02 08:12:13 BuildModels for TargetColumns(5)
        ds: 2017-02-02 08:12:13 Build Processing(0/5) Algo(SepalLength)
        ds: 2017-02-02 08:12:13 Build Processing(0/5) Algo(SepalLength)
        Build Processing(0/5) Algo(SepalLength)
        Loading CSV(/opt/work/data/src/iris.csv)
        Counting Samples from Mask
        Counting Predictions from Mask

        more logs...

        -----------------------------------------------------
        Creating Analysis Visualizations
        Plotting Feature Importance
        /venv/lib/python2.7/site-packages/matplotlib/font_manager.py:1297: UserWarning: findfont: Font family [u'sans-serif'] not found. Falling back to DejaVu Sans
        (prop.get_family(), self.defaultFamily[fontext]))
        Plotting PairPlots
        Plotting Confusion Matrices
        /venv/lib/python2.7/site-packages/matplotlib/cbook.py:136: MatplotlibDeprecationWarning: The finance module has been deprecated in mpl 2.0 and will be removed in mpl 2.2. Please use the module mpl_finance instead.
        warnings.warn(message, mplDeprecation, stacklevel=1)
        Plotting Scatters
        Plotting JointPlots
        Done Creating Analysis Visualizations
        -----------------------------------------------------

        Analysis Complete Saved Images(12)

        (venv)root:/opt/work# 

#.  Checkout the Analyzed IRIS Images

    After the analysis completes it will save the image files to this folder.

    ::

        (venv)root:/opt/work# ls /opt/work/data/src/
        featimp_IRIS_REGRESSOR.png      jointplot_IRIS_REGRESSOR_3.png  scatter_IRIS_REGRESSOR_2.png
        iris.csv                        jointplot_IRIS_REGRESSOR_4.png  scatter_IRIS_REGRESSOR_3.png
        jointplot_IRIS_REGRESSOR_0.png  pairplot_IRIS_REGRESSOR.png     scatter_IRIS_REGRESSOR_4.png
        jointplot_IRIS_REGRESSOR_1.png  scatter_IRIS_REGRESSOR_0.png    spy.csv
        jointplot_IRIS_REGRESSOR_2.png  scatter_IRIS_REGRESSOR_1.png
        (venv)root:/opt/work# 

#.  Exit the DataNode Container

    ::

        (venv)root:/opt/work# exit
        exit
        datanode $ 

#.  Stop the DataNode Container

    ::

        datanode $ ./stop.sh
        Stopping Docker image(docker.io/jayjohnson/datanode)
        Stopping datanode ... done
        Removing datanode ... done
        datanode $ 


Viewing Plots over X11
----------------------

If your system supports X11 forwarding with Docker, you can try the `plots-start.sh`_ start script that loads the `compose-x11-local.yml`_ for exposing your user's X11 session into the container. If your system does not show the image plots, it may be permissions on the host's X11 server that need to be changed with: ``xhost +``. If that still does not work, please refer to the posts I used to set this up the first time on my Fedora 24 host:

http://stackoverflow.com/questions/16296753/can-you-run-gui-apps-in-a-docker-container
http://stackoverflow.com/questions/3453188/matplotlib-display-plot-on-a-remote-machine
http://stackoverflow.com/questions/4931376/generating-matplotlib-graphs-without-a-running-x-server
http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/

#.  Start the Container for viewing Generated Plots

    ::

        datanode $ ./plots-start.sh 
        Starting new Docker Compose(./compose-x11-local.yml)
        Creating datanode
        datanode $ 

#.  SSH into the Container


    ::

        datanode $ ./ssh.sh 
        SSH-ing into Docker image(datanode)
        (venv)root:/opt/work#
    

#.  Run the IRIS XGB Regression and Review the Plots

    With X11 setup correctly, the images should look like the ones in the Sci-pype `Redis Labs Predict From Cached XGB IPython notebook`_

    ::

        (venv)root:/opt/work# ./bins/ml/demo-rl-regressor-iris.py 
        Processing ML Predictions for CSV(/opt/work/data/src/iris.csv)
        Loading CSV(/opt/work/data/src/iris.csv)
        ds: 2017-02-02 08:24:07 BuildModels for TargetColumns(5)
        ds: 2017-02-02 08:24:07 BuildModels for TargetColumns(5)
        ds: 2017-02-02 08:24:07 Build Processing(0/5) Algo(SepalLength)
        ds: 2017-02-02 08:24:07 Build Processing(0/5) Algo(SepalLength)
        Build Processing(0/5) Algo(SepalLength)
        Loading CSV(/opt/work/data/src/iris.csv)
        Counting Samples from Mask
        Counting Predictions from Mask
        Done Counting Samples(149) Predictions(150)

        more logs...

        Done Caching Models
        -----------------------------------------------------
        Creating Analysis Visualizations
        Plotting Feature Importance
        /venv/lib/python2.7/site-packages/matplotlib/font_manager.py:1297: UserWarning: findfont: Font family [u'sans-serif'] not found. Falling back to DejaVu Sans
        (prop.get_family(), self.defaultFamily[fontext]))
        Plotting PairPlots
        Plotting Confusion Matrices
        /venv/lib/python2.7/site-packages/matplotlib/cbook.py:136: MatplotlibDeprecationWarning: The finance module has been deprecated in mpl 2.0 and will be removed in mpl 2.2. Please use the module mpl_finance instead.
        warnings.warn(message, mplDeprecation, stacklevel=1)
        Plotting Scatters
        Plotting JointPlots
        Done Creating Analysis Visualizations
        -----------------------------------------------------

        Analysis Complete Saved Images(12)

        (venv)root:/opt/work# 

#.  Stop the DataNode Container

    ::

        datanode $ ./stop.sh
        Stopping Docker image(docker.io/jayjohnson/datanode)
        Stopping datanode ... done
        Removing datanode ... done
        datanode $ 

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
.. _plots-start.sh: https://github.com/jay-johnson/datanode/blob/master/plots-start.sh
.. _compose-x11-local.yml: https://github.com/jay-johnson/datanode/blob/master/compose-x11-local.yml
.. _Redis Labs Predict From Cached XGB IPython notebook: https://github.com/jay-johnson/sci-pype/blob/master/examples/ML-IRIS-Redis-Labs-Predict-From-Cached-XGB.ipynb


License
=======

This repo is Apache 2.0 License: https://github.com/jay-johnson/datanode/blob/master/LICENSE

Redis - https://redis.io/topics/license

Please refer to the Conda Licenses for individual Python libraries: https://docs.continuum.io/anaconda/pkg-docs

