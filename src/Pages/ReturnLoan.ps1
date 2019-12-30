$ReturnLoan = New-UDPage -Name "Return Book Loan" -Content {
    
    New-UDRow {
        New-UDColumn -Size 6 {

            New-UDInput -Title "Return Book" -Endpoint {
                [cmdletBinding()]
                Param(
                    [Parameter()]
                    [String]
                    $Title
                )

                Invoke-SqlCmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database Library -Query "UPDATE Books SET IsLoaned = '0' WHERE Title = '$Title'"
                Invoke-Sqlcmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database Library -Query "DELETE FROM Loans WHERE Title = '$Title'"

                Show-UDToast -Title "Book Return" -Message "Title: '$Title' return: SUCCESS"
            }
        }
    }

}