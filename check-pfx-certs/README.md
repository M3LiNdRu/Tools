# PFX Certificate Inspector Tool

A C# utility application for loading and inspecting PFX (PKCS#12) certificate files. This tool displays key certificate information such as subject, issuer, and validity dates.

## Overview

The **PFX Certificate Inspector** is a simple command-line application that helps you:

- Load and validate PFX certificate files
- Display certificate metadata (subject, issuer, validity period)
- Verify certificate authentication details
- Test PFX certificate passwords
- Inspect certificates programmatically

This tool is useful for developers and system administrators who need to work with digital certificates, particularly for mobile wallet integrations, SSL/TLS verification, or certificate management.

## Prerequisites

- **.NET Framework** (4.7.2 or higher) or **.NET Core/5+**
- A **PFX certificate file** (.pfx or .p12 format)
- The **password** for the certificate (if it's password-protected)

## Project Structure

```
check-pfx-certs/
├── LoadPfxCertificate.sln       # Visual Studio solution
├── LoadPfxCertificate.csproj    # Project configuration
├── Program.cs                    # Main application code
├── App.config                    # Application configuration
└── README.md                     # This file
```

## Installation & Setup

### Prerequisites Installation

**On Windows:**
- Download and install [.NET Framework](https://dotnet.microsoft.com/download/dotnet-framework) or [.NET](https://dotnet.microsoft.com/download)
- Install [Visual Studio](https://visualstudio.microsoft.com/) (Community edition is free)

**On Linux/macOS:**
- Install [.NET SDK](https://dotnet.microsoft.com/download)

### Building the Project

**Using Visual Studio:**
1. Open `LoadPfxCertificate.sln`
2. Right-click on the project and select **Build**
3. Run with F5 or Ctrl+F5

**Using .NET CLI:**
```bash
dotnet build
dotnet run
```

## Configuration

### Step 1: Add Your PFX Certificate

Place your PFX certificate file in the project directory or any accessible location.

### Step 2: Update the Program

Edit `Program.cs` and update these variables:

```csharp
// Path to your .pfx file
string pfxPath = "./default.pfx";  // Replace with actual path

// Certificate password (if it has one)
string password = "XXXX";           // Replace with actual password
```

**Examples:**
```csharp
// Absolute path
string pfxPath = "C:/certificates/MyWallet.pfx";

// Relative path
string pfxPath = "../certs/AppleWallet-MOB_UAT.pfx";

// With password
string password = "SecurePassword123!";

// No password (empty string)
string password = "";
```

### Step 3: Compile and Run

Build the project and run the executable. The application will display certificate information to the console.

## Usage

### Basic Usage

After configuring the file path and password, run the application:

```bash
dotnet run
```

Or execute the compiled `.exe` file directly.

### Example Output

```
Subject: CN=AppleWallet-MOB_UAT, OU=Mobile, O=MyOrganization, C=US
Issuer: CN=Certification Authority, O=MyOrganization, C=US
Valid From: 1/15/2024 10:00:00 AM
Valid To: 1/15/2026 10:00:00 AM
```

### Output Fields Explained

| Field | Description |
|-------|-------------|
| **Subject** | The entity (organization, person, or service) the certificate was issued to |
| **Issuer** | The Certificate Authority (CA) that issued this certificate |
| **Valid From** | Certificate validity start date and time |
| **Valid To** | Certificate expiration date and time |

## Common Use Cases

### 1. Verify Certificate Validity

Check if a certificate is still valid by comparing the "Valid To" date with the current date.

### 2. Extract Certificate Information

Display certificate details for documentation or integration purposes.

### 3. Test Certificate Passwords

Verify that you have the correct password for a protected PFX file.

### 4. Certificate Diagnostics

Troubleshoot certificate-related issues in applications that use PFX files.

## Troubleshooting

### Error: "Cannot find the specified file"
- **Solution:** Verify the file path is correct and the file exists
- Check if the path is relative or absolute
- Ensure the file has read permissions

### Error: "The specified network password is not correct"
- **Solution:** The password is incorrect
- Verify the password doesn't have typos
- Try an empty password: `string password = "";`
- Use a password manager to verify the correct password

### Error: "Invalid certificate format"
- **Solution:** Ensure the file is a valid PFX/PKCS#12 certificate
- Verify the file extension is `.pfx` or `.p12`
- Try opening the certificate in Windows Certificate Manager or OpenSSL

### Application closes immediately after running
- **Solution:** Add a pause to see the output:
```csharp
Console.WriteLine("Press any key to exit...");
Console.ReadKey();
```

## Extending the Tool

### Display Additional Certificate Information

You can extend `Program.cs` to show more details:

```csharp
// Display thumbprint
Console.WriteLine("Thumbprint: " + certificat.Thumbprint);

// Display public key algorithm
Console.WriteLine("Algorithm: " + certificat.PublicKey.Oid.FriendlyName);

// Check if certificate has a private key
Console.WriteLine("Has Private Key: " + certificat.HasPrivateKey);

// Display certificate version
Console.WriteLine("Version: " + certificat.Version);
```

### Validate Certificate Chain

```csharp
X509Chain chain = new X509Chain();
bool isValid = chain.Build(certificat);
Console.WriteLine("Certificate is valid: " + isValid);
```

### Export Certificate Information to File

Modify the program to write output to a log file instead of console:

```csharp
using (StreamWriter writer = new StreamWriter("certificate_info.txt"))
{
    writer.WriteLine("Subject: " + certificat.Subject);
    writer.WriteLine("Issuer: " + certificat.Issuer);
    // ... more lines
}
```

## Security Considerations

- **Never commit PFX files** to version control repositories
- **Never hardcode passwords** in production code
- Use **environment variables** for sensitive data:
  ```csharp
  string password = Environment.GetEnvironmentVariable("PFX_PASSWORD");
  ```
- Store certificates in **secure locations** with proper access controls
- **Rotate certificates** before expiration
- Use **strong passwords** for PFX files

## Related Tools & Resources

- [Windows Certificate Manager](https://docs.microsoft.com/en-us/dotnet/framework/security/how-to-use-the-certificate-store)
- [OpenSSL PFX Tools](https://www.ssl.com/how-to/convert-a-certificate-to-the-pfx-format/)
- [.NET X509Certificate2 Documentation](https://docs.microsoft.com/en-us/dotnet/api/system.security.cryptography.x509certificates.x509certificate2)
- [PKCS#12 Format Specification](https://en.wikipedia.org/wiki/PKCS_12)

## License

This tool is provided as-is for educational and development purposes.

## Support

For issues or questions:
- Review .NET documentation
- Check certificate validity with OpenSSL: `openssl pkcs12 -info -in certificate.pfx`
- Consult your Certificate Authority for password reset
