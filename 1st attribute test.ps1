[string]$proxydomain = "@funimation.com"; #Proxy domain
[string]$usersOU = "OU=Users,OU=Test-Attribute,DC=Corp,DC=Group1200,DC=com"; #OU to apply changes
[int]$count = 0 ;

Import-Module ActiveDirectory

  Get-ADUser -Filter "*" -SearchScope Subtree -SearchBase "$usersOU" -Properties proxyAddresses, employeeType, givenName, Surname | foreach-object {

  Write-Host "Editing user: $_.SamAccountName"

    if ($_.Proxyaddresses -match $_.givenName+"."+$_.Surname+$proxydomain)
    {
      Write-Host "Result: PproxyAddresses value already exists; No action taken."
    }
    else
    {
      Set-ADUser -Identity $_.SamAccountName -Add @{proxyAddresses="SMTP:"+$_.givenName+"."+$_.Surname+$proxydomain}

      Write-Host "Result: Added proxyAddresses value to Account"
      $count++
    }
       

  }

Write-Host "Sucessfully Edited" $count "users"