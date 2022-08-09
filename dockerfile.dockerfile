# FROM command create a layer from the Ubuntu:20.04 Docker image
FROM ubuntu:20.04 
# can also use latest to get latest version - instead of version number 

#Fix any timezone errors that might popup as the result of openjdk-11 - picked a random timezone
ENV TZ=Asia/Dubai 
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update
RUN apt install -y tzdata

# Prerequisites - Using the RUN command to install all necessary packages
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-11-jdk wget
# In this instance 'curl git unzip xz-utils zip libglu1-mesa' are all required by the Flutter SDK and openjdk-8-jdk is required by the Android SDK, wget can be used to download Android tools.

# Set up new user (non-root called developer and set it as the current user, and change the working directory to its home dir). 
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# create Android directories and system variables
RUN mkdir -p Android/sdk/cmdline-tools
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk/cmdline-tools
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv cmdline-tools Android/sdk/cmdline-tools/tools
RUN cd Android/sdk/cmdline-tools/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/cmdline-tools/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

# Run basic check to download Dart SDK
RUN flutter doctor
#RUN flutter config --android-sdk $HOME/Android/sdk/cmdline-tools