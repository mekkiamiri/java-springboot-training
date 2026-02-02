FROM jupyter/base-notebook:latest

USER root

# 1. Install Java 21 (Required for modern features)
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk wget && \
    apt-get clean

# 2. Download and Install Rapaio Kernel
# We use the -auto flag to handle the installation automatically
RUN wget https://github.com/padreati/rapaio-jupyter-kernel/releases/download/v3.0.1/rapaio-jupyter-kernel-3.0.1.jar && \
    java -jar rapaio-jupyter-kernel-3.0.1.jar -i -auto && \
    rm rapaio-jupyter-kernel-3.0.1.jar

# 3. FIX THE GREY KERNEL (Crucial)
# Binder runs as user 'jovyan'. We must give jovyan ownership 
# of the kernel specification directory.
RUN chown -R ${NB_USER}:${NB_USER} /usr/local/share/jupyter/kernels/java && \
    chmod -R 755 /usr/local/share/jupyter/kernels/java

# 4. Final Setup
USER ${NB_USER}
WORKDIR ${HOME}
COPY . ${HOME}
