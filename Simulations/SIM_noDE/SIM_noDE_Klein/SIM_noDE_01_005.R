source("E:/RNAseqProject/QQsim_v2_SingleCellExperiment.R")
load("E:/RNAseqProject/PROJECT_scRNAseq/FIGURE_DROPOUT/DROPOUT_MAIN/Klein933_DIY.RData")
source("E:/RNAseqProject/TSTAT_140817.r")
source("E:/RNAseqProject/MANY_DE_FUN.R")
source("E:/RNAseqProject/MANY_NORM_FUN.R")
Sim_List_Input$SCE<-NULL
Sim_List_Input$Est_params@counts.norm.TC<-matrix()
library(bayNorm)




#######Begin simulation#######


Est_params<-Sim_List_Input$Est_params
Est_params@nGroups<-2
Est_params@groupCells=c(100,100)
Est_params@nGenes<-10000
Est_params@MeanBeta<-c(0.1,0.05)
Est_params@de.prob<-c(0,0)
Est_params@de.downProb<-c(0,0)
Est_params@de.facLoc<-c(1,1)
Est_params@de.facScale<-c(0.5,0.5)

Est_params@beta.scale

Est_params@out.prob<-0
Est_params@mean.shape

Est_params@Beta<-numeric()
length(Est_params@Beta)


library(splatter)
#Est_params<-newQQParams(nGenes = 10000, nCells = 100,nGroups = 2,groupCells = c(100,100), mean.rate =1/60, mean.shape = 0.35,lib.loc = 10,lib.scale = 0.5,out.prob =0, out.neg.prob=0,out.facLoc = 0.1,out.facScale = 0.05,de.prob = c(0.2,0),de.downProb = c(0.5,0), de.facLoc =c(1,1),de.facScale =c(0.5,0.5),bcv.common = 0.2,bcv.df = 20,SimControl='F',MeanBeta=c(0.1,0.1))

SCE<-QQinitiate(Est_params)
SCE<-QQSimGeneMeans(SCE,Est_params)
#Group
SCE<-QQSimGroupDE(SCE,Est_params)
SCE<-QQSimGroupCellMeans(SCE, Est_params,Effect=F)

SCE<-QQSimBETA(SCE, Est_params)
SCE<-QQSimBCVMeans(SCE,Est_params)
SCE<-QQSimBinomial(SCE,Est_params)


dim(counts(SCE))
CONDITION<-SCE@colData@listData$GroupInd
table(CONDITION)


DROP<-which(rowSums(counts(SCE))==0)




#########True Parameters#####
TrueBeta1<-colData(SCE)$Beta[CONDITION==1]*Est_params@MeanBeta[1]
TrueBeta2<-colData(SCE)$Beta[CONDITION==2]*Est_params@MeanBeta[2]
summary(TrueBeta1)
summary(TrueBeta2)




TrueSIZES1<-1/(rowMeans(SCE@assays@.xData$data$BCV[,CONDITION==1])[-DROP])^2
TrueSIZES2<-1/(rowMeans(SCE@assays@.xData$data$BCV[,CONDITION==2])[-DROP])^2

TrueMU<-rowData(SCE)$BaseGeneMean[-DROP]


#begin bayNorm######
RAW_DAT<-counts(SCE)[-DROP,]
library(scran)
BETA_SCRAN_1<-computeSumFactors(RAW_DAT[,CONDITION==1])
BETA_SCRAN_1<-BETA_SCRAN_1/mean(BETA_SCRAN_1)*Est_params@MeanBeta[1]
BETA_SCRAN_2<-computeSumFactors(RAW_DAT[,CONDITION==2])
BETA_SCRAN_2<-BETA_SCRAN_2/mean(BETA_SCRAN_2)*Est_params@MeanBeta[2]

plot(BETA_SCRAN_1,TrueBeta1,pch=16)
abline(0,1)


library(bayNorm)
#bayNorm_out<-bayNorm(Data<-RAW_DAT,BETA_vec<-c(BETA_SCRAN_1,BETA_SCRAN_2),Conditions=CONDITION,Prior_type = 'GG',S=10)

