###########################
# Hunting for Scheduled Tasks
# The intent of this script file is not to be ran all at once, but rather line by line
# Author: ViviCat
###########################

# First look at the available information in get-scheduledtask
(Get-ScheduledTask).Count
Get-ScheduledTask | Get-Member
(Get-ScheduledTask).Actions | Get-Member

### Anomalies to look for
## Task Execution
(Get-ScheduledTask).Actions.Execute
(Get-ScheduledTask).Actions | Group-Object -property Execute | Sort-Object -Property Count
(Get-ScheduledTask).Actions | Where-Object {$_.Execute -notlike "*windir*" -and $_.Execute -notlike "*Systemroot*"} | Group-Object -property Execute | Sort-Object -Property Count

# sc.exe
Get-ScheduledTask | Where-Object {$_.Actions.Execute -like "sc.exe"} | Select-Object *
(Get-ScheduledTask).Actions | Where-Object {$_.Execute -like "sc.exe"} | Select-Object *


## Task Arguments
(Get-ScheduledTask).Actions.Arguments
# Things executing powershell
(Get-ScheduledTask).Actions | Where-Object {$_.Arguments -like "*powershell*"} | Select-Object *

## Task Path outside Microsoft
get-scheduledtask | group-object -property TaskPath
get-scheduledtask | Where-Object {$_.TaskPath -notlike "\Microsoft*"} | Format-Table TaskName,Taskpath,State

## Principal data - userid
(Get-scheduledtask).Principal | group-object -property UserId

# Author
get-scheduledtask | Group-Object -property Author | Sort-Object -Property Count
Get-scheduledtask | Where-Object {$_.Author -like "USER01\Administrator"} | Select-Object *
(Get-scheduledtask | Where-Object {$_.Author -like "USER01\Administrator"}).Actions | Select-Object *