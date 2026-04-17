$ErrorActionPreference = "Stop"

$targetDir = "d:\realityfaces\50 shaades of salon"

Write-Host "Finding and replacing logo paths in html files..."
$files = Get-ChildItem -Path $targetDir -Recurse -Include *.html, *.css, *.js, *.json

foreach ($f in $files) {
    if ($f.PSIsContainer) { continue }
    
    try {
        $content = Get-Content $f.FullName -Raw -ErrorAction Stop
    } catch {
        continue
    }

    if ($null -ne $content) {
        # Replace occurrences of the specific logo names with /logo.png
        # Using a regex to match the base name and any size variations like -230x73, etc.
        $newContent = $content -replace '/?wp-content/uploads/2026/01/studio-27-hair-salon-extensions-everett-ma-logo[0-9x-]*\.png', '/logo.png'
        
        # Also let's clean up any width/height on the img tag for the logo to avoid stretching
        # Since it's a new logo, hardcoded width/height can break the aspect ratio. Let's just remove them.
        # But wait, removing width/height might break layout. Let's just do the path replacement first.
        
        if ($content -cne $newContent) {
            Write-Host "Updating logo in $($f.FullName)"
            Set-Content -Path $f.FullName -Value $newContent -NoNewline -Encoding UTF8
        }
    }
}

Write-Host "Logo update complete!"
