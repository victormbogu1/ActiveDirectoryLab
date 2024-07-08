# ----- Edit these Variables for your own Use Case ----- #
$PASSWORD_FOR_USERS   = "Password1"
$USER_FIRST_LAST_LIST = Get-Content .\names.txt
# ------------------------------------------------------ #

$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force
New-ADOrganizationalUnit -Name _USERS -ProtectedFromAccidentalDeletion $false

foreach ($n in $USER_FIRST_LAST_LIST) {
    $first = $n.Split(" ")[0].ToLower()
    $last = $n.Split(" ")[1].ToLower()
    $username = "$($first.Substring(0,1))$($last)".ToLower()
    Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Cyan
    
    New-AdUser -AccountPassword $password `
               -GivenName $first `
               -Surname $last `
               -DisplayName $username `
               -Name $username `
               -EmployeeID $username `
               -PasswordNeverExpires $true `
               -Path "ou=_USERS,$(([ADSI]`"").distinguishedName)" `
               -Enabled $true
}

Brief explaination of this code:
The script is designed to create multiple AD user accounts using a list of names provided in a file called names.txt. Each user will be created with a predefined password and certain attributes.
Define Variables:
$PASSWORD_FOR_USERS: This variable stores the password that will be used for all the new users.
$USER_FIRST_LAST_LIST: This variable holds the content of the file names.txt, which contains the first and last names of the users to be created. Each line in the file is expected to have a first and last name separated by a space.
ConvertTo-SecureString: This cmdlet converts the plain text password to a secure string format, which is required by the New-AdUser cmdlet.
New-ADOrganizationalUnit: This cmdlet creates a new OU in AD named _USERS.
-ProtectedFromAccidentalDeletion $false: This parameter ensures that the OU can be deleted if needed.
foreach ($n in $USER_FIRST_LAST_LIST): This loop iterates over each name in the list.

$n.Split(" ")[0].ToLower(): Splits the name into first and last components and converts the first name to lowercase.
$n.Split(" ")[1].ToLower(): Splits the name into first and last components and converts the last name to lowercase.
$username = "$($first.Substring(0,1))$($last)".ToLower(): Constructs a username by taking the first letter of the first name and concatenating it with the last name, all in lowercase.
Write-Host "Creating user: $($username)" -BackgroundColor Black -ForegroundColor Cyan: Displays a message indicating the creation of a user.

New-AdUser: This cmdlet creates a new user in AD with the specified properties:

-AccountPassword $password: Sets the user's password.
-GivenName $first: Sets the user's first name.
-Surname $last: Sets the user's last name.
-DisplayName $username: Sets the user's display name.
-Name $username: Sets the user's name.
-EmployeeID $username: Sets the user's employee ID.
-PasswordNeverExpires $true: Sets the user's password to never expire.
-Path "ou=_USERS,$(([ADSI]"").distinguishedName)": Specifies the path where the user will be created, within the _USERS` OU.
-Enabled $true: Enables the user account.
