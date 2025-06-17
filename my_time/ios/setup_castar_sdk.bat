@echo off
REM Script to set up CastarSDK for iOS

REM Create Frameworks directory if it doesn't exist
if not exist "Frameworks" mkdir Frameworks

REM Check if CastarSDK.framework already exists
if exist "Frameworks\CastarSDK.framework" (
    echo CastarSDK.framework already exists.
) else (
    echo CastarSDK.framework not found. Please place the CastarSDK.framework in the Frameworks directory.
    echo You can download it from the CastarSDK developer portal.
    echo.
    echo After downloading, unzip the file and place the CastarSDK.framework in the ios\Frameworks directory.
    exit /b 1
)

REM Run pod install
echo Running pod install...
pod install

echo CastarSDK setup completed successfully!
echo You can now build the iOS app using: flutter build ios --release --no-codesign 