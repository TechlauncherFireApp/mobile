# SETUP
## CONTAINERISED INSTALL
> This method helps to reduce the amount of software installed on your personal computer and reduces issues setting up development environments on multiple computers and makes troubleshooting easier as the development environment will always be consistent. 
1. Install Docker Desktop
    * Instructions: https://docs.docker.com/get-docker/
    * Docker is free but you may need to register an account to download the software
    * For windows you made need to install WSL 2 and ensure that Hyper-V is turned on at the BIOS/UEFI level
2. Install an android emulator 
    * Android Studio (Android Virtual Machine)
        - If using a AMD based Windows computer 
            1. you will need to enable "Windows HyperVisor Platform"
            2. Hyper-V/Virtualisation MUST be ENABLED in bios/uefi for Docker to work
    * Visual Studio Emulator for Android
        - a more lightweight Android emulator, try this if having issues with android studio
3. Install VSCode & the "Remote Container" extension (HIGHLY RECOMMENDED)      
        - but you can install another IDE if you prefer, search for the instructions for enabling docker container dev env for that software
3. Clone the repository 
    - `git clone https://github.com/TechlauncherFireApp/FireApp-Mobile <directory>`
4. Open the repository in VSCode 
5. Open the VSCode Command Palette (Ctrl+Shift+P) and type `VSCode Remote Container - Open folder in container` 
6. Select the repository/folder 
    - "FireApp-Mobile" not the 'fireapp' folder
7. Wait for the docker container to build (first time will always take longer but after its built it should load instantly)

Now that the Docker container is established you can use 
    `close connection` - to close the container
    `Open folder in container` - to start the container - should automatically get a prompt whenever you open the project.
    `rebuild container` - to recreate the container if you makes  changes to the setup (dockerfile.dockerfile)

Connect to emulator:
1. Start the emulator on your local machine
    * If you are using Android Studio this includes openning Android Studio and starting the emulator from there. See: https://developer.android.com/studio/run/managing-avds 
2. In the docker container terminal type `adb tcpip 5555`
3. "Device not found" may pop up - if so you can just ignore it
4. Type `adb connect host.docker.internal:5555`
5. Wait for the emulator to connect - usually you can select it from the bottom right hand corner of VSCode. 
6. CD into the fireapp dir & run the project using `flutter run` from within the fireapp dir 

> Note: VSCode Extensions may need to be installed in both the local and container - see the heading "Managing extensions" @ https://code.visualstudio.com/docs/remote/containers for more detail. 
> **Does not apply to the Remote Container extension**

Connect a physcial Android Device: 
1. Install `adb` on your local system (with container turned off) 
    - Download platform tools: https://developer.android.com/studio/releases/platform-tools#downloads 
    - Add its path to your environment variable for easy access
1. Enable USB Debugging on your Android device
2. Connect the device to your computer over USB
3. Run `adb devices` (inside the docker container) to get a list of all connected devices
4. Get the IP Address of your Android device 
   * Usually found on your android device under `WiFi Settings -> Advanced`
3. Enter the following commands
    `adb tcpip 5555`
    `adb connect <Your-Devices-IP-Address>`
4. Run `adb devices` again, this time the IP Address should come up
5. Disconnect the device and run `adb devices` again, to verify if device is still connected wirelessly 
6. Turn on the docker container
7. Then run the following commands
 `adb connect <IP-Address>:5555`
 `adb devices`
8. Allow USB debugging when it pops up on your device
    - if you encounter 'device unauthorised' run
    `adb kill-server`
    `adb connect <IP-Address>:5555`
    `adb devices`
9. Run `Fflutter doctor` to check if device is recognised by flutte

Steps to setup WiFi/USB sync with Android Devicehttps://blog.codemagic.io/how-to-dockerize-flutter-apps/

### Troubleshooting
For Docker to work & for the Android emulator to work, Virtualisation MUST BE ENABLED.
    - https://support.microsoft.com/en-us/windows/enable-virtualization-on-windows-11-pcs-c5578302-6e43-4b4b-a449-8ced115f58e1 
    - Needs to be enabled in your bios
    - If Docker works but the Android emulator gives the error "Hyper-V must be disabled" - do not disable Hyper-V instead on the windows search bar search for "Windows features" or 'Turn windows features on or off" and ensure that Virtual Machine Platform & Windows Hypervisor Platform are turned on. 

## Local Install 
> To emulate iOS you will have to install Flutter locally on a MacOS Machine. 
> ARM-based Macs (models released 2021 and after) at this point in time cannot emulate android

Step 1: 
Simply follow these instructions to install flutter from the Flutter website:
https://docs.flutter.dev/get-started/install for installation instructions for Flutter & Emulators
*Note that if you are on MacOS and want to use the iOS emulator (required if you have an ARM-based mac) then you will need to install XCode from Apple (available on the Mac App Store).*

Step 2: 
Install and setup an IDE (if not already installed)
See: https://docs.flutter.dev/get-started/editor 
(This link includes instructions for setting up Android Studio, IntelliJ and/or VSCode as your main flutter IDE)

Step 3:
Clone the repository



