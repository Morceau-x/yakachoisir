using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(YakaTicket.Startup))]
namespace YakaTicket
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            Database.Database.database = new Database.Database();
        }
    }
}
