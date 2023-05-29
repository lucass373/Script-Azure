$users = Import-Csv -Path "C:\Temp\office\CargaProfessores.csv" -UseCulture 
foreach($user in $users){
    while ($user.DisplayName -ne ""){
    $userAD = Get-AzureADUser -Filter "UserPrincipalName eq'$($user.UserPrincipalName)'"
    if($userAD -and $user.FirstName -ne ""){
        Write-Output "$($user.UserPrincipalName) | USUÁRIO JA EXISTE"
        "$($user.UserPrincipalName) | NAO CRIADO" | Out-File -FilePath C:\Temp\office\log.txt -Append
        break;
    }
    else{
        
        try{
            New-MsolUser -StrongPasswordRequired $false -DisplayName $user.DisplayName -UsageLocation BR -FirstName $user.FirstName -LastName $user.LastName -UserPrincipalName $user.UserPrincipalName -LicenseAssignment $user.LicenseAssignment -Password $user.Password
            "$($user.UserPrincipalName) | CRIADO" | Out-File -FilePath C:\Temp\office\log.txt -Append
            Write-Output "$($user.UserPrincipalName) | CRIADO"
            break;
    }
        catch [System.SystemException]{
            "$($user.UserPrincipalName) | ERROR" | Out-File -FilePath C:\Temp\office\log.txt -Append
            Write-Output "$($user.UserPrincipalName) | ERROR"
            Write-Output $_
            break;
        }
    }
}
}

