% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pseudo.absence.R
\name{pseudo.absence}
\alias{pseudo.absence}
\title{Pseudo-absence random samples}
\usage{
pseudo.absence(x, n, window = "hull", Mask = NULL, s = NULL,
  sigma = "Scott", wts = NULL, KDE = FALSE, gradient = 1, p = NULL,
  edge = FALSE)
}
\arguments{
\item{x}{An sp class SpatialPointsDataFrame or SpatialPoints object}

\item{n}{Number of random samples to generate}

\item{window}{Type of window (hull OR extent), overridden if mask provided}

\item{Mask}{Optional rasterLayer class mask raster. The resolution of the density estimate will match mask.}

\item{s}{Optional resolution passed to window argument. Caution should be used due to long processing times associated with high resolution. In contrast, coarse resolution can exclude known points.}

\item{sigma}{Bandwidth selection method for KDE, default is 'Scott'. Options are 'Scott', 'Stoyan', 'Diggle', 'likelihood', and 'geometry'}

\item{wts}{Optional vector of weights corresponding to point pattern}

\item{KDE}{save KDE raster (TRUE/FALSE)}

\item{gradient}{A scaling factor applied to the sigma parameter used to adjust the gradient decent of the density estimate. The default is 1, for no adjustment (downweight < 1 | upweight > 1)}

\item{p}{Minimum value for probability distribution (must be >  0)}

\item{edge}{Apply Diggle edge correction (TRUE/FALSE)}
}
\value{
A list class object with the following components:
\itemize{ 
\item   sample SpatialPointsDataFrame containing random samples
\item   kde sp RasterLayer class of KDE estimates (IF KDE = TRUE)
\item   sigma Selected bandwidth of KDE 
 }
}
\description{
Generates pseudo-absence samples based on density estimate of known locations
}
\details{
The window type creates a convex hull by default or, optionally, uses the maximum extent (envelope). If a mask is provided the kde will represent areas defined by the mask and defines the area that pseudo absence data will be generated.
Available bandwidth selection methods are:
\itemize{
\item   Scott (Scott 1992), Scott's Rule for Bandwidth Selection (1st order)
\item   Diggle (Berman & Diggle 1989), Minimize the mean-square error via cross validation (2nd order)  
\item   likelihood (Loader 1999), Maximum likelihood cross validation (2nd order)
\item   geometry, Bandwidth is based on simple window geometry (1st order)
\item   Stoyan (Stoyan & Stoyan 1995), Based on pair-correlation function (strong 2nd order)
 }

Note; resulting bandwidth can vary widely by method. the 'diggle' method is intended for selecting bandwidth representing 2nd order spatial variation whereas the 'scott' method will represent 1st order trend. the 'geometry' approach will also represent 1st order trend. for large datasets, caution should be used with the 2nd order 'likelihood' approach, as it is slow and computationally expensive. finally, the 'stoyan' method will produce very strong 2nd order results.
}
\examples{
 library(raster) 
 library(sp)
 data(meuse)
 data(meuse.grid)
   coordinates(meuse) = ~x+y   
   coordinates(meuse.grid) = ~x+y
   proj4string(meuse.grid) <- CRS("+init=epsg:28992")
   gridded(meuse.grid) = TRUE
   r <- raster(meuse.grid)

   # Using a raster mask   
   pa <- pseudo.absence(meuse, n=100, window='hull', KDE=TRUE, Mask = r, 
                        sigma='Diggle', s=50) 
     col.br <- colorRampPalette(c('blue','yellow'))
       plot(pa$kde, col=col.br(10))
         plot(meuse, pch=20, cex=1, add=TRUE)
           plot(pa$sample, col='red', pch=20, cex=1, add=TRUE)
             legend('top', legend=c('Presence', 'Pseudo-absence'), 
                    pch=c(20,20),col=c('black','red'))

 # With clustered data
 library(sp)
 library(spatstat)
 data(bei)
   trees <- as(bei, 'SpatialPoints')
     trees <- SpatialPointsDataFrame(coordinates(trees), 
                         data.frame(ID=1:length(trees))) 
       trees.abs <- pseudo.absence(trees, n=100, window='extent', KDE=TRUE)
 
 col.br <- colorRampPalette(c('blue','yellow'))
   plot(trees.abs$kde, col=col.br(10))
    plot(trees, pch=20, cex=0.50, add=TRUE)
       plot(trees.abs$sample, col='red', pch=20, cex=1, add=TRUE)
         legend('top', legend=c('Presence', 'Pseudo-absence'), 
                pch=c(20,20),col=c('black','red'))
     
}
\references{
Berman, M. and Diggle, P. (1989) Estimating weighted integrals of the second-order intensity of a spatial point process. Journal of the Royal Statistical Society, series B 51, 81-92.

Fithian, W & T. Hastie (2013) Finite-sample equivalence in statistical models for presence-only data. Annals of Applied Statistics 7(4): 1917-1939

Hengl, T., H. Sierdsema, A. Radovic, and A. Dilo (2009) Spatial prediction of species distributions from occurrence-only records: combining point pattern analysis, ENFA and regression-kriging. Ecological Modelling, 220(24):3499-3511

Loader, C. (1999) Local Regression and Likelihood. Springer, New York.

Scott, D.W. (1992) Multivariate Density Estimation. Theory, Practice and Visualization. New York, Wiley.

Stoyan, D. and Stoyan, H. (1995) Fractals, random shapes and point fields: methods of geometrical statistics. John Wiley and Sons.

Warton, D.i., and L.C. Shepherd (2010) Poisson Point Process Models Solve the Pseudo-Absence Problem for Presence-only Data in Ecology. The Annals of Applied Statistics, 4(3):1383-1402
}
\author{
Jeffrey S. Evans  <jeffrey_evans@tnc.org>
}
