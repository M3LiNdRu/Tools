using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Distributed;
using System;
using System.Threading.Tasks;

namespace Api.Controllers
{
    [ApiController]
    [Route("api/cache")]
    public class CacheController : ControllerBase
    {
        private readonly IDistributedCache _cache;

        public CacheController(IDistributedCache cache)
        {
            _cache = cache;
        }

        [HttpPost("set")] 
        public async Task<IActionResult> SetCache([FromQuery] string key, [FromQuery] string value)
        {
            var options = new DistributedCacheEntryOptions
            {
                AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10)
            };
            
            await _cache.SetStringAsync(key, value, options);
            return Ok("Valor emmagatzemat a la memòria cau");
        }

        [HttpGet("get")] 
        public async Task<IActionResult> GetCache([FromQuery] string key)
        {
            var value = await _cache.GetStringAsync(key);
            if (value == null)
            {
                return NotFound("Clau no trobada a la memòria cau");
            }
            return Ok(value);
        }
    }
}
