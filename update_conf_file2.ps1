#Note: 
# 1. Change the $user and $passwd.
# 2. $Filename1  contains a dummy config for testing as "\ConfigCI22.CONF". Needs to be changed post testing.


$user = "xxxxxx"
$passwd = "xxxxxxxxx"

# Config_Path is a folder in which Config file is kept

$Config_Path = 'D:\Program Files\Tivoli\PDWeb\etc'			



$Filename1 = $Config_Path + "\ConfigCI22.CONF"
$TempFile1 = $Config_Path + "\temp1.txt"

if (Test-Path $TempFile1) 
{
  Remove-Item $TempFile1
}

Get-Content $Filename1 | ? {$_.trim() -ne "" } | Where { $_ -notmatch "#" } | Set-Content "$TempFile1"

$TempFile_data1 = @(Get-Content -Path $TempFile1 )

$results = ""

clear-host


$Filename2 = $Config_Path + "\ConfigCI33.CONF"
$TempFile2 = $Config_Path + "\temp2.txt"

if(Test-Path $Filename2)
{
	if (Test-Path $TempFile2) 
	{
	  Remove-Item $TempFile2
	}

	Get-Content $Filename2 | ? {$_.trim() -ne "" } | Where { $_ -notmatch "#" } | Set-Content "$TempFile2"

	$TempFile_data2 = @(Get-Content -Path $TempFile2)
	$t1 = $TempFile_data1.Length
	$t2 = $TempFile_data2.Length
	$t2
}
else
{
	Copy-item $Filename1 -Destination $Filename2
	
}	

if((Get-Item $Filename1).LastWriteTime	-eq (Get-Item $Filename2).LastWriteTime)
{
	write-host "Same"
}
else
{
	write-host "not Same"
	
	
	$flag=0
	$Str = ""
	


	foreach ($i in $TempFile_data1)
	{
	$flag=0
		foreach ($j in $TempFile_data2)
		{
			if("$i" -eq "$j")
			{
				$flag=1
				break;
			}
		}
		if($flag -ne 1)
		{
			$Str += "$i"+"`n"
		}
	}

	write-host "Not matched string is : "
	write-host $Str

	Copy-item $Filename1 -Destination $Filename2
	
	if (Test-Path C:\Users\$user\Desktop\Out.txt) 
	{
	  Remove-Item C:\Users\$user\Desktop\Out.txt
	}
	(Get-Item $Filename1).LastWriteTime > C:\Users\$user\Desktop\Date_Out.txt
	$Str > C:\Users\$user\Desktop\ModifiedData_Out.txt
	
	#$result
	write-host "Done"
	exit
	
	#write-host " Last Updated time of Config file : "
	#write-host (Get-Item $Filename2).LastWriteTime
}

