========
DataNode
========

A python 2 container runtime for processing data science tasks and workloads. This repository builds a large (``~3.4 gb``) docker container hosting a virtual environment with a large number of data science pips installed. It is a no-ui backend processing workhorse for my https://github.com/jay-johnson/sci-pype analysis and tasks.

I use this repository as a python 2 runtime with docker-compose to mount source, data, binaries, and third party libraries into known, pre-configured locations. 

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

    After the analysis completes it will save the artifact image files to ``/opt/work/data/src/``. This directory is setup as a mounted volume from the host inside the `compose-local.yml`_ docker compose file (the machine learning artifacts are available outside the Docker container).

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

If your system supports X11 forwarding with Docker, you can try the `plots-start.sh`_ script that loads the `compose-x11-local.yml`_ for exposing your user's X11 session into the container. If your system does not show the image plots, it may be permissions on the host's X11 server that need to be changed with: ``xhost +``. If that still does not work, please refer to the posts I used to set this up the first time on my Fedora 24 host:

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

More Command Line Examples
==========================

Most of the notebooks and command line tools require running with a redis server listening on port 6000 (``<repo base dir>/dev-start.sh`` will start one). The command line versions that do not require docker or Jupyter can be found:

::
    
    <repo base dir>
    ├── bins
    │   ├── demo-running-locally.py - Simple validate env is working test
    │   ├── ml
    │   │   ├── builders - Build and Train Models then Analyze Predictions without display any plotted images (automation examples)
    │   │   │   ├── build-classifier-iris.py
    │   │   │   ├── build-regressor-iris.py
    │   │   │   ├── rl-build-regressor-iris.py
    │   │   │   └── secure-rl-build-regressor-iris.py
    │   │   ├── demo-ml-classifier-iris.py - Command line version of: ML-IRIS-Analysis-Workflow-Classification.ipynb
    │   │   ├── demo-ml-regressor-iris.py - Command line version of: ML-IRIS-Analysis-Workflow-Regression.ipynb
    │   │   ├── demo-rl-regressor-iris.py - Command line version of: ML-IRIS-Redis-Labs-Cache-XGB-Regressors.ipynb
    │   │   ├── demo-secure-ml-regressor-iris.py - Demo with a Password-Required Redis Server running locally
    │   │   ├── demo-secure-rl-regressor-iris.py - Demo with a Password-Required Redis Labs Cloud endpoint
    │   │   ├── downloaders
    │   │   │   ├── download_boston_house_prices.py
    │   │   │   └── download_iris.py - Command line tool for downloading + preparing the IRIS dataset
    │   │   ├── extractors
    │   │   │   ├── extract_and_upload_iris_classifier.py - Command line version of: ML-IRIS-Extract-Models-From-Cache.ipynb (Classifier)
    │   │   │   ├── extract_and_upload_iris_regressor.py - Command line version of: ML-IRIS-Extract-Models-From-Cache.ipynb (Regressor)
    │   │   │   ├── rl_extract_and_upload_iris_regressor.py - Command line version of:  ML-IRIS-Redis-Labs-Extract-From-Cache.ipynb
    │   │   │   └── secure_rl_extract_and_upload_iris_regressor.py - Command line version with a password for: ML-IRIS-Redis-Labs-Extract-From-Cache.ipynb 
    │   │   ├── importers
    │   │   │   ├── import_iris_classifier.py - ML-IRIS-Import-and-Cache-Models-From-S3.ipynb (Classifier)
    │   │   │   ├── import_iris_regressor.py - ML-IRIS-Import-and-Cache-Models-From-S3.ipynb (Regressor)
    │   │   │   ├── rl_import_iris_regressor.py - Command line version of: ML-IRIS-Redis-Labs-Import-From-S3.ipynb
    │   │   │   └── secure_rl_import_iris_regressor.py - Command line version with a password for: ML-IRIS-Redis-Labs-Import-From-S3.ipynb
    │   │   └── predictors
    │   │       ├── predict-from-cache-iris-classifier.py - ML-IRIS-Predict-From-Cache-for-New-Predictions-and-Analysis-Classifier.ipynb (Classifier)
    │   │       ├── predict-from-cache-iris-regressor.py - ML-IRIS-Predict-From-Cache-for-New-Predictions-and-Analysis-Regressor.ipynb (Regressor)
    │   │       ├── rl-predict-from-cache-iris-regressor.py - Command line version of: ML-IRIS-Redis-Labs-Predict-From-Cached-XGB.ipynb
    │   │       └── secure-rl-predict-from-cache-iris-regressor.py - Command line version with a password for: ML-IRIS-Redis-Labs-Predict-From-Cached-XGB.ipynb

Authenticated Redis Examples
============================

