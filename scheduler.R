library(taskscheduleR)

script_path <- "C://Users//rpwju//OneDrive//Desktop//post-game-win-expectancy-cfb//retrieve_data.R"

taskscheduler_create(
  taskname  = "My_R_Scheduled_Task",   
  rscript   = script_path,            
  schedule  = "DAILY",                  
  starttime = "03:01",
  startdate = "08/15/2025"         
)

taskscheduler_delete(taskname = "My_R_Scheduled_Task")

taskscheduler_run(taskname = "My_R_Scheduled_Task")

source(script_path)

all_tasks <- taskscheduler_ls()
my_task <- all_tasks[all_tasks$TaskName == "My_R_Scheduled_Task", ]
my_task
