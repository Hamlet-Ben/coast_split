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

#combine parts into a single polyline shapefile - not sure why there's a need to save files and reload them in but this works


line_part_files <- list.files("line parts", pattern = ".shp") #create a vector with all the shapefile names

#load

res <- list()

for (file in line_part_files) {
  
  temp <-  st_read(paste0("line parts/", file)) #read in file

  temp$ID <- gsub(".*?([0-9]+).*", "\\1", file) #add ID
  temp$km <- as.numeric(st_length(temp))/1000 #add section length in km
  
  res[[file]] <- temp #save to output list
    
}

final_res <- do.call("rbind", res) #combine into single GIS object

#plot finished GIS object

plot(final_res, col = 1:nrow(final_res))

st_write(final_res,  "Britain Coast sections.shp", delete_layer = T)

# Shapefile reprojection - in cae WGS 1984 projection is required
final_res1984 <- st_transform(final_res, CRS("+proj=longlat +datum=WGS84"))

st_write(final_res1984,  "Britain Coast sections WGS 1984.shp", delete_layer = T)


