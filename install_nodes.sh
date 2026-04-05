#!/bin/bash
# ── Build-time node installer (runs inside Dockerfile RUN) ───────
set -e

COMFYUI_DIR=/opt/ComfyUI
CUSTOM_NODES_DIR=$COMFYUI_DIR/custom_nodes
mkdir -p "$CUSTOM_NODES_DIR"

clone_node() {
    local url="$1"
    local name="$2"
    local dest="$CUSTOM_NODES_DIR/$name"
    git clone --depth 1 "$url" "$dest"
    if [ -f "$dest/requirements.txt" ]; then
        pip install --no-cache-dir -r "$dest/requirements.txt"
    fi
}

clone_node "https://github.com/comfyuistudio/ComfyUI-Studio-nodes"  "ComfyUI-Studio-nodes"
clone_node "https://github.com/Lightricks/ComfyUI-LTXVideo"          "ComfyUI-LTXVideo"
clone_node "https://github.com/logtd/ComfyUI-Lotus"                  "ComfyUI-Lotus"
clone_node "https://github.com/evanspearman/ComfyMath"               "ComfyMath"
clone_node "https://github.com/pythongosssss/ComfyUI-Custom-Scripts" "ComfyUI-Custom-Scripts"
clone_node "https://github.com/yolain/ComfyUI-Easy-Use"              "ComfyUI-Easy-Use"
clone_node "https://github.com/SLAPaper/ComfyUI-Image-Selector"      "ComfyUI-Image-Selector"
clone_node "https://github.com/kijai/ComfyUI-KJNodes"                "ComfyUI-KJNodes"
clone_node "https://github.com/wolfden/ComfyUi-Styles-Csv-Loader"    "ComfyUi-Styles-Csv-Loader"
clone_node "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite" "ComfyUI-VideoHelperSuite"
clone_node "https://github.com/Fannovel16/comfyui_controlnet_aux"    "comfyui_controlnet_aux"
clone_node "https://github.com/cubiq/ComfyUI_essentials"             "ComfyUI_essentials"
clone_node "https://github.com/chflame163/ComfyUI_LayerStyle"        "ComfyUI_LayerStyle"
clone_node "https://github.com/rgthree/rgthree-comfy"                "rgthree-comfy"
clone_node "https://github.com/WASasquatch/was-node-suite-comfyui"   "was-node-suite-comfyui"
