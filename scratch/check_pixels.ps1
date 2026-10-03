Add-Type -AssemblyName System.Drawing
$path = 'C:\Users\Amir Hossein\.gemini\antigravity\brain\a7b25061-7173-4f09-80e6-1ea39e8e6cdb\coffeeaholic_app_icon_1791068346619.jpg'
$bmp = [System.Drawing.Bitmap]::FromFile($path)
Write-Host "Pixel (0,0): $($bmp.GetPixel(0,0))"
Write-Host "Pixel (512,0): $($bmp.GetPixel(512,0))"
Write-Host "Pixel (512,120): $($bmp.GetPixel(512,120))"
Write-Host "Pixel (95,95): $($bmp.GetPixel(95,95))"
Write-Host "Pixel (200,200): $($bmp.GetPixel(200,200))"
$bmp.Dispose()
