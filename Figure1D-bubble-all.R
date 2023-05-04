library(ggplot2)

# Set working directory
setwd("D:/高云云/5-基因组所AGIS/9-works/1-刘老师项目/20230328专刊/")

# Read in data
mydata <- read.table("2-figure1D-protrin&cell-高分权重/cited journal-all.txt", header = TRUE, sep = "\t")

# Create a color palette for the data types
mycolors <- c("<3" = "#ffffbf", ">3"="#d9f0a3",">5" = "#addd8e", ">10" = "#78c679", ">30" = "#31a354", ">60" = "#006837")

# create the bubble chart

p = ggplot(mydata, aes(x = IF, y = index, size = index, color = type)) +
  geom_point(alpha = 0.8) +
  scale_color_manual(values = mycolors, 
                     limits = c("<3",">3", ">5", ">10", ">30", ">60")) + # specify the legend order
  scale_size(range = c(2, 15), breaks = c(30, 50, 100, 200, 300), 
             labels = c(30, 50, 100, 200, 300)) +
  xlab("Journal IF") +
  ylab("Citation index") +
  guides(
    color = guide_legend(
      title = "IF in 2021", 
      override.aes = list(size=5),
      direction = "vertical",    # change the direction of color legend to horizontal
      label.position = "right", # place the labels on the right
      title.position = "top"
    ),
    size = guide_legend(
      title = "Citation index", 
      override.aes = list(color = "grey50"),
      direction = "vertical",      # change the direction of size legend to vertical
      label.position = "right",     # place the labels on the right
      title.position = "top"
    )
  )

p+theme_classic() +
  theme(
    panel.background = element_rect(fill="white", colour="white", size=0.25),
    axis.line = element_line(colour="black", size=0.5),
    axis.title = element_text(size=13, color="black"),
    axis.text = element_text(size=12, color="black"),
    aspect.ratio = 0.8,
    legend.position = c(0.95, 0.65), # set position of color legend
  )

