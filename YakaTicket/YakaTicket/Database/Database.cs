using Newtonsoft.Json;
using Npgsql;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

namespace YakaTicket.Database
{
    public class Database
    {
        public static Database database;

        NpgsqlConnection connection;

        public Database()
        {
            string file;

            try
            {
                Assembly _assembly = Assembly.GetExecutingAssembly();
                StreamReader jsonFile = new StreamReader(_assembly.GetManifestResourceStream("YakaTicket.config.json"));
                file = jsonFile.ReadToEnd();
            } catch (Exception e)
            {
                file = String.Empty;
            }

            dynamic json = JsonConvert.DeserializeObject(file);
            StringBuilder sb = new StringBuilder();
            sb.AppendFormat("Host={0}; ", json.database.host);
            sb.AppendFormat("Port={0}; ", json.database.port);
            sb.AppendFormat("Database={0}; ", json.database.database);
            sb.AppendFormat("Username={0}; ", json.database.username);
            sb.AppendFormat("Password={0}", json.database.password);
            this.connection = new NpgsqlConnection(sb.ToString());
            this.connection.Open();
        }

        public bool RequestBoolean(string function, params object[] args)
        {
            var command = BuildCommand(function, args);
            bool resp = (bool)command.ExecuteScalar();
            return resp;
        }

        public int RequestInteger(string function, params object[] args)
        {
            var command = BuildCommand(function, args);
            int resp = (int)command.ExecuteScalar();
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
            string cmd = BuildString(function, args);
            NpgsqlCommand command = new NpgsqlCommand(cmd, connection);

            string text = command.CommandText;
            return command;
        }

        private string BuildString(string function, object[] args)
        {
            int n = args.Length;
            var sb = new StringBuilder();
            sb.Append("SELECT * FROM ");
            sb.Append(function);
            sb.Append("(");
            for (int i = 0; i < n - 1; i++)
            {
                sb.Append(MakeParam(args[i]));
                sb.Append(",");
            }
            if (n > 0)
                sb.Append(MakeParam(args[n - 1]));
            sb.Append(");");
            return sb.ToString();
        }

        private string MakeParam(object arg)
        {
            StringBuilder sb = new StringBuilder();
            if (arg is string)
                sb.Append('\'');
            string str = arg.ToString().Replace("'", string.Empty);
            sb.Append(str);
            if (arg is string)
                sb.Append('\'');

            return sb.ToString();
        }
    }
}