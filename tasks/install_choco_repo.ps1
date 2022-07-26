#!/usr/local/bin/pwsh
[CmdletBinding()]
Param(
  $server,
  $password
)

Write-Output $server $password
choco install chocolatey-nexus-repo -y --params=\"'/Username=admin /Password=${password} /RepositoryName=choco /ServerUri=http://${server}:8081'\"
#return 'butts'
return "${server} is a gas"