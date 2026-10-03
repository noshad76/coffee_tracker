Add-Type -AssemblyName System.Drawing

$srcPath = 'C:\Users\Amir Hossein\.gemini\antigravity\brain\a7b25061-7173-4f09-80e6-1ea39e8e6cdb\flat_c_cup_symbol_1791068600262.jpg'
$root = 'c:\Github\coffee_tracker'

# Ensure source exists
if (-not (Test-Path $srcPath)) {
    Write-Error "Source file does not exist: $srcPath"
    exit 1
}

$srcBmp = [System.Drawing.Bitmap]::FromFile($srcPath)

function Resize-And-Save($targetPath, $width, $height) {
    $dir = [System.IO.Path]::GetDirectoryName($targetPath)
    if (-not (Test-Path $dir)) {
        [System.IO.Directory]::CreateDirectory($dir) | Out-Null
    }
    
    $dest = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($dest)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    
    $g.DrawImage($srcBmp, 0, 0, $width, $height)
    $dest.Save($targetPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $dest.Dispose()
    Write-Host "Created: $targetPath ($width x $height)"
}

# 1. Master project asset
Resize-And-Save "$root\assets\icons\app_icon.png" 1024 1024

# 2. Android legacy & standard mipmaps
Resize-And-Save "$root\android\app\src\main\res\mipmap-mdpi\ic_launcher.png" 48 48
Resize-And-Save "$root\android\app\src\main\res\mipmap-hdpi\ic_launcher.png" 72 72
Resize-And-Save "$root\android\app\src\main\res\mipmap-xhdpi\ic_launcher.png" 96 96
Resize-And-Save "$root\android\app\src\main\res\mipmap-xxhdpi\ic_launcher.png" 144 144
Resize-And-Save "$root\android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png" 192 192

# 3. Android adaptive foregrounds
Resize-And-Save "$root\android\app\src\main\res\mipmap-mdpi\ic_launcher_foreground.png" 108 108
Resize-And-Save "$root\android\app\src\main\res\mipmap-hdpi\ic_launcher_foreground.png" 162 162
Resize-And-Save "$root\android\app\src\main\res\mipmap-xhdpi\ic_launcher_foreground.png" 216 216
Resize-And-Save "$root\android\app\src\main\res\mipmap-xxhdpi\ic_launcher_foreground.png" 324 324
Resize-And-Save "$root\android\app\src\main\res\mipmap-xxxhdpi\ic_launcher_foreground.png" 432 432

# 4. iOS AppIcon set
$iosDir = "$root\ios\Runner\Assets.xcassets\AppIcon.appiconset"
Resize-And-Save "$iosDir\Icon-App-20x20@1x.png" 20 20
Resize-And-Save "$iosDir\Icon-App-20x20@2x.png" 40 40
Resize-And-Save "$iosDir\Icon-App-20x20@3x.png" 60 60
Resize-And-Save "$iosDir\Icon-App-29x29@1x.png" 29 29
Resize-And-Save "$iosDir\Icon-App-29x29@2x.png" 58 58
Resize-And-Save "$iosDir\Icon-App-29x29@3x.png" 87 87
Resize-And-Save "$iosDir\Icon-App-40x40@1x.png" 40 40
Resize-And-Save "$iosDir\Icon-App-40x40@2x.png" 80 80
Resize-And-Save "$iosDir\Icon-App-40x40@3x.png" 120 120
Resize-And-Save "$iosDir\Icon-App-60x60@2x.png" 120 120
Resize-And-Save "$iosDir\Icon-App-60x60@3x.png" 180 180
Resize-And-Save "$iosDir\Icon-App-76x76@1x.png" 76 76
Resize-And-Save "$iosDir\Icon-App-76x76@2x.png" 152 152
Resize-And-Save "$iosDir\Icon-App-83.5x83.5@2x.png" 167 167
Resize-And-Save "$iosDir\Icon-App-1024x1024@1x.png" 1024 1024

$srcBmp.Dispose()
Write-Host "All icons generated successfully!"
