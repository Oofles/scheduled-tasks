######################################
# Pulls all scheduled tasks and exports them into a single folder 
# and adds the .xml extension
# Author: ViviCat
######################################

$savefolder = "C:\Some\Folder\"

Get-ScheduledTask |
    ForEach-Object {
        $_.TaskName
        Export-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath | 
            Out-file (Join-Path $savefolder "$($_.TaskName).xml")
    }
