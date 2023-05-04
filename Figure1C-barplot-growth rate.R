# Create a sample data frame
df <- data.frame(
  Year = c("2018", "2019", "2020", "2021", "2022"),
  World = c(28.00733089, 30.96446701, 29.28841185, 19.670997, 2.941932169),
  United_States = c(23.70572207, 21.40234949, 21.77199879, 3.973181028, -4.08406974),
  China = c(79.61165049, 53.91891892, 50.21949078, 46.93161894, 36.35640414),
  Germany = c(22.31638418, 33.48729792, 23.52941176, 26.8907563, -7.726269316),
  United_Kingdom = c(8.092485549, 50.26737968, 19.03914591, 9.56651719, -10.5047749),
  Canada = c(25.93856655, 18.42818428, 30.66361556, 10.68301226, -13.44936709)
)

# Set the Year column as a factor to ensure the x-axis is ordered correctly
df$Year <- factor(df$Year, levels = unique(df$Year))

# Convert the data frame to long format
library(tidyr)
df_long <- pivot_longer(df, -Year, names_to = "Country", values_to = "Growth_Rate")

# Set the levels of the "Country" factor in the desired order
df_long$Country <- factor(df_long$Country, levels = c("United_States", "China", "Germany", "United_Kingdom", "Canada", "World"))

# Create the barplot
library(ggplot2)
p=ggplot(df_long, aes(x = Year, y = Growth_Rate, fill = Country)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Growth Rate of Different Countries",
       x = "Year", y = "Growth Rate", fill = "Country") +
  scale_fill_manual(values = c( "#af8dc3","#762a83","#e7d4e8", "#d9f0d3", "#7fbf7b", "#1b7837"))


p+labs(x = "Publication Years", y = "YoY Growth rate") +  # Add this line
  scale_y_continuous(expand = c(0,0),limits = c(-20,100),breaks = seq(0, 100, by = 20)) +
  theme_classic() +
  theme(
    panel.background = element_rect(fill="white", colour="white", size=0.25),
    axis.line = element_line(colour="black", size=0.5),
    axis.title = element_text(size=10, color="black"),
    axis.text = element_text(size=10, color="black"),
    legend.position = c(0.9, 0.8),
    legend.text = element_text(size =10),
    aspect.ratio = 0.8,  # set figure size to 8x6 inches
    plot.title = element_text(size = 10)
  ) 

