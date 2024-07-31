
FROM python:3.11-slim
#FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime
#FROM pytorch/pytorch:2.3.1-cuda11.8-cudnn8-runtime

# Install needed packages
#RUN --mount=target=/var/lib/apt/lists,type=cache \
#    --mount=target=/var/cache/apt,type=cache \
#    apt update && \
#    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends git git-lfs rsync fonts-recommended libgl1 libgl1-mesa-glx libglib2.0-0

#ENV XDG_CACHE_HOME=/cache
#ENV PIP_CACHE_DIR=/cache/pip
#ENV HF_HOME=/cache/huggingface
#ENV TRANSFORMERS_CACHE=/cache/huggingface/hub
ENV COMFYUI_PATH=/app
ENV COMFYUI_MODEL_PATH=/app/models

# create cache directory. During build we will use a cache mount,
# but later this is useful for custom node installs
#RUN --mount=type=cache,target=/cache/,uid=${USER_UID},gid=${USER_GID} \
#RUN	mkdir -p ${PIP_CACHE_DIR} ${HF_HOME} ${TRANSFORMERS_CACHE}

# Install needed packages
# Remove nginx default site (create nginx site config via CMD script)
RUN --mount=target=/var/lib/apt/lists,type=cache \
 --mount=target=/var/cache/apt,type=cache \
 apt update \
 && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
  git git-lfs rsync fonts-recommended libgl1 libgl1-mesa-glx libglib2.0-0 \
  nginx apache2-utils sudo \
 && rm /etc/nginx/sites-enabled/default

# Make /app the homedir for nobody user
RUN install -v -m 0777 -o nobody -g nogroup -d /app \
 && usermod --home /app nobody \
 && mkdir -p /app/.cache/pip

# Enable nobody access to sudo without password
COPY nobody.sudoer /etc/sudoers.d/nobody

USER nobody:nogroup

# Install needed packages
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /tmp/comfy \
  && mv /tmp/comfy/* /app/ \
  && rm -rf /tmp/comfy

RUN cd /app/custom_nodes \
  && git clone https://github.com/ltdrdata/ComfyUI-Manager.git \
  && git clone https://github.com/marhensa/sdxl-recommended-res-calc \
  && git clone https://github.com/rgthree/rgthree-comfy.git \
  && git clone --recursive https://github.com/ssitu/ComfyUI_UltimateSDUpscale \
  && git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git \
  && git clone https://github.com/Jordach/comfy-plasma.git \
  && git clone https://github.com/JPS-GER/ComfyUI_JPS-Nodes.git \
  && git clone https://github.com/evanspearman/ComfyMath \
  && git clone https://github.com/crystian/ComfyUI-Crystools \
  && git clone https://github.com/teward/ComfyUI-Helper-Nodes.git \
  && git clone https://github.com/Fannovel16/comfyui_controlnet_aux \
  && git clone https://github.com/kijai/ComfyUI-SUPIR.git \
  && git clone https://github.com/kijai/ComfyUI-KJNodes.git \
  && git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack \
  && git clone https://github.com/jags111/efficiency-nodes-comfyui \
  && git clone https://github.com/sipherxyz/comfyui-art-venture \
  && git clone https://github.com/cubiq/ComfyUI_InstantID \
 && find -name .git -type d | xargs -r0 rm -rf

WORKDIR /app

#COPY nginx_reverse_proxy_comfyui.conf /etc/nginx/sites-enabled/
COPY --chmod=755 . /
#COPY --chmod=755 nginx_*.sh /usr/local/bin/

#VOLUME /app/.cache/pip
VOLUME /app/models

# default start command
SHELL ["/bin/bash", "-eux", "-o", "pipefail", "-c"]
CMD /comfyui.sh
