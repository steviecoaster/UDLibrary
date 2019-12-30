$NewLoan = New-UDPage -Name "New Book Loan" -Content {
    
    New-UDRow {
        New-UDColumn -Size 6 {
            New-UDInput -Title "New Loan" -Endpoint {

                [cmdletBinding()]
                Param(
                    [Parameter(Mandatory)]
                    [String]
                    $Title,
        
                    [Parameter(Mandatory)]
                    [String]
                    $Name,
                    
                    [Parameter(Mandatory)]
                    [String]
                    $Due
                )
        
                Invoke-Sqlcmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database "Library" -Query "INSERT INTO Loans (Title,Name,Due) VALUES ('$Title','$Name','$Due')"
                Invoke-Sqlcmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database "Library" -Query "UPDATE Books SET IsLoaned = '1' WHERE Title = '$Title'"
        
                Show-UDToast -Title "SUCCESS" -Message "Book : $Title Loaned to : $Name Due back: $Due"
            } -SubmitText "Loan Book"
        }
    }

}