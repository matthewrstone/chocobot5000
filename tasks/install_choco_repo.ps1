[CmdletBinding()]
Param(
  [Parameter(Mandatory = $true)] [String] $server,
  [Parameter(Mandatory = $true)] [String] $username,
  [Parameter(Mandatory = $true)] [String] $password
)

choco install chocolatey-nexus-repo -y --params=\"'/Username=admin /Password=${password} /RepositoryName=choco /ServerUri=http://${server}:8081'\"