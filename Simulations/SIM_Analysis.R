CV_fun<-function(data){
    
    if(length(dim(data))!=3){
        data_sd<-apply(data,1,sd)
        cv<-data_sd  /rowMeans(data)
    } else if(length(dim(data))==3){
        MuTest<-apply(data,1,mean)
        SdTest<-apply(apply(data, c(1,3), sd), 1, mean)
        cv<-SdTest/MuTest
    }

    return(cv)
}

source("E:/RNAseqProject/MANY_DE_FUN.R")
source("E:/RNAseqProject/MANY_NORM_FUN.R")
#SIM1: B_01_01_D_02_0#############
load("E:/RNAseqProject/SIMULATION/SIM_1/SIM_1.RData")


BAY_OUT_S1<-mbayNorm_out
TRUE_MU_S1<-TrueMU
TRUE_SIZE_S1_1<-TrueSIZES1
TRUE_SIZE_S1_2<-TrueSIZES2
DROP_S1<-DROP

TRUE_DAT_S1<-SCE@assays$data$TrueCounts[-DROP_S1,]
TRUE_CV_S1_1<-CV_fun(TRUE_DAT_S1[,CONDITION==1])
TRUE_CV_S1_2<-CV_fun(TRUE_DAT_S1[,CONDITION==2])

# EST_CV_S1_1<-CV_fun(BAY_OUT_S1$Bay_mat_list$`Group 1`)
# EST_CV_S1_2<-CV_fun(BAY_OUT_S1$Bay_mat_list$`Group 2`)
EST_CV_S1_1<-CV_fun(bayNorm_out$Bay_array_list$`Group 1`)
EST_CV_S1_2<-CV_fun(bayNorm_out$Bay_array_list$`Group 2`)

EST_MU_S1_1<-rowMeans(BAY_OUT_S1$Bay_mat_list$`Group 1`)
EST_MU_S1_2<-rowMeans(BAY_OUT_S1$Bay_mat_list$`Group 2`)

EST_SD_S1_1<-apply(BAY_OUT_S1$Bay_mat_list$`Group 1`,1, sd)
EST_SD_S1_2<-apply(BAY_OUT_S1$Bay_mat_list$`Group 2`,1, sd)

EST_SIZE_S1_1<-EST_MU_S1_1^2/(EST_SD_S1_1^2-EST_MU_S1_1)
EST_SIZE_S1_2<-EST_MU_S1_2^2/(EST_SD_S1_2^2-EST_MU_S1_2)



TRUE_LABEL_S1<-TRUE_LABEL
TRUE_LABEL_reverse_S1<-TRUE_LABEL
TRUE_LABEL_reverse_S1[TRUE_LABEL_reverse_S1==1]=3
TRUE_LABEL_reverse_S1[TRUE_LABEL_reverse_S1==0]=1
TRUE_LABEL_reverse_S1[TRUE_LABEL_reverse_S1==3]=0


# load("E:/RNAseqProject/SIMULATION/SIM_1/M_T_RESULTS.RData")
# S1_M_list<-list(bayNorm=M_mbayNorm$adjpval,SAVER=M_saver$adjpval,scImpute=M_scImpute$adjpval,SCnorm=M_scnorm$adjpval,Scaling=M_RB$adjpval,MAGIC=M_MAGIC$adjpval,DCA=M_DCA$adjpval)


S1_M_list2<-list(bayNorm_10=apply(M_bay10,1,median),SAVER_10=apply(M_saver10,1,median),bayNorm_mean=M_mbayNorm$adjpval,SAVER_mean=M_saver$adjpval,scImpute=M_scImpute$adjpval,SCnorm=M_scnorm$adjpval,Scaling=M_RB$adjpval,MAGIC=M_MAGIC$adjpval,DCA=M_DCA$adjpval)




#SIM2: B_005_01_D_02_0#############
load("E:/RNAseqProject/SIMULATION/SIM_005_01/SIM_005_01.RData")



BAY_OUT_S2<-mbayNorm_out
TRUE_MU_S2<-TrueMU
TRUE_SIZE_S2_1<-TrueSIZES1
TRUE_SIZE_S2_2<-TrueSIZES2
DROP_S2<-DROP

EST_MU_S2_1<-rowMeans(BAY_OUT_S2$Bay_mat_list$`Group 1`)
EST_MU_S2_2<-rowMeans(BAY_OUT_S2$Bay_mat_list$`Group 2`)

