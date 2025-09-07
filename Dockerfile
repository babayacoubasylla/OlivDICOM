# Utiliser Ubuntu 20.04 (focal) — le plus stable pour Orthanc sur Render
FROM ubuntu:20.04

# Forcer IPv4 + augmenter le timeout DNS
RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4 && \
    echo 'Acquire::http::Timeout "30";' >> /etc/apt/apt.conf.d/99force-ipv4 && \
    echo 'Acquire::https::Timeout "30";' >> /etc/apt/apt.conf.d/99force-ipv4

# Mettre à jour les paquets avec retry
RUN apt-get update --fix-missing && apt-get install -y \
    curl \
    nginx \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# Ajouter la clé Orthanc + installer pour focal
RUN curl -s https://apt.orthanc-server.com/orthanc.key | apt-key add - \
    && echo "deb https://apt.orthanc-server.com/ focal main" > /etc/apt/sources.list.d/orthanc.list \
    && apt-get update \
    && apt-get install -y orthanc

# Télécharger OHIF Viewer
RUN mkdir -p /var/www/ohif
WORKDIR /var/www/ohif
RUN curl -L https://github.com/OHIF/Viewers/releases/latest/download/ohif-viewer-app.tar.gz | tar xz

# Copier les fichiers de configuration
COPY nginx.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Port exposé
EXPOSE 80

# Lancement du service
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]