library(sf)
library(lwgeom)

British_coast <- st_read("British Coast.shp")

#split into 15 parts of roughly 672km, which is approx the length of the Cornish coast

## create an output directory if needed
if (!dir.exists("line parts")) {
 dir.create("line parts")
}

for(i in 0:14){
  
  temp <- st_linesubstring(British_coast, i/15 ,(i+1)/15)
  
  st_write(temp$geometry,  paste0("line parts/line",i + 1,".shp"), delete_layer = T)
  
}

#combine parts into a single polyline shapefile - I only know how to do this in rgdal so I'm loading them back in using this package
#there may well be a more simple way to do this


library(rgdal)

line_part_files <- list.files("line parts", pattern = ".shp") #create a vector with all the shapefile names

#load

res <- list() #list to save output to

for (file in line_part_files) {
  
  temp <-  readOGR(paste0("line parts/", file)) #read in file

  temp@data <- data.frame(ID = gsub(".*?([0-9]+).*", "\\1", file), km = SpatialLinesLengths(temp)/1000) #add data frame with ID and section length
  
  res[[file]] <- temp #save to output list
    
}

final_res <- do.call("rbind", res) #combine into single GIS object

final_res <- final_res[order(as.numeric(final_res@data$ID)),] #get sections in correct order
 
rownames(final_res@data) <- 1:nrow(final_res) #fix rownames of associated data frame

#plot finished GIS object

plot(final_res, col = 1:nrow(final_res))

writeOGR(final_res, getwd(),"Britain Coast sections.shp", driver="ESRI Shapefile", overwrite_layer = T) #export

# Shapefile reprojection - in cae WGS 1984 projection is required
final_res1984 <- spTransform(final_res, CRS("+proj=longlat +datum=WGS84"))

writeOGR(final_res1984, getwd(),"Britain Coast sections WGS 1984.shp", driver="ESRI Shapefile", overwrite_layer = T) #export