EST_SD_S2_1<-apply(BAY_OUT_S2$Bay_mat_list$`Group 1`,1, sd)
EST_SD_S2_2<-apply(BAY_OUT_S2$Bay_mat_list$`Group 2`,1, sd)


EST_SIZE_S2_1<-EST_MU_S2_1^2/(EST_SD_S2_1^2-EST_MU_S2_1)
EST_SIZE_S2_2<-EST_MU_S2_2^2/(EST_SD_S2_2^2-EST_MU_S2_2)


TRUE_LABEL_S2<-TRUE_LABEL
TRUE_LABEL_reverse_S2<-TRUE_LABEL
TRUE_LABEL_reverse_S2[TRUE_LABEL_reverse_S2==1]=3
TRUE_LABEL_reverse_S2[TRUE_LABEL_reverse_S2==0]=1
TRUE_LABEL_reverse_S2[TRUE_LABEL_reverse_S2==3]=0


#S2_M_list<-list(bayNorm=M_mbayNorm$adjpval,SAVER=M_saver$adjpval,scImpute=M_scImpute$adjpval,SCnorm=M_scnorm$adjpval,Scaling=M_RB$adjpval,MAGIC=M_MAGIC$adjpval,DCA=M_DCA$adjpval)

S2_M_list2<-list(bayNorm_10=apply(M_bay10,1,median),SAVER_10=apply(M_saver10,1,median),bayNorm_mean=M_mbayNorm$adjpval,SAVER_mean=M_saver$adjpval,scImpute=M_scImpute$adjpval,SCnorm=M_scnorm$adjpval,Scaling=M_RB$adjpval,MAGIC=M_MAGIC$adjpval,DCA=M_DCA$adjpval)



#SIM3: B_005_005_D_02_0#############
load("E:/RNAseqProject/SIMULATION/SIM_005_005/SIM_005_005.RData")



BAY_OUT_S3<-mbayNorm_out
TRUE_MU_S3<-TrueMU
TRUE_SIZE_S3_1<-TrueSIZES1
TRUE_SIZE_S3_2<-TrueSIZES2
DROP_S3<-DROP

all.equal(rownames(BAY_OUT_S3$Bay_mat_list$`Group 1`),names(M_MAGIC_005_005$adjpval))

EST_MU_S3_1<-rowMeans(BAY_OUT_S3$Bay_mat_list$`Group 1`)
EST_MU_S3_2<-rowMeans(BAY_OUT_S3$Bay_mat_list$`Group 2`)

EST_SD_S3_1<-apply(BAY_OUT_S3$Bay_mat_list$`Group 1`, 1, sd)
EST_SD_S3_2<-apply(BAY_OUT_S3$Bay_mat_list$`Group 2`, 1, sd)

EST_SIZE_S3_1<-EST_MU_S3_1^2/(EST_SD_S3_1^2-EST_MU_S3_1)
EST_SIZE_S3_2<-EST_MU_S3_2^2/(EST_SD_S3_2^2-EST_MU_S3_2)

TRUE_LABEL_S3<-TRUE_LABEL
TRUE_LABEL_reverse_S3<-TRUE_LABEL
TRUE_LABEL_reverse_S3[TRUE_LABEL_reverse_S3==1]=3
TRUE_LABEL_reverse_S3[TRUE_LABEL_reverse_S3==0]=1
TRUE_LABEL_reverse_S3[TRUE_LABEL_reverse_S3==3]=0


#S3_M_list<-list(bayNorm=M_mbayNorm$adjpval,SAVER=M_saver$adjpval,scImpute=M_scImpute$adjpval,SCnorm=M_scnorm$adjpval,Scaling=M_RB$adjpval,MAGIC=M_MAGIC_005_005$adjpval,DCA=M_DCA$adjpval)

S3_M_list2<-list(bayNorm_10=apply(M_bay10,1,median),SAVER_10=apply(M_saver10,1,median),bayNorm_mean=M_mbayNorm$adjpval,SAVER_mean=M_saver$adjpval,scImpute=M_scImpute$adjpval,SCnorm=M_scnorm$adjpval,Scaling=M_RB$adjpval,MAGIC=M_MAGIC_005_005$adjpval,DCA=M_DCA$adjpval)


#SIM4: B_01_005_D_02_0#############
load("E:/RNAseqProject/SIMULATION/SIM_01_005/SIM_01_005.RData")

