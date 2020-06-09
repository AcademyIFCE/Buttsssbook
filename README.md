# Buttsssbook

## Server

There are a few steps to take before running the server.

#### Generate Xcode Project

Using the terminal, navigate to the **buttsssbook-server** directory and run the following command:

```bash
swift package generate-xcodeproj
```

#### Setting Working Directory

Open the **buttsssbook-server.xcodeproj** file, select *Edit Scheme* for the **Run** scheme, check *Use custom working directory* and set it to `$PROJECT_DIR`.


