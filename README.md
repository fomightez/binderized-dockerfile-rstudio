# RStudio in Binder using a Dockerfile

[![Binder](http://mybinder.org/badge.svg)](http://mybinder.org/v2/gh/fomightez/dockerfile-rstudio/master)

This deploys a Binder that exposes the
RStudio UI instead of a Jupyter Notebook. It also installs
several packages from the tidyverse, and includes a demo
script to show off functionality.  Plus some items for bioinformatics. Several I was unable to install via the Dockerfile.
And so I gave up doing it that way for now.  

Can do once running with this in the running RStudio session:

    source("https://bioconductor.org/biocLite.R")
    biocLite(c("tximportData", "tximport"))

I think that works whereas it fails in the Dockerfile because rocker us MRAN as pointed out [here](https://stackoverflow.com/a/41400455/8508004), which came up when I searched for issues, and as described [here](https://www.bioconductor.org/install/#why-biocLite) the `biocLite()` approach is the recommended way because it overcomes issues the 'standard' way R packages are installed, which is what I was ending up doing in the Dockerfile.  
BUT IT TAKES FOREVER!!


To start your RStudio session, click on "new" in the top right,
and at the bottom will be `RStudio Session`.
Click that and your RStudio session will begin momentarily!

See `instructions.ipynb` for more details.

*Special thanks to Ryan Lovett (@ryanlovett) for figuring out
RStudio support with JupyterHub*