BAY_OUT_S4<-mbayNorm_out
TRUE_MU_S4<-TrueMU
TRUE_SIZE_S4_1<-TrueSIZES1
TRUE_SIZE_S4_2<-TrueSIZES2
DROP_S4<-DROP

all.equal(rownames(BAY_OUT_S4$Bay_mat_list$`Group 1`),names(M_MAGIC_01_005$adjpval))

TRUE_LABEL_S4<-TRUE_LABEL
TRUE_LABEL_reverse_S4<-TRUE_LABEL
TRUE_LABEL_reverse_S4[TRUE_LABEL_reverse_S4==1]=3
TRUE_LABEL_reverse_S4[TRUE_LABEL_reverse_S4==0]=1
TRUE_LABEL_reverse_S4[TRUE_LABEL_reverse_S4==3]=0



#S4_M_list<-list(bayNorm=M_mbayNorm$adjpval,SAVER=M_saver$adjpval,scImpute=M_scImpute$adjpval,SCnorm=M_scnorm$adjpval,Scaling=M_RB$adjpval,MAGIC=M_MAGIC_01_005$adjpval,DCA=M_DCA$adjpval)

S4_M_list2<-list(bayNorm_10=apply(M_bay10,1,median),SAVER_10=apply(M_saver10,1,median),bayNorm_mean=M_mbayNorm$adjpval,SAVER_mean=M_saver$adjpval,scImpute=M_scImpute$adjpval,SCnorm=M_scnorm$adjpval,Scaling=M_RB$adjpval,MAGIC=M_MAGIC_01_005$adjpval,DCA=M_DCA$adjpval)


EST_MU_S4_1<-rowMeans(BAY_OUT_S4$Bay_mat_list$`Group 1`)
EST_MU_S4_2<-rowMeans(BAY_OUT_S4$Bay_mat_list$`Group 2`)

EST_SD_S4_1<-apply(BAY_OUT_S4$Bay_mat_list$`Group 1`,1, sd)
EST_SD_S4_2<-apply(BAY_OUT_S4$Bay_mat_list$`Group 2`,1, sd)

EST_SIZE_S4_1<-EST_MU_S4_1^2/(EST_SD_S4_1^2-EST_MU_S4_1)
EST_SIZE_S4_2<-EST_MU_S4_2^2/(EST_SD_S4_2^2-EST_MU_S4_2)

plot(TRUE_SIZE_S4_2,BAY_OUT_S4$PRIORS_LIST$`Group 2`$MME_SIZE_adjust,log='xy')
abline(0,1)




save.image("E:/RNAseqProject/SIMULATION/SIM_Analysis_loadall.RData")

#####BEGIN ANALYSIS##########

load("E:/RNAseqProject/SIMULATION/SIM_Analysis_loadall.RData")





#BB SIZE: Fig S28######
cex=4
cex.lab=1.5
cex.axis=1.5
line=1.5
lwd=3
cex.main=1.5
linecol<-2

jpeg("E:/RNAseqProject/SIMULATION/RESULTS/BB_SIZE.jpeg", width = 8, height = 9, units = 'in', res = 300)
#pdf("E:/RNAseqProject/SIMULATION/RESULTS/BB_SIZE.pdf",width = 7.5, height = 9)

