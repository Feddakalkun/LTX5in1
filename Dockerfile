# ─────────────────────────────────────────────
# LTX5in1 – Custom RunPod Docker image
#
# Build:  docker build -t <youruser>/ltx5in1-comfyui .
# Push:   docker push <youruser>/ltx5in1-comfyui
# ─────────────────────────────────────────────
FROM runpod/pytorch:2.4.0-py3.11-cuda12.4.1-devel-ubuntu22.04

# Avoid interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive
ENV WORKSPACE=/workspace

# ── System dependencies ───────────────────────
RUN apt-get update -y && apt-get install -y --no-install-recommends \
        git \
        wget \
        curl \
        ffmpeg \
        libgl1 \
        libglib2.0-0 \
        libsm6 \
        libxext6 \
        libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# ── Copy repo assets into image ───────────────
WORKDIR /app
COPY LTX-23-5in1.JSON /app/LTX-23-5in1.JSON
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# ── Pre-install ComfyUI (pinned to /opt/ComfyUI so the workspace  ──
# ── volume can overlay it at runtime if desired)                  ──
RUN git clone --depth 1 https://github.com/comfyanonymous/ComfyUI.git /opt/ComfyUI \
    && pip install --no-cache-dir -r /opt/ComfyUI/requirements.txt

# ── Helper used at build time to clone + pip-install a node ──────
COPY install_nodes.sh /tmp/install_nodes.sh
RUN chmod +x /tmp/install_nodes.sh && /tmp/install_nodes.sh

# ── Expose ComfyUI port ───────────────────────
EXPOSE 8188

# ── Entry point ───────────────────────────────
# start.sh re-installs/updates to $WORKSPACE at runtime and then
# launches ComfyUI from the persistent workspace volume.
CMD ["/app/start.sh"]
