FROM jupyter/base-notebook:latest
USER root
RUN apt-get update && apt-get install -y openjdk-17-jdk
RUN wget https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip && \
    unzip ijava-1.3.0.zip && \
    python3 install.zip --sys-prefix
USER ${NB_USER}
