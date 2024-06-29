library(sf)
British_coast <- st_read("British Coast.shp")

#split into 15 parts

for(i in 0:14){
  
  temp <- st_linesubstring(British_coast, i/15 ,(i+1)/15)
  
  st_write(temp$geometry,  paste0("line parts/line",i + 1,".shp"))
  
}

library(rgdal)

line_part_files <- list.files("line parts", pattern = ".shp")

#load

res <- list()

for (file in line_part_files) {
  
  temp <-  readOGR(paste0("line parts/", file))

  temp@data <- data.frame(Name = gsub(".*?([0-9]+).*", "\\1", file), km = SpatialLinesLengths(temp)/1000)
  
  res[[file]] <- temp
    
}

final_res <- do.call("rbind", res)

final_res@data$ID <- 1:nrow(final_res)


writeOGR(final_res, getwd(),"Britain Coast sections.shp", driver="ESRI Shapefile")

