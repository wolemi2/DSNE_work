#################IAP2 climate data preprocessing
#For RCP2.6 {0 = EC-EARTH_RCA4; 1 = MPI-ESM-LR_REMO; 2 =  NorESM1-M_RCA4} ; For RCP4.5 {0 = HadGEM2-ES_RCA4; 1 = MPI-ESM-LR_CCLM4; 2 =  GFDL-ESM2M_RCA4} ; For RCP8.5 {0 = HadGEM2-ES_RCA4; 1 = CanESM2_CanRCM4; 2 =  IPSL-CM5A-MR_WRF; 3 = GFDL-ESM2M_RCA4} ;
#0 = RCP2.6; 1 = RCP4.5 ; 2 = RCP8.5
#0 = "SSP1 / We are the world"; 1 = "SSP3 / Icarus"; 2 =  "SSP5 / Should I Stay Or Should I Go" 3 = ;"SSP4 / Riders on the Storm"; 4 = "Baseline"

library(abind)
nam=c("pre","rad","tmn","tmp","tmx")
GCM=c("EC-EARTH_RCA4","MPI-ESM-LR_REMO","NorESM1-M_RCA4","HadGEM2-ES_RCA4","MPI-ESM-LR_CCLM4","GFDL-ESM2M_RCA4","HadGEM2-ES_RCA4","CanESM2_CanRCM4","IPSL-CM5A-MR_WRF","GFDL-ESM2M_RCA4")
ind=list(c(0,1,2),c(0,1,2),c(0,1,2,3))
rread=list.files(pattern=".txt")
dat=list()
for(num in 1:length(rread)){
dat[[num]]=	read.table(rread[num],header=TRUE,sep=",")
}
dd=abind(dat,along=3)##23871*20*150
########yearly data
s2020s=dd[,20,1:50]
s2050s=dd[,20,51:100]
s2080s=dd[,20,101:150]
s20=array(s2020s,c(23871,5,10))
s50=array(s2050s,c(23871,5,10))
s80=array(s2080s,c(23871,5,10))

