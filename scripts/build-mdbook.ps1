param(
    [switch]$RebuildImage
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $repoRoot

$imageTag = "kubernetes-with-ansible-mdbook:0.4.40"

function Invoke-CheckedCommand {
    param(
        [scriptblock]$Command,
        [string]$ErrorMessage
    )

    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw $ErrorMessage
    }
}

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
    Invoke-CheckedCommand -ErrorMessage "Docker image build failed." -Command {
        docker build -t $imageTag -f "docs/Dockerfile" "docs"
    }
}

Write-Host "Running mdBook build for 'docs'..."
Invoke-CheckedCommand -ErrorMessage "mdBook build failed in container." -Command {
    docker run --rm `
        -v "${repoRoot}:/workspace" `
        -w "/workspace" `
        $imageTag build docs
}

Write-Host "Done. HTML book is in docs/book/"

