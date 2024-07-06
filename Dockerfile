# For more information, please refer to https://aka.ms/vscode-docker-python
FROM pytorch/pytorch:2.3.1-cuda11.8-cudnn8-devel

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Setup pip mirror
RUN python -m pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pip==24.0
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# Install pip requirements
COPY server/requirements.txt .
RUN python -m pip install -r requirements.txt

# Install PortAudio
RUN apt-get update
RUN apt-get install -y libportaudio2
RUN apt-get install -y libasound-dev

# Working directory
WORKDIR /app/server
COPY . /app

# Export the port
EXPOSE 6006

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
# RUN adduser -u 1000 --disabled-password --gecos "" appuser && chown -R appuser /app
# USER appuser

# Setup pip mirro for the non-root user
# RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
ENTRYPOINT [ "sh" ]
CMD ["python", "MMVCServerSIO.py"]
