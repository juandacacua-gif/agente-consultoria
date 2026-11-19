# Ejecutor de R aislado. Se construye con red (para instalar paquetes) y se
# EJECUTA sin red, sin secretos y con el sistema de archivos de solo lectura
# (ver docker-compose.yml).
#
# Antes de construir, comprueba que la etiqueta existe:
#   docker pull rocker/r-ver:4.6.0
# Si no existe, usa la serie de R más cercana disponible y anótalo en el README.
FROM rocker/r-ver:4.6.0

RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 \
      libcurl4-openssl-dev libssl-dev libxml2-dev \
      libfontconfig1-dev libfreetype6-dev libharfbuzz-dev libfribidi-dev \
      libpng-dev libjpeg-dev libtiff-dev libglpk-dev libgmp-dev libicu-dev libuv1-dev \
    && rm -rf /var/lib/apt/lists/*

# Paquetes de R que el agente ha usado en sus scripts (instalados aquí, porque
# en ejecución no hay red).
COPY install_packages.R /tmp/install_packages.R
RUN mkdir -p /opt/runner && Rscript /tmp/install_packages.R && rm /tmp/install_packages.R

RUN useradd --create-home --uid 1001 runner \
    && mkdir /work && chmod 1777 /work
COPY --chown=runner:runner runner.py /opt/runner/runner.py

USER runner
WORKDIR /opt/runner
ENV PYTHONUNBUFFERED=1
EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
  CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:8000/health', timeout=3)" || exit 1

CMD ["python3", "/opt/runner/runner.py"]
