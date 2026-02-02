FROM jupyter/base-notebook:latest

USER root

# 1. Install Java 21
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk wget unzip && \
    apt-get clean

# 2. Download IJava
RUN wget https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip && \
    unzip ijava-1.3.0.zip

# 3. Install Kernel directly into the Conda environment Binder uses
# This is the "magic" line that fixes the missing kernel
RUN python3 install.py --sys-prefix --prefix=/srv/conda/envs/notebook

# 4. Cleanup
RUN rm ijava-1.3.0.zip install.py

# 5. Fix permissions for the Binder user
RUN chown -R ${NB_USER}:${NB_GROUP} /srv/conda/envs/notebook/share/jupyter/kernels/java
RUN chmod -R 755 /srv/conda/envs/notebook/share/jupyter/kernels/java

USER ${NB_USER}
WORKDIR ${HOME}
COPY . ${HOME}
