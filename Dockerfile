
#FROM python:3.11-slim
#FROM pytorch/pytorch:2.1.2-cuda12.1-cudnn8-runtime
FROM pytorch/pytorch:2.3.1-cuda11.8-cudnn8-runtime

SHELL ["/bin/bash", "-eux", "-o", "pipefail", "-c"]

# Install needed packages
ARG DEB_PKGS=git git-lfs rsync fonts-recommended libgl1 libgl1-mesa-glx libglib2.0-0
RUN --mount=target=/var/lib/apt/lists,type=cache \
    --mount=target=/var/cache/apt,type=cache \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends git git-lfs rsync fonts-recommended libgl1 libgl1-mesa-glx libglib2.0-0

ENV XDG_CACHE_HOME=/cache
ENV PIP_CACHE_DIR=/cache/pip
ENV HF_HOME=/cache/huggingface
ENV TRANSFORMERS_CACHE=/cache/huggingface/hub

# create cache directory. During build we will use a cache mount,
# but later this is useful for custom node installs
#RUN --mount=type=cache,target=/cache/,uid=${USER_UID},gid=${USER_GID} \
RUN	mkdir -p ${PIP_CACHE_DIR} ${HF_HOME} ${TRANSFORMERS_CACHE}

WORKDIR /app

# Install ComfyUI and custom nodes !
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /app \
  && pip install -r requirements.txt

RUN git clone https://github.com/ltdrdata/ComfyUI-Manager.git /app/custom_nodes/ComfyUI-Manager

RUN git clone https://github.com/evanspearman/ComfyMath /app/custom_nodes/ComfyMath \
  && cd /app/custom_nodes/ComfyMath \
  && pip install -r requirements.txt

RUN git clone https://github.com/crystian/ComfyUI-Crystools /app/custom_nodes/ComfyUI-Crystools \
  && cd /app/custom_nodes/ComfyUI-Crystools \
  && pip install -r requirements.txt

RUN git clone https://github.com/teward/ComfyUI-Helper-Nodes.git /app/custom_nodes/ComfyUI-Helper-Nodes \
  && cd /app/custom_nodes/ComfyUI-Helper-Nodes \
  && pip install -r requirements.txt

RUN git clone --recursive https://github.com/ssitu/ComfyUI_UltimateSDUpscale /app/custom_nodes/ComfyUI_UltimateSDUpscale

RUN git clone https://github.com/Fannovel16/comfyui_controlnet_aux /app/custom_nodes/comfyui_controlnet_aux \
  && cd /app/custom_nodes/comfyui_controlnet_aux \
  && pip install -r requirements.txt

#RUN git clone https://github.com/yuvraj108c/ComfyUI-Upscaler-Tensorrt /app/custom_nodes/ComfyUI-Upscaler-Tensorrt \
#  && cd /app/custom_nodes/ComfyUI-Upscaler-Tensorrt \
#  && pip install -r requirements.txt

RUN git clone https://github.com/marhensa/sdxl-recommended-res-calc /app/custom_nodes/sdxl-recommended-res-calc 

RUN git clone https://github.com/rgthree/rgthree-comfy.git /app/custom_nodes/rgthree-comfy

RUN git clone https://github.com/kijai/ComfyUI-SUPIR.git /app/custom_nodes/ComfyUI-SUPIR \
  && cd /app/custom_nodes/ComfyUI-SUPIR \
  && pip install -r requirements.txt

RUN git clone https://github.com/kijai/ComfyUI-KJNodes.git /app/custom_nodes/ComfyUI-KJNodes \
  && cd /app/custom_nodes/ComfyUI-KJNodes \
  && pip install -r requirements.txt

RUN git clone https://github.com/JPS-GER/ComfyUI_JPS-Nodes.git /app/custom_nodes/ComfyUI_JPS-Nodes
#  && cd /app/custom_nodes/ComfyUI_JPS-Nodes \
#  && pip install -r requirements.txt

RUN git clone https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes.git /app/custom_nodes/ComfyUI_Comfyroll_CustomNodes

RUN git clone https://github.com/Jordach/comfy-plasma.git /app/custom_nodes/comfy-plasma

#VOLUME /app/custom_nodes
VOLUME /app/models
#VOLUME /opt/conda/lib/python3.10/site-packages

# default start command
CMD python -u main.py --listen 0.0.0.0
