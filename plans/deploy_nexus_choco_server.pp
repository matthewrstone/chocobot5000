plan chocobot5000::deploy_nexus_choco_server (
  TargetSpec $targets,
  String $repo_name = 'choco',
) {
  # apply($targets, _description => 'Installing Nexus OSS package via Chocolatey') {
  #   package { 'nexus-repository' :
  #     ensure   => present,
  #     provider => chocolatey,
  #   }
  # }

  $nexus_server = (get_targets($targets).map |$n| { $n.name })[0]
  run_command(
    'netsh advfirewall firewall add rule name="Nexus" dir=in action=allow protocol=TCP localport=8081',
    $targets
  )

  run_command(
    "choco install nexus-repository -y -params \"'/Fqdn:${nexus_server}'\"'",
    $targets
  )

  $password = run_command('(Get-Content C:\ProgramData\sonatype-work\nexus3\admin.password).ToString()', $targets)

  return $password['stdout']

  #run_command('choco install chocolatey-nexus-repo -y -params \"'/Fqdn:${nexus_server}'\"' ', $targets)

  # apply($targets) {
  #   package { 'chocolatey-nexus-repo':
  #     ensure          => present,
  #     provider        => chocolatey,
  #     install_options => [
  #       '-params',
  #       '"',
  #       '/username=admin',
  #       "/password=${password}",
  #       "/repositoryname=${repo_name}",
  #       '"',
  #     ],
  #   }
}
