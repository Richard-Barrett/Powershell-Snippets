function Get-IMDBItem
{
    <#
    .Synopsis
       Retrieves information about a movie/tv show etc. from IMDB.
    .DESCRIPTION
       This cmdlet fetches information about the movie/tv show matching the specified ID from IMDB.
       The ID is often seen at the end of the URL at IMDB.
    .EXAMPLE
        Get-IMDBItem -ID tt0848228
    .EXAMPLE
       Get-IMDBMatch -Title 'American Dad!' | Get-IMDBItem
 
       This will fetch information about the item(s) piped from the Get-IMDBMatch cmdlet.
    .PARAMETER ID
       Specify the ID of the tv show/movie you want get. The ID has the format of tt0123456
    #>
 
    [cmdletbinding()]
    param([Parameter(Mandatory=$True, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
          [string[]] $ID)
 
    BEGIN { }
 
    PROCESS {
        foreach ($ImdbID in $ID) {
 
            $IMDBItem = Invoke-WebRequest -Uri "http://www.imdb.com/title/$ImdbID"
 
            $ItemInfo = $IMDBItem.AllElements
 
            $MoreInfo = ((($ItemInfo | where class -eq "subtext" | select -First 1).innerText).split('|')).trim()
            
            $ItemTitle = (($ItemInfo | where itemprop -eq "name" | select -First 1).innerHTML -split "&nbsp;")[0]
            
            If ($MoreInfo[3] -like "TV Series*") {
                $Type = "TV Series"
                $Released = $null
            } Else {
                $Type = "Movie"
                [DateTime]$Released = ($MoreInfo[3].Replace("(USA)",""))
            }
 
            $Description = ($iteminfo | where class -eq "summary_text" | select -First 1).innerText
            
            $Rating = (($ItemInfo | where class -eq "imdbRating" | select -First 1).innerText -split "/")[0]
            
            $Genres = (($MoreInfo[2]).Split(",")).Trim()

            $MPAARating = $MoreInfo[0]

            try {
                $RuntimeMinutes = New-TimeSpan -minutes (($ItemInfo | where itemprop -eq "duration" | select -First 1).datetime -replace '\D','')
            }
            catch {
                $RuntimeMinutes = $null
            }
  
            if ($Description -like '*Add a plot*') {
                $Description = $null
            }
 
            $returnObject = New-Object System.Object
            $returnObject | Add-Member -Type NoteProperty -Name ID -Value $ImdbID
            $returnObject | Add-Member -Type NoteProperty -Name Type -Value $Type
            $returnObject | Add-Member -Type NoteProperty -Name Title -Value $ItemTitle
            $returnObject | Add-Member -Type NoteProperty -Name Genre -Value $Genres
            $returnObject | Add-Member -Type NoteProperty -Name Description -Value $Description
            $returnObject | Add-Member -Type NoteProperty -Name Released -Value $Released
            $returnObject | Add-Member -Type NoteProperty -Name RuntimeMinutes -Value $RuntimeMinutes
            $returnObject | Add-Member -Type NoteProperty -Name Rating -Value $Rating
            $returnObject | Add-Member -Type NoteProperty -Name MPAARating -Value $MPAARating
 
            Write-Output $returnObject
 
            Remove-Variable IMDBItem, ItemInfo, ItemTitle, Genres, Description, Released, Type, Rating, RuntimeMinutes, MPAARating -ErrorAction SilentlyContinue
        }
    }
 
    END { }
}
