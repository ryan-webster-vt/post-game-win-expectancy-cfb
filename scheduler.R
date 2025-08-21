library(taskscheduleR)

script_path <- "C://Users//rpwju//OneDrive//Desktop//post-game-win-expectancy-cfb//retrieve_new_data.R"

taskscheduler_create(
  taskname      = "My_R_Scheduled_Task",
  rscript       = script_path,
  schedule      = "WEEKLY",
  days          = "MON",
  starttime     = "03:00",
  startdate     = "08/20/2025"  # MM/DD/YYYY
)

taskscheduler_run(taskname = "My_R_Scheduled_Task")
