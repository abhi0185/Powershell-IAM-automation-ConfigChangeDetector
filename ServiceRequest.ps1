# Note:
# 1. Codefile: ServiceRequest.ps1
# 2. Update requisite $user and $passwd.
# 3. Logfile created in the current directory as "External_ServiceRequest_yyyy-MM-dd" updated after every run.
# 4. Ipfile: All_server_services.txt 


$user = "xxxxxxx"
$passwd = "xxxxxxxxxx"

clear-host
$Config_Path = 'C:\Users\$user\Desktop\ConfigChangeDetector'
#write-host $Config_Path
$FileName = $Config_Path + "\All_server_services.txt"

$SendFile = $Config_Path + "\ab.bat"


$result = @()


#write-host $FileName

$IPaddress = @(Get-Content -Path $FileName )
#$IPaddress.Length

For ($i=0; $i -lt $IPaddress.Length; $i++)
{
#$IPaddress.Length
	$IP_normal = $IPaddress[$i]
	
	$Full_Path = $Config_Path + "\" + $IP_normal +".csv"
	$IP_withslash = "\\"+$IPaddress[$i]
	
	if($IPaddress[$i].Length -ne 0)
	{
		Write-host ("URL :	",$IPaddress[$i])
		
		#Net use $IPs $passwd /user:$user
		Net use $IP_withslash $passwd /user:$user


		$IP_normal
		
		if($IPaddress[$i].Length -ne 0)
		{
			if(Test-Path -Path "$IP_withslash\c$\Users\$user\Desktop\receieve.ps1")
				{
				write-host "Already present"
				}
			else{
			Write-host ("URL :	",$IPaddress[$i])
			Copy-item -Path $Config_Path\update_conf_file2.ps1 -Destination $IP_withslash\c$\Users\$user\Desktop\receieve.ps1
			write-host "Copy done"	}

				
			winrs /r:$IP_normal /u:$user /p:$passwd powershell.exe -nologo -noprofile -command C:\Users\$user\Desktop\receieve.ps1
			
			if(Test-Path -Path "$IP_withslash\c$\Users\$user\Desktop\Date_Out.txt")
			{
				write-host "create csv"
				$Date_Data = ""
				$ModifiedData = ""
				$Date_Data = Get-Content -Path $IP_withslash\c$\Users\$user\Desktop\Date_Out.txt -Raw
				$ModifiedData = Get-Content -Path $IP_withslash\c$\Users\$user\Desktop\ModifiedData_Out.txt -Raw

				$a = $Date_Data
				$b = $ModifiedData
				
				#$details = @{"Date" = $Date_Data
				#"Updated Data" = $ModifiedData}
				$details = @{
					"Date" = $a
					"Updated Data" = $b
					}
				#$details = @{"Date" = "abcd"
				#"Updated Data" = "Mydata"}
				$details
				
				$results+= New-Object PSObject -Property $details 
				$results
				$results | export-csv -append $Full_Path -NoTypeInformation
				
				
				################## Code to send attachments in mail ################## 
				$o = New-Object -com Outlook.Application
				$mail = $o.CreateItem(0)
				$mail.importance = 2
				$mail.subject = "Federated Certificate Details"
				$mail.body = "Hi User `n`n Please find attachments regarding the Config file Change."

				#separate multiple recipients with a ";"
				$mail.To = $user + '@cognizant.com'


				
				$mail.Attachments.Add($Full_Path);
				$mail.Send()
				
				

				Remove-Item $IP_withslash\c$\Users\$user\Desktop\Date_Out.txt
				Remove-Item $IP_withslash\c$\Users\$user\Desktop\ModifiedData_Out.txt
				
				
			}
			write-host "done"


		}


	}
	

}
	
	