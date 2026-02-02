FROM jupyter/base-notebook:latest

USER root

# 1. Install OpenJDK 21 (Essential for Module 4 Virtual Threads)
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk wget && \
    apt-get clean

# 2. Download and Install Rapaio Jupyter Kernel (v3.0.1)
# We use the -auto flag to handle the installation without user input
RUN wget https://github.com/padreati/rapaio-jupyter-kernel/releases/download/v3.0.1/rapaio-jupyter-kernel-3.0.1.jar && \
    java -jar rapaio-jupyter-kernel-3.0.1.jar -i -auto && \
    rm rapaio-jupyter-kernel-3.0.1.jar

# 3. Fix Permissions (Crucial for Binder)
# This ensures the 'jovyan' user (Binder's default) can execute the Java kernel
RUN chown -R ${NB_USER} /home/jovyan && \
    chmod -R 755 /usr/local/share/jupyter/kernels/java

USER ${NB_USER}

# Copy repository files
COPY . ${HOME}
