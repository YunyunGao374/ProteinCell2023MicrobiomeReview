library(readxl)
library(ggplot2)
library(tidyr)
library(ggalluvial)
library(alluvial)
getwd()
setwd("D:/高云云/5-基因组所AGIS/9-works/1-刘老师项目/20230328专刊/0-Figures/")
mydata<- read.table("0-figure1C(2)-microbiome-places/data-percentage.txt", header = T, sep='\t')

test1 <- gather(mydata, E1, E2, -ID) 

# Define the desired order of levels for the ID variable
my_order <- c("United States", "China", "Germany", "United Kingdom", "Canada", "Italy", "Australia", "Spain", "Netherlands", "France", "India", "Japan", "South Korea", "Brazil", "Denmark", "Switzerland", "Sweden", "Belgium", "Poland", "Ireland", "Others")




my_order<- c("Others","Ireland","Poland","Belgium","Sweden","Switzerland","Denmark","Brazil","South Korea","Japan","India","France","Netherlands","Spain","Australia","Italy","Canada","United Kingdom","Germany","China","United States")


# Use the factor() function to reorder the levels of the ID variable
test1$ID <- factor(test1$ID, levels = my_order)



ggplot(test1, aes(x=E1, y=E2,alluvium = ID)) + 
  geom_alluvium(aes(fill= ID),
                alpha= 0.4, width = 0.4) +
  geom_bar(stat="identity",aes(fill=ID), width = 0.4) +
  scale_y_continuous(expand = c(0,0)) +
  scale_fill_manual(values=c("#a6cee3","#1f78b4","#b2df8a","#33a02c","#fb9a99",
                                      "#e31a1c","#fdbf6f","#ff7f00","#cab2d6",
                                      "#6a3d9a","#ffff99","#ffed6f","#ccebc5",
                                      "#bc80bd","#d9d9d9","#fccde5","#b3de69",
                                      "#fdb462","#80b1d3","#fb8072","#8dd3c7"))+
                                        theme_classic() +
  theme(
    panel.background = element_rect(fill="white", colour="white", size=0.25),
    axis.line = element_line(colour="black", size=0.5),
    axis.title = element_text(size=13, color="black"),
    axis.text = element_text(size=12, color="black"),
    legend.text = element_text(size =10),
    aspect.ratio = 1,  # set figure size to 8x6 inches
    plot.title = element_text(size = 10), # optional, add a title
    axis.text.x = element_text(angle = 45, hjust = 1) # Rotate x-axis labels by 45 degrees
  ) +
  guides(fill = guide_legend(reverse = TRUE))

                                      



                                      