par(mfrow=c(4,2))
plot(TRUE_SIZE_S1_1,BAY_OUT_S1$PRIORS_LIST$`Group 1`$BB_prior[,2],main='SIM I, group 1',xlab='True size',ylab='BB estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)
plot(TRUE_SIZE_S1_2,BAY_OUT_S1$PRIORS_LIST$`Group 2`$BB_prior[,2],main='SIM I, group 2',xlab='True size',ylab='BB estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)

plot(TRUE_SIZE_S2_1,BAY_OUT_S2$PRIORS_LIST$`Group 1`$BB_prior[,2],main='SIM II, group 1',xlab='True size',ylab='BB estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)
plot(TRUE_SIZE_S2_2,BAY_OUT_S2$PRIORS_LIST$`Group 2`$BB_prior[,2],main='SIM II, group 2',xlab='True size',ylab='BB estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)

plot(TRUE_SIZE_S3_1,BAY_OUT_S3$PRIORS_LIST$`Group 1`$BB_prior[,2],main='SIM III, group 1',xlab='True size',ylab='BB estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)
plot(TRUE_SIZE_S3_2,BAY_OUT_S3$PRIORS_LIST$`Group 2`$BB_prior[,2],main='SIM III, group 2',xlab='True size',ylab='BB estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)

plot(TRUE_SIZE_S4_1,BAY_OUT_S4$PRIORS_LIST$`Group 1`$BB_prior[,2],main='SIM IV, group 1',xlab='True size',ylab='BB estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)
plot(TRUE_SIZE_S4_2,BAY_OUT_S4$PRIORS_LIST$`Group 2`$BB_prior[,2],main='SIM IV, group 2',xlab='True size',ylab='BB estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)

dev.off()


#MME adjusted SIZE: Fig S29######


jpeg("E:/RNAseqProject/SIMULATION/RESULTS/MMEadj_SIZE.jpeg", width = 8, height = 9, units = 'in', res = 300)
#pdf("E:/RNAseqProject/SIMULATION/RESULTS/MMEadj_SIZE.pdf",width = 7.5, height = 9)

xlab='True size'
ylab='Adjusted MME size'

par(mfrow=c(4,2))
plot(TRUE_SIZE_S1_1,BAY_OUT_S1$PRIORS_LIST$`Group 1`$MME_SIZE_adjust,main='SIM I, group 1',xlab=xlab,ylab=ylab,log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)
plot(TRUE_SIZE_S1_2,BAY_OUT_S1$PRIORS_LIST$`Group 2`$MME_SIZE_adjust,main='SIM I, group 2',xlab=xlab,ylab=ylab,log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)

plot(TRUE_SIZE_S2_1,BAY_OUT_S2$PRIORS_LIST$`Group 1`$MME_SIZE_adjust,main='SIM II, group 1',xlab=xlab,ylab=ylab,log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)
plot(TRUE_SIZE_S2_2,BAY_OUT_S2$PRIORS_LIST$`Group 2`$MME_SIZE_adjust,main='SIM II, group 2',xlab=xlab,ylab=ylab,log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)

plot(TRUE_SIZE_S3_1,BAY_OUT_S3$PRIORS_LIST$`Group 1`$MME_SIZE_adjust,main='SIM III, group 1',xlab=xlab,ylab=ylab,log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)
plot(TRUE_SIZE_S3_2,BAY_OUT_S3$PRIORS_LIST$`Group 2`$MME_SIZE_adjust,main='SIM III, group 2',xlab=xlab,ylab=ylab,log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)

plot(TRUE_SIZE_S4_1,BAY_OUT_S4$PRIORS_LIST$`Group 1`$MME_SIZE_adjust,main='SIM IV, group 1',xlab=xlab,ylab=ylab,log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)
plot(TRUE_SIZE_S4_2,BAY_OUT_S4$PRIORS_LIST$`Group 2`$MME_SIZE_adjust,main='SIM IV, group 2',xlab=xlab,ylab=ylab,log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lty=2,lwd=lwd,col=linecol)

dev.off()



#MME SIZE: Fig S27######


jpeg("E:/RNAseqProject/SIMULATION/RESULTS/MME_SIZE.jpeg", width = 8, height = 9, units = 'in', res = 300)
#pdf("E:/RNAseqProject/SIMULATION/RESULTS/MME_SIZE.pdf", width = 8, height = 9)

par(mfrow=c(4,2))
plot(TRUE_SIZE_S1_1,BAY_OUT_S1$PRIORS_LIST$`Group 1`$MME_prior$MME_SIZE,main='SIM I, group 1',xlab='True size',ylab='MME estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lwd=lwd,lty=2,col=linecol)
plot(TRUE_SIZE_S1_2,BAY_OUT_S1$PRIORS_LIST$`Group 2`$MME_prior$MME_SIZE,main='SIM I, group 2',xlab='True size',ylab='MME estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lwd=lwd,lty=2,col=linecol)

plot(TRUE_SIZE_S2_1,BAY_OUT_S2$PRIORS_LIST$`Group 1`$MME_prior$MME_SIZE,main='SIM II, group 1',xlab='True size',ylab='MME estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lwd=lwd,lty=2,col=linecol)
plot(TRUE_SIZE_S2_2,BAY_OUT_S2$PRIORS_LIST$`Group 2`$MME_prior$MME_SIZE,main='SIM II, group 2',xlab='True size',ylab='MME estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lwd=lwd,lty=2,col=linecol)

plot(TRUE_SIZE_S3_1,BAY_OUT_S3$PRIORS_LIST$`Group 1`$MME_prior$MME_SIZE,main='SIM III, group 1',xlab='True size',ylab='MME estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lwd=lwd,lty=2,col=linecol)
plot(TRUE_SIZE_S3_2,BAY_OUT_S3$PRIORS_LIST$`Group 2`$MME_prior$MME_SIZE,main='SIM III, group 2',xlab='True size',ylab='MME estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lwd=lwd,lty=2,col=linecol)

plot(TRUE_SIZE_S4_1,BAY_OUT_S4$PRIORS_LIST$`Group 1`$MME_prior$MME_SIZE,main='SIM IV, group 1',xlab='True size',ylab='MME estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lwd=lwd,lty=2,col=linecol)
plot(TRUE_SIZE_S4_2,BAY_OUT_S4$PRIORS_LIST$`Group 2`$MME_prior$MME_SIZE,main='SIM IV, group 2',xlab='True size',ylab='MME estimated size',log='xy',pch='.',cex=cex,cex.lab=cex.lab,cex.main=cex.main,cex.axis=cex.axis)
abline(0,1,lwd=lwd,lty=2,col=linecol)

dev.off()

####ROC curves: Fig S22#######
ROC_plot<-function(Input_re_list,TRUE_LABEL_reverse,cex=1,lwd=1,cex.lab=1,cex.axis=1,cex.legend=1,line=2.5) {
    
    auc_vec<-NULL
    TRUE_LABEL_input<-TRUE_LABEL_reverse
    table(TRUE_LABEL_input)
    
    library(ROCR)
    list_pref<-foreach(i=1:length(Input_re_list))%do%{
        pred_MAST <- prediction((Input_re_list[[i]]), TRUE_LABEL_input)
        perf_MAST <- performance( pred_MAST, "tpr", "fpr" )
        
        auc_temp<-performance( pred_MAST, measure='auc' )
        auc_temp<-auc_temp@y.values[[1]]
        auc_vec<-c(auc_vec,auc_temp)
        return(perf_MAST)
    }
    
    ROC_fun(list_pref=list_pref,vec_auc=auc_vec,method_vec=method_vec,col_vec=col_vec,MAIN=mainn,cex=cex,lwd=lwd,cex.lab=cex.lab,cex.axis=cex.axis,cex.legend=cex.legend,line=line)
    abline(0,1,lty=2)
}


load("E:/RNAseqProject/SIMULATION/SIM_Analysis_loadall.RData")


source("E:/RNAseqProject/MANY_DE_FUN.R")
source("E:/RNAseqProject/MANY_NORM_FUN.R")


library(foreach)
method_vec<-c('bayNorm_10','SAVER_10','bayNorm_mean','SAVER_mean','scImpute','SCnorm','Scaling','MAGIC','DCA')


cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7",'#990000')
names(cbbPalette )<-c('bayNorm_mean','bayNorm_10','SCnorm','Scaling','SAVER_10','scImpute','MAGIC','SAVER_mean','DCA')

col_vec<-cbbPalette[method_vec]

#col_vec<-seq(1,length(method_vec))
cex=0.6
lwd=2
cex.lab=1
cex.axis=1
cex.legend=0.8
line=2


par(mfrow=c(2,2))

  mainn=''
  ROC_plot(Input_re_list=S1_M_list2,TRUE_LABEL_reverse=TRUE_LABEL_reverse_S1,cex=cex,lwd=lwd,cex.lab=cex.lab,cex.axis=cex.axis,cex.legend=cex.legend,line=line)


  mainn=''
  ROC_plot(Input_re_list=S2_M_list2,TRUE_LABEL_reverse=TRUE_LABEL_reverse_S2,cex=cex,lwd=lwd,cex.lab=cex.lab,cex.axis=cex.axis,cex.legend=cex.legend,line=line)


  mainn=''
  ROC_plot(Input_re_list=S4_M_list2,TRUE_LABEL_reverse=TRUE_LABEL_reverse_S4,cex=cex,lwd=lwd,cex.lab=cex.lab,cex.axis=cex.axis,cex.legend=cex.legend,line=line)

  
  mainn=''
  ROC_plot(Input_re_list=S3_M_list2,TRUE_LABEL_reverse=TRUE_LABEL_reverse_S3,cex=cex,lwd=lwd,cex.lab=cex.lab,cex.axis=cex.axis,cex.legend=cex.legend,line=line)





