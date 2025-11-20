# ============================================================
# Kaggle Official CPU Python Image + kaggle API + ruff
# ============================================================
FROM gcr.io/kaggle-images/python:latest

ENV DEBIAN_FRONTEND=noninteractive

# Create Kaggle-like directory structure
RUN mkdir -p /kaggle /kaggle/input /kaggle/working /kaggle/temp

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install kaggle API
RUN pip install --no-cache-dir kaggle

# Kaggle credential directory
RUN mkdir -p /root/.kaggle && chmod 600 /root/.kaggle

# Install ruff
RUN pip install --no-cache-dir ruff

# Working directory (same as Kaggle notebook environment)
WORKDIR /kaggle/working

CMD ["bash"]