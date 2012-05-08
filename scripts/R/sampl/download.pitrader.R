
filesroot = "/home/hagen/myperl/.data/"

start_t<-Sys.time()

# Create and set the working directory if it doesn't exist
if (!file.exists(paste(filesroot, "/.incoming", sep="")))
   dir.create(paste(filesroot, "/.incoming", sep=""), mode="0777")
setwd(paste(filesroot, "/.incoming", sep=""))

# Does the archive directory structure exist?
if (!file.exists("../.archive")){  
  dir.create("../.archive", mode="0777")
  dir.create("../.archive/zip_files", mode="0777")
}
if (!file.exists("../.archive/zip_files"))
  dir.create("../.archive/zip_files", mode="0777")
  
# Use wget so that we don't need a list of files to work from
system("wget -r -l1 -H -t1 -nd -N -np -A.zip http://pitrading.com/free_market_data.htm")

# -r -H -l1 -np These options tell wget to download recursively. 
# That  means it goes to a URL, downloads the page there, then follows 
# every  link it finds. The -H tells the app to span domains, meaning 
# it should  follow links that point away from the page. And the -l1 
# (a lowercase L  with a numeral one) means to only go one level deep; 
# that is, don't  follow links on the linked site. It  will take each 
# link from the list of pages, and download it. The -np  switch stands 
# for "no parent", which instructs wget to never follow a  link up to a 
# parent directory. 
#  
# We don't, however, want all the links -- just those that point to 
# zip files we haven't yet seen. Including -A.zip tells wget to only 
# download files that end with the .zip extension. And -N turns on 
# timestamping, which means wget won't download something with the same 
# name unless it's newer. 
#  
# To keep things clean, we'll add -nd, which makes the app save every 
# thing it finds in one directory, rather than mirroring the directory 
# structure of linked sites. 

# Unzip the files to text files
system("unzip \\*.zip")
system("mv *.zip ../.archive/zip_files/")

# What files did we download?
files = list.files()

# Each file contains the full history for the symbol, so we just need to 
# move the file into the correct base directory.  We don't need to do any
# data parsing.
pisymbols = vector()
for(i in 1:length(files)) {
  # generate a list of symbols from the files we downloaded
  filename.txt <- files[i]
  pisymbols[i] <- substr(filename.txt, 1, nchar(filename.txt) - 4)
}

# The extra ".CC" appended to each symbol to indicate that the data is for a 
# "continuous contract" rather than a futures contract to be used as a root.
# We're modifying the symbols used so that they don't conflict with actual
# futures contracts.
for(pisymbol in pisymbols) {
  # check to make sure directories exist for each
  dir.create(paste("../", pisymbol, ".CC", sep=""), showWarnings = FALSE, 
  recursive = FALSE, mode = "0777")
  # move files into appropriate directory
  system(paste("mv ", pisymbol, ".txt", " ../", pisymbol, ".CC/", pisymbol, ".CC.csv", sep=""))
}

end_t<-Sys.time()
print(c("Elapsed time: ",end_t-start_t))
print(paste("Processed ", length(pisymbols), " symbols.", sep=""))