s20_emi=list(s20[,,1:3],s20[,,4:6],s20[,,7:10])
s50_emi=list(s50[,,1:3],s50[,,4:6],s50[,,7:10])
s20_emi=list(s80[,,1:3],s80[,,4:6],s80[,,7:10])
#########################################load input parameter
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/base_2020s")#dat1,2000*27 variables
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/base_2050s")
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/base_2080s")
k1=dat1[,1:2]##extract emission and model combinations
k2=dat2[,1:2]
k3=dat3[,1:2]
k1=k1+1;k2=k2+1;k3=k3+1
a1=a2=a3=list()
for(i in 1:2000){
a1[[i]]=s20_emi[[k1[i,1]]][,,k1[i,2]]	
}
b1=abind(a1,along=0)
#
for(i in 1:2000){
a2[[i]]=s50_emi[[k2[i,1]]][,,k2[i,2]]	
}
b2=abind(a2,along=0)
for(i in 1:2000){
a3[[i]]=s80_emi[[k3[i,1]]][,,k3[i,2]]	
}
b3=abind(a3,along=0)
setwd("input0")
save(b1,file="base0_2020s")
save(b2,file="base0_2050s")
save(b3,file="base0_2080s")
setwd("..")
rm(dat1,dat2,dat3,a1,a2,a3,b1,b2,b3)
#####################################ICA
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/ica_2020s")#dat1,2000*27 variables
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/ica_2050s")
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/ica_2080s")
k1=dat1[,1:2]##extract emission and model combinations
k2=dat2[,1:2]
k3=dat3[,1:2]
k1=k1+1;k2=k2+1;k3=k3+1
a1=a2=a3=list()
for(i in 1:2000){
a1[[i]]=s20_emi[[k1[i,1]]][,,k1[i,2]]	
}
b1=abind(a1,along=0)
#
for(i in 1:2000){
a2[[i]]=s50_emi[[k2[i,1]]][,,k2[i,2]]	
}
b2=abind(a2,along=0)
for(i in 1:2000){
a3[[i]]=s80_emi[[k3[i,1]]][,,k3[i,2]]	
}
b3=abind(a3,along=0)
setwd("input0")
save(b1,file="ica0_2020s")
save(b2,file="ica0_2050s")
save(b3,file="ica0_2080s")
setwd("..")
rm(dat1,dat2,dat3,a1,a2,a3,b1,b2,b3)
#####################################
#####################################WAW
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/waw_2020s")#dat1,2000*27 variables
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/waw_2050s")
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/waw_2080s")
k1=dat1[,1:2]##extract emission and model combinations
k2=dat2[,1:2]
k3=dat3[,1:2]
k1=k1+1;k2=k2+1;k3=k3+1
a1=a2=a3=list()
for(i in 1:2000){
a1[[i]]=s20_emi[[k1[i,1]]][,,k1[i,2]]	
}
b1=abind(a1,along=0)
#
for(i in 1:2000){
a2[[i]]=s50_emi[[k2[i,1]]][,,k2[i,2]]	
}
b2=abind(a2,along=0)
for(i in 1:2000){
a3[[i]]=s80_emi[[k3[i,1]]][,,k3[i,2]]	
}
b3=abind(a3,along=0)
setwd("input0")
save(b1,file="waw0_2020s")
save(b2,file="waw0_2050s")
save(b3,file="waw0_2080s")
setwd("..")
rm(dat1,dat2,dat3,a1,a2,a3,b1,b2,b3)
#####################################
#####################################ROS
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/ros_2020s")#dat1,2000*27 variables
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/ros_2050s")
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/ros_2080s")
k1=dat1[,1:2]##extract emission and model combinations
k2=dat2[,1:2]
k3=dat3[,1:2]
k1=k1+1;k2=k2+1;k3=k3+1
a1=a2=a3=list()
for(i in 1:2000){
a1[[i]]=s20_emi[[k1[i,1]]][,,k1[i,2]]	
}
b1=abind(a1,along=0)
#
for(i in 1:2000){
a2[[i]]=s50_emi[[k2[i,1]]][,,k2[i,2]]	
}
b2=abind(a2,along=0)
for(i in 1:2000){
a3[[i]]=s80_emi[[k3[i,1]]][,,k3[i,2]]	
}
b3=abind(a3,along=0)
setwd("input0")
save(b1,file="ros0_2020s")
save(b2,file="ros0_2050s")
save(b3,file="ros0_2080s")
setwd("..")
rm(dat1,dat2,dat3,a1,a2,a3,b1,b2,b3)
#####################################
#####################################SIG
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/sig_2020s")#dat1,2000*27 variables
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/sig_2050s")
load("/scratch/hpc/37/oyebamij/landuse/Baseline/input/sig_2080s")
k1=dat1[,1:2]##extract emission and model combinations
k2=dat2[,1:2]
k3=dat3[,1:2]
k1=k1+1;k2=k2+1;k3=k3+1
a1=a2=a3=list()
for(i in 1:2000){
a1[[i]]=s20_emi[[k1[i,1]]][,,k1[i,2]]	
}
b1=abind(a1,along=0)
#
for(i in 1:2000){
a2[[i]]=s50_emi[[k2[i,1]]][,,k2[i,2]]	
}
b2=abind(a2,along=0)
for(i in 1:2000){
a3[[i]]=s80_emi[[k3[i,1]]][,,k3[i,2]]	
}
b3=abind(a3,along=0)
setwd("input0")
save(b1,file="sig0_2020s")
save(b2,file="sig0_2050s")
save(b3,file="sig0_2080s")
setwd("..")
rm(dat1,dat2,dat3,a1,a2,a3,b1,b2,b3)
#####################################
