$AddBook2 = New-UDPage -Name "Add Book Manual" -Content {

    New-UDRow {
        New-UDColumn -Size 6 -Content {
            New-UDInput -Title "Add New Book" -Endpoint {

                
                [cmdletBinding()]
                Param(
                    [Parameter(Mandatory)]
                    [String]
                    $ISBN,

                    [Parameter(Mandatory)]
                    [String]
                    $Author,

                    [Parameter(Mandatory)]
                    [String]
                    $Title
                )
                
                $result = Invoke-RestMethod -Uri "https://www.googleapis.com/books/v1/volumes?q=isbn:$ISBN"
                
                $object = [pscustomobject]@{
                    Title  = "$($result.items.volumeinfo.title)"
                    Author = "$($result.items.volumeinfo.authors)"
                    ISBN   = "$($result.items.volumeinfo.industryIdentifiers.Identifier[1])"
                    Cover  = "$($result.items.volumeinfo.imageLinks.smallThumbnail)"
                }
                
                Invoke-Sqlcmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database "Library" -Query "INSERT INTO Books (Title,Author,ISBN,Cover) VALUES ('$($Title -replace "'","''")','$($Author -replace "'","''")','$($ISBN)','')"
                
                Show-UDToast -Duration 3000 -Title "SUCCESS" -Message "$($Title) successfully added to Database!"

                New-UDInputAction -ClearInput -Toast ''

            } -SubmitText "Add"
        }
    }
}