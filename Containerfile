FROM debian:stable-slim

# Avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Emacs, sudo, git, and fundamental CLI tools
RUN apt-get update && apt-get install -y \
    emacs-nox \
    elpa-go-mode \
    elpa-yaml-mode \
    elpa-markdown-mode \
    vim \
    git \
    curl \
    tmux \
    htop \
    build-essential \
    ripgrep \
    fd-find \
    sudo \
    python3 \
    python3-pip \
    python3-dotenv \
    rakudo \
    raku-zef \
    golang \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Define the build argument for the host username
ARG DEV_USER=user

# Create the user and configure passwordless sudo
RUN useradd -m -s /bin/bash ${DEV_USER} && \
    echo "${DEV_USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${DEV_USER}
WORKDIR /home/${DEV_USER}

# Clone dotfiles repository directly into the container
RUN git clone https://github.com/neffercarrillo/dotfiles.git /home/${DEV_USER}/dotfiles

# Run repository's custom setup script
RUN cd /home/${DEV_USER}/dotfiles && ./setup

# Trigger Emacs package pre-compilation 
RUN emacs --batch --eval '(message "Packages synced!")'

CMD ["/bin/bash", "-c", "/usr/bin/emacs --daemon && sleep 0.5 && ([ -d ~/project ] && cd ~/project || [ -d /home/user/project ] && cd /home/user/project || cd ~); exec /bin/bash"]
