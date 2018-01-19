# RStudio in Binder using a Dockerfile (the hope was to add Bioinformatics Packages but so far little luck)

[![Binder](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/fomightez/dockerfile-rstudio/master)

This deploys a Binder that exposes the
RStudio UI instead of a Jupyter Notebook. It also installs
several packages from the tidyverse, and includes a demo
script to show off functionality.  Plus, I had wanted to add some items for bioinformatics, but that didn't work out.

Turned out I was unable to install many of the Biocondcutor packages via the Dockerfile(, and then my modified DOckerfile failed in later steps too).
And so I gave up doing it that way for now.  

Can do once running when launced from example Binder in the running RStudio session:

    source("https://bioconductor.org/biocLite.R")
    biocLite(c("tximport","DESeq2","readr","RColorBrewer","pheatmap")) #for tximport and DESeq2 
    install.packages('rjson') #for tximport and DESeq2 
    biocLite(c("edgeR","DOSE","KEGGREST","pathview","clusterProfiler")) # for EdgeR
    OPTIONAL: biocLite(c("tximportData"))  #for tximport and DESeq2 

I think that works whereas it fails in the Dockerfile because rocker us MRAN as pointed out [here](https://stackoverflow.com/a/41400455/8508004), which came up when I searched for issues, and as described [here](https://www.bioconductor.org/install/#why-biocLite) the `biocLite()` approach is the recommended way because it overcomes issues the 'standard' way R packages are installed, which is what I was ending up doing in the Dockerfile.  
BUT `tximportData` TAKES FOREVER SO DON'T DO IF NOT NEEDED!! Essentially takes so long to do each session that it isn't useful. (I wonder if I could build what I need in a container, even using biocLite to do the installs in RStudio and save image with those updates(?), and then can store the docker image at Dockerhub for easy calling at start of Dockerfile to build via Binder and then once built, everything should be fast again?)
Note that the installation of the rjson package would have worked moved to the Dockerfile but since already running stuff within RStudio session after launched and it is small, might was well keep here for now since using the binderized RStudio example as it is for now.


To start your RStudio session, click on "new" in the top right,
and at the bottom will be `RStudio Session`.
Click that and your RStudio session will begin momentarily!

See `instructions.ipynb` for more details.


