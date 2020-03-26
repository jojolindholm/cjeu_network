library(igraph)
library(parallel)
library(RCurl)

setwd("~/Dropbox/Arbete/Forskning/Projekt/CJEU dataset/Scripts/cjeu_network")

# LOAD RESOURCES

  load("~/Dropbox/CJEU/data/ReferencesGoJ.rda")
  load("~/Dropbox/CJEU/data/Judgments.rda")

  
# CREATE NETWORK DATA  

  createCitationGraph <- function(){
    
    buildEl <- function() {  # creates edgelist
      el <- cbind.data.frame(ReferencesGoJ$ecli, ReferencesGoJ$ecli_ref, as.Date(ReferencesGoJ$case_date), stringsAsFactors = FALSE)   # create raw el
      colnames(el) <- c("from", "to", "case_date")   # rename el cols
      el <- el[!is.na(el$to),]   # remove non-case refs
      return(el)
    }
    
    buildGraph <- function(el) {   # creates graph   // date attr conversion an issue?
      g <- graph_from_data_frame(el, TRUE)   # create graph
      g <- set_edge_attr(g, "date", E(g), el$case_date)  # add date to edges to enable stuying development 
      islands <- Judgments$ecli[!Judgments$ecli %in% V(g)$name]   # identify islands (non-included vertices))
      g <- add_vertices(g, length(islands), name = islands)   # add islands to graph
      V(g)$date_document <- Judgments$date_document[match(V(g)$name, Judgments$ecli)]  # add date, includes non-judgments, t-cases
      return(g)
    }
    
    addNetworkCentrality <- function(g){   # calculates vertex centralities
      
      initial_hub_score <- function(g){   # calculates initial hub score of v
        
        calc_ihs <- function(v) {
          date <- V(g)[v]$date_document
          all_vs <- na.exclude(V(g)$date_document <= date)
          sg <- induced_subgraph(g, V(g)[all_vs])
          ihs <- hub_score(sg)$vector[v]
          return(ihs)
        }
        
        ihs <- unlist(mclapply(V(g), calc_ihs, mc.cores = detectCores()))
        return(ihs)
      }
      
      hub_rank <- function(g){
        
        calc_hr <- function(v){
          es <- incident(g, v, mode = "in")
          if(length(es) > 0){
            hubrank <- sum(V(g)$pagerank[tail_of(g, es)])
          } else {
            hubrank <- 0
          }
          return(hubrank)
        }

        hr <- unlist(mclapply(V(g), calc_hr, mc.cores = detectCores()))
        return(hr)
      }
      
      V(g)$indegree <- degree(g, mode = "in")
      V(g)$outdegree <- degree(g, mode = "out")
      V(g)$page_rank <- page_rank(g, directed = TRUE, damping = 0.5)$vector
      V(g)$hub_score <- hub_score(g)$vector
      V(g)$initial_hub_score <- initial_hub_score(g)
      V(g)$hub_rank <- hub_rank(g)
      V(g)$authority <- authority_score(g)$vector
      V(g)$betweenness <- betweenness(g)
      return(g)
    }
    
    addClustering <- function(g){
      V(g)$info_map <- cluster_infomap(g)$membership
    }
    
    el <- buildEl()
    g <- buildGraph(el)
    g <- addNetworkCentrality(g)
    return(g)
  }
  
  createVertexDf <- function(g){
    return(tibble(ecli = V(g)$name,
           indegree = V(g)$indegree,
           outdegree = V(g)$outdegree,
           page_rank = V(g)$page_rank,
           hub_score = V(g)$hub_score,
           initial_hub_score = V(g)$initial_hub_score,
           hub_rank = V(g)$hub_rank,
           authority = V(g)$authority,
           betweenness = V(g)$betweenness,
           info_map = V(g)$info_map))
  }
  
  
# MAIN LOOP
  
  g <- createCitationGraph()
  write_graph(g, "output/cjeu_network.gml", format = "gml")

  df <- createVertexDf(g)
  write_csv(df, "output/cjeu_centrality.csv")