nthread=1#2#8
library(abind)
library(data.table)
library(igraph)
library(INLA)
library(fields)
library(mgcv)
library(rworldmap)
library(rgeos)
library(maptools)
library(data.table)##fread
library(raster)
library(spNNGP)
library(abind)
library(matlabr)
library(R.matlab)
library(openxlsx)
col=c(rgb(0.2081, 0.1663, 0.5292),
rgb(0.3961, 0.3176, 0.8000),
rgb(0.0123, 0.4213, 0.8802),
rgb(0.4941, 0.7647, 0.8980),
rgb(0.1157, 0.7022, 0.6843),
rgb(0.5216, 0.6980, 0.1725),
rgb(0.9968, 0.7513, 0.2325),
rgb(1.0000, 0.4863, 0.0000),
rgb(0.8000, 0.3176, 0.3176),
rgb(0.6980, 0.1725, 0.1725))
N=10
model=c("Baseline","ICA","ROS","SIG","WAW")
ttime=c("2020s","2050s","2080s")
nam=c("Food per capita","People flooded in a 1 in 100 year event","Water exploitation index","Intensity Index","Land use diversity","Biodiversity Vulnerability Index","Timber Product", "Artificial Surface"
,"Food production","Potential Carbon stock","Irrigation usage","Intensive Arable","Intensive Diary","Extensively.grass","Very.Extensively.grass","Unmanaged.land","Managed.forest","Unmanaged.forest","Urban")
#ind=c(12,73,18,2,3,6,7,8,9,10,85)
idd=c(13,65,118,17,16,140,15,108,12,73,18,2,3,6,7,8,9,10,85)#6 outputs
a1=seq(1,2387300,23873)
a2=seq(2,2387300,23873)
#gaga=readLines("EuropeBaseline2020s_4_outputsAllSpecies.csv")
#gaga2=gaga[-c(a1,a2)]
#dat=data.matrix(fread(text=gaga2,header=FALSE,showProgress=TRUE,nThread=nthread,select=idd,stringsAsFactors=FALSE))
#aa=run_matlab_script("./data_processing/Build_SDG_15_code.m",verbose = TRUE, desktop = TRUE,display=TRUE,splash=TRUE)
##################################
temp=fread("EuropeBaseline2050s_1_outputsAllSpecies.csv",header=TRUE,showProgress=TRUE,nThread=nthread,select=1:357,stringsAsFactors=FALSE,skip=23874,nrows=23871)
ogo=subset(temp,select="Arable crops")
path0="./data_processing/"
RobFile="ProcessDataSDG15_v5_RobD3.xlsx"
species=read.xlsx(paste(path0,RobFile,sep=""), sheet = "SL", startRow = 1:1, colNames =FALSE,cols=1)
habitat=read.xlsx(paste(path0,RobFile,sep=""), sheet = "SL", startRow = 1:1, colNames =FALSE,cols=2)
setaside=as.numeric(as.matrix(read.xlsx(paste(path0,RobFile,sep=""), sheet = "Setaside",colNames=TRUE, startRow =1,rows=1:2, cols=5:37)))
SET=matrix(rep(setaside,23871),ncol=33,nrow=23871,byrow=TRUE)
load('IAP_regions.mat')
IAP_regions=unlist(readMat(paste(path0,"IAP_regions.mat",sep="")))
RR=sort(unique(IAP_regions))
region_names=c('Alpine','Northern','Atlantic','Continental','Southern')#%-->10     %-->20      %-->30    %-->40        %-->50];
#%Read baseline values
bla=read.xlsx(paste(path0,RobFile,sep=""),sheet='BL',startRow=2,rows=1:23874,cols=1:96,colNames=TRUE)
BL_spec=bla[,1:91]
BL=bla[,92]
#BL=read.xlsx(paste(path0,RobFile,sep=""),sheet='BL',startRow=3,rows=1:23874,cols=96,colNames=FALSE)
# %sum of species in each gridbox
BL_EU=sum(BL)
# %sum number of present species in baseline for Europe
BL_reg=rep(NA,length(RR))
for(r in 1:length(RR)){
    a=which(IAP_regions==RR[r])
    BL_reg[r] = sum(BL[a])
}
Strategy=10:12
nam0=colnames(temp)
gap=as.matrix(species)
indx=match(gap,nam0)##finding species names in the whole file#c(151,163,169)
indx[which(is.na(indx))]=c(151,163,169)##unmatchable
id=rvec_to_matlab(indx,sep=" ")
###run matlab code
add_path("E:/Baseline_2020s/2020s/outputs") 
#run_matlab_code("test.m",verbose = TRUE, desktop = TRUE, splash = TRUE, display = TRUE, wait = TRUE)
run_matlab_code("test",verbose = TRUE, desktop = TRUE, splash = TRUE, display = TRUE, wait =TRUE)
