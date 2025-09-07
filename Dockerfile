# On part d'une image Ubuntu légère
FROM ubuntu:22.04

# On installe les outils de base
RUN apt-get update && apt-get install -y \
    curl \
    nginx \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

# On ajoute le dépôt et installe Orthanc (serveur DICOM)
RUN curl -s https://apt.orthanc-server.com/orthanc.key | apt-key add - \
    && echo "deb https://apt.orthanc-server.com/ jammy main" > /etc/apt/sources.list.d/orthanc.list \
    && apt-get update \
    && apt-get install -y orthanc

# On télécharge OHIF Viewer (le visualiseur web)
RUN mkdir -p /var/www/ohif
WORKDIR /var/www/ohif
RUN curl -L https://github.com/OHIF/Viewers/releases/latest/download/ohif-viewer-app.tar.gz | tar xz

# On copie nos fichiers de configuration
COPY nginx.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# On expose le port 80
EXPOSE 80

# On lance Supervisor (qui va lancer Orthanc + Nginx)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]