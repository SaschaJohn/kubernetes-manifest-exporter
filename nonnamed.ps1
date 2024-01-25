$non_ns_api = kubectl api-resources -o name --namespaced=$false

mkdir cluster

Write-Host "Exporting cluster resources"
foreach ($r in $non_ns_api) {
    $names = kubectl get $r -o name
    if ([string]::IsNullOrEmpty($names)) {
        Write-Host "Skipping because of empty value`n"
    }
    else {
        Write-Host "Dumping $r`n`n"
        foreach ($name in $names) {
            mkdir -p (Split-Path -Path "cluster/$name" -Parent)
            kubectl get $name -o yaml | kubectl neat > "cluster/$name.yaml"
            Write-Host "manifest saved to cluster/$name.yaml`n"
        }
    }
}
