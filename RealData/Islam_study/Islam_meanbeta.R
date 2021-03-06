library(bayNorm)
source("E:/RNAseqProject/MANY_DE_FUN.R")
source("E:/RNAseqProject/MANY_NORM_FUN.R")

Top1000_Jaakkola<-read.table(file="E:/RNAseqProject/NEWPROJECT_PAPERS/Classical paper/DE_Comparison of methods to detect differentially/Top1000_Jaakkola.txt")

DAT_Jaakkola<-read.delim("E:/RNAseqProject/NEWPROJECT_PAPERS/Classical paper/DE_Comparison of methods to detect differentially/Islam_overlap.txt", sep = "\t" , header = T)

length(intersect(Top1000_Jaakkola$V1,rownames(DAT_Jaakkola)))
DAT_Jaakkola<-as.matrix(DAT_Jaakkola)
length(which(rowSums(DAT_Jaakkola)==0))
drop<-which(rowSums(DAT_Jaakkola)==0)
length(drop)


TRUE_LABEL<-rep(0,dim(DAT_Jaakkola)[1])
names(TRUE_LABEL)<-rownames(DAT_Jaakkola)
#length(intersect(as.character(Top1000_Jaakkola$V1),rownames(DAT_Jaakkola)))
TRUE_LABEL[which(rownames(DAT_Jaakkola) %in% as.character(Top1000_Jaakkola$V1))]<-1
grs = table(substr(colnames(DAT_Jaakkola),1,2))
DAT_Jaakkola<-DAT_Jaakkola[-drop,]
TRUE_LABEL<-TRUE_LABEL[-drop]
max(DAT_Jaakkola)
dim(DAT_Jaakkola)


CONDITION<-c(rep(1,grs[1]),rep(2,grs[2]))

library(scran)
library(foreach)

tttemp<-round(cbind(DAT_Jaakkola[,CONDITION==1]/10,DAT_Jaakkola[,CONDITION==2]/10))
summary(colSums(tttemp))

sf_scran<-computeSumFactors(tttemp, sizes=c(20,30,40,50),positive=T)




###1.5% mean BETA#########
BETA_0015<-sf_scran/mean(sf_scran)*0.015
names(BETA_0015)<-colnames(DAT_Jaakkola)
BETA_0015[which(BETA_0015==0)]=min(BETA_0015[BETA_0015>0])
summary(BETA_0015[CONDITION==1])
summary(BETA_0015[CONDITION==2])


library(bayNorm)
mBAY_LL_out_0015<-bayNorm(Data=DAT_Jaakkola,BETA_vec=BETA_0015,S=1000,parallel=T,NCores=5,FIX_MU = T,GR=F,Conditions=CONDITION,BB_SIZE = T,mode_version = F,mean_version = T,UMI_sffl=c(10,10),Prior_type = 'LL',verbose = T)

aBAY_LL_out_0015<-bayNorm_sup(Data=DAT_Jaakkola,BETA_vec = unlist(mBAY_LL_out_0015$BETA),PRIORS = mBAY_LL_out_0015$PRIORS_LIST,Conditions = CONDITION,S=20,UMI_sffl=c(10,10))

library(abind)
qq<-abind(aBAY_LL_out_0015$Bay_array_list,along=2)
M_aBAY_LL_0015<-SCnorm_runMAST3(Data=qq,NumCells=as.numeric(table(CONDITION)))

M_mBAY_LL_0015<-SCnorm_runMAST(Data=cbind(mBAY_LL_out_0015$Bay_mat_list$`Group 1`,mBAY_LL_out_0015$Bay_mat_list$`Group 2`),NumCells=as.numeric(table(CONDITION)))
T_mBAY_LL_0015<-wilcox_fun(cells=mBAY_LL_out_0015$Bay_mat_list$`Group 1`,ctrls=mBAY_LL_out_0015$Bay_mat_list$`Group 2`)
save(mBAY_LL_out_0015,M_mBAY_LL_0015,T_mBAY_LL_0015,aBAY_LL_out_0015,M_aBAY_LL_0015,file="E:/RNAseqProject/NEWPROJECT_PAPERS/Classical paper/DE_Comparison of methods to detect differentially/BAY_scale_10/FINAL/meanBAY_results_0015.RData")



######6% mean BETA###########
BETA_006<-sf_scran/mean(sf_scran)*0.06
names(BETA_006)<-colnames(DAT_Jaakkola)
BETA_006[which(BETA_006==0)]=min(BETA_006[BETA_006>0])
summary(BETA_006[CONDITION==1])
summary(BETA_006[CONDITION==2])


