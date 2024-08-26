param( [Parameter(Mandatory=$true)] $JSONFile)

function CreateADGroup() {
	param( [Parameter(Mandatory=$true)] $groupObject)

	$name = $groupObject.name
	New-ADGroup -name $name -GroupScope Global
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

$json = ( Get-Content $JSONFile | ConvertFrom-Json )
# Write-Output $json.users


$Global:Domain = $json.domain

foreach ( $group in $json.groups ){
	CreateADGroup $group
}


foreach ( $user in $json.users ){
	CreateADUser $user
}

