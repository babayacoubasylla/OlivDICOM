# Utiliser Ubuntu 20.04 (focal) → plus stable sur Render
FROM ubuntu:20.04

# Forcer IPv4 + utiliser des miroirs rapides
RUN echo 'Acquire::ForceIPv4 "true";' | tee /etc/apt/apt.conf.d/99force-ipv4 && \
    sed -i 's/archive.ubuntu.com/mirrors.ubuntu.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.ubuntu.com/g' /etc/apt/sources.list

# Mise à jour et installation des paquets
RUN apt-get update && apt-get install -y \
    curl \
    nginx \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Ajout de la clé Orthanc + installation pour Ubuntu 20.04 (focal)
RUN curl -s https://apt.orthanc-server.com/orthanc.key | apt-key add - \
    && echo "deb https://apt.orthanc-server.com/ focal main" > /etc/apt/sources.list.d/orthanc.list \
    && apt-get update \
    && apt-get install -y orthanc

# Téléchargement d'OHIF Viewer
RUN mkdir -p /var/www/ohif
WORKDIR /var/www/ohif
RUN curl -L https://github.com/OHIF/Viewers/releases/latest/download/ohif-viewer-app.tar.gz | tar xz

# Copie des fichiers de configuration
COPY nginx.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Port exposé
EXPOSE 80

# Lancement du service
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]