param( [Parameter(Mandatory=$true)] $JSONFile)

function CreateADGroup() {
	param( [Parameter(Mandatory=$true)] $groupObject)

	$name = $groupObject.name
	New-ADGroup -name $name -GroupScope Global
}


function RemoveADGroup() {
	param( [Parameter(Mandatory=$true)] $groupObject)

	$name = $groupObject.name
	Remove-ADGroup -Identity $name -Confirm:$False
}




function CreateADUser() {
	param( [Parameter(Mandatory=$true)] $userObject )
	
	#pulls names from json objects.
	$name = $userObject.name
	$password = $userObject.password

	#generates first initial lastname
	$firstname, $lastname = $name.Split(" ")
	$username = ($firstname[0] + $lastname).ToLower() 	
	$samAccountName = $username
	$principalname = $username
	

	#Creates the AD User Object.
	New-ADUser -Name "$name" -GivenName $firstname -Surname $lastname -SamAccountName $SamAccountName -UserPrincipalName $principalname@$Global:Domain -AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) -PassThru | Enable-ADAccount

	#add a user to their appropriate group
	foreach($group_name in $userObject.group) {

		try{
			Get-ADGroup -Identity "$group_name"
			Add-ADGroupMember -Identity $group_name -Members $username
		}
		catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
		{
			Write-Warning "User $name NOT added to group $group_name because it does not exist"
		}
		
	}
}


function WeakenPasswordPolicy(){
	secedit /export /cfg C:\Windows\Tasks\secpol.cfg
    (Get-Content C:\Windows\Tasks\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0").replace("MinimumPasswordLength = 7", "MinimumPasswordLength = 1") | Out-File C:\Windows\Tasks\secpol.cfg
    secedit /configure /db c:\windows\security\local.sdb /cfg C:\Windows\Tasks\secpol.cfg /areas SECURITYPOLICY
    Remove-Item -force C:\Windows\Tasks\secpol.cfg -confirm:$false
}

WeakenPasswordPolicy


$json = ( Get-Content $JSONFile | ConvertFrom-Json )
# Write-Output $json.users


$Global:Domain = $json.domain

foreach ( $group in $json.groups ){
	CreateADGroup $group
}


foreach ( $user in $json.users ){
	CreateADUser $user
}

