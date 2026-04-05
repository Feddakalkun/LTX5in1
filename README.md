# LTX5in1 — ComfyUI on RunPod

A ready-to-launch RunPod setup for the **LTX-2.3 5-in-1** ComfyUI workflow.

The workflow covers:
- LTX-2.3 22B text-to-video & image-to-video (with IC-LoRA)
- Distilled-LoRA fast mode
- Lotus depth conditioning
- FLUX.2-Klein-9B image generation
- Audio VAE encode/decode
- HuggingFace model auto-download (no manual model setup needed)

---

## Prerequisites

| Tool | Notes |
|---|---|
| [Docker](https://docs.docker.com/get-docker/) | Only needed if you build the custom image yourself |
| [RunPod account](https://runpod.io) | Free sign-up |
| Docker Hub account | Only needed if you push your own image |

---

## Option A — Use a pre-built image (fastest)

> If you want to skip the Docker build entirely, deploy directly from
> `ghcr.io/feddakalkun/ltx5in1-comfyui` once it has been pushed there,
> or follow Option B to build and push your own copy.

---

## Option B — Build & push your own Docker image

```bash
# Clone this repo
git clone https://github.com/Feddakalkun/LTX5in1.git
cd LTX5in1

# Build the image (takes ~10-20 min depending on network speed)
docker build -t <dockerhub-username>/ltx5in1-comfyui:latest .

# Push to Docker Hub
docker push <dockerhub-username>/ltx5in1-comfyui:latest
```

---

## Deploy on RunPod

### 1. Create a new Pod

1. Go to **Pods → Deploy** in the RunPod dashboard.
2. Select a GPU with at least **24 GB VRAM** (RTX 3090, 4090, A100, etc.).
   - The 22B model in fp8 fits comfortably on 24 GB.

### 2. Configure the template

| Field | Value |
|---|---|
| **Container Image** | `<dockerhub-username>/ltx5in1-comfyui:latest` (or the pre-built image) |
| **Container Start Command** | *(leave blank — `start.sh` is the default CMD)* |
| **Expose HTTP Ports** | `8188` |
| **Volume Mount Path** | `/workspace` *(optional but recommended for persistent storage)* |

### 3. Environment variables (optional)

| Variable | Default | Purpose |
|---|---|---|
| `WORKSPACE` | `/workspace` | Where ComfyUI is installed at runtime |

### 4. Launch & connect

1. Click **Deploy**.
2. Wait for the pod to reach **Running** state (first boot installs/updates custom nodes — ~3-5 min).
3. Open the **Connect** menu → **HTTP Service → 8188** to open ComfyUI in your browser.

### 5. Load the workflow

The workflow is automatically placed at:
```
/workspace/ComfyUI/user/default/workflows/LTX-23-5in1.JSON
```

In ComfyUI: **Load → LTX-23-5in1** (it will appear in the workflow browser).

### 6. Download models

The workflow includes two **HuggingFaceDownloader** nodes that pull all
required models automatically on first run:

**LTX-2.3 models:**
- `diffusion_models/ltx-2.3-22b-dev_transformer_only_fp8_scaled.safetensors`
- `text_encoders/ltx-2.3_text_projection_bf16.safetensors`
- `text_encoders/gemma_3_12B_it.safetensors`
- `vae/LTX23_video_vae_bf16.safetensors`
- `vae/LTX23_audio_vae_bf16.safetensors`
- `loras/ltx-2.3-22b-distilled-lora-384.safetensors`
- `loras/ltx-2.3-22b-ic-lora-union-control-ref0.5.safetensors`
- `unet/lotus-depth-g-v2-0-disparity.safetensors`
- `vae/vae-ft-mse-840000-ema-pruned.safetensors`

**FLUX.2-Klein-9B models:**
- `diffusion_models/flux-2-klein-9b-fp8.safetensors`
- `text_encoders/qwen_3_8b_fp8mixed.safetensors`
- `vae/flux2-vae.safetensors`

Just queue the HuggingFaceDownloader nodes and they will download everything
into the correct ComfyUI model folders automatically.

---

## Repo structure

```
LTX5in1/
├── LTX-23-5in1.JSON    # ComfyUI workflow
├── Dockerfile           # Custom RunPod image definition
├── start.sh             # Pod startup script
├── install_nodes.sh     # Build-time custom node installer
└── README.md            # This file
```

---

## Custom nodes included

| Package | Provides |
|---|---|
| [ComfyUI-Studio-nodes](https://github.com/comfyuistudio/ComfyUI-Studio-nodes) | `HuggingFaceDownloader`, `AspectRatioImageSize` |
| [ComfyUI-LTXVideo](https://github.com/Lightricks/ComfyUI-LTXVideo) | LTX Video samplers & conditioning nodes |
| [ComfyUI-Lotus](https://github.com/logtd/ComfyUI-Lotus) | Lotus depth estimation |
| [ComfyMath](https://github.com/evanspearman/ComfyMath) | Math utility nodes |
| [ComfyUI-Custom-Scripts](https://github.com/pythongosssss/ComfyUI-Custom-Scripts) | `MathExpression` and UI helpers |
| [ComfyUI-Easy-Use](https://github.com/yolain/ComfyUI-Easy-Use) | `easy int`, `easy mathInt`, `easy showAnything` |
| [ComfyUI-Image-Selector](https://github.com/SLAPaper/ComfyUI-Image-Selector) | `ImageSelector` |
| [ComfyUI-KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | `ImageResizeKJv2`, `FloatConstant`, `VAELoaderKJ` |
| [ComfyUi-Styles-Csv-Loader](https://github.com/wolfden/ComfyUi-Styles-Csv-Loader) | `Load Styles CSV` |
| [ComfyUI-VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | `VHS_LoadVideo`, `VHS_VideoCombine`, `VHS_LoadAudioUpload` |
| [comfyui_controlnet_aux](https://github.com/Fannovel16/comfyui_controlnet_aux) | `CannyEdgePreprocessor`, `DWPreprocessor` |
| [ComfyUI_essentials](https://github.com/cubiq/ComfyUI_essentials) | `GetImageSize+`, `SimpleMath+` |
| [ComfyUI_LayerStyle](https://github.com/chflame163/ComfyUI_LayerStyle) | `LayerUtility: PurgeVRAM` |
| [rgthree-comfy](https://github.com/rgthree/rgthree-comfy) | `Power Lora Loader`, `Fast Groups Muter`, `Label` |
| [was-node-suite-comfyui](https://github.com/WASasquatch/was-node-suite-comfyui) | `Text Concatenate` |

---

## Troubleshooting

**ComfyUI shows red "missing node" errors**  
Run the two HuggingFaceDownloader nodes first so the workflow can resolve
all file-backed nodes, then refresh the page.

**CUDA out of memory**  
Use a larger GPU tier (A100 40 GB or H100) or enable tiled VAE decoding
via the `VAEDecodeTiled` node already present in the workflow.

**start.sh re-clones on every boot**  
Mount a RunPod network volume at `/workspace` — the script detects an
existing clone and only does a `git pull` instead.
