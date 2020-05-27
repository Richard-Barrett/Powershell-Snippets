#!/bin/powershell

function City {
     param(
         [Parameter(Mandatory)]
         [string]$Name
     )
     Write-Output "City name $Name was supplied"
 }

function State-Province {
     param(
         [Parameter(Mandatory)]
         [string]$Name
     )
     Write-Output "State-province name $Name was supplied"
 }
 
function Country {
     param(
         [Parameter(Mandatory)]
         [string]$Name
     )
     Write-Output "Country nanme $Name was supplied"
 }
