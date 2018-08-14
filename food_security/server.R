###
#
# This is the backend of food security shiny app.
#

library(shiny)
library(ggplot2)
library(plotly)
load("food_security.rda")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  

  # filter = 
  
  output$ssr_plot <- renderPlotly({
    
    # draw the plot based on the filtered data.
    # manuplicated data based on the input. 
    # input name and type.
    # $Period, the period to draw the plot. default is "All". 
    #     Note that only the last 3 digits were used to filter data
    # $region, the regions of counties, default is "All",
    # $Country, the country to plot data. default is "All".
    plot_data <- ssr # avoid contanminate the original data.
    
    # filter the period.
    if(input$Period == "All"){
      plot_data = plot_data
    }
    else{
      # get the last 3 digits from the string.
      Period_filter <- stringr::str_sub(input$Period, -3, -1)
      plot_data = filter(plot_data, Period == Period_filter)
    }
    
    # To do:
    # add regions to the data set.
    
    # filter the country.
    
    if(input$Country == "All"){
      plot_data = plot_data
    }
    else{
      plot_data = filter(plot_data, Country == input$Country)
    }
    
    # draw the plots.
    ssr_supply = plot_data %>% 
      group_by(Country, Period) %>% 
      summarise(SSR_mean = mean(SSR, na.rm = T),
                supply_mean = mean(supply, na.rm = T)) %>%
      ggplot()+
      geom_point(aes(x = SSR_mean, y = supply_mean, color = Period, label = Country), alpha = 0.8)+
      scale_color_brewer(palette = "RdBu")+
      #facet_wrap(.~Period)+
      theme_bw(base_size = 11)+
      annotate("segment", x = 85, xend = 85, y = -Inf, yend = Inf, linetype = "dashed")+
      annotate("segment", x = 115, xend = 115, y = -Inf, yend = Inf, linetype = "dashed")+
      annotate("segment", x = -Inf, xend = Inf, y = 2196, yend = 2196, linetype  = "dashed")+
      guides(color=guide_legend(ncol=2))+
      theme(legend.justification = c(0,0),
            legend.position = c(1,1.05))+
      labs(x = "Self-sufficient Ratios", y = "Food supply (kcal/capital/day)",tag = "A")+
      scale_y_continuous(limits = c(1000,4000) )+
      scale_x_continuous(limits = c(0, 320))+
      annotate("rect", xmin = 17, xmax = 67, ymin = 1000, ymax = 1200, fill = "lightblue" )+
      annotate("rect", xmin = 85, xmax = 115, ymin = 1000, ymax = 1200, fill = "lightblue" )+
      annotate("rect", xmin = 175, xmax = 225, ymin = 1000, ymax = 1200, fill = "lightblue" )+
      annotate("text", x = 42, y = 1100, label = "Import Food")+
      annotate("text", x = 100, y = 1100, label = "Balanced")+
      annotate("text", x = 200, y = 1100, label = "Export Food")+
      annotate("rect", xmin = 300, xmax = 320, ymin = 1000, ymax = 2000, fill = "lightgreen")+
      annotate("rect", xmin = 300, xmax = 320, ymin = 2500, ymax = 3500, fill = "lightgreen")+
      #annotate("text", x = 310, y = 1500, label = "Inadequate energy", angle = 90)+
      #annotate("text", x = 310, y = 3000, label = "Adequate energy", angle = 90)+
      NULL
    
    # make it intervative using plotly.
    ggplotly(ssr_supply) %>% 
      layout(height = input$plotHeight, autosize=TRUE) %>% 
      add_lines(x = c(85,85), y = c(950,4050), showlegend = FALSE, mode = "lines", color = I("black"), linetype = I("dashed")) %>% 
      add_lines(x = c(115,115), y = c(950,4050), showlegend = FALSE, mode = "lines", color = I("black"), linetype = I("dashed")) %>% 
      add_lines(x = c(0,300), y = c(2196,2196), showlegend = FALSE, mode = "lines", color = I("black"), linetype = I("dashed")) %>% 
      add_annotations(text = "Inadequate energy", textangle = -90, x = 310, y = 1300) %>% 
      add_annotations(text = "Adequate energy", textangle = -90, x = 310, y = 3000)
    
    
  })
  
})