mbayNorm_out<-bayNorm(Data<-RAW_DAT,BETA_vec<-c(BETA_SCRAN_1,BETA_SCRAN_2),Conditions=CONDITION,mean_version = T,S=1000,Prior_type = 'GG')


gr<-table(CONDITION)
M_mbayNorm<-SCnorm_runMAST(Data=cbind(mbayNorm_out$Bay_mat_list$`Group 1`,mbayNorm_out$Bay_mat_list$`Group 2`),NumCells = gr)
T_mbayNorm<-wilcox_fun(cells=mbayNorm_out$Bay_mat_list$`Group 1`,ctrls=mbayNorm_out$Bay_mat_list$`Group 2`)

R_mbayNorm<-ROTS(data=cbind(mbayNorm_out$Bay_mat_list$`Group 1`,mbayNorm_out$Bay_mat_list$`Group 2`),groups=CONDITION,B=100,log=F)
names(R_mbayNorm)<-rownames(RAW_DAT)






#mode 
modebayNorm_out<-bayNorm_sup(Data=RAW_DAT,BETA_vec=do.call(c,mbayNorm_out$BETA),Conditions=CONDITION,mode_version = T,S=1000,PRIORS=mbayNorm_out$PRIORS_LIST)

modebayNorm_out<-bayNorm_sup(Data<-RAW_DAT,BETA_vec<-c(BETA_SCRAN_1,BETA_SCRAN_2),Conditions=CONDITION,mode_version = T,S=1000,PRIORS =mbayNorm_out$PRIORS_LIST )
M_modebayNorm<-SCnorm_runMAST(Data=cbind(modebayNorm_out$Bay_mat_list$`Group 1`,modebayNorm_out$Bay_mat_list$`Group 2`),NumCells = gr)
T_modebayNorm<-wilcox_fun(cells=modebayNorm_out$Bay_mat_list$`Group 1`,ctrls=modebayNorm_out$Bay_mat_list$`Group 2`)
library(ROTS)
R_modebayNorm<-ROTS(data=cbind(modebayNorm_out$Bay_mat_list$`Group 1`,modebayNorm_out$Bay_mat_list$`Group 2`),groups=CONDITION,B=100,log=F)
names(R_modebayNorm)<-rownames(RAW_DAT)

#array
abayNorm_out<-bayNorm_sup(Data=RAW_DAT,BETA_vec=do.call(c,mbayNorm_out$BETA),Conditions=CONDITION,S=10,PRIORS=mbayNorm_out$PRIORS_LIST)

abayNorm_out<-bayNorm_sup(Data<-RAW_DAT,BETA_vec<-c(BETA_SCRAN_1,BETA_SCRAN_2),Conditions=CONDITION,S=10,PRIORS =mbayNorm_out$PRIORS_LIST )
library(abind)


qq<-abind(modebayNorm_out$Bay_array_list,along=2)
M_abayNorm<-SCnorm_runMAST3(Data=qq,NumCells = gr)
T_abayNorm<-wilcox_fun(cells=abayNorm_out$Bay_array_list$`Group 1`,ctrls=abayNorm_out$Bay_array_list$`Group 2`)
library(ROTS)
library(foreach)
R_abayNorm_temp<-foreach(i=1:10,.combine=cbind)%do%{
    qq<-ROTS(data=cbind(modebayNorm_out$Bay_mat_list$`Group 1`,modebayNorm_out$Bay_mat_list$`Group 2`),groups=CONDITION,B=100,log=F)
    names(qq)<-rownames(RAW_DAT)
    return(qq)
}
R_abayNorm<-apply(R_abayNorm_temp,1,median) 


save.image("E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/SIM_noDE_01_005.RData")






####SAVER#######
load("E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/SIM_noDE_01_005.RData")
library(SAVER)
saver_out<-saver(x=RAW_DAT,size.factor=1/c(BETA_SCRAN_1,BETA_SCRAN_2))

