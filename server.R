library(shiny)
library(shinyjs)

function(input, output, session) {
  # store selected cellchat in single sample view
  selected_cellchat <- reactive({
    req(input$sample_name)
    cellchat.list[[input$sample_name]]})
  
  # Initialize choices for comparison
  observe({
    updateSelectInput(session, "sample1", choices = names(cellchat.list),selected=names(cellchat.list)[1])
  })
  
  # Update the choices for sample2 when sample1 is selected
  observeEvent(input$sample1, {
    remaining_choices <- setdiff(names(cellchat.list), input$sample1)
    updateSelectInput(session, "sample2", choices = remaining_choices)
  })
  
  # create a merged cellchat for comparison
#  compare_cellchat <- reactive({
#    req(input$sample1, input$sample2)
#    if(input$sample1!=input$sample2){
#      cc.list <- cellchat.list[c(input$sample1, input$sample2)]
#      cc <- mergeCellChat(cc.list, add.names = names(cc.list))
#    } else {
#      message("Error: please select 2 different samples.")
#      cc <- mergeCellChat(cellchat.list, add.names=names(cellchat.list))
#    }
#    return(cc)
#    })
  
  
  # Update the pathway choices based on the selected cellchat object
  observe({
      cellchat_obj <- selected_cellchat()
      choices <- cellchat_obj@netP$pathways
      cell_types <- sort(unique(cellchat_obj@idents))  # Extract available cell types
#    if(!is.null(compare_cellchat())){
#      cellchat_obj <- selected_cellchat()
#      choices <- intersect(cellchat.list[[input$sample1]]@netP$pathways, cellchat.list[[input$sample2]]@netP$pathways)
#      cell_types <- sort(intersect(unique(cellchat.list[[input$sample1]]@idents), unique(cellchat.list[[input$sample2]]@idents)))
#    }
    updateSelectizeInput(session, 'pathway_name', choices = choices, server = TRUE)
    # Update sender and receiver cell choices
    updatePickerInput(session, 'sender_cells', 
                      choices = cell_types, 
                      selected = cell_types)  # Default to all cell types selected
    updatePickerInput(session, 'receiver_cells', 
                      choices = cell_types, 
                      selected = cell_types)
  })
  
  # Get indices of selected cell types
  get_index <- reactive({
    # Filter the communication network based on selected sender and receiver cells
    cellchat_obj <- selected_cellchat()
    sources <- which(levels(cellchat_obj@idents)%in%input$sender_cells)
    targets <- which(levels(cellchat_obj@idents)%in%input$receiver_cells)
    list(sources = sources, targets = targets)
  })
  
  # Reactive value to store the selected pathway
  select_pathway <- reactive({
    req(input$pathway_name)
    input$pathway_name
  })
  
  # Reactive value to store plot dimensions
  plot_dimensions <- reactive({
    list(height=input$plot_height, width=input$plot_width, cex=input$plot_cex)
  })
  
  plot_type <- reactive({
    input$plot_type
  })
  
  # General function to generate plots, reducing redundancy
  generate_plot <- function(plot_func) {
    cellchat_obj <- req(selected_cellchat())
    pathway.show <- req(select_pathway())
    cell_type <- req(get_index())
    dim <- plot_dimensions()
    type <- plot_type()
    plot_func(cellchat_obj, 
              signaling = pathway.show, 
              sources = cell_type$sources, 
              targets = cell_type$targets, 
              cex = dim$cex,
              type = type)
  }
  
  # aggregated plot
  agPlot <- eventReactive(input$update_plot, {
    generate_plot(function(cellchat_obj, signaling, sources, targets, cex, type) {
      groupSize <- as.numeric(table(cellchat_obj@idents))
      if(type=="count"){
        netVisual_circle(cellchat_obj@net$count, 
                         vertex.weight=groupSize,
                         sources.use=sources,
                         targets.use=targets,
                         edge.weight.max = max(cellchat_obj@net$count),
                         weight.scale = T, label.edge= F, 
                         vertex.label.cex = cex)
        #title(main = "Number of interactions")
      } else {
        netVisual_circle(cellchat_obj@net$count, 
                         vertex.weight=groupSize,
                         sources.use=sources,
                         targets.use=targets,
                         edge.weight.max = max(cellchat_obj@net$count),
                         weight.scale = T, label.edge= F, 
                         vertex.label.cex = cex)
        #title(main = "Interaction strength")
      }
    })
  })
  
  
  # circle plot for specific pathway
  cPlot <- eventReactive(input$update_plot, {
    generate_plot(function(cellchat_obj, signaling, sources, targets, cex, type) {
      netVisual_aggregate(cellchat_obj, signaling = signaling, 
                          sources.use=sources, 
                          targets.use=targets,
                          vertex.weight = NULL,
                          weight.scale = (type=="weight"),
                          layout = "circle", 
                          vertex.label.cex = cex)
      #title(main = paste0("Circle plot of ", signaling, " pathway"))
    })
  })
  
  # bubble plot for specific pathway
  bPlot <- eventReactive(input$update_plot, {
    generate_plot(function(cellchat_obj, signaling, sources, targets, cex, type) {
      netVisual_bubble(cellchat_obj, 
                       signaling = signaling,
                       sources.use=sources, 
                       targets.use=targets,
                       angle.x=45,
                       font.size = cex*10)
      #title(main = paste0("Bubble plot of ", signaling, " pathway"))
    })
  })
  
  # heatmap for specific pathway
  hPlot <- eventReactive(input$update_plot, {
    generate_plot(function(cellchat_obj, signaling, sources, targets, cex, type) {
      netVisual_heatmap(cellchat_obj, 
                        signaling = signaling, 
                        measure=type,
                        sources.use=sources, 
                        targets.use=targets,
                        font.size=cex*10)
      #title(main = paste0("Heatmap of ", signaling, " pathway"))
    })
  })
  
  chPlot <- eventReactive(input$update_plot, {
    generate_plot(function(cellchat_obj, signaling, sources, targets, cex, type) {
      netVisual_aggregate(cellchat_obj, signaling = signaling, 
                          sources.use=sources, 
                          targets.use=targets,
                          layout = "chord", 
                          weight.scale = (type=="weight"),
                          vertex.label.cex = cex)
      #title(main = paste0("Chord plot of ", signaling, " pathway"))
    })
  })
  
  output$aggr_plot_UI <- renderUI({
    dim <- plot_dimensions()
      plotOutput("agPlot", height=dim$height, width=dim$width)
  })
  
  output$agPlot <- renderPlot({
    agPlot()
  })
  
  # Render the circle plot UI and plot with consistent dimensions
  output$circle_plot_UI <- renderUI({
    dim <- plot_dimensions()
    plotOutput("circle_plot", height=dim$height, width=dim$width)
  })
  
  output$circle_plot <- renderPlot({
    cPlot()
  })
  
  # Render the bubble plot UI and plot with consistent dimensions
  output$bubble_plot_UI <- renderUI({
    dim <- plot_dimensions()
    plotOutput("bubble_plot", height=dim$height, width=dim$width)
  })
  
  output$bubble_plot <- renderPlot({
    req(hPlot())
    bPlot()
  })
  
  # Render the role plot UI and plot with consistent dimensions
  output$heatmap_UI <- renderUI({
    dim <- plot_dimensions()
    plotOutput("heatmap", height=dim$height, width=dim$width)
  })
  
  output$heatmap <- renderPlot({
    req(hPlot())
    hPlot()
  })
  
  # Render the chord plot UI and plot with consistent dimensions
  output$chord_plot_UI <- renderUI({
    dim <- plot_dimensions()
    plotOutput("chord_plot", height=dim$height, width=dim$width)
  })
  
  output$chord_plot <- renderPlot({
    chPlot()
  })
}



