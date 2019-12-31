$SearchLoan = New-UDPage -Name "Search Loans" -Content {

    New-UDRow {
        New-UDColumn -Size 6 {

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
    }

    New-UDRow {
        New-UDColumn -Size 6 {

            New-UDGrid -Title "Results" -Endpoint {

                $session:Loan | Out-UDGridData
            } -AutoRefresh -ServerSideProcessing

        }
    }
}