gr<-table(CONDITION)
M_saver<-SCnorm_runMAST(Data=saver_out$estimate,NumCells = gr)
T_saver<-wilcox_fun(cells=saver_out$estimate[,CONDITION==1],ctrls=saver_out$estimate[,CONDITION==2])

# plot(rowMeans(mbayNorm_out$Bay_mat_list$`Group 1`),rowMeans(mbayNorm_out$Bay_mat_list$`Group 2`),log='xy')
# abline(0,1)


save(saver_out,M_saver,file="E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/SAVER_noDE_01_005.RData")



#SCnorm
library(SCnorm)
scnorm_out_ori<-SCnorm(Data=RAW_DAT,Conditions=CONDITION,ditherCounts =T)
scnorm_out<-scnorm_out_ori@metadata$NormalizedData
M_scnorm<-SCnorm_runMAST(Data=scnorm_out,NumCells = gr)
T_scnorm<-wilcox_fun(cells=scnorm_out[,CONDITION==1],ctrls=scnorm_out[,CONDITION==2])
save(scnorm_out_ori,scnorm_out,M_scnorm,T_scnorm,file="E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/SCnorm_noDE_01_005.RData")


#scImpute
source("E:/RNAseqProject/MANY_NORM_FUN.R")
library(scImpute)
scimpute_fun(Data=RAW_DAT,Data_name='DE_noDE_01_005')
#scImpute_out<-readRDS("E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/DE_noDE_01_005scimpute_count.rds")
scImpute_out<-readRDS("E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/DE_noDE_01_005scimpute_count_K1.rds")

length(which(M_scImpute$adjpval<0.05))

gr<-table(CONDITION)
M_scImpute<-SCnorm_runMAST(Data=scImpute_out,NumCells = gr)
T_scImpute<-wilcox_fun(cells=scImpute_out[,which(CONDITION==1)],ctrls=scImpute_out[,which(CONDITION==2)])

save(scImpute_out,M_scImpute,T_scImpute,file="E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/scImpute_noDE_01_005.RData")

#scaling
RB_out<-t(t(RAW_DAT)/c(BETA_SCRAN_1,BETA_SCRAN_2))
gr<-table(CONDITION)
M_RB<-SCnorm_runMAST(Data=RB_out,NumCells = gr)
T_RB<-wilcox_fun(cells=RB_out[,which(CONDITION==1)],ctrls=RB_out[,which(CONDITION==2)])

save(RB_out,M_RB,T_RB,file="E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/RB_noDE_01_005.RData")


##MAGIC#######
load("E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/SIM_noDE_01_005.RData")
qq<-prcomp(t(MAGIC_out),scale. = T)
plot(qq$x[,1:2],col=CONDITION)

library(Rmagic)
MAGIC_out<-run_magic(data=t(RAW_DAT))
rownames(MAGIC_out)<-rownames(t(RAW_DAT))
colnames(MAGIC_out)<-colnames(t(RAW_DAT))
MAGIC_out<-t(MAGIC_out)
gr<-table(CONDITION)
M_magic<-SCnorm_runMAST(Data=MAGIC_out,NumCells = c(100,100))
summary(M_magic$adjpval)
length(which(M_magic$adjpval<0.05))

#save(MAGIC_out,M_magic,file="E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/MAGIC_noDE_01_005.RData")

####analysis######
load("E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/SIM_noDE_01_005.RData")




Inputdat<-RAW_DAT


MedExp <- log(apply(Inputdat, 1, function(x) median(x[x != 0])))
summary(apply(Inputdat, 1, function(x) median(x[x != 0])))

plot(density(MedExp))
summary(MedExp)

sum(duplicated(MedExp))
hist(MedExp)

sort(MedExp)[1:40]
#MedExp<-log(TrueMU)
#names(MedExp)<-rownames(RAW_DAT)
# split into 4 equally sized groups:
grpnum <- 6
names(TrueMU)<-rownames(RAW_DAT)
splitby <- sort(MedExp)
grps <- length(splitby)/grpnum
sreg <- split(splitby, ceiling(seq_along(splitby)/grps))

