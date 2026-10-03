Add-Type -AssemblyName System.Drawing
$path = 'C:\Users\Amir Hossein\.gemini\antigravity\brain\a7b25061-7173-4f09-80e6-1ea39e8e6cdb\flat_c_cup_symbol_1791068600262.jpg'
$bmp = [System.Drawing.Bitmap]::FromFile($path)
Write-Host "Dimensions: $($bmp.Width) x $($bmp.Height)"
Write-Host "Pixel (0,0): $($bmp.GetPixel(0,0))"
Write-Host "Pixel (512,0): $($bmp.GetPixel(512,0))"
Write-Host "Pixel (10,10): $($bmp.GetPixel(10,10))"
Write-Host "Pixel (512,512): $($bmp.GetPixel(512,512))"
$bmp.Dispose()
