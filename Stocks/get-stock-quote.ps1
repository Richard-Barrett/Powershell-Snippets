param([String]$qindex,[String]$qname ,[Int32]$iterations=10)

 

function getQPreviousCloseAndOpenInfo($index)
{
<#
  .SYNOPSIS
  Returns 2 values of a given qoute
  .DESCRIPTION
  Takes the symbol of a quote and returns the values: 
  Previous Close, Open 
  .EXAMPLE
  $q = getQInfo "BCE.TO"
  .EXAMPLE
  $q = getQInfo "IBM"
  $q = getQInfo "giba.to"
  .PARAMETER $index
  The quote symbol 
  #>


    $url="http://ca.finance.yahoo.com/q?s=$sindex"
    # regex to extract the values
    $pclose="Prev Close:(.*)<td class=(.*)>(.*)</td>(.*)"
    $popen="Open:(.*)<td class=(.*)>(.*)</td>(.*)"
        
    # obtain data from the given url
    $wc = new-object System.Net.WebClient
    $wc.Headers.Add("user-agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)")
    $data=$wc.OpenRead($url)
    $rd = new-object System.IO.StreamReader($data)
    $s=$rd.ReadToEnd()
    # extract partial strings to be matched with he above regex
    $sprevclose=$s.substring($s.IndexOf("Prev Close:"),59)
    $sopen=$s.substring($s.IndexOf("Open:"),53)
    $open=0.0
    $prevclose=0.0
    
    if ($sprevclose -Match $pclose ) {$prevclose =( $matches[3] -as [double])}
    if ($sopen -Match $popen ){$open = ($matches[3] -as [double])}
    # return values in an object
    $q=new-object PSObject -property @{prevclose=$prevclose;open=$open}
    return $q
}
function getQAskAndBidInfo($index)
{
<#
  .SYNOPSIS
  Returns 2 values of a given qoute
  .DESCRIPTION
  Takes the symbol of a quote and returns the values: 
  Bid and Ask
  .EXAMPLE
  $q = getQInfo "BCE.TO"
  .EXAMPLE
  $q = getQInfo "IBM"
  $q = getQInfo "giba.to"
  .PARAMETER $index
  The quote symbol 
  #>

    $url="http://ca.finance.yahoo.com/q?s=$sindex"
    # regex to extract the values
    $pask="Ask:(.*)<td class=(.*)(.*)(.*)"
    $pbid="Bid:(.*)    $i=0
        $openclose=getQPreviousCloseAndOpenInfo $sindex
        showQOpenClose $openclose
    $prevQ= new-object PSObject -property @{ask=0.0;bid=0.0}
    while ($i -lt $iterations) {
           write-host "---iteration $i : Time: $(get-date -Format ‘HH:mm:ss’)----"
            $q2= getQAskAndBidInfo $sindex
        $lbl =        "*** Ask        : "
        if ($q2.ask -lt $prevQ.ask) {writeQInfo  $openclose.prevclose $q2.ask $lbl "red"}
        if ($q2.ask -gt $prevQ.ask) {writeQInfo  $openclose.prevclose $q2.ask $lbl "green"}
        if ($q2.ask -eq $prevQ.ask) {writeQinfo  $openclose.prevclose $q2.ask $lbl "white"}
        $prevQ.ask=$q2.ask

        $lbl =     "*** Bid        : "
        if ($q2.bid -lt $prevQ.bid) {writeQInfo $openclose.prevclose $q2.bid $lbl "red"  }
        if ($q2.bid -gt $prevQ.bid) {writeQInfo $openclose.prevclose $q2.bid $lbl "green"}
        if ($q2.bid -eq $prevQ.bid) {writeQinfo  $openclose.prevclose $q2.bid $lbl "white"}
        $prevQ.bid = $q2.bid
                
        Start-sleep -seconds 10
        $i=$i+1
    }
    
    
}
function uHelp($script){
     write-host "usage "       $script " quoteindex [quotename] [noiterations]"
     write-host "example: .  " $script " bce.to"
     write-host "example: .  " $script " bce.to 'bce.inc' "
     write-host "example: .  " $script " bce.to 'bce.inc' 100"
     write-host "example running for index giba.to with 3 iterations :  "
    
}
# main program 
if ($qindex -eq "" ){
    uHelp $MyInvocation.MyCommand.Definition
    exit
}
 
runQInfo $qindex $qname $iterations
