##############################DOE
#"csaveCMEEuropeWAW2050_8.csv" 
set.seed(3)
library(lhs)
library(abind)
Timeslice=c("2020s","2050s","2080s")
emissionComboBox=c(0,1,2)##
sensitivityComboBox=1
modelComboBox=c(0,1,2,3)
ComboBoxSES=c(0,1,2,3,4)
CaseStudy="Europe"
KeyField=paste(CaseStudy)
SSE=c("WAW","ICA","SIG","ROS","Baseline")
setwd("C:\\Users\\user\\Desktop\\CLIMSAVE\\Inputs")
#v1=read.csv("BatchfilesSIG2050/csaveCMEEuropeSIG2050_8.csv",header=TRUE)
v2=read.csv("SSE.csv",header=TRUE)

nam0=c("KeyField","CaseStudy","Timeslice","emissionComboBox","modelComboBox","sensitivityComboBox","ComboBoxSES")
########## Variable "capital"
nam2=c("new_hcRButtonVeryLow","new_hcRButtonLow","new_hcRButtonMedium","new_hcRButtonHigh","new_hcRButtonVeryHigh",
"new_scRButtonVeryLow","new_scRButtonLow","new_scRButtonMedium","new_scRButtonHigh","new_scRButtonVeryHigh",
"new_mcRButtonVeryLow","new_mcRButtonLow","new_mcRButtonMedium","new_mcRButtonHigh","new_mcRButtonVeryHigh",
"new_fcRButtonVeryLow","new_fcRButtonLow","new_fcRButtonMedium","new_fcRButtonHigh","new_fcRButtonVeryHigh",
"new_hcRButtonVeryLow2050","new_hcRButtonLow2050","new_hcRButtonMedium2050","new_hcRButtonHigh2050",
"new_hcRButtonVeryHigh2050","new_scRButtonVeryLow2050","new_scRButtonLow2050","new_scRButtonMedium2050",
"new_scRButtonHigh2050","new_scRButtonVeryHigh2050","new_mcRButtonVeryLow2050","new_mcRButtonLow2050",
"new_mcRButtonMedium2050","new_mcRButtonHigh2050","new_mcRButtonVeryHigh2050","new_fcRButtonVeryLow2050",	
"new_fcRButtonLow2050","new_fcRButtonMedium2050","new_fcRButtonHigh2050","new_fcRButtonVeryHigh2050","new_hcRButtonVeryLow2100",
"new_hcRButtonLow2100","new_hcRButtonMedium2100","new_hcRButtonHigh2100","new_hcRButtonVeryHigh2100","new_scRButtonVeryLow2100",
"new_scRButtonLow2100","new_scRButtonMedium2100","new_scRButtonHigh2100","new_scRButtonVeryHigh2100","new_mcRButtonVeryLow2100",
"new_mcRButtonLow2100","new_mcRButtonMedium2100","new_mcRButtonHigh2100","new_mcRButtonVeryHigh2100","new_fcRButtonVeryLow2100",
"new_fcRButtonLow2100","new_fcRButtonMedium2100","new_fcRButtonHigh2100","new_fcRButtonVeryHigh2100")

