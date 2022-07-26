#!/usr/local/bin/pwsh
[CmdletBinding()]
Param(
  $username='admin',
  $server,
  $password
)

Write-Output $server $password
choco install chocolatey-nexus-repo -y --params="'/Username=admin /Password=${password} /RepositoryName=choco /ServerUri=http://${server}:8081'"