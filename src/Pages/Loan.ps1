$Loan = New-UDPage -Name "Book Loans" -Content {

    New-UDRow -Columns {
        New-UDColumn -Size 3 {
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

        New-UDColumn -Size 3 {

            New-UDInput -Title "Search Loan" -Endpoint {
                [cmdletBinding()]
                Param(
                    [Parameter(Position=0)]
                    [String]
                    $Title,
        
                    [Parameter(Position=1)]
                    [String]
                    $Name,

                    [Parameter(Position=2)]
                    [Switch]
                    $All
                )
        
                If ($Title) {
        
                    $session:Loan = Invoke-Sqlcmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database "Library" -Query "SELECT * FROM Loans WHERE Title LIKE '%$Title%'" -as PSObject
                }
        
                If ($Name) {
                    
                    $session:Loan = Invoke-Sqlcmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database "Library" -Query "SELECT * FROM Loans WHERE Name LIKE '%$Name%'" -As PSObject
        
                }

                If($All) {

                    $session:Loan = Invoke-Sqlcmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database "Library" -Query "SELECT * FROM Loans" -As PSObject
                }
        
                Sync-UDElement -Id 'Loans'
            } -SubmitText "Search"

        }

        New-UDColumn -Size 3 {

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

    New-UDRow {
        New-UDColumn -Size 6 {
        
            New-UDGrid -Title "Loans" -Endpoint {

                $Session:Loan | Out-UDGridData
            } -ServerSideProcessing -AutoRefresh -Id 'Loans'
        }
    }
    
}