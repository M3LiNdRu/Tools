using System;

namespace Api
{
    public class RedisSettings
    {
        public static string Section => "RedisDistributedCache";
        public string Dns { get; set; }
        public int Port { get; set; }
        public string Password { get; set; }
        public TimeSpan ConnectionTimeout { get; set; }
        public int ConnectionRetries { get; set; }
        public bool SslEnabled { get; set; }
        public int DatabaseNumber { get; set; }
        public string ClientName { get; set; }
    }
}
