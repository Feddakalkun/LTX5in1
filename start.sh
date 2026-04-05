#!/bin/bash
set -e

# ─────────────────────────────────────────────
# LTX5in1 – RunPod startup script
# Installs ComfyUI + all required custom nodes,
# copies the workflow, then launches ComfyUI.
# ─────────────────────────────────────────────

WORKSPACE="${WORKSPACE:-/workspace}"
COMFYUI_DIR="$WORKSPACE/ComfyUI"
CUSTOM_NODES_DIR="$COMFYUI_DIR/custom_nodes"
WORKFLOW_SRC="/app/LTX-23-5in1.JSON"
WORKFLOW_DST="$COMFYUI_DIR/user/default/workflows/LTX-23-5in1.JSON"

echo "==> [1/4] Setting up ComfyUI in $COMFYUI_DIR"

if [ ! -d "$COMFYUI_DIR/.git" ]; then
    git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git "$COMFYUI_DIR"
else
    echo "    ComfyUI already cloned – pulling latest…"
    git -C "$COMFYUI_DIR" pull --ff-only
fi

pip install --quiet --no-cache-dir -r "$COMFYUI_DIR/requirements.txt"

# ─── helper ──────────────────────────────────
install_node() {
    local url="$1"
    local name="$2"
    local dest="$CUSTOM_NODES_DIR/$name"

    if [ ! -d "$dest/.git" ]; then
        echo "    Cloning $name…"
        git clone --depth 1 "$url" "$dest"
    else
        echo "    Updating $name…"
        git -C "$dest" pull --ff-only
    fi

    if [ -f "$dest/requirements.txt" ]; then
        pip install --quiet --no-cache-dir -r "$dest/requirements.txt"
    fi
}
# ─────────────────────────────────────────────

echo "==> [2/4] Installing custom nodes"

mkdir -p "$CUSTOM_NODES_DIR"

# ComfyUI Studio nodes (HuggingFaceDownloader + AspectRatioImageSize)
install_node "https://github.com/comfyuistudio/ComfyUI-Studio-nodes" "ComfyUI-Studio-nodes"

# LTX Video nodes
install_node "https://github.com/Lightricks/ComfyUI-LTXVideo" "ComfyUI-LTXVideo"

# Lotus depth estimation nodes
install_node "https://github.com/logtd/ComfyUI-Lotus" "ComfyUI-Lotus"

# Math nodes
install_node "https://github.com/evanspearman/ComfyMath" "ComfyMath"

# Custom scripts (pysssss)
install_node "https://github.com/pythongosssss/ComfyUI-Custom-Scripts" "ComfyUI-Custom-Scripts"

# Easy-use utilities
install_node "https://github.com/yolain/ComfyUI-Easy-Use" "ComfyUI-Easy-Use"

# Image selector
install_node "https://github.com/SLAPaper/ComfyUI-Image-Selector" "ComfyUI-Image-Selector"

# KJNodes
install_node "https://github.com/kijai/ComfyUI-KJNodes" "ComfyUI-KJNodes"

# Styles CSV loader
install_node "https://github.com/wolfden/ComfyUi-Styles-Csv-Loader" "ComfyUi-Styles-Csv-Loader"

# Video Helper Suite (VHS)
install_node "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite" "ComfyUI-VideoHelperSuite"

# ControlNet Auxiliary preprocessors (Canny, DWPose …)
install_node "https://github.com/Fannovel16/comfyui_controlnet_aux" "comfyui_controlnet_aux"

# Essentials
install_node "https://github.com/cubiq/ComfyUI_essentials" "ComfyUI_essentials"

# LayerStyle (PurgeVRAM)
install_node "https://github.com/chflame163/ComfyUI_LayerStyle" "ComfyUI_LayerStyle"

# rgthree nodes (Power Lora Loader, Fast Groups Muter, Label …)
install_node "https://github.com/rgthree/rgthree-comfy" "rgthree-comfy"

# WAS node suite (Text Concatenate …)
install_node "https://github.com/WASasquatch/was-node-suite-comfyui" "was-node-suite-comfyui"

echo "==> [3/4] Copying workflow"

mkdir -p "$(dirname "$WORKFLOW_DST")"
cp "$WORKFLOW_SRC" "$WORKFLOW_DST"
echo "    Workflow saved to $WORKFLOW_DST"

echo "==> [4/4] Starting ComfyUI on port 8188"

cd "$COMFYUI_DIR"
exec python main.py \
    --listen 0.0.0.0 \
    --port 8188 \
    --enable-cors-header \
    --preview-method auto
