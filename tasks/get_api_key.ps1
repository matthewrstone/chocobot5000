#!/usr/local/bin/pwsh
[CmdletBinding()]
Param(
  $password,
  $server
)

### API KEY
$credPair = "admin:${password}"
$encodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($credPair))

$header = @{
    Authorization = "Basic $encodedCredentials"
}

$content = @"
import org.sonatype.nexus.security.authc.apikey.ApiKeyStore
import org.sonatype.nexus.security.realm.RealmManager
import org.apache.shiro.subject.SimplePrincipalCollection
def getOrCreateNuGetApiKey(String userName) {
    realmName = "NexusAuthenticatingRealm"
    apiKeyDomain = "NuGetApiKey"
    principal = new SimplePrincipalCollection(userName, realmName)
    keyStore = container.lookup(ApiKeyStore.class.getName())
    apiKey = keyStore.getApiKey(apiKeyDomain, principal)
    if (apiKey == null) {
        apiKey = keyStore.createApiKey(apiKeyDomain, principal)
    }
    return apiKey.toString()
}
getOrCreateNuGetApiKey("admin")
"@

$body = @{
    name    = "apikey"
    type    = "groovy"
    content = $content
}

Invoke-RestMethod -Uri "http://${server}:8081/service/rest/v1/script" -ContentType 'application/json' -Body $($body | ConvertTo-Json) -Header $header -Method Post
$result = Invoke-RestMethod -Uri "http://${server}:8081/service/rest/v1/script/apikey/run" -ContentType 'text/plain' -Header $header -Method Post

return $result.result
