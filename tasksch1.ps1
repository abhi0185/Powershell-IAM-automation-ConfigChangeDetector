
clear-host


$user = "xxxxxx"

Copy-item -Path "C:\Users\$user\Desktop\ConfigChangeDetector\ServiceRequest.ps1" -Destination "C:\Users\$user\Desktop\ServiceRequest.ps1"
Copy-item -Path "C:\Users\$user\Desktop\ConfigChangeDetector\All_server_services.txt" -Destination "C:\Users\$user\Desktop\All_server_services.txt"


$Sta = New-ScheduledTaskAction -Execute C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe "C:\Users\$user\Desktop\ServiceRequest.ps1"

#The second command creates a scheduled task trigger that starts the task once at 7:00 A.M for 3000 days and assigns the **ScheduledTaskTrigger** object to the $Stt variable.

# uncomment below for running task with intervals of 1 minute
$Stt = New-ScheduledTaskTrigger  -Once -At 7am -RepetitionDuration  (New-TimeSpan -Days 3000)  -RepetitionInterval  (New-TimeSpan -Minutes 1)

# uncomment below for running task with intervals of 6 hours
#$Stt = New-ScheduledTaskTrigger  -Once -At 10am -RepetitionDuration  (New-TimeSpan -Days 3000)  -RepetitionInterval  (New-TimeSpan -Minutes 360)

#$Stt = New-ScheduledTaskTrigger -AtLogon -User $user


#The third command registers the scheduled task Task01 to run the task action named Cmd once at 3:00 A.M.
Register-ScheduledTask Task01 -Action $Sta -Trigger $Stt

