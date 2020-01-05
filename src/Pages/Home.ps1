$Homepage = New-UDPage -Name "Home" -Content {
    
    New-UDTextbox -Label "Search" -Type text -Autofocus -Placeholder "Search Titles" -Id 'SearchBox'

    New-UDButton -Text "Search" -OnClick {
        $Element = Get-UDElement -ID 'SearchBox'
        $Session:Title = $Element.Attributes['value']
        $Session:SelectedBook = Invoke-Sqlcmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database "Library" -Query "SELECT * FROM Books WHERE Title LIKE '%$($Session:Title)%'" -As PSObject
        New-UDPage -Url "$($Session:SelectedBook.Title)" -Content {

            New-UDHeading -Text "Ha HA!"
        }
        Invoke-UDRedirect -Url "http://localhost/$($Session:SelectedBook.Title)"
    }
    
    $books = Invoke-Sqlcmd2 -ServerInstance "Localhost\SQLEXPRESS" -Database "Library" -Query "SELECT * From Books WHERE Cover LIKE 'http%'" -As PSObject | Select-Object Cover
    New-UDImageCarousel -Items {
 
     $books | ForEach-Object {
        $Session:SelectedBook = [pscustomobject]@{
            Title = $_.Title
            Cover = $_.Cover
            Description = $_.Description
        }
         New-UDImageCarouselItem -BackgroundImage $_.Cover -BackgroundRepeat no-repeat -BackgroundSize Cover -Text $_.Title -TextPosition Center
     }
    }
}