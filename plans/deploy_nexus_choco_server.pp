plan chocobot5000::deploy_nexus_choco_server (
  TargetSpec $targets,
  String $repo_name,
) {
  # apply($targets, _description => 'Installing Nexus OSS package via Chocolatey') {
  #   package { 'nexus-repository' :
  #     ensure   => present,
  #     provider => chocolatey,
  #   }
  # }
  run_command('choco install nexus-repository -y', $targets)

  $password = run_command(
    '(Get-Content C:\ProgramData\sonatype-work\nexus3\admin.password).ToString()',
    _description => 'Retreiving temporary password...'
  )

  return $password
  # run_command(
  #   'netsh advfirewall firewall add rule name="Nexus" dir=in action=allow protocol=TCP localport=8081',
  #   _description => 'Configuring firewall settings...',
  #   $targets
  # )

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
