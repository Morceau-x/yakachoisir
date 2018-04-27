using Newtonsoft.Json;
using Npgsql;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace YakaTicket.Database
{
    public class Database
    {
        NpgsqlConnection connection;

        public Database()
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

        public bool RequestBoolean(string function, params object[] args)
        {
            var command = BuildCommand(function, args);
            bool resp = (bool)command.ExecuteScalar();
            return resp;
        }

        public void RequestVoid(string function, params object[] args)
        {
            var command = BuildCommand(function, args);
            command.ExecuteNonQuery();
        }

        public object RequestObject(string function, params object[] args)
        {
            var command = BuildCommand(function, args);
            return command.ExecuteScalar();
        }

        public object[] RequestLine(string function, int length, params object[] args)
        {
            var command = BuildCommand(function, args);
            var reader = command.ExecuteReader();

            if (!reader.HasRows)
                return null;

            if (!reader.Read())
                return null;

            var resp = new object[length];

            try
            {
                for (int i = 0; i < length; i++)
                    resp[i] = reader[i];
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            reader.Close();
            return resp;
        }

        public List<object[]> RequestTable(string function, int length, params object[] args)
        {
            var command = BuildCommand(function, args);
            var reader = command.ExecuteReader();
            if (!reader.HasRows)
                return null;

            var resp = new List<object[]>();
            while (reader.Read())
            {
                var tmp = new object[length];
                try
                {
                    for (int i = 0; i < length; i++)
                        tmp[i] = reader[i];
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
                resp.Add(tmp);
            }
            reader.Close();
            return resp;
        }

        private NpgsqlCommand BuildCommand(string function, params object[] args)
        {
            string cmd = BuildString(function, args.Length);
            NpgsqlCommand command = new NpgsqlCommand(cmd, connection);

            for (int i = 0; i < args.Length; i++)
            {
                command.Parameters.AddWithValue("@p" + (i - 1), args[i]);
            }

            return command;
        }

        private string BuildString(string function, int n)
        {
            var sb = new StringBuilder();
            sb.Append("SELECT ");
            sb.Append(function);
            sb.Append("(");
            for (int i = 1; i < n; i++)
            {
                sb.Append("@p");
                sb.Append(i);
                sb.Append(",");
            }
            if (n > 0)
            {
                sb.Append("@p");
                sb.Append(n);
            }
            sb.Append(");");
            return sb.ToString();
        }
    }
}