You can lock redis down with a password by setting it in the redis.conf before starting the redis server (https://redis.io/topics/security#authentication-feature). Here is how to use the machine learning API with a password-locked Redis Labs endpoint or a local one.

Environment Variables
---------------------

If you are running datanode in a docker container it will load the following env vars to ensure the redis application system's clients are setup with the password and database:

::

    # Redis Password where Empty = No Password like:
    # ENV_REDIS_PASSWORD=
    ENV_REDIS_PASSWORD=2603648a854c4f3ba7c93e8449319380
    ENV_REDIS_DB_ID=0

You can run without a password by either not defining the ``ENV_REDIS_PASSWORD`` environment variable or `making it set to an empty string`_.

.. _making it set to an empty string: https://github.com/jay-johnson/datanode/blob/f037c78ea9cd58875e7887db1a552815abf70d3d/src/connectors/redis/base_redis_application.py#L18-L21

Using a Password-locked Redis Labs Cloud endpoint
-------------------------------------------------

#.  Run the Secure Redis Labs Cloud Demo

    ::

        bins/ml$ ./demo-secure-rl-regressor-iris.py

#.  Connect to the Redis Labs Cloud endpoint

    After running it you can verify the models were stored on the secured endpoint:

    ::

        $ redis-cli -h pub-redis-12515.us-west-2-1.1.ec2.garantiadata.com -p 12515

#.  Verify the server is enforcing the password

    ::

        pub-redis-12515.us-west-2-1.1.ec2.garantiadata.com:12515> KEYS *
        (error) NOAUTH Authentication required

#.  Authenticate with the password

    ::

        pub-redis-12515.us-west-2-1.1.ec2.garantiadata.com:12515> auth 2603648a854c4f3ba7c93e8449319380
        OK

#.  View the redis keys

    ::

        pub-redis-12515.us-west-2-1.1.ec2.garantiadata.com:12515> KEYS *
        1) "_MD_IRIS_REGRESSOR_PetalWidth"
        2) "_MD_IRIS_REGRESSOR_PredictionsDF"
        3) "_MD_IRIS_REGRESSOR_SepalWidth"
        4) "_MODELS_IRIS_REGRESSOR_LATEST"
        5) "_MD_IRIS_REGRESSOR_ResultTargetValue"
        6) "_MD_IRIS_REGRESSOR_Accuracy"
        7) "_MD_IRIS_REGRESSOR_PetalLength"
        8) "_MD_IRIS_REGRESSOR_SepalLength"
        pub-redis-12515.us-west-2-1.1.ec2.garantiadata.com:12515> exit
        bins/ml$

Local
-----

#.  You can run a password-locked, standalone redis server with docker compose using this script:
        
    https://github.com/jay-johnson/datanode/blob/master/bins/redis/auth-start.sh

#.  Once the redis server is started you can run the local secure demo with the script:

    ::

        bins/ml$ ./demo-secure-ml-regressor-iris.py

#.  After the demo finishes you can authenticate with the local redis server and view the cached models:

    ::

        bins/ml$ redis-cli -p 6400
        127.0.0.1:6400> KEYS *
        (error) NOAUTH Authentication required.
        127.0.0.1:6400> AUTH 2603648a854c4f3ba7c93e8449319380
        OK
        127.0.0.1:6400> KEYS *
        1) "_MD_IRIS_REGRESSOR_PetalWidth"
        2) "_MD_IRIS_REGRESSOR_PetalLength"
        3) "_MD_IRIS_REGRESSOR_PredictionsDF"
        4) "_MD_IRIS_REGRESSOR_SepalWidth"
        5) "_MODELS_IRIS_REGRESSOR_LATEST"
        6) "_MD_IRIS_REGRESSOR_Accuracy"
        7) "_MD_IRIS_REGRESSOR_ResultTargetValue"
        8) "_MD_IRIS_REGRESSOR_SepalLength"
        127.0.0.1:6400> exit
        bins/ml$ 
    
#.  If you want to stop the redis server run:

    https://github.com/jay-johnson/datanode/blob/master/bins/redis/stop.sh

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

.. _start-container.sh: https://github.com/jay-johnson/datanode/blob/master/docker/start-container.sh
.. _plots-start.sh: https://github.com/jay-johnson/datanode/blob/master/plots-start.sh
.. _compose-local.yml: https://github.com/jay-johnson/datanode/blob/8660da719892cfe018edb0610b6d4174f4dc872b/compose-local.yml#L13
.. _compose-x11-local.yml: https://github.com/jay-johnson/datanode/blob/master/compose-x11-local.yml
.. _Redis Labs Predict From Cached XGB IPython notebook: https://github.com/jay-johnson/sci-pype/blob/master/examples/ML-IRIS-Redis-Labs-Predict-From-Cached-XGB.ipynb


License
=======

This repo is Apache 2.0 License: https://github.com/jay-johnson/datanode/blob/master/LICENSE

Redis - https://redis.io/topics/license

Please refer to the Conda Licenses for individual Python libraries: https://docs.continuum.io/anaconda/pkg-docs

