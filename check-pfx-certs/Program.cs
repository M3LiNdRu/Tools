using System;
using System.Security.Cryptography.X509Certificates;

namespace LoadPfxCertificate
{
    internal class Program
    {
        static void Main()
        {
            // Path of the .pfx file
            string pfxPath = "./default.pfx"; // Replace with the actual path to your .pfx file

            // Password of the .pfx file (if it has one)
            string password = "XXXX"; // Replace with the actual password

            // Load the .pfx certificate
            X509Certificate2 certificat = new X509Certificate2(pfxPath, password);

            // Example: Display information about the loaded certificate
            Console.WriteLine("Subject: " + certificat.Subject);
            Console.WriteLine("Issuer: " + certificat.Issuer);
            Console.WriteLine("Valid From: " + certificat.NotBefore);
            Console.WriteLine("Valid To: " + certificat.NotAfter);
        }
    }
}
