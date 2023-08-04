# Use the ensembl-vep as a base
FROM ensemblorg/ensembl-vep:release_105.0

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


