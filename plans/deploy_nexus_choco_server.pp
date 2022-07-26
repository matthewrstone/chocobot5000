plan chocobot5000::deploy_nexus_choco_server (
  TargetSpec $targets,
  String $repo_name = 'choco',
) {
  $nexus_server = (get_targets($targets).map |$n| { $n.name })[0]
  run_command(
    'netsh advfirewall firewall add rule name="Nexus" dir=in action=allow protocol=TCP localport=8081',
    $targets
  )

  run_command(
    "choco install nexus-repository -y -params \"'/Fqdn:${nexus_server}'\"",
    $targets
  )

  $password = run_command('(Get-Content C:\ProgramData\sonatype-work\nexus3\admin.password).ToString()', $targets)[0]['stdout'].strip()

  run_task(
    'chocobot5000::install_choco_repo',
    $targets,
    username => 'admin', password => $password, server => $nexus_server
  )
  # run_command(
  #   "choco install chocolatey-nexus-repo -y --params=\"'/Username=admin /Password=${password} /RepositoryName=${repo_name} /ServerUri=http://${nexus_server}:8081'\"",
  #   $targets
  # )

  return "The secret is ${password}"
}
