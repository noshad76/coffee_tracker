Add-Type -AssemblyName System.Drawing
$path = 'C:\Users\Amir Hossein\.gemini\antigravity\brain\a7b25061-7173-4f09-80e6-1ea39e8e6cdb\coffeeaholic_app_icon_1791068346619.jpg'
$img = [System.Drawing.Image]::FromFile($path)
Write-Host "Dimensions: $($img.Width) x $($img.Height)"
$img.Dispose()
