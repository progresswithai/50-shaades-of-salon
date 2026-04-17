$ErrorActionPreference = "Stop"

$targetDir = "d:\realityfaces\50 shaades of salon"
$subDir = Join-Path $targetDir "www.studio27hairsalon.com"

Write-Host "Removing old HTTrack root index.html..."
if (Test-Path (Join-Path $targetDir "index.html")) {
    Remove-Item -Path (Join-Path $targetDir "index.html") -Force
}

Write-Host "Moving files from sub-directory to root..."
if (Test-Path $subDir) {
    Get-ChildItem -Path $subDir | Move-Item -Destination $targetDir -Force
    Remove-Item -Path $subDir -Recurse -Force
} else {
    Write-Host "Subdirectory not found, perhaps already moved."
}

Write-Host "Finding and replacing domain in all html, css, js, json files..."
$files = Get-ChildItem -Path $targetDir -Recurse -Include *.html, *.css, *.js, *.json

foreach ($f in $files) {
    if ($f.PSIsContainer) { continue }
    
    try {
        $content = Get-Content $f.FullName -Raw -ErrorAction Stop
    } catch {
        continue
    }

    if ($null -ne $content) {
        $newContent = $content -replace 'https://www\.studio27hairsalon\.com/?', '/'
        $newContent = $newContent -replace 'http://www\.studio27hairsalon\.com/?', '/'
        $newContent = $newContent -replace 'www\.studio27hairsalon\.com/?', '/'
        
        if ($content -cne $newContent) {
            Write-Host "Updating $($f.FullName)"
            Set-Content -Path $f.FullName -Value $newContent -NoNewline -Encoding UTF8
        }
    }
}

Write-Host "Localization complete!"
