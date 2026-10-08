# .github/hooks/scripts/verify-context.ps1

Write-Host "=== Copilot session started ==="
Write-Host "Working directory: $((Get-Location).Path)"

# List top-level entries (will include your symlinks)
Write-Host "Top-level entries in workspace:"
Get-ChildItem | ForEach-Object {
    $type = if ($_.Attributes -match "Directory") { "dir" } else { "file" }
    Write-Host "  [$type] $($_.Name)"
}

Write-Host "=== End of startup verification ==="