library(bayNorm)
mBAY_LL_out_006<-bayNorm(Data=DAT_Jaakkola,BETA_vec=BETA_006,S=1000,parallel=T,NCores=5,FIX_MU = T,GR=F,Conditions=CONDITION,BB_SIZE = T,mode_version = F,mean_version = T,UMI_sffl=c(10,10),Prior_type = 'LL',verbose = T)

aBAY_LL_out_006<-bayNorm_sup(Data=DAT_Jaakkola,BETA_vec = unlist(mBAY_LL_out_006$BETA),PRIORS = mBAY_LL_out_006$PRIORS_LIST,Conditions = CONDITION,S=20,UMI_sffl=c(10,10))

library(abind)
qq<-abind(aBAY_LL_out_006$Bay_array_list,along=2)
M_aBAY_LL_006<-SCnorm_runMAST3(Data=qq,NumCells=as.numeric(table(CONDITION)))


M_mBAY_LL_006<-SCnorm_runMAST(Data=cbind(mBAY_LL_out_006$Bay_mat_list$`Group 1`,mBAY_LL_out_006$Bay_mat_list$`Group 2`),NumCells=as.numeric(table(CONDITION)))
T_mBAY_LL_006<-wilcox_fun(cells=mBAY_LL_out_006$Bay_mat_list$`Group 1`,ctrls=mBAY_LL_out_006$Bay_mat_list$`Group 2`)

save(mBAY_LL_out_006,M_mBAY_LL_006,T_mBAY_LL_006,aBAY_LL_out_006,M_aBAY_LL_006,file="E:/RNAseqProject/NEWPROJECT_PAPERS/Classical paper/DE_Comparison of methods to detect differentially/BAY_scale_10/FINAL/meanBAY_results_006.RData")


###analysis####
load("Islam_many_normalizations.RData")
load("E:/RNAseqProject/NEWPROJECT_PAPERS/Classical paper/DE_Comparison of methods to detect differentially/BAY_scale_10/FINAL/meanBAY_results_006.RData")
load("E:/RNAseqProject/NEWPROJECT_PAPERS/Classical paper/DE_Comparison of methods to detect differentially/BAY_scale_10/FINAL/meanBAY_results_0015.RData")






MAST_RE_LIST<-list(MAST_abay_003=apply(MAST_bay_mat,1,median),MAST_abay_0015=apply(M_aBAY_LL_0015,1,median),MAST_abay_006=apply(M_aBAY_LL_006,1,median),MAST_bay_003=M_mBAY_LL$adjpval,MAST_bay_0015=M_mBAY_LL_0015$adjpval,MAST_bay_006=M_mBAY_LL_006$adjpval)



TRUE_LABEL_input<-TRUE_LABEL
TRUE_LABEL_input[TRUE_LABEL_input==0]=3
TRUE_LABEL_input[TRUE_LABEL_input==1]=0
TRUE_LABEL_input[TRUE_LABEL_input==3]=1


library(foreach)
source("E:/RNAseqProject/MANY_DE_FUN.R")
source("E:/RNAseqProject/MANY_NORM_FUN.R")

mmme<-'MAST'
auc_vec_M<-NULL
Input_re_list<-MAST_RE_LIST



library(ROCR)
list_pref_M<-foreach(i=1:length(Input_re_list))%do%{
    pred_MAST <- prediction(Input_re_list[[i]], TRUE_LABEL_input)
    perf_MAST <- performance( pred_MAST, "tpr", "fpr" )
    
    auc_temp<-performance( pred_MAST, measure='auc' )
    auc_temp<-auc_temp@y.values[[1]]
    auc_vec_M<-c(auc_vec_M,auc_temp)
    return(perf_MAST)
}





method_vec<-c('bayNorm_20_3%:','bayNorm_20_1.5%:','bayNorm_20_6%:','bayNorm_mean_3%:','bayNorm_mean_1.5%:','bayNorm_mean_6%:')


cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
names(cbbPalette )<-c('bayNorm_20_1.5%:','bayNorm_20_3%:','bayNorm_20_6%:','bayNorm_mean_3%:','bayNorm_mean_1.5%:','bayNorm_mean_6%:','NULL1','NULL2')
col_vec<-cbbPalette[method_vec]


#Fig S23 (b)
ROC_fun(list_pref=list_pref_M,vec_auc=auc_vec_M,method_vec=method_vec,col_vec=col_vec,MAIN=paste(''),cex=1,cex.axis=1,lwd=1.5,cex.lab=1,cex.legend=1,line=2)
abline(0,1,lty=2)
dev.off()

