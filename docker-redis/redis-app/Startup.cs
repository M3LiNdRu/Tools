using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using StackExchange.Redis;
using System.Net;
using Microsoft.Extensions.Hosting;

namespace Api 
{
    public class Startup
    {
        private readonly IConfiguration _configuration;

        public Startup(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            //services.AddDistributedMemoryCache(); // In-memory

            services.AddStackExchangeRedisCache(options =>
            {
                var settings = GetRedisConfigurationSettings(_configuration);

                options.ConfigurationOptions = new ConfigurationOptions
                {
                    Password = settings.Password,
                    ConnectTimeout = (int)settings.ConnectionTimeout.TotalMilliseconds,
                    ConnectRetry = settings.ConnectionRetries,
                    Ssl = settings.SslEnabled,
                    DefaultDatabase = settings.DatabaseNumber,
                    ClientName = settings.ClientName
                };

                options.ConfigurationOptions.EndPoints.Add(new DnsEndPoint(settings.Dns,settings.Port));
                options.ConfigurationOptions.CertificateValidation += (sender, cert, chain, errors) => true;

            });

        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseRouting();
            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }

        private RedisSettings GetRedisConfigurationSettings(IConfiguration configuration)
        {
            return configuration
                .GetSection(Api.RedisSettings.Section)
                .Get<RedisSettings>();
        }
    }
}