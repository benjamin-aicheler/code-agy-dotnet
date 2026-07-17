# Coder unterstützt amd64 und arm64 im selben Tag automatisch
FROM codercom/code-server:4.129.0-ubuntu

USER root

# .NET 10 SDK UND das GitHub CLI (gh) direkt aus den nativen Ubuntu 24.04 Quellen installieren.
# Beide Pakete sind für amd64 und arm64 offiziell von Canonical optimiert.
RUN apt-get update && apt-get install -y \
    dotnet-sdk-10.0 \
    gh \
    && rm -rf /var/lib/apt/lists/*

# Zurück zum vordefinierten 'coder' Benutzer wechseln
USER coder
WORKDIR /home/coder

# Lokales Bin-Verzeichnis in PATH aufnehmen
ENV PATH="/home/coder/.local/bin:${PATH}"

# Das Google Antigravity CLI installieren (erkennt arm64 automatisch im Skript)
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash

# Empfohlene Umgebungsvariablen für .NET in Docker-Umgebungen
ENV DOTNET_USE_POLLING_FILE_WATCHER=1
ENV ASPNETCORE_ENVIRONMENT=Development

EXPOSE 8080

CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "."]