summary(sreg[[4]])

reee='MAST'
#reee='TSTAT'



if(reee=='MAST'){

    #INPUT_LIST_temp<-list(apply(M_bayNorm_a10,1,median),M_scnorm$adjpval,M_scImpute$adjpval,M_RB$adjpval,apply(M_saver10,1,median),M_magic$adjpval,M_DCA$adjpval)
    INPUT_LIST_temp<-list(apply(M_bayNorm_a10,1,median),M_scnorm$adjpval,M_RB$adjpval,apply(M_saver10,1,median),M_magic$adjpval,M_DCA$adjpval)

}else if (reee=='TSTAT'){

    INPUT_LIST_temp<-list(T_mbayNorm,T_scnorm,T_scImpute,T_RB)

}

INPUT_LIST<-INPUT_LIST_temp
names(INPUT_LIST)<-names(INPUT_LIST_temp)

Gene_exp_gr<-seq(1,grpnum)

library(foreach)
thres<-0.05

#norm_vec<-c('bayNorm','SCnorm','scImpute','Scaling','SAVER','MAGIC','DCA')
norm_vec<-c('bayNorm','SCnorm','Scaling','SAVER','MAGIC','DCA')
BAR_MAST_l_list<-foreach(i=1:length(sreg))%do%{
    BAR_MAST_l<-lapply(INPUT_LIST,function(x){length(intersect(names(which(x<thres)),names(sreg[[i]])))})
    #BAR_MAST_l<-lapply(INPUT_LIST,function(x){length(intersect(names(which(x[,4]<thres)),names(sreg[[i]])))})

    return(BAR_MAST_l)

}

BAR_MAST_DAT<-foreach(i=1:length(BAR_MAST_l_list),.combine=rbind)%:%
    foreach(j=1:length(INPUT_LIST),.combine=rbind)%do%{
        temp<-BAR_MAST_l_list[[i]][[j]]
        temp<-c(temp,norm_vec[j],Gene_exp_gr[i])
        return(temp)
    }


BAR_MAST_DAT<-as.data.frame(BAR_MAST_DAT)
colnames(BAR_MAST_DAT)<-c('Number of detected DE genes','Normalization methods','Gene expression group')
BAR_MAST_DAT[,1]<-as.numeric(as.character(BAR_MAST_DAT[,1]))
BAR_MAST_DAT[,3]<-factor(BAR_MAST_DAT[,3],levels=unique(BAR_MAST_DAT[,3]))
BAR_MAST_DAT[,2]<-factor(BAR_MAST_DAT[,2],levels=unique(BAR_MAST_DAT[,2]))

cbbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
names(cbbPalette )<-c('NULL','bayNorm','SCnorm','Scaling','SAVER','scImpute','MAGIC','DCA')
cbbPalette2<-cbbPalette[which(names(cbbPalette) %in% norm_vec)]


library(ggplot2)
textsize<-14
DE_H1<-ggplot(data=BAR_MAST_DAT, aes(x=BAR_MAST_DAT[,3], y=BAR_MAST_DAT[,1], fill=BAR_MAST_DAT[,2])) +
    geom_bar(stat="identity", position = position_dodge(0.9),width=0.9)+
    geom_text(aes(label=BAR_MAST_DAT[,1]), vjust=0, color="black", position = position_dodge(0.9), size=2.5)+
    labs(x = "Gene expression group",y='Number of detected DE genes',fill='Normalization methods')+ggtitle("") +
    #scale_fill_brewer(palette="Paired")+
    scale_fill_manual(values=cbbPalette2)+
    theme(legend.text = element_text(size = textsize),legend.title  = element_text(size = textsize),plot.title = element_text(size = textsize),axis.title = element_text(size = textsize),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),plot.subtitle = element_text(size = textsize),plot.caption =  element_text(size = textsize),axis.text=element_text(size=textsize) ,legend.key.size = unit(1,"line"),legend.position ='top')
#dev.off()
DE_H1


