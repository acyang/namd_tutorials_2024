# docker build -t namd:latest .
FROM nvcr.io/nvidia/cuda:12.5.0-runtime-ubuntu22.04

LABEL maintainer "An-Cheng Yang<acyang0903@gmail.com>"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 TZ=Asia/Taipei

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y wget unzip bzip2 ca-certificates curl git apt-utils gnupg pkg-config vim  tini && \
    curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > /tmp/conda.gpg && \
    install -o root -g root -m 644 /tmp/conda.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list && \
    apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y conda && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

ENV PATH /opt/conda/bin:$PATH

COPY NAMD_2.14_Linux-x86_64-multicore-CUDA.tar.gz NAMD_3.0_Linux-x86_64-multicore-CUDA.tar.gz /root

RUN tar -zxv -f /root/NAMD_2.14_Linux-x86_64-multicore-CUDA.tar.gz -C /opt

ENV PATH /opt/NAMD_2.14_Linux-x86_64-multicore-CUDA:$PATH

ENV LD_LIBRARY_PATH /opt/NAMD_2.14_Linux-x86_64-multicore-CUDA:$LD_LIBRARY_PATH

ENTRYPOINT ["/usr/bin/tini", "--"]