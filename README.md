A docker project for:
 - building a TermSuite docker image including its 3rd-party dependencies,
 - running TermSuite tools.

# Building TermSuite docker image

1. Clone this docker project:

```
$ git clone https://github.com/termsuite/termsuite-docker.git
```

2. Build the docker image:

```
$ cd termsuite-docker
$ bin/build
```

This will build the docker image `termsuite:X.Y.Y` where `X.Y.Z` is the version of TermSuite. The version of TermSuite (and of the docker image to build) can be set or changed in the `Dockerfile`, within the instruction `ENV`:

```
ENV \
  TT_VERSION=3.2.1 \
  TERMSUITE_VERSION=3.0 \
```

# Running TermSuite

Once the image is built you can run TermSuite tools with `bin/termsuite`.

```
$ bin/termsuite --help
```

There are currently three TermSuite tools available with the docker images:

 1. `preprocess`: runs `fr.univnantes.termsuite.tools.PreprocessorCLI` (applies TermSuite preprocessing to documents),
 1. `extract`: runs `fr.univnantes.termsuite.tools.TerminologyExtractorCLI` (extracts terminologies from a domain-specific corpus),  
 1. `align`: runs `fr.univnantes.termsuite.tools.AlignerCLI` (runs bilingual aligners).


Run one of these programs with:

```
$ bin/termsuite {preprocess,extract,align} OPTIONS
```

Where `OPTIONS` are the options you need to run the given TermSuite tool,
 **except the tagger home option `-t`**, which is no more required here because
 the tagger is installed inside the docker image.

See TermSuite [Command Line API documentation](https://termsuite.github.io/documentation/command-line-api/) to get details on how to run each of these programs.


You can also get each tool instruction with option `--help`:

```
$ bin/termsuite preprocess --help
$ bin/termsuite extract --help
$ bin/termsuite align --help
```

# Examples

The command line below runs terminology extraction on the local corpus `/path/to/my/corpus/` and language `en`, and outputs the terminology to `my-termino.tsv`.

```
bin/termsuite extract --tsv my-termino.tsv -c /path/to/my/corpus/ -l en
```