source(file="E:/RNAseqProject/MANY_SAVE_PATH.R")
#jpeg(FIGURE_2_PATH_fun("/FIG2_W_H1.jpeg"), width = 75, height = 70, units = 'mm', res = 300)
#width=2.8,height=2.8
#postscript(FIGURE_SUP_PATH_fun('/SIM_noDE_BAR.eps'),width=4,height=3)
pdf(FIGURE_SUP_PATH_fun('/SIM_noDE_BAR.pdf'),width=3.75,height=3)
DE_H1
dev.off()

##useless#######

cex=4
cex.lab=1.5
cex.axis=1.5
line=1.5
lwd=3
cex.main=1.5
linecol=2

#postscript(FIGURE_SUP_PATH_fun('/SIM_noDE_scatter.eps'),width=8,height=10)
#jpeg(FIGURE_SUP_PATH_fun('/SIM_noDE_scatter.jpg'),width=7,height=8,res=300,units='in')
source(file="E:/RNAseqProject/MANY_SAVE_PATH.R")
pdf(FIGURE_SUP_PATH_fun('/SIM_noDE_scatter.pdf'),width=7.5,height=9)


par(mfrow=c(3,2))
xx<-rowMeans(mbayNorm_out$Bay_mat_list$`Group 1`)
yy<-rowMeans(mbayNorm_out$Bay_mat_list$`Group 2`)
plot(xx,yy,log='xy',xlab='Mean expression of group 1',ylab='Mean expression of group 2',main=paste('MSE=',round(mean((xx-yy)^2),4),sep=''),pch='.',cex=cex,cex.lab=cex.lab,cex.axis=cex.axis,cex.main=cex.main)
abline(0,1,lty=2,lwd=lwd,col=linecol)


xx<-rowMeans(scnorm_out[,CONDITION==1])
yy<-rowMeans(scnorm_out[,CONDITION==2])
plot(xx,yy,log='xy',xlab='Mean expression of group 1',ylab='Mean expression of group 2',main=paste('MSE=',round(mean((xx-yy)^2),4),sep=''),pch='.',cex=cex,cex.lab=cex.lab,cex.axis=cex.axis,cex.main=cex.main)
abline(0,1,lty=2,lwd=lwd,col=linecol)

xx<-rowMeans(saver_out$estimate[,CONDITION==1])
yy<-rowMeans(saver_out$estimate[,CONDITION==2])
plot(xx,yy,log='xy',xlab='Mean expression of group 1',ylab='Mean expression of group 2',main=paste('MSE=',round(mean((xx-yy)^2),4),sep=''),pch='.',cex=cex,cex.lab=cex.lab,cex.axis=cex.axis,cex.main=cex.main)
abline(0,1,lty=2,lwd=lwd,col=linecol)


xx<-rowMeans(scImpute_out[,CONDITION==1])
yy<-rowMeans(scImpute_out[,CONDITION==2])
plot(xx,yy,log='xy',xlab='Mean expression of group 1',ylab='Mean expression of group 2',main=paste('MSE=',round(mean((xx-yy)^2),4),sep=''),pch='.',cex=cex,cex.lab=cex.lab,cex.axis=cex.axis,cex.main=cex.main)
abline(0,1,lty=2,lwd=lwd,col=linecol)


xx<-rowMeans(RB_out[,CONDITION==1])
yy<-rowMeans(RB_out[,CONDITION==2])
plot(xx,yy,log='xy',xlab='Mean expression of group 1',ylab='Mean expression of group 2',main=paste('MSE=',round(mean((xx-yy)^2),4),sep=''),pch='.',cex=cex,cex.lab=cex.lab,cex.axis=cex.axis,cex.main=cex.main)
abline(0,1,lty=2,lwd=lwd,col=linecol)
dev.off()



