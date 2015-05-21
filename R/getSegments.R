# =================================================================
# Extraction of segments and clustering
# =================================================================
#' Extract segments and cluster
#'
#' Extract segments and ID from a list of \code{\link{aneuHMM}} or \code{\link{aneuBiHMM}} objects and cluster if desired.
#'
#' @param hmm.list A list of \code{\link{aneuHMM}} or \code{\link{aneuBiHMM}} objects or files that contain such objects.
#' @param cluster Either \code{TRUE} or \code{FALSE}, indicating whether the samples should be clustered by similarity in their CNV-state.
#' @param getSCE Either \code{TRUE} or \code{FALSE}, indicating whether SCE coordinates should also be returned.
#' @return A \code{list()} with (clustered) segments and SCE coordinates.
getSegments <- function(hmm.list, cluster=TRUE, getSCE=TRUE) {

	## Load the files
	hmm.list <- loadHmmsFromFiles(hmm.list)

	## Get segments from list
	grlred <- GRangesList()
	for (hmm in hmm.list) {
		if (!is.null(hmm$segments)) {
			grlred[[hmm$ID]] <- hmm$segments
		}
	}
	sce <- list()
	if (getSCE) {
		message("getting SCE coordinates ...", appendLF=F); ptm <- proc.time()
		for (hmm in hmm.list) {
			if (!is.null(hmm$segments) & class(hmm)==class.bivariate.hmm) {
				sce[[hmm$ID]] <- getSCEcoordinates(hmm)
			}
		}
		time <- proc.time() - ptm; message(" ",round(time[3],2),"s")
	}

	## Clustering
	if (cluster) {
		message("making consensus template ...", appendLF=F); ptm <- proc.time()
		suppressPackageStartupMessages(consensus <- disjoin(unlist(grlred)))
		constates <- matrix(NA, ncol=length(grlred), nrow=length(consensus))
		for (i1 in 1:length(grlred)) {
			grred <- grlred[[i1]]
			splt <- split(grred, mcols(grred)$state)
			mind <- as.matrix(findOverlaps(consensus, splt, select='first'))
			constates[,i1] <- mind
		}
		meanstates <- apply(constates, 1, mean, na.rm=T)
		mcols(consensus)$meanstate <- meanstates
		time <- proc.time() - ptm; message(" ",round(time[3],2),"s")

		# Distance measure
		message("clustering ...", appendLF=F); ptm <- proc.time()
		constates[is.na(constates)] <- 0
		wcor <- cov.wt(constates, wt=as.numeric(width(consensus)), cor=T)
		dist <- as.dist(1-wcor$cor)
		# Dendrogram
		hc <- hclust(dist)
		# Reorder samples
		grlred <- grlred[hc$order]
		if (getSCE) {
			sce <- sce[hc$order]
		}
		time <- proc.time() - ptm; message(" ",round(time[3],2),"s")
	}

	return(list(segments=grlred, sce=sce))
}