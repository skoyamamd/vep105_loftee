#Use the ensembl-vep as a base
FROM ensemblorg/ensembl-vep:release_105.0

USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    libncurses5-dev \
    libbz2-dev \
    liblzma-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libssl-dev

# Install SamTools
RUN mkdir -p /tmp/samtools && \
    curl -sSL https://github.com/samtools/samtools/releases/download/1.18/samtools-1.18.tar.bz2 | tar -jx -C /tmp/samtools --strip-components=1 && \
    cd /tmp/samtools && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    rm -rf /tmp/samtools

# Install LOFTEE
RUN mkdir -p /loftee && \
    curl -sSL https://github.com/konradjk/loftee/archive/refs/tags/v1.0.4_GRCh38.tar.gz | tar -xz -C /loftee --strip-components=1

# Add loftee to PERL5LIB
ENV PERL5LIB /loftee:$PERL5LIB

# Install plugins
INSTALL.pl -a p -s homo_sapiens -y GRCh38 -n -g all