######FC plot#####
#DATA_list<-list(bayNorm=cbind(mbayNorm_out$Bay_mat_list$`Group 1`,mbayNorm_out$Bay_mat_list$`Group 2`),SCnorm=scnorm_out,scImpute=scImpute_out,Scaling=RB_out,SAVER=saver_out,MAGIC=MAGIC_out,DCA=DCA_out)
DATA_list<-list(bayNorm=cbind(mbayNorm_out$Bay_mat_list$`Group 1`,mbayNorm_out$Bay_mat_list$`Group 2`),SCnorm=scnorm_out,Scaling=RB_out,SAVER=saver_out,MAGIC=MAGIC_out,DCA=DCA_out)

source("E:/RNAseqProject/Bacher__SCnorm_2016/FC_fun.R")
FC_out<-FC_fun(Inputdat=RAW_DAT,CONDITION=CONDITION,DATA_list,textsize=14,legend.key.size=1,colourval = cbbPalette2)
FC_out


source(file="E:/RNAseqProject/MANY_SAVE_PATH.R")
library(gridExtra)
library(ggpubr)
library(cowplot)
#qq<-ggarrange(DE_H1 ,MSE_H1,ncol=2,nrow=1,common.legend = TRUE, legend="top")
qq<-plot_grid(DE_H1,FC_out + theme(legend.position="none"),ncol=1,nrow=2)
#draw_grob(get_legend(DE_H1), 0.55, 0.75, 1/3, 0.5)
qq
ggsave(FIGURE_SUP_PATH_fun('/SIM_noDE_scatter_tr_default.pdf'),plot=qq,width = 8, height =10,units='in')


#####different DE method#####

source("E:/RNAseqProject/BAY_DEFUN.R")

baylist1<-list(mean=mbayNorm_out$Bay_mat_list$`Group 1`,mode=modebayNorm_out$Bay_mat_list$`Group 1`,array=abayNorm_out$Bay_array_list$`Group 1`)
baylist2<-list(mean=mbayNorm_out$Bay_mat_list$`Group 2`,mode=modebayNorm_out$Bay_mat_list$`Group 2`,array=abayNorm_out$Bay_array_list$`Group 2`)

DE_LIST<-BAY_DEFUN(baylist1,baylist2,CONDITION=CONDITION,NumCells=c(100,100))



load("E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/SIM_noDE_01_005.RData")
source("E:/RNAseqProject/BAY_DEFUN.R")
textsize<-12
BAR_OUT<-BAR_DE_FUN(DE_list=DE_LIST,Inputdat=RAW_DAT,xlab='DE method_type of output from bayNorm')
BAR_OUT

library(ggplot2)
ggsave(filename="E:/RNAseqProject/Illustrator_bayNorm/SUP/SUP_SIMnoDE.pdf",plot=BAR_OUT,width=8.2,height=5.5,units='in')



######GGLL#########
load("E:/RNAseqProject/SIMULATION/SIM_noDE_01_005/SIM_noDE_01_005.RData")

library(bayNorm)
LL_bayNorm_out<-bayNorm(Data<-RAW_DAT,BETA_vec<-c(BETA_SCRAN_1,BETA_SCRAN_2),Conditions=CONDITION,Prior_type = 'LL',S=10)

LL_mbayNorm_out<-bayNorm_sup(Data<-RAW_DAT,BETA_vec<-c(BETA_SCRAN_1,BETA_SCRAN_2),Conditions=CONDITION,mean_version = T,S=1000,PRIORS =LL_bayNorm_out$PRIORS_LIST )

library(abind)
qq<-abind(LL_bayNorm_out$Bay_array_list,along=2)
M_LL_bayNorm_out<-SCnorm_runMAST3(Data=qq,NumCells = c(100,100))
M_LL_mbayNorm_out<-SCnorm_runMAST3(Data=cbind(LL_mbayNorm_out$Bay_mat_list$`Group 1`,LL_mbayNorm_out$Bay_mat_list$`Group 2`),NumCells = c(100,100))

save(LL_bayNorm_out,LL_mbayNorm_out,M_LL_bayNorm_out,M_LL_mbayNorm_out,abayNorm_out,mbayNorm_out,M_bayNorm_a10,M_mbayNorm,file="E:/RNAseqProject/SIMULATION/DE_GG_explore/GG_SIM_noDE_01_005.RData")
