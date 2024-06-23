# ComfyUI on CUDA base image w/ useful custom nodes

### To run:
(CTRL-C to exit)
```sh
docker run --gpus=all -p 8188:8188 -v /MODELS/models:/app/models --name comfyui ghcr.io/gsfjohnson/comfyui-docker:cuda
```

### Restart, after initial run:
(CTRL-C to exit)
```sh
docker start -ia comfy
```

### Build and run locally:

```sh
docker build . --tag comfyui
docker run --gpus=all -p 8188:8188 -v /MODELS/models:/app/models --name comfyui comfyui
```
