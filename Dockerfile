# Use official PyTorch image with CUDA support
FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn8-runtime

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# Clone the FramePack repo
RUN git clone https://github.com/Cally99/FramePack.git  .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Optional: Install sage-attention (remove if not needed)
RUN pip install --no-cache-dir sageattention==1.0.6

# Patch demo_gradio.py to allow remote access
RUN sed -i 's/app.launch()/app.launch(server_name="0.0.0.0", server_port=7860, debug=True)/' demo_gradio.py

# Copy startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Expose Gradio port
EXPOSE 7860

# Start the app
CMD ["/run.sh"]
