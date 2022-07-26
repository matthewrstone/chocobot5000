#!/usr/local/bin/pwsh
[CmdletBinding()]
Param(
  $password,
  $server
)

# Write-Output $server $password
# choco install chocolatey-nexus-repo -y --params="'/Username=admin /Password=${password} /RepositoryName=choco /ServerUri=http://${server}:8081'"

Write-Output "nexus.scripts.allowCreation=true" | Out-File C:\ProgramData\sonatype-work\nexus3\etc\nexus.properties -Encoding Ascii -Force

Restart-Service Nexus
Start-Sleep -Seconds 15

### INSTALL CHOCO REPO ###
choco install chocolatey-nexus-repo --version 1.0.0 --params="'/username=admin /password=$password /repositoryname=choco /serveruri=http://${server}:8081'"