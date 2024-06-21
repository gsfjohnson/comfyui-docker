### Build:

```sh
docker build . --tag comfy
```

### To run:
(CTRL-C to exit)
```sh
docker run --gpus=all -p 8188:8188 -v /MODELS/models:/app/models --name comfy comfy
```


### Restart, after initial run:
(CTRL-C to exit)
```sh
docker start -ia comfy
```

