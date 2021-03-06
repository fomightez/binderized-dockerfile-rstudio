# RStudio with Bioinformatics Packages that run in Binder 

[![Binder](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/fomightez/dockerfile-rstudio/master)

This deploys a Binder that exposes the
RStudio UI instead of a Jupyter Notebook. It also installs
several packages from the tidyverse, and includes a demo
script to show off functionality.  Plus, I added my favorite R-related items for bioinformatics.

Running RStudio session
-----------------------

To start your RStudio session once [the Binder server](http://mybinder.org/v2/gh/fomightez/dockerfile-rstudio/master) has launched and you are greeted with the Jupyter dashboard, click on "New" in the top right,
and at the bottom will be `RStudio Session`.
Click that and your RStudio session will begin momentarily!

See `instructions.ipynb` for more details.


Post-fork differences
--------------------

I had found I could do all or some of the following once running when launched from [example Binder in the running RStudio session](https://github.com/binder-examples/dockerfile-rstudio):

    source("https://bioconductor.org/biocLite.R")
    biocLite(c("tximport","DESeq2","readr","RColorBrewer","pheatmap")) #for tximport and DESeq2 
    install.packages('rjson') #for tximport and DESeq2 
    biocLite(c("edgeR","DOSE","KEGGREST","pathview","clusterProfiler")) # for EdgeR
    OPTIONAL: biocLite(c("tximportData"))  #for tximport and DESeq2 

But those take a long time to install that way. I had tried adding using `biocLite()` approach in a Dockerfile first based on [here](https://hub.docker.com/r/rocker/geospatial/~/dockerfile/), which was part of past of the image the Binder example was using. However, I couldn't get the libraries I had added to work because of errors about version of R and bioconductor packages not being compatible. Luckily when looking into something else, I saw [here](https://github.com/binder-examples/dockerfile-r/network) that taylorreiter [was using RNA-seq](https://github.com/taylorreiter/dockerfile-r) and the approach there was to use the `install.r` (comparable to `install.R` I noted was already set up in the Dockerfile for [example Binder in the running RStudio session](https://github.com/binder-examples/dockerfile-rstudio) to handle the `biocLite()` installations). Moving the handling of the Bioconductor-controlled packages there, seemed to fix my issues. As described [here](https://www.bioconductor.org/install/#why-biocLite) the `biocLite()` approach is the recommended way because it overcomes issues the 'standard' way R packages are installed.

Whet set up January 2018, it was getting the versions of items associated with Bioconductor 3.6 (R version 3.4.2). See [here](https://github.com/fomightez/R_and_Bioconductor#related) for help about checking version in running RStudio session or getting versions of Bioconductor packages if you know what version of Bioconductor you had used or are using.

