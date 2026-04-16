param(
    [switch]$RebuildImage
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $repoRoot

$imageTag = "kubernetes-with-ansible-mdbook:0.4.40"

# Check if image exists
$imageExists = $false
try {
    docker image inspect $imageTag | Out-Null
    $imageExists = $true
} catch {
    $imageExists = $false
}

if ($RebuildImage -or -not $imageExists) {
    Write-Host "Building mdBook Docker image '$imageTag'..."
    docker build -t $imageTag -f "docs/Dockerfile" "docs"
}

Write-Host "Running mdBook build for 'docs'..."
docker run --rm `
    -v "${repoRoot}:/workspace" `
    -w "/workspace" `
    $imageTag build docs

Write-Host "Done. HTML book is in docs/book/"

