New Zealand aviation emissions 
--------------------------------------------------
# load some libraries
library(tidyr)
library(readxl)
library(dplyr)
# download detailed emissions data by category from Ministry for the Environment
 
# https://environment.govt.nz/publications/new-zealands-greenhouse-gas-inventory-1990-2021/ 13 April 2023 Reference: ME 1750 
# download 1990 2021 Time series by category spreadsheet
download.file("https://environment.govt.nz/assets/publications/climate-change/Time-series-emissions-data-by-category-presented-in-AR4-Excel-xlsx.xlsx","Time-series-emissions-data-by-category-presented-in-AR4-Excel-xlsx")
trying URL 'https://environment.govt.nz/assets/publications/climate-change/Time-series-emissions-data-by-category-presented-in-AR4-Excel-xlsx.xlsx'
Content type 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' length 1497400 bytes (1.4 MB)
==================================================
downloaded 1.4 MB 

# List all sheets in an excel spreadsheet 
excel_sheets("Time-series-emissions-data-by-category-presented-in-AR4-Excel-xlsx")
[1] "AR4 - All gases" "AR4 - CO2"       "AR4 - CH4"       "AR4 - N2O"      
[5] "AR4 - HFCs"      "AR4 - PFCs"      "AR4 - SF6"     

# read in inventory data in a HUGE block including Years row 11 as column headers

data <- read_excel("Time-series-emissions-data-by-category-presented-in-AR4-Excel-xlsx", sheet = "AR4 - All gases",skip=10,col_types = c("guess"))  
str(data) 
tibble [1,085 × 34] (S3: tbl_df/tbl/data.frame)
 $ Category code: chr [1:1085] "Sectors Totals" "Sectors Totals" "1" "1.AA" ...
 $ Category name: chr [1:1085] "[Sectors/Totals] (Net, with LULUCF)" "[Sectors/Totals] (Gross, excluding LULUCF)" "[1.  Energy]" "[1.AA  Fuel Combustion - Sectoral approach]" ... 

# row 93 of sheet    [1.A.3.a  Domestic Aviation]       = row 82 of 'data'
# row 322 of sheet   [1.D.1.a  International Aviation]  = row 311 of 'data'

data[82,]
# A tibble: 1 × 34
  `Category code` `Category name`      `1990` `1991` `1992` `1993` `1994` `1995`
  <chr>           <chr>                 <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
