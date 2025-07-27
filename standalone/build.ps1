# Remove the dist folder if it exists
Remove-Item -Path "$PSScriptRoot\..\dist" -Recurse -Force

# Run PyInstaller with the standalone specification file
& "C:\Users\mobre\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.12_qbz5n2kfra8p0\LocalCache\local-packages\Python312\Scripts\pyinstaller.exe" "$PSScriptRoot\standalone.spec"

# Copy README.txt to dist/SweetDreams directory
Copy-Item -Path "$PSScriptRoot\README.txt" -Destination "$PSScriptRoot\..\dist\SweetDreams"

# Clean up by removing the build folder
Remove-Item -Path "$PSScriptRoot\..\build" -Recurse -Force

# Zip the result
$originalDir = Get-Location
cd "$PSScriptRoot\..\dist\SweetDreams"
Compress-Archive -Path * -DestinationPath "SweetDreams-vX.X.X-windows.zip"
cd $originalDir