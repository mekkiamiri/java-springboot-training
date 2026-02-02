# Use a specific version, not 'latest', for Binder stability
FROM jupyter/base-notebook:800680f4f7a2 

USER root

# 1. Install Java 21 (JDK is required for JShell)
RUN apt-get update && \
    apt-get install -y openjdk-21-jdk wget unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Install the IJava Kernel
# We download, unzip, and install it to the system-wide kernelspec
RUN wget https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip && \
    unzip ijava-1.3.0.zip && \
    python3 install.py --sys-prefix && \
    rm ijava-1.3.0.zip install.py

# 3. IMPORTANT: Fix Permissions
# Binder runs as user 'jovyan'. If the kernel files are owned by root, 
# they will be greyed out. We must fix this.
RUN chown -R ${NB_USER}:${NB_USER} /home/jovyan && \
    chmod -R 755 /usr/local/share/jupyter/kernels/java

# Switch back to the standard Binder user
USER ${NB_USER}

# Copy your notebook into the container
COPY . ${HOME}