1 1.A.3.a         [1.A.3.a  Domestic …   948.   822.   814.   942.  1088.  1120.
# ℹ 26 more variables: `1996` <dbl>, `1997` <dbl>, `1998` <dbl>, `1999` <dbl>,
#   `2000` <dbl>, `2001` <dbl>, `2002` <dbl>, `2003` <dbl>, `2004` <dbl>,
#   `2005` <dbl>, `2006` <dbl>, `2007` <dbl>, `2008` <dbl>, `2009` <dbl>,
#   `2010` <dbl>, `2011` <dbl>, `2012` <dbl>, `2013` <dbl>, `2014` <dbl>,
#   `2015` <dbl>, `2016` <dbl>, `2017` <dbl>, `2018` <dbl>, `2019` <dbl>,
#   `2020` <dbl>, `2021` <dbl> 

# leave out first 2 columns so its only the 1990 to 2021 emissions
data[82,3:34]
# A tibble: 1 × 32
  `1990` `1991` `1992` `1993` `1994` `1995` `1996` `1997` `1998` `1999` `2000`
   <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
1   948.   822.   814.   942.  1088.  1120.  1100.  1048.  1104.  1086.  1183.
# ℹ 21 more variables: `2001` <dbl>, `2002` <dbl>, `2003` <dbl>, `2004` <dbl>,
#   `2005` <dbl>, `2006` <dbl>, `2007` <dbl>, `2008` <dbl>, `2009` <dbl>,
#   `2010` <dbl>, `2011` <dbl>, `2012` <dbl>, `2013` <dbl>, `2014` <dbl>,
#   `2015` <dbl>, `2016` <dbl>, `2017` <dbl>, `2018` <dbl>, `2019` <dbl>,
#   `2020` <dbl>, `2021` <dbl>
data[82,2]
# A tibble: 1 × 1
  `Category name`             
  <chr>                       
1 [1.A.3.a  Domestic Aviation] 

domestic_aviation <- as.numeric(data[82,3:34])

data[311,]
# A tibble: 1 × 34
  `Category code` `Category name`      `1990` `1991` `1992` `1993` `1994` `1995`
  <chr>           <chr>                 <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
1 1.D.1.a         [1.D.1.a  Internati…  1333.  1293.  1269.  1295.  1292.  1615.
# ℹ 26 more variables: `1996` <dbl>, `1997` <dbl>, `1998` <dbl>, `1999` <dbl>,
#   `2000` <dbl>, `2001` <dbl>, `2002` <dbl>, `2003` <dbl>, `2004` <dbl>,
#   `2005` <dbl>, `2006` <dbl>, `2007` <dbl>, `2008` <dbl>, `2009` <dbl>,
#   `2010` <dbl>, `2011` <dbl>, `2012` <dbl>, `2013` <dbl>, `2014` <dbl>,
#   `2015` <dbl>, `2016` <dbl>, `2017` <dbl>, `2018` <dbl>, `2019` <dbl>,
#   `2020` <dbl>, `2021` <dbl> 

international_aviation <- as.numeric(data[311,3:34])

year <- c(1990:2021)

nz_aviation <-as.data.frame(cbind(year,domestic_aviation,international_aviation)) 

str(nz_aviation) 
'data.frame':	32 obs. of  3 variables:
 $ year                  : num  1990 1991 1992 1993 1994 ...
 $ domestic_aviation     : num  948 822 814 942 1088 ...
 $ international_aviation: num  1333 1293 1269 1295 1292 ... 

# add a total column
nz_aviation[["total"]] <- nz_aviation[["domestic_aviation"]] + nz_aviation[["international_aviation"]]

write.table(nz_aviation, file = "nz_aviation.csv", sep = ",", col.names = TRUE, qmethod = "double",row.names = FALSE)

svg(filename="NZ-aviation-ghgs-2021-720.svg", width = 8, height = 6, pointsize = 12, onefile = FALSE, family = "sans", bg = "white", antialias = c("default", "none", "gray", "subpixel"))
#png("NZ-aviation-ghgs-2021-560.png", bg="white", width=560, height=420, pointsize = 12)
par(mar=c(2.7,2.7,1,1)+0.1)
plot(nz_aviation[["year"]],nz_aviation[["total"]]/1000,ylim=c(0,5.25), xlim=c(1989,2021),tck=0.01,axes=FALSE,ann=FALSE, type="n",las=1)
axis(side=1, tck=0.01, las=0, lwd = 1, at = c(1990:2021), labels = c(1990:2021), tick = TRUE)
axis(side=2, tck=0.01, las=2, line = NA,lwd = 1, at = c(0,1,2,3,4,5), labels = c(0,1,2,3,4,5),tick = TRUE)
axis(side=4, tck=0.01, at = c(0,1,2,3,4,5), labels = FALSE, tick = TRUE)
box(lwd=1)
lines(nz_aviation[["year"]],nz_aviation[["total"]]/1000,col="#E41A1C",lwd=1)
points(nz_aviation[["year"]],nz_aviation[["total"]]/1000,col="#E41A1C",cex=1.1,pch=16)
lines(nz_aviation[["year"]],nz_aviation[["domestic_aviation"]]/1000,col="#377EB8",lwd=1)
points(nz_aviation[["year"]],nz_aviation[["domestic_aviation"]]/1000,col="#377EB8",cex=1,pch=15)
lines(nz_aviation[["year"]],nz_aviation[["international_aviation"]]/1000,col="#4DAF4A",lwd=1)
points(nz_aviation[["year"]],nz_aviation[["international_aviation"]]/1000,col="#4DAF4A",cex=1,pch=17)
mtext(side=1,line=-1.5,cex=1,"Data: New Zealand’s Greenhouse Gas Inventory 1990 – 2021 MfE 2023 Report ME 1750 \nTime-series-emissions-data-by-category-presented-in-AR4-Excel-xlsx.xlsx")
mtext(side=3,cex=1.5, line=-2,expression(paste("New Zealand aviation emissions 1990 2021")) )
mtext(side=2,cex=1, line=-1.5,expression(paste("million tonnes C", O[2], "-e")))
mtext(side=4,cex=0.75, line=0.05,R.version.string)
legend(1990,4.75, bty = "n",cex=1.1, c("Total NZ aviation emissions","International aviation emissions","Domestic aviation emissions"), col =  c("#E41A1C","#4DAF4A","#377EB8") , text.col = 1, lty = 1, pch = c(16,17,15))
dev.off()

http://tourismdashboard.mbie.govt.nz/
