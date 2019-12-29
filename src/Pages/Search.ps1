$Search = New-UDPage -Name "Book Search" -Content {

    New-UDInput -Id Search -Endpoint {

        

        [cmdletBinding(DefaultParameterSetName = "ISBN")]
        Param(
            [Parameter()]
            [String]
            $ISBN,

            [Parameter()]
            [String]
            $Title,

            [Parameter()]
            [String]
            $Author

        )

        If ($ISBN) {
                    
            $session:data = Invoke-SQLCmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database 'Library' -Query "SELECT * FROM Books WHERE ISBN LIKE '%$ISBN%'" -As PSObject
        }  
        
        If ($Title) {
            $session:data = Invoke-SQLCmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database 'Library' -Query "SELECT * FROM Books WHERE Title LIKE '%$Title%'" -As PSObject

        }

        If($Author){
            $session:data = Invoke-SQLCmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database 'Library' -Query "SELECT * FROM Books WHERE Author LIKE '%$Author%'" -As PSObject

        }
    } -SubmitText "Search"
        
        

        
    New-UDGrid -Title "Book Information" -Endpoint {
        $session:data | Out-UDGridData
        
    } -AutoRefresh -ServerSideProcessing

}