nam3=c("floodProtectionRadioButtonLow","floodProtectionRadioButtonMedium","floodProtectionRadioButtonHeigh")	
base=c(0,0	,1	,0,	0	,0	,0,	1,	0	,0	,0	,0	,1,	0	,0	,0	,0,	1,	
0,0,0,0,	1,	0,	0,	0,	0,	1,	0,	0,	0,	0,	1,	0,	0,	0,	0,	1,	0,	
0,	0,	0,	1,	0,	0,	0,	0,	1,	0,	0,	0,	0,	1,	0,	0,	0,	0,	1,	0,	0)
#########################################################
dirname=getwd()
ppara=v2[,1]
nvar=nrow(v2)##20
nvar2=2
nvar3=3
npoints=100###nunber of experimental design points
N=20
eps=1
text0=text1=text2=text3=list()
for(kk in ComboBoxSES){
				 sse=sub("kk",kk,SSE[kk+1])
				 sse0=kk
				 dir.create(sse)
setwd(sse)
#
for(ii in 1:3){##timeslices	
	ttime=sub("ii",ii,Timeslice[ii])
	dir.create(ttime)
setwd(ttime)			 
#####
for(jj in 1:N){#####Number of iterations
###	generate 20 continuous parameters			 
val=eval(parse(text=paste("v2$standard",ttime,sep="_")))
min1=eval(parse(text=sub("ii",ii,paste("v2$min",Timeslice[ii],sep="_"))))
max1=eval(parse(text=sub("ii",ii,paste("v2$max",Timeslice[ii],sep="_"))))
#hyper=maximinLHS(npoints,nvar)
hyper=optimumLHS(npoints,nvar, maxSweeps = 2, eps = 0.01)
design= matrix(NA,nrow=npoints, ncol=nvar)
for(j in 1:nvar){
design[,j]=signif(qunif(hyper[,j], min=min1[j]*.9, max=max1[j]*.9),4)##multiply by 0.9 to avoid extreme values
}
design[1,]=val###include baseline values
colnames(design)=ppara

######Generate 2 factor variable scenarios[emissionComboBox, modelComboBox]
design2= matrix(NA,nrow=npoints*5, ncol=nvar2)
hyper2=randomLHS(npoints*5,nvar2)
emi=design2[,1] <- floor(qunif(hyper2[,1], 0, 2+eps)) 
mod=design2[,2] <- floor(qunif(hyper2[,2], 0, 3+eps))
v0=cbind(emi,mod) 
id=which(v0[,1]<2 & v0[,2]==3)
v1=v0[-id,][1:npoints,]
#########Generate 3 factor variable scenarios[floodProtectionRadioButtonLow,floodProtectionRadioButtonMedium,floodProtectionRadioButtonHeigh]
X0 <- randomLHS(1000, 3) 
xx=X0
for(i in 1:3){
xx[,i]=round(runif(X0[,i], 0, 1) )
}
xxx=xx[rowSums(xx)==1,]
design3=xxx[1:npoints,]#take the first 100 samples that equivalent to a rowsum of 1.
colnames(design3)=nam3
########################
KeyField=paste(CaseStudy,sse,ttime,(((jj*npoints)-99):(jj*npoints)),sep="")
#dat=matrix(rep(c(CaseStudy,ttime,emi,mod,sensitivityComboBox,sse0),npoints),nrow=npoints,byrow=TRUE)
dat=cbind(CaseStudy,ttime,v1,sensitivityComboBox,sse0)
dat2=(cbind(KeyField,dat))
colnames(dat2)=noquote(nam0)
text=cbind(dat2,design,design3)
g1=data.frame(text,stringsAsFactors = FALSE)
g2=lapply(g1, type.convert)
g3=abind(g2,along=2)
text0=as.data.frame(g3)
text0[,1:3]=noquote(text[,1:3])
print(jj)
Key=paste(CaseStudy,sse,ttime,sep="")
text1=noquote(text0)
write.csv(text0,quote=FALSE,paste(Key,sub("jj",jj,"_jj.csv"),sep=""),row.names=FALSE)
}
setwd("..")
}
setwd("..")
}
#########################################END
################################
X <- t(as.matrix(expand.grid(0:3, 0:3))); X <- X[, colSums(X) <= 3]
X0=t(rmultinom(100, size = 4, prob = c(0.1,0.2,0.8)))
X0=X0[, colSums(X0) <= 1]
#
X0=t(rmultinom(100, size = 1, prob = c(0.1,0.2,0.8)))
X0[rowSums(X0) == 1,]
 ceiling(qunif(x[,1], 0, 3)) 

########
X <- randomLHS(1000, 3) 
xx=X
for(i in 1:3){
xx[,i]=round(runif(X[,i], 0, 1) )
}
xxx=xx[rowSums(xx)<=1,]
#take the first 100 samples that give a rowsum equals 1.
