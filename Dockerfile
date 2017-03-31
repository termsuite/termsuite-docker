FROM openjdk:8-jre

LABEL maintainer="Damien Cram <damien.cram@univ-nantes.fr>"

ENV \
  TT_VERSION=3.2.1 \
  TERMSUITE_VERSION=3.0.1 \
  TT_URL=http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/data

# Install gosu to allow to run termsuite as current user
ENV GOSU_VERSION 1.10
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && export GNUPGHOME="$(mktemp -d)" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

RUN mkdir -p /opt/treetagger/
WORKDIR /opt/treetagger/
RUN wget ${TT_URL}/tree-tagger-linux-${TT_VERSION}.tar.gz \
    && wget ${TT_URL}/tagger-scripts.tar.gz \
    && wget ${TT_URL}/english-par-linux-3.2-utf8.bin.gz \
    && wget ${TT_URL}/french-par-linux-3.2-utf8.bin.gz \
    && wget ${TT_URL}/german-par-linux-3.2-utf8.bin.gz \
    && wget ${TT_URL}/russian-par-linux-3.2-utf8.bin.gz \
    && wget ${TT_URL}/spanish-par-linux-3.2-utf8.bin.gz \
    && wget http://corpus.leeds.ac.uk/tools/zh/tt-lcmc.tgz \
    && wget ${TT_URL}/install-tagger.sh \
    && sh /opt/treetagger/install-tagger.sh \
    && mv lib models \
    && rm -rf *.gz *.tgz cmd/ doc/

WORKDIR /opt/treetagger/models/
RUN mv french-utf8.par french.par \
    && mv english-utf8.par english.par \
    && mv spanish-utf8.par spanish.par \
    && mv russian-utf8.par russian.par \
    && mv german-utf8.par german.par \
    && rm *-utf8 *-abbreviations *-mwls *-tokens *.txt \
    && chmod a+x /opt/treetagger/models/

WORKDIR /opt/
RUN  curl -O -L https://search.maven.org/remotecontent?filepath=fr/univ-nantes/termsuite/termsuite-core/${TERMSUITE_VERSION}/termsuite-core-${TERMSUITE_VERSION}.jar

COPY ./src/launcher /opt/
RUN chmod a+x /opt/launcher

ENTRYPOINT ["/opt/launcher"]

RUN apt-get purge -y --auto-remove
