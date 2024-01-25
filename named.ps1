$ns_api = kubectl api-resources -o name --namespaced=true
$namespaces = kubectl get namespaces -o name | %{ $_.ToString().Replace("namespace/", " ") }

Write-Host "Exporting namespaced resources"
mkdir namespaces

foreach ($n in $namespaces) {
    foreach ($r in $ns_api) {
        $names = kubectl get $r -n $n -o name
        if ([string]::IsNullOrEmpty($names)) {
            Write-Host "Skipping because of empty value"
        }
        else {
            Write-Host "Dumping $r in $n`n"
            foreach ($name in $names) {
                mkdir -p (Split-Path -Path "namespaces/$n/$name" -Parent)
                kubectl get $name -n $n -o yaml | kubectl neat > "namespaces/$n/$name.yaml"
                Write-Host "manifest saved to namespaces/$n/$name.yaml`n"
            }
        }
    }
}
