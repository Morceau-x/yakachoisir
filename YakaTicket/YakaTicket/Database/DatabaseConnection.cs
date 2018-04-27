using Newtonsoft.Json;
using Npgsql;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace YakaTicket.Database
{
    public class DatabaseConnection
    {
        NpgsqlConnection connection;

        public DatabaseConnection()
        {
            string jsonFile = File.ReadAllText("config.json");
            dynamic json = JsonConvert.DeserializeObject(jsonFile);
            StringBuilder sb = new StringBuilder();
            sb.AppendFormat("Host={0}; ", json.database.host);
            sb.AppendFormat("Port={0}; ", json.database.port);
            sb.AppendFormat("Database={0}; ", json.database.database);
            sb.AppendFormat("Username={0}; ", json.database.username);
            sb.AppendFormat("Password={0}", json.database.password);
            this.connection = new NpgsqlConnection(sb.ToString());
        }